import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/pages/signup_page.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPushingHome = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      Provider.of<AuthProvider>(context, listen: false)
          .loginProvider(context, email, password);
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  void didChangeDependencies() async {
    // final currentRoute = ModalRoute.of(context)?.settings?.name;
    Future.delayed(const Duration(seconds: 2)).then((value) async {
      final authState = Provider.of<AuthProvider>(context, listen: false);
      if (authState.isAuthenticated) {
        if (!isPushingHome) {
          isPushingHome = true;
          Navigator.of(context).pushReplacementNamed("/home").then((value) {
            isPushingHome = false;
          });
        }
      }
    });

    super.didChangeDependencies();
  }

  @override
  void initState() {
    isPushingHome = false;
    listenForAuthStateChange();
    super.initState();
  }

  void listenForAuthStateChange() {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user != null) {
        final token = await user.getIdToken();
        bool hasSuccessfullySignedup =
            await provider.createUserFromSocailSignup(token as String);
        if (hasSuccessfullySignedup) {
          provider.socialloginProvider(token);
        } else {
          provider.setLoading(false);
          showLoginFailureToast();
        }
      }
    });
  }

  void showLoginFailureToast() {
    Fluttertoast.showToast(
      msg: 'Login Failed!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red[800],
      textColor: Colors.white,
    );
  }

  Future<void> signInWithGoogle() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      provider.setLoading(true);
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      showLoginFailureToast();
    } finally {
      provider.setLoading(false);
    }
  }

  Future<void> signInWithFacebook() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      provider.setLoading(true);
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: ['email']);

      if (result.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      showLoginFailureToast();
    } finally {
      provider.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 232, 230, 235), // Primary color
            Color.fromRGBO(208, 196, 242, 1), // Secondary color
          ],
        )),
        child: authState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    const SizedBox(height: 80.0),
              Image.asset(
                'assets/images/logo.png',
                      width: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.cover,
              ),
                    const SizedBox(height: 20.0),
              if (!authState.isAuthenticated &&
                  authState.errorMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          authState.errorMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (authState.isRegistered && authState.successMessage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          authState.successMessage,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Apply corner radius
                          ),
                          prefixIcon:
                              const Icon(Icons.email_outlined, size: 24),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.lock, size: 24)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Variables.primaryColor),
                          ),
                          onPressed: _submitForm,
                          child: const Text("SIGN IN",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                            // GestureDetector(
                            //   child: const Padding(
                            //     padding: EdgeInsets.only(right: 8.0),
                            //     child: Text(
                            //       'Forget password?',
                            //       style: TextStyle(
                            //         fontWeight: FontWeight.bold,
                            //         color: Variables.primaryColor,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                    ],
                  ),
                ),
              ),
                    // if (authState.isLoading)
                    //   const Column(
                    //     children: [
                    //       SizedBox(height: 10.0),
                    //       SizedBox(
                    //         height: 20.0,
                    //         width: 20,
                    //         child: CircularProgressIndicator(),
                    //       )
                    //     ],
                    //   ),
              const SizedBox(height: 10.0),
              const Text(
                "Sign in using",
                style: TextStyle(),
              ),
              const SizedBox(height: 10.0),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        color: Variables.primaryColor,
                        style: IconButton.styleFrom(
                            iconSize: 30,
                            backgroundColor: Colors.grey.shade300),
                        onPressed: signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata)),
                    const SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        color: Variables.primaryColor,
                        style: IconButton.styleFrom(
                            iconSize: 30,
                            backgroundColor: Colors.grey.shade300),
                        onPressed: signInWithFacebook,
                        icon: const Icon(Icons.facebook))
                  ]),
              const SizedBox(height: 10.0),
              const SizedBox(height: 20.0),
              GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "Register here",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Variables.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

            ],
          ),
        ),
      ),
    ));
  }
}
