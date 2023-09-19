import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
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
          Navigator.of(context).pushNamed("/home").then((value) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120.0),
              Image.asset(
                'assets/images/logo.png',
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Log In to your account',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
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
                  prefixIcon: const Icon(Icons.email_outlined, size: 24),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  onPressed: _submitForm,
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              if (authState.isLoading)
                const Column(
                  children: [
                    SizedBox(height: 10.0),
                    SizedBox(
                      height: 20.0,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  ],
                ),
              const SizedBox(height: 10.0),
              const Text(
                "Sign in using",
              ),
              const SizedBox(height: 10.0),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade300),
                        onPressed: signInWithGoogle,
                        icon: const Icon(Icons.g_mobiledata)),
                    IconButton(
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade300),
                        onPressed: signInWithFacebook,
                        icon: const Icon(Icons.facebook))
                  ]),
              const SizedBox(height: 10.0),
              GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Forget password?',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
