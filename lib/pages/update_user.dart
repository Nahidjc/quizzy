import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quizzy/models/user_data_model.dart';
import 'package:quizzy/provider/login_provider.dart';
import 'package:quizzy/provider/user_provider.dart';
import 'package:quizzy/widget/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;

  const UserProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isLoading = true;
  UserDataModel? userDetails;
  late AuthProvider authProvider;
  final picker = ImagePicker();
  File? image;

  Future getImage() async {
    try {
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img != null) {
        setState(() {
          image = File(img.path);
        });
      }
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserDetails();
    });
  }

  Future<void> fetchUserDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    userDetails = await userProvider.fetchUserDetailsById(widget.userId);
    setState(() {
      isLoading = false;
    });
    if (userDetails != null) {
      firstnameController.text = userDetails!.name;
      lastnameController.text = userDetails!.lastName;
      mobileController.text = userDetails!.mobileNumber ?? '';
    }
  }

  void showToastAfterupdateProfile() {
    Fluttertoast.showToast(
      msg: 'Update successful',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void updateData() {
    authProvider.userDetails(authProvider.userId);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    AuthProvider user = Provider.of<AuthProvider>(context);
    ImageProvider<Object>? backgroundImage;
    if (user.profileUrl == null) {
      backgroundImage = const AssetImage(
        "assets/images/avatar.png",
      );
    } else {
      backgroundImage = NetworkImage(user.profileUrl!);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update your Prfile",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height - 200,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: [
                    GestureDetector(
                      onTap: () => getImage(),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            image != null ? FileImage(image!) : backgroundImage,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: firstnameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: lastnameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: mobileController,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        content: userProvider.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Update User',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: () async {
                          final updatedFirstName = firstnameController.text;
                          final updatedlastName = lastnameController.text;
                          final updatedMobile = mobileController.text;

                          final isUpdate = await userProvider.updateUserProfile(
                            name: updatedFirstName,
                            lastName: updatedlastName,
                            mobileNumber: updatedMobile,
                            profilePicPath: image?.path,
                            userId: widget.userId,
                          );
                          if (isUpdate) {
                            updateData();
                            showToastAfterupdateProfile();
                          }
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
