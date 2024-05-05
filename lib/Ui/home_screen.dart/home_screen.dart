import 'package:flutter/material.dart';
import 'package:service_pro_provider/Ui/chat_screen/chat_screen.dart';
import 'package:service_pro_provider/Ui/home_screen.dart/default_home.dart';
import 'package:service_pro_provider/Ui/profile/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  Color? unSelectedItemColor = Colors.pink[900];
  Color selectedItemColor = Colors.white;
  late Widget currentBody;

  @override
  Widget build(BuildContext context) {
    switch (currentIndex) {
      case 0:
        currentBody = DefaultHome();

        break;
      case 1:
        currentBody = Chat();

        break;

      case 2:
        currentBody = ProfilePage();
        break;
    }
    return SafeArea(
        child: Scaffold(
      // backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Service Pro'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: currentBody,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BottomNavigationBar(
                // type: BottomNavigationBarType.fixed,
                backgroundColor: Theme.of(context).primaryColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/home.png',
                      height: 30,
                      color: currentIndex == 0
                          ? selectedItemColor
                          : unSelectedItemColor,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/chat.png',
                        height: 30,
                        color: currentIndex == 1
                            ? selectedItemColor
                            : unSelectedItemColor),
                    label: 'Chat',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset('assets/icons/profile.png',
                        height: 30,
                        color: currentIndex == 2
                            ? selectedItemColor
                            : unSelectedItemColor),
                    label: 'Profile',
                  ),
                  // BottomNavigationBarItem(
                  //   icon: Image.asset('assets/icons/profile.png',
                  //       height: 30,
                  //       color: currentIndex == 3
                  //           ? selectedItemColor
                  //           : unSelectedItemColor),
                  //   label: 'Profile',
                  // ),
                ],
                currentIndex: currentIndex,
                selectedItemColor: selectedItemColor,
                unselectedItemColor: unSelectedItemColor,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
