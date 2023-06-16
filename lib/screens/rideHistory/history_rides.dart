import 'package:corporate_ride_sharing/screens/rideHistory/past_trips.dart';
import 'package:corporate_ride_sharing/screens/rideHistory/upcoming_trips.dart';
import 'package:flutter/material.dart';

import '../../utils/style.dart';

class HistoryRides extends StatefulWidget {
  const HistoryRides({Key? key}) : super(key: key);

  @override
  _HistoryRidesState createState() => _HistoryRidesState();
}

class _HistoryRidesState extends State<HistoryRides> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorShades.backGroundBlack,
          automaticallyImplyLeading: false,
          title: Text("rides history", style: Theme.of(context).textTheme.h3),
          bottom: TabBar(
            indicatorColor: Colors.lightBlue,
            overlayColor: MaterialStateProperty.all(Colors.black),
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 18.0),
            tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')],
          ),
        ),
        body: const TabBarView(
          children: [
            UpcomingTrips(),
            PastTrips(),
          ],
        ),
      ),
    );
  }
}
