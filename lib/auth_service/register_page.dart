import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../app_utilities/dialog_helper.dart';
import '../widgets/text_field.dart';
import 'auth_service.dart';
import 'login_page.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {
    // set is loading to true.
    setState(() {
      isLoading = true;
    });
    // signup user using our auth-method
    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        role: nameController.text);
    // if string return is success, user has been created and navigate to next screen other wits show error.
    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      Get.to(const LoginScreen());
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar( res,Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const Text(
                    'Register Here',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  TextFieldInput(
                      icon: Icons.person,
                      textEditingController: nameController,
                      hintText: 'Enter your role Admin/User',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                      icon: Icons.email,
                      textEditingController: emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.text),
                  TextFieldInput(
                    icon: Icons.lock,
                    textEditingController: passwordController,
                    hintText: 'Enter your passord',
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                InkWell(
                  onTap: signupUser,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          color: Colors.blue),
                      child:const Text(
                        'Sign Up',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Container(height: 1, color: Colors.black26)),
                      const Text("  or  "),
                      Expanded(child: Container(height: 1, color: Colors.black26)),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          Get.to(const LoginScreen());
                        },
                        child: const Text(
                          " Login",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}