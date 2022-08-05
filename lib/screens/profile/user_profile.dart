import 'package:corporate_ride_sharing/utils/constants.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                isActive: true,
                onPressed: () {
                  if (kDebugMode) {
                    print(_fullNameController.text);
                    print(_emailController.text);
                  }
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/space', (route) => false);
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
