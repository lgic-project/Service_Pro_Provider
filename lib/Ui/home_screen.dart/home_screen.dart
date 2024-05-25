import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Rating and Reviews',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          RatingBarIndicator(
            rating: 4, // replace with your provider rating
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.yellow,
            ),
            itemCount: 5,
            itemSize: 40.0,
            direction: Axis.horizontal,
          ),
          SizedBox(height: 24),
          Container(
            height: 200, // adjust this value as needed
            child: ListView.builder(
              itemCount: 4, // replace with your list of reviews length
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Great job, keep doing'), // replace with your provider review
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Request',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text('Category: Plumbing'), // replace with your category name
                Text('Service: Fixing Leaks'), // replace with your service name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {}, // implement your accept function
                      child: Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () {}, // implement your reject function
                      child: Text('Reject'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red, // foreground
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}