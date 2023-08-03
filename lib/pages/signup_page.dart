import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/pages/login_page.dart';
import 'package:quizzy/provider/login_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String firstName = _firstNameController.text;
      String lastName = _lastNameController.text;
      String mobileNo = _mobileNoController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      Provider.of<AuthProvider>(context, listen: false)
          .register(context, firstName, lastName, email, mobileNo, password);
      _mobileNoController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthProvider>(context);
    if (authState.isRegistered) {
      return const LoginPage();
    }
    return Scaffold(
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'FirstName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined, size: 24),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'LastName',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email_outlined, size: 24),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
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
                  controller: _mobileNoController,
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.phone_rounded, size: 24),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (value.length != 11) {
                      return 'Mobile number must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.number,
                  obscureText: _obscured,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscured,
                  keyboardType: TextInputType.number,
                  focusNode: textFieldFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.purple),
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Login here",
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
      ),
    );
  }
}
