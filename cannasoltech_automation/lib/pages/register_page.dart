import 'package:cannasoltech_automation/components/square_tile.dart';
import 'package:cannasoltech_automation/handlers/user_handler.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

import '../UserInterface/ui.dart';


class RegisterPage extends StatefulWidget {

  final dynamic toggleFn;

  const RegisterPage({super.key, required this.toggleFn});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  bool _isPasswordVisible = false;
  // bool _rememberMe = false;

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red[600],
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

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password')
        );
      },
    );
  }

  void signUserUp(UserHandler userHandler) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
      try {
        if (passwordController.text == confirmPasswordController.text){
          await auth.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          await userHandler.initialize();
          await userHandler.setUsername(userNameController.text);
        } else {
          showErrorMessage('Passwords do not match!');
        }
      } on FirebaseAuthException catch (e) {
        // Navigator.pop(context);
        showErrorMessage(e.code);
      }
  }

  String? validateEmail(String? input) {
    final bool isValid = EmailValidator.validate(emailController.text);
    if (!isValid){
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? input) {
    if (passwordController.text.length < 8 && passwordController.text.isNotEmpty){
        return "Password must be longer than 8 characters.";
    }
    return null;
  }

  String? validateConfirmPassword(String? input) {
    if (confirmPasswordController.text.length < 8 && confirmPasswordController.text.isNotEmpty){
        return "Password must be longer than 8 characters.";
    }
    return null;
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<SystemDataModel>().alarmHandler.notifications;
    // Provider.of<SystemDataModel>(context, listen: false).alarmHandler.showAlarmBanners(context);
    UI ui = userInterface(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                    children: [
                      Image.asset("assets/images/SmallIcon.png"),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Cannasol Technologies",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Enter your information to continue.",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _gap(),
                      TextFormField(
                            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
                            // validator: validateEmail,
                            controller: userNameController,
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                              hintText: "Enter your Username",
                              // prefixIcon: Icon(Icons.mail),
                              border: OutlineInputBorder(),
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
                      TextFormField(
                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePassword,
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            // hintText: 'Enter your password',
                            // prefixIcon: const Icon(Icons.lock_outline_rounded),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )),
                      ),
                      _gap(),
                      TextFormField(
                        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePassword,
                        controller: confirmPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            // hintText: 'Enter your password',
                            // prefixIcon: const Icon(Icons.lock_outline_rounded),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )),
                      ),
                      // _gap(),
                      // CheckboxListTile(
                      //   value: _rememberMe,
                      //   onChanged: (value) {
                      //     if (value == null) return;
                      //     setState(() {
                      //       _rememberMe = value;
                      //     });
                      //   },
                      //   title: const Text('Remember me'),
                      //   controlAffinity: ListTileControlAffinity.leading,
                      //   dense: true,
                      //   contentPadding: const EdgeInsets.all(0),
                      // ),
                      // _gap(),
                      _gap(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () async {
                            signUserUp(Provider.of<SystemDataModel>(context, listen: false).userHandler);
                            
                          },
                        ),
                      ),
                      _gap(),
                      _gap(),
                      _gap(),
                      
                      Row(
                        children: [
                          Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400]),),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text("Or continue with"),
                          ),
                          Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400]),),
                        ]
                      ),
                      _gap(),
                      _gap(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Image.asset("assets/images/SmallIcon.png"),
                          SquareTile(imagePath: "assets/images/g_logo.png"),
                        
                      //     SquareTile(imagePath: '/assets/images/SmallIcon.png'),
                        ]
                      ),
                      _gap(),
                      _gap(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.toggleFn,
                            child: const Text(
                              'Login now',
                              style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ]
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _gap() => const SizedBox(height: 16);
}
