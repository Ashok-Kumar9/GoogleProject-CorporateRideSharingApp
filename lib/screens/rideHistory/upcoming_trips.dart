import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UpcomingTrips extends StatefulWidget {
  const UpcomingTrips({Key? key}) : super(key: key);

  @override
  State<UpcomingTrips> createState() => _UpcomingTripsState();
}

class _UpcomingTripsState extends State<UpcomingTrips> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorShades.backGroundGrey,

        body: ListView.builder(
            itemCount: 1,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return rideHistoryCard(index, context, screenHeight);
            }),
      ),
    );
  }

  Card rideHistoryCard(int index, BuildContext context, double screenHeight) {
    return Card(
      color: ColorShades.lightGrey,
      margin: const EdgeInsets.all(6.0),
      surfaceTintColor: ColorShades.googleRed,
      elevation: 2.0,
      shadowColor: ColorShades.grey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorShades.mediumGrey,
                  child: SvgPicture.asset(
                    'assets/images/svg/${index % 2 == 0 ? "car" : "bike"}.svg',
                    placeholderBuilder: (context) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  "Sun, Sep 14, 08:38 AM",
                  style: Theme.of(context).textTheme.h5,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.my_location_rounded,
                  color: ColorShades.googleRed,
                  size: 16,
                ),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Text(
                    // "Himalaya Mess Rd, Indian Institute Of Technology",
                    "Himalaya Mess Rd, Indian Institute Of Technology, Chennai, Tamil Nadu 600036",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.h6,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
              child: const VerticalDivider(
                color: ColorShades.grey,
                indent: 2.0,
                endIndent: 0.0,
                width: 16.0,
                thickness: 1,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.near_me_rounded,
                  color: ColorShades.googleGreen,
                  size: 16,
                ),
                const SizedBox(width: 6.0),
                Flexible(
                  child: Text(
                    "Airport Rd, Meenambakkam, Chennai, Tamil Nadu 600027",
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(context).textTheme.h6,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
