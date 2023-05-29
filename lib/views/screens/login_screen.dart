import 'package:flutter/material.dart';
import 'package:instagram_app/controllers/resources/auth_methods.dart';
import 'package:instagram_app/views/screens/signup_screen.dart';
import 'package:instagram_app/models/utils/colors.dart';
import 'package:instagram_app/models/utils/utils.dart';
import 'package:instagram_app/views/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

   void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginuser(
        email: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Responsivelayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
          (route) => false);

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
          // instagram logo
          Image.asset(
            'assets/images/instagram_logo.png',
            color: primaryColor,
            height: 64,
          ),
          // text input for email
          const SizedBox(
            height: 64,
          ),
          TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress),
          // text input for password
          const SizedBox(
            height: 25,
          ),
          TextFieldInput(
            textEditingController: _passwordController,
            hintText: 'Enter your password',
            textInputType: TextInputType.text,
            isPass: true,
          ),
          // button login
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: loginUser,
            child: Container(
              // to align cointainer child to center
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                color: blueColor,
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    )
                  : const Text('Log in'),
            ),
          ),

          Flexible(
            flex: 2,
            child: Container(),
          ),
          // transitioning to sign up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Text(
                  'Don\'t have an account?',
                ),
              ),
              GestureDetector(
                onTap: navigateToSignup,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    ' Sign up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          )
        ]),
      )),
    );
  }
}
