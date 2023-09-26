import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/api_caller/coin_transfer.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/token/token_manager.dart';

class CoinTransferPage extends StatefulWidget {
  const CoinTransferPage({super.key});
  @override
  State<CoinTransferPage> createState() => _CoinTransferPageState();
}

class _CoinTransferPageState extends State<CoinTransferPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _transferCoinController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSendingCoin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _transferCoinController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authState = Provider.of<AuthProvider>(context, listen: false);
      String transferToEmail = _emailController.text;
      int transferCoin = int.parse(_transferCoinController.text);
      int availableCoin = authState.coin;
      if (availableCoin < transferCoin) {
        showToast("Insufficient coin");
        return;
      }

      String? jwtToken = await TokenManager.getToken();
      if (jwtToken!.isNotEmpty) {
        final response = await TransferCoinAPI()
            .transferCoin(transferToEmail, jwtToken, transferCoin);

        print(response.body);
        print(transferToEmail);
        print(transferCoin);
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red[800],
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Coin transfer",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 4,
          backgroundColor: Variables.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 232, 230, 235), // Primary color
                Color.fromRGBO(208, 196, 242, 1), // Secondary color
              ],
            )),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Receiver email address",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Apply corner radius
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
                          const Text(
                            "Transfer amount",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _transferCoinController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Transfer amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Apply corner radius
                              ),
                              prefixIcon: const Icon(Icons.money, size: 24),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter transfer coin amount';
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
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Variables.primaryColor),
                              ),
                              onPressed: _submitForm,
                              child: const Text("Transfer Coin",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isSendingCoin)
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
                ],
              ),
            ),
          ),
        ));
  }
}
