import 'dart:io'; // Importing dart IO library for file operations

import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Cloud Firestore library
import 'package:firebase_auth/firebase_auth.dart'; // Importing Firebase Authentication library
import 'package:firebase_storage/firebase_storage.dart'; // Importing Firebase Storage library
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // Importing Image Picker library
import '../../consts/validator.dart'; // Importing custom validators
import '../../screens/loading_manager.dart'; // Importing LoadingManager widget
import '../../services/my_app_functions.dart'; // Importing custom functions
import '../../widgets/app_name_text.dart'; // Importing custom widget
import '../../widgets/subtitle_text.dart'; // Importing custom widget
import '../../widgets/title_text.dart'; // Importing custom widget

import '../../root_screen.dart'; // Importing RootScreen
import '../../widgets/auth/image_picker_widget.dart'; // Importing custom widget for image picker

class RegisterScreen extends StatefulWidget {
  static const routName = "/RegisterScreen"; // Route name for navigation
  const RegisterScreen({super.key}); // Constructor for RegisterScreen widget

  @override
  State<RegisterScreen> createState() => _RegisterScreenState(); // Creating state for RegisterScreen
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureText = true; // State variable to toggle password visibility
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController; // Text controllers for form fields

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode; // Focus nodes for form fields

  final _formkey = GlobalKey<FormState>(); // GlobalKey for form validation
  XFile? _pickedImage; // Variable to store picked image
  bool _isLoading = false; // State variable to track loading state
  final auth = FirebaseAuth.instance; // Firebase authentication instance
  String? userImageUrl; // URL for user image

  @override
  void initState() {
    _nameController = TextEditingController(); // Initialize text controllers
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    // Initialize focus nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState(); // Call super method
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose(); // Dispose text controllers
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      // Dispose focus nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
    }
    super.dispose(); // Call super method
  }

  Future<void> _registerFCT() async {
    final isValid = _formkey.currentState!.validate(); // Validate form fields
    FocusScope.of(context).unfocus(); // Hide keyboard

    if (_pickedImage == null) {
      // Check if an image is picked
      MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: "Make sure to pick up an image",
          fct: () {});
      return;
    }

    if (isValid) {
      try {
        setState(() {
          _isLoading = true; // Set loading state to true
        });

        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(), // Create user with email and password
          password: _passwordController.text.trim(),
        );

        final User? user = auth.currentUser; // Get current user
        final String uid = user!.uid; // Get user ID
        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child("${_emailController.text.trim()}.jpg"); // Reference for user image in Firebase Storage

        await ref.putFile(File(_pickedImage!.path)); // Upload image to Firebase Storage
        userImageUrl = await ref.getDownloadURL(); // Get download URL for the uploaded image

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          // Add user data to Firestore
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });

        Fluttertoast.showToast(
          msg: "An account has been created", // Show toast message for successful registration
          textColor: Colors.white,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName); // Navigate to RootScreen after registration
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(), // Show error message if registration fails
          fct: () {},
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(), // Show error message if registration fails
          fct: () {},
        );
      } finally {
        setState(() {
          _isLoading = false; // Set loading state to false
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker(); // Create instance of ImagePicker
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera); // Pick image from camera
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery); // Pick image from gallery
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null; // Remove picked image
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Hide keyboard on tap outside of text field
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: _isLoading, // Display loading indicator if isLoading is true
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  const AppNameTextWidget(
                    fontSize: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitlesTextWidget(label: "Welcome back!"),
                          SubtitleTextWidget(label: "Your welcome message"),
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: size.width * 0.3,
                    width: size.width * 0.3,
                    child: PickImageWidget(
                      pickedImage: _pickedImage, // Pass picked image to PickImageWidget
                      function: () async {
                        await localImagePicker(); // Call image picker function
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Full Name Text Field
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.displayNamevalidator(value); // Validate full name
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Email Address Text Field
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(
                              IconlyLight.message,
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.emailValidator(value); // Validate email address
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Password Text Field
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "***********",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_repeatPasswordFocusNode);
                          },
                          validator: (value) {
                            return MyValidators.passwordValidator(value); // Validate password
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        // Repeat Password Text Field
                        TextFormField(
                          controller: _repeatPasswordController,
                          focusNode: _repeatPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Repeat password",
                            prefixIcon: const Icon(
                              IconlyLight.lock,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) async {
                            await _registerFCT(); // Call registration function on submit
                          },
                          validator: (value) {
                            return MyValidators.repeatPasswordValidator(
                              value: value,
                              password: _passwordController.text,
                            ); // Validate repeated password
                          },
                        ),
                        const SizedBox(
                          height: 36.0,
                        ),
                        // Register Button
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
                            icon: const Icon(IconlyLight.addUser),
                            label: const Text("Sign up"),
                            onPressed: () async {
                              await _registerFCT(); // Call registration function
                            },
                          ),
                        ),
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
