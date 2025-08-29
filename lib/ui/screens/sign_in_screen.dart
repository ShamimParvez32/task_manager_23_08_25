import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_23_08_25/data/models/user_model.dart';
import 'package:task_manager_23_08_25/data/services/network_caller.dart';
import 'package:task_manager_23_08_25/data/utlis/urls.dart';
import 'package:task_manager_23_08_25/ui/controllers/auth_controller.dart';
import 'package:task_manager_23_08_25/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager_23_08_25/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_23_08_25/ui/screens/sign_up_screen.dart';
import 'package:task_manager_23_08_25/ui/utlis/app_colors.dart';
import 'package:task_manager_23_08_25/ui/widgets/looder.dart';
import 'package:task_manager_23_08_25/ui/widgets/screen_background.dart';
import 'package:task_manager_23_08_25/ui/widgets/show_snakebar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(36),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text('Get Started with', style: textTheme.titleLarge),
                  SizedBox(height: 24),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Enter password'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Visibility(
                    visible: _signInProgress == false,
                    replacement: CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () {
                        _onTabSignInBtn();
                      },
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                  SizedBox(height: 48),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ForgotPasswordVerifyEmailScreen.name);
                          },
                          child: Text('Forgot Password ?'),
                        ),
                        SizedBox(height: 8),
                        _buildRichText(),
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

  Widget _buildRichText() {
    return RichText(
      text: TextSpan(
        text: "Dont have an account ?",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(
            text: '  Sign Up',
            style: TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = () {
            Navigator.pushNamed(context, SignUpScreen.name);
            },
          ),
        ],
      ),
    );
  }

  void _onTabSignInBtn() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    _signInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    final NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.signInUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      String token = response.responseBody!['token'];
      UserModel userModel = UserModel.fromJson(response.responseBody!['data']);
      await AuthController.setUserData(token, userModel);
      showSnakeBarMessage(context, 'login Successful');
      Navigator.pushReplacementNamed(context, MainBottomNavScreen.name);
    } else {
      _signInProgress = false;
      setState(() {});
      if(response.statusCode ==401){
        showSnakeBarMessage(context, 'Email/password is invalid try again');
      }
      else{
        showSnakeBarMessage(context, response.errorMessage);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
  }
}
