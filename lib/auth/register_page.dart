import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../helper/helper_function.dart';
import '../widgets/widgets.dart';
import '../auth/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String fullName = '';
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Text('Drawer'),
        ),

        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        // ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Text Me',
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Create your account to text me',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400),
                          ),
                          Image.asset("assets/register.png"),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Full Name',
                              hintText: 'Enter your full name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter your full name';
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                fullName = val;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Email',
                              hintText: 'Enter your Email ID',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please provide a valid email";
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            validator: (val) {
                              if (val!.length < 6) {
                                return 'Password must be at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                register();
                              },
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Login now',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const LoginPage());
                                      // navigate to desired screen
                                    },
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
      ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state


        await HelperFunctions.saveUserLoggedInStatus(true);
  
        await HelperFunctions.saveUserEmailSF(email);

              await HelperFunctions.saveUserNameSF(fullName);

              nextScreenReplace(context, const HomePage());

        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
