/// @file sign_in.dart
/// @author Stephen Boyett
/// @date 2025-09-06
/// @brief User sign-in page with email/password and Google authentication.
/// @details Provides user authentication interface with email validation,
///          password visibility toggle, Google Sign-In integration, and error handling.
/// @version 1.0
/// @since 1.0

import 'package:cannasoltech_automation/api/firebase_api.dart';
import 'package:cannasoltech_automation/components/square_tile.dart';
import 'package:cannasoltech_automation/providers/system_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../UserInterface/ui.dart';
import '../handlers/user_handler.dart';
import 'reset_password.dart';

/// Sign-in page widget with multiple authentication options.
///
/// A stateful widget that provides email/password authentication,
/// Google Sign-In, and navigation to registration and password reset.
class SignInPage1 extends StatefulWidget {
  /// Function to toggle between sign-in and registration pages
  final dynamic toggleFn;

  /// Creates a [SignInPage1] widget.
  ///
  /// The [toggleFn] is required to switch between sign-in and registration views.
  const SignInPage1({super.key, required this.toggleFn});

  /// Creates the state for the [SignInPage1] widget.
  @override
  State<SignInPage1> createState() => _SignInPage1State();
}

class _SignInPage1State extends State<SignInPage1> {
  bool _isPasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
          )),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(title: Text('Incorrect Password'));
      },
    );
  }

  Future<void> signUserIn(UserHandler userHandler) async {
    try {
      await userHandler.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorMessage('User not found!');
      } else if (e.code == 'wrong-password') {
        showErrorMessage('Incorrect password');
      } else {
        showErrorMessage('Invalid login!');
      }
    } catch (error) {
      showErrorMessage('Invalid login!');
    }
  }

  Future<void> signInWithGoogle(UserHandler userHandler) async {
    try {
      bool success = await userHandler.signInWithGoogle();
      if (!success) {
        showErrorMessage('Google sign-in aborted');
      }
    } catch (error) {
      showErrorMessage('Google sign-in failed: ${error.toString()}');
    }
  }


  String? validateEmail(String? input) {
    final bool isValid = EmailValidator.validate(emailController.text);
    if (!isValid) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? input) {
    if (passwordController.text.length < 8 &&
        passwordController.text.isNotEmpty) {
      return "Password must be longer than 8 characters.";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UI ui = userInterface(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
                constraints: BoxConstraints(
                    maxWidth: ui.size.maxWidth,
                    maxHeight: ui.size.displayHeight * 0.9),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "Enter your email and password to continue.",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        key: const Key('email_field'),
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateEmail,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      _gap(),
                      TextFormField(
                        key: const Key('password_field'),
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePassword,
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () => {
                                    Navigator.of(context).pop(),
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ResetPasswordPage())),
                                  })
                        ],
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
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onPressed: () async {
                            final userHandler = Provider.of<SystemDataModel>(
                                    context,
                                    listen: false)
                                .userHandler;
                            await signUserIn(userHandler);
                          },
                        ),
                      ),
                      _gap(),
                      _gap(),
                      _gap(),

                      Row(children: [
                        Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text("Or continue with"),
                        ),
                        Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
                      ]),
                      _gap(),
                      _gap(),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            signInWithGoogle(Provider.of<SystemDataModel>(
                                    context,
                                    listen: false)
                                .userHandler);
                          },
                          child: const SquareTile(
                              imagePath: "assets/images/g_logo.png"),
                        ),
                      )
                      _gap(),
                      _gap(),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          GestureDetector(
                            onTap: widget.toggleFn,
                            child: const Text(
                              'Register now',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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
