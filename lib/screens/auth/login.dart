import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../consts/validator.dart'; // Importing custom validators
import '../../root_screen.dart'; // Importing RootScreen
import '../../screens/auth/forgot_password.dart'; // Importing ForgotPasswordScreen
import '../../screens/auth/register.dart'; // Importing RegisterScreen
import '../../screens/loading_manager.dart'; // Importing LoadingManager widget
import '../../widgets/app_name_text.dart'; // Importing custom widget
import '../../widgets/subtitle_text.dart'; // Importing custom widget
import '../../widgets/title_text.dart'; // Importing custom widget

import '../../services/my_app_functions.dart'; // Importing custom functions
import '../../widgets/auth/google_btn.dart'; // Importing custom GoogleButton widget

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen'; // Route name for navigation
  const LoginScreen({super.key}); // Constructor for LoginScreen widget

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Creating state for LoginScreen
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true; // State variable to toggle password visibility
  late final TextEditingController _emailController; // Controller for email text field
  late final TextEditingController _passwordController; // Controller for password text field

  late final FocusNode _emailFocusNode; // Focus node for email text field
  late final FocusNode _passwordFocusNode; // Focus node for password text field

  final _formkey = GlobalKey<FormState>(); // GlobalKey for form validation
  bool _isLoading = false; // State variable to track loading state
  final auth = FirebaseAuth.instance; // Firebase authentication instance

  @override
  void initState() {
    _emailController = TextEditingController(); // Initialize email controller
    _passwordController = TextEditingController(); // Initialize password controller
    // Initialize focus nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState(); // Call super method
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose(); // Dispose email controller
      _passwordController.dispose(); // Dispose password controller
      // Dispose focus nodes
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose(); // Call super method
  }

  Future<void> _loginFct() async {
    final isValid = _formkey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Hide keyboard

    if (isValid) {
      try {
        setState(() {
          _isLoading = true; // Set loading state to true
        });

        await auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(), // Get email from text field
          password: _passwordController.text.trim(), // Get password from text field
        );
        Fluttertoast.showToast(
          msg: "Login Successful", // Show toast message for successful login
          textColor: Colors.white,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName); // Navigate to RootScreen after login
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(), // Show error message if login fails
          fct: () {},
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(), // Show error message if login fails
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard when tapping outside text fields
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading, // Pass loading state to LoadingManager widget
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const AppNameTextWidget(
                    fontSize: 30, // Custom widget for app name text
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: TitlesTextWidget(label: "Welcome back!")), // Custom widget for title text
                  const SizedBox(
                    height: 16,
                  ),
                  Form(
                    key: _formkey, // Assign GlobalKey to form
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _emailController, // Assign controller to email text field
                          focusNode: _emailFocusNode, // Assign focus node to email text field
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ), // Icon for email text field
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode); // Move focus to password field on submit
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value); // Validate email using custom validator
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                          obscureText: obscureText, // Toggle password visibility
                          controller: _passwordController, // Assign controller to password text field
                          focusNode: _passwordFocusNode, // Assign focus node to password text field
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText; // Toggle password visibility
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            hintText: "***********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ), // Icon for password text field
                          ),
                          onFieldSubmitted: (value) async {
                            await _loginFct(); // Call login function on submit
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value); // Validate password using custom validator
                          },
                        ),
                        // Forgot password button
                        const SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                ForgotPasswordScreen.routeName,
                              ); // Navigate to ForgotPasswordScreen
                            },
                            child: const SubtitleTextWidget(
                              label: "Forgot password?",
                              fontStyle: FontStyle.italic,
                              textDecoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Login button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                              ),
                            ),
                            icon: const Icon(Icons.login),
                            label: const Text("Login"),
                            onPressed: () async {
                              await _loginFct(); // Call login function on button press
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Google sign-in button
                        SubtitleTextWidget(
                          label: "Or connect using".toUpperCase(),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Google sign-in button and Guest button
                        SizedBox(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: FittedBox(
                                    child: GoogleButton(), // Custom Google sign-in button
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(12.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                    ),
                                    child: const Text("Guest?"),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushNamed(RootScreen.routeName); // Navigate to RootScreen
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitleTextWidget(label: "New here?"),
                            TextButton(
                              child: const SubtitleTextWidget(
                                label: "Sign up",
                                fontStyle: FontStyle.italic,
                                textDecoration: TextDecoration.underline,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routName); // Navigate to RegisterScreen
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
