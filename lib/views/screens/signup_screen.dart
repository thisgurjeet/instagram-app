import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/controllers/resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../../models/utils/colors.dart';
import '../../models/utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  // image picker
  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  // sign up user function which is used at on tap
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    // importing auth methods class and signupuser function to authenticate our user
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    print(res);

    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Responsivelayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Flexible(
          flex: 2,
          child: Container(),
        ),
        // image
        Image.asset(
          'assets/images/instagram_logo.png',
          color: primaryColor,
          height: 64,
        ),
        const SizedBox(
          height: 54,
        ),
        // circular widget for a profile
        Stack(
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg'),
                  ),
            Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo))),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        // username
        TextFieldInput(
          textEditingController: _usernameController,
          hintText: 'Enter your username',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        // TextField for email
        TextFieldInput(
            textEditingController: _emailController,
            hintText: 'Enter Your Email',
            textInputType: TextInputType.emailAddress),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          textEditingController: _passwordController,
          hintText: 'Enter Your Password',
          textInputType: TextInputType.emailAddress,
          isPass: true,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          textEditingController: _bioController,
          hintText: 'Enter Your bio',
          textInputType: TextInputType.text,
        ),

        const SizedBox(
          height: 24,
        ),
        // button
        InkWell(
          onTap: signUpUser,
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const ShapeDecoration(
                color: blueColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)))),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: primaryColor,
                  ))
                : const Text('Sign up'),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Flexible(
          flex: 2,
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                'Already have an account?',
              ),
            ),
            GestureDetector(
              onTap: navigateToLogin,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  ' Log in',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        )
      ]),
    )));
  }
}
