// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quizzy/api_caller/forget_password.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/pages/login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final String email;

  const ChangePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String otp = "";
  int countdownSeconds = 180;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    startCountdownTimer();
  }

  void startCountdownTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (timer) {
      if (countdownSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          countdownSeconds--;
        });
      }
    });
  }

  void handleChangedPassword(BuildContext context) async {
    if (otp.length != 6) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid 6-digit OTP',
        backgroundColor: Colors.red,
      );
      return;
    }

    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Password fields cannot be empty',
        backgroundColor: Colors.red,
      );
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: 'Passwords do not match',
        backgroundColor: Colors.red,
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await ForgotPasswordInitiate().confirmForgotPassword(
        email: widget.email,
        code: otp,
        newPassword: password,
      );
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Password changed successfully');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: 'Failed to change password',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Reset Password',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Enter the OTP sent to your email and set a new password.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16.0),
              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) {
                  otp = value;
                },
                onCompleted: (value) {
                  // Handle when OTP is completed
                },
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeColor: Colors.blue,
                  activeFillColor: Colors.white,
                  inactiveColor: Colors.grey,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Enter OTP (6 digits)',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  hintText: 'Enter your new password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  hintText: 'Confirm your new password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Variables.primaryColor),
                  ),
                  onPressed: () {
                    handleChangedPassword(context);
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text('Change Password',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Resend OTP in ${countdownSeconds}s',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
