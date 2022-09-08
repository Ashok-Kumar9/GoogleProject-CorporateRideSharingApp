import 'package:corporate_ride_sharing/Models/user_data.dart';
import 'package:corporate_ride_sharing/services/remote_service.dart';
import 'package:corporate_ride_sharing/utils/constants.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/reusable_widgets.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  late UserData userData;
  bool isUserAlreadyExists = false;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    userData = await RemoteService().getUserData(SharedPrefs().userId);
    _emailController.text = userData.user.emailId ?? "";
    _fullNameController.text = userData.user.fullName ?? "";
    isUserAlreadyExists = userData.user.fullName != null;
    setState(() {});
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorShades.backGroundBlack,
        body: Container(
          height: screenHeight - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.04,
            horizontal: screenWidth * 0.08,
          ).copyWith(top: screenHeight * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "my profile",
                style: Theme.of(context).textTheme.h2,
              ),
              SizedBox(height: screenHeight * 0.03),
              Stack(
                children: [
                  SizedBox(
                    height: screenHeight * 0.12,
                    width: screenHeight * 0.12,
                    child: ReusableWidgets().buildCachedImageWithBlurHash(
                      AppConstants.defaultUserImageUrl,
                      blurHash: AppConstants.defaultUserImageBlurHash,
                      boxFit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "please enter your full name",
                style: Theme.of(context).textTheme.h5,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecorations().textFieldBox,
                child: Center(
                  child: TextField(
                    controller: _fullNameController,
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.h4,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintStyle: Theme.of(context)
                            .textTheme
                            .h4
                            .copyWith(color: Colors.grey),
                        hintText: 'your name',
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "please enter your email id",
                style: Theme.of(context).textTheme.h5,
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecorations().textFieldBox,
                child: Center(
                  child: TextField(
                    controller: _emailController,
                    cursorColor: Colors.white,
                    style: Theme.of(context).textTheme.h4,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintStyle: Theme.of(context)
                            .textTheme
                            .h4
                            .copyWith(color: Colors.grey),
                        hintText: 'your email',
                        border: InputBorder.none),
                  ),
                ),
              ),
              const Spacer(),
              CustomButton(
                isActive: _fullNameController.text.isNotEmpty &&
                    _emailController.text.isNotEmpty,
                onPressed: () async {
                  userData.user.fullName = _fullNameController.text;
                  userData.user.emailId = _emailController.text;
                  userData.user.mobileNo = SharedPrefs().phoneNumber;
                  userData.user.role = SharedPrefs().userRole;

                  UserData newUserData = await (isUserAlreadyExists
                      ? RemoteService().updateUserData(userData.user).onError(
                          (error, stackTrace) => UserData(
                              message: error.toString(), user: userData.user))
                      : RemoteService().postUserData(userData.user).onError(
                          (error, stackTrace) => UserData(
                              message: error.toString(), user: userData.user)));

                  print(newUserData.message);

                  if (!mounted) return;
                  if (newUserData.message == "user registered successfully" ||
                      newUserData.message == "user updated successfully") {
                    SharedPrefs().userId = newUserData.user.userId!;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/space', (route) => false);
                  } else {
                    ReusableWidgets().showToast(newUserData.message);
                  }
                },
                child: Center(
                  child: Text(
                    "continue",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.h3,
                    // textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
