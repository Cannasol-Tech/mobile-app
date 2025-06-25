import 'package:cannasoltech_automation/components/system_app_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import '../UserInterface/ui.dart';
import '../components/side_menu.dart';
import '../handlers/user_handler.dart';
import '../shared/methods.dart';
import '../shared/snacks.dart';


class ResetPasswordPage extends StatefulWidget {
  
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();

}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final emailController = TextEditingController();


  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(190, 155, 25, 11),
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.grey[300]),
            )
          ),
        );
      },
    );
  }
  String? validateEmail(String? input) {
    final bool isValid = EmailValidator.validate(emailController.text);
    if (!isValid){
      return "Please enter a valid email";
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    UserHandler userHandler = Provider.of<SystemDataModel>(context, listen: false).userHandler;
    return Consumer<SystemDataModel> (builder: (context, value, child) =>  Scaffold(
      appBar: systemAppBar(context, value.activeDevice),
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
              constraints: BoxConstraints(
                maxWidth: ui.size.maxWidth, 
                maxHeight: MediaQuery.of(context).size.height*0.9),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                      Image.asset("assets/images/SmallIcon.png"),
                      _gap(),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Cannasol Technologies",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Receive an email to reset your password.",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _gap(),
                      TextFormField(
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: validateEmail,
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: "Enter your email",
                              // prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(),
                            ),
                          ),
                      _gap(),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 15,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          onPressed: () {
                            resetPassword(userHandler);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    drawer: const SideMenu(),

    ));
  }
  Widget _gap() => const SizedBox(height: 16);

  Future<void> resetPassword(UserHandler userHandler) async {

    if (!await userHandler.doesEmailExist(emailController.text)){
      // ignore: use_build_context_synchronously
      showSnack(context, emailNotFoundSnack(emailController.text));
    }
    else {
      // ignore: use_build_context_synchronously
      showSnack(context, passwordResetEmailSnack(emailController.text));
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    } on FirebaseAuthException {
      showErrorMessage('Enter a valid email');
    }
  }
}

