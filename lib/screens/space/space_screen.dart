import 'package:corporate_ride_sharing/screens/Account/account.dart';
import 'package:corporate_ride_sharing/screens/giveRide/give_ride.dart';
import 'package:corporate_ride_sharing/screens/requestRide/request_ride.dart';
import 'package:corporate_ride_sharing/screens/rideHistory/ride_history.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:corporate_ride_sharing/utils/style.dart';
import 'package:flutter/material.dart';

class SpaceScreen extends StatefulWidget {
  const SpaceScreen({Key? key}) : super(key: key);

  @override
  State<SpaceScreen> createState() => _SpaceScreenState();
}

class _SpaceScreenState extends State<SpaceScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  final List<int> navigationBarIndexStackList = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = SharedPrefs().indexOfScreenWhereUserLeft;
  }

  void saveIndex(index) async {
    if (!navigationBarIndexStackList.contains(_currentIndex)) {
      navigationBarIndexStackList.add(_currentIndex);
    } else {
      navigationBarIndexStackList.remove(_currentIndex);
      navigationBarIndexStackList.add(_currentIndex);
    }
    if (navigationBarIndexStackList.length > 4) {
      navigationBarIndexStackList.removeAt(0);
    }
    SharedPrefs().indexOfScreenWhereUserLeft = _currentIndex;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (navigationBarIndexStackList.isEmpty || _currentIndex == 0) {
          return Future.value(true);
        }
        navigationBarIndexStackList.remove(_currentIndex);
        setState(() {
          _currentIndex = navigationBarIndexStackList.removeLast();
        });
        return Future.value(false);
      },
      child: Scaffold(
        body: _currentIndex == 0
            ? const RequestRide()
            : _currentIndex == 1
                ? const GiveRide()
                : _currentIndex == 2
                    ? const RideHistory()
                    : const Account(),
        bottomNavigationBar: NavigationBarTheme(
          data: const NavigationBarThemeData(
            indicatorColor: ColorShades.backGroundGrey,
          ),
          child: NavigationBar(
            backgroundColor: ColorShades.backGroundBlack,
            selectedIndex: _currentIndex,
            animationDuration: const Duration(milliseconds: 500),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (index) => saveIndex(index),
            destinations: const [
              NavigationDestination(
                selectedIcon: Icon(Icons.pool),
                icon: Icon(Icons.pool_outlined),
                label: "request",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.directions_car),
                icon: Icon(Icons.directions_car_outlined),
                label: "ride",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.history),
                icon: Icon(Icons.history_outlined),
                label: "history",
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.account_circle),
                icon: Icon(Icons.account_circle_outlined),
                label: "account",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
