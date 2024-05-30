import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/login_logout_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).userProfile(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<LoginLogoutProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Consumer<ProfileProvider>(builder: (context, profile, child) {
          var user = profile.data;
          final profilePic = (user['Image'] ??
              'https://dudewipes.com/cdn/shop/articles/gigachad.jpg?v=1667928905&width=2048');
          return Container(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF43cbac), Colors.white],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profilePic.toString()),
                        ),
                      ),
                      SizedBox(height: 10),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: ListTile(
                          title: Text(
                            user['Name'] ?? 'User Name',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF43cbac),
                            ),
                          ),
                          subtitle: Text(
                            user['Email'] ?? 'User Email',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF43cbac),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
