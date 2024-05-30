import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    return SingleChildScrollView(
      child: Consumer<ProfileProvider>(builder: (context, profile, child) {
        Color activeColor = Colors.grey;
        final active = profile.data['Active'];
        if (active == false) {
          activeColor = Colors.red;
        } else if (active == true) {
          activeColor = Colors.green;
        }
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
                decoration: const BoxDecoration(
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
                            color: activeColor.withOpacity(0.9),
                            spreadRadius: 5,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profilePic.toString()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListTile(
                        title: Text(
                          user['Name'] ?? 'Invalid Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF43cbac),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Services: ${user['ServiceAnalytics']['TotalServices'].toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF43cbac),
                              ),
                            ),
                            Text(
                              'Completed Services: ${user['ServiceAnalytics']['CompletedServices'].toString()}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF43cbac),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Rating and Reviews',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: RatingBarIndicator(
                        rating: 4, // replace with your provider rating
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                        itemCount: 5,
                        itemSize: 40.0,
                        direction: Axis.horizontal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 200, // adjust this value as needed
                      child: ListView.builder(
                        itemCount:
                            4, // replace with your list of reviews length
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                    'Great job, keep doing'), // replace with your provider review
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
