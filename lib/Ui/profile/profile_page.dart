import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/profile_provider.dart';
import '../../Provider/user_provider.dart';

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profilePic.toString()),
                      ),
                      SizedBox(height: 10),
                      Text(
                        user['Name'] ?? 'User Name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        user['Email'] ?? 'User Email',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ListTile(
                      //   leading: const Icon(Icons.key),
                      //   title: TextButton(
                      //     onPressed: () {
                      //       // TODO: Implement change password functionality
                      //       showDialog(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return AlertDialog(
                      //             title: const Text('Change Password'),
                      //             content: const Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 TextField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Current Password',
                      //                   ),
                      //                 ),
                      //                 TextField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'New Password',
                      //                   ),
                      //                 ),
                      //                 TextField(
                      //                   decoration: InputDecoration(
                      //                     labelText: 'Retype New Password',
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   // TODO: Save password changes
                      //                   Navigator.pop(context);
                      //                 },
                      //                 child: const Text('Save'),
                      //               ),
                      //               TextButton(
                      //                 onPressed: () {
                      //                   // TODO: Discard password changes
                      //                   Navigator.pop(context);
                      //                 },
                      //                 child: const Text('Discard'),
                      //               ),
                      //             ],
                      //           );
                      //         },
                      //       );
                      //     },
                      //     child: const Text(
                      //       'Change Password',
                      //       style: TextStyle(fontSize: 20, color: Colors.black),
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: TextButton(
                          onPressed: () {
                            // Show confirmation dialog for logout
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text(
                                      'Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close the dialog
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        userProvider.logOut();
                                        Navigator.pushReplacementNamed(
                                            context, '/login');
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })),
    );
  }
}