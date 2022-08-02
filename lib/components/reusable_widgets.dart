import 'package:cached_network_image/cached_network_image.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReusableWidgets {
  CachedNetworkImage buildCachedImage(String imageUrl,
      {BoxFit boxFit = BoxFit.cover}) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: boxFit,
          ),
        ),
      ),
      placeholder: (context, url) => threeBounceLoader(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  ClipRRect buildCachedImageWithBlurHash(String imageUrl,
      {BoxFit boxFit = BoxFit.cover,
      String blurHash = "LkQ9_?ae00j[jtayfQj[4nof9Fay"}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10000.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: imageProvider,
              fit: boxFit,
            ),
          ),
        ),
        placeholder: (context, url) => Center(
          child: BlurHash(
            curve: Curves.easeIn,
            imageFit: BoxFit.contain,
            hash: blurHash,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Center threeBounceLoader() {
    return const Center(
      child: SpinKitThreeBounce(
        color: Colors.white,
        size: 20.0,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.h5,
        textAlign: TextAlign.center,
      ),
      backgroundColor: ColorShades.backGroundGrey,
    ));
  }

  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: ColorShades.backGroundGrey,
      textColor: Colors.white,
    );
  }
}
