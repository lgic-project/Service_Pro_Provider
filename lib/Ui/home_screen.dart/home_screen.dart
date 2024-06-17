import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/category_provider/service_provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/get_service_request.dart';
import 'package:service_pro_provider/Provider/login_logout_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final chatUserProvider =
        Provider.of<ChatUserProvider>(context, listen: false);
    final getServiceRequest =
        Provider.of<GetServiceRequest>(context, listen: false);
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    await chatUserProvider.getChatUser(context);
    await getServiceRequest.getServiceRequest(context);
    await serviceProvider.getServices();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<ChatUserProvider, GetServiceRequest, ServiceProvider,
        LoginLogoutProvider>(
      builder: (context, chatUserProvider, getServiceRequest, serviceProvider,
          loginLogoutProvider, child) {
        final userData = chatUserProvider.users;
        final requestData = getServiceRequest.serviceRequests;
        final serviceData = serviceProvider.service;
        final token = loginLogoutProvider.token;

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        final id = decodedToken['id'];

        // Debugging prints
        print('User Data: $userData');
        print('Request Data: $requestData');
        print('Service Data: $serviceData');
        print('Token: $token');
        print('Id: $id');

        // Filter requests by provider ID
        List pendingRequests = requestData.where((request) {
          return request['ProviderId'] == id && request['Status'] == 'pending';
        }).toList();

        List acceptedRequests = requestData.where((request) {
          return request['ProviderId'] == id && request['Status'] == 'accepted';
        }).toList();

        List completedRequests = requestData.where((request) {
          return request['ProviderId'] == id &&
              request['Status'] == 'completed';
        }).toList();

        List rejectedRequests = requestData.where((request) {
          return request['ProviderId'] == id && request['Status'] == 'rejected';
        }).toList();

        Widget buildRequestCard(request) {
          final user = userData.firstWhere(
            (user) => user['_id'] == request['UserId'],
            orElse: () => null,
          );
          final service = serviceData.firstWhere(
            (service) => service['_id'] == request['ServiceId'],
            orElse: () => null,
          );

          return Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User: ${user != null ? user['Name'] : 'Unknown'}'),
                Text(
                    'Service: ${service != null ? service['Name'] : 'Unknown'}'),
                Text('Status: ${request['Status']}'),
                if (request['Status'] == 'pending')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement your accept function here
                        },
                        child: Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your reject function here
                        },
                        child: Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red, // foreground
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requests',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Pending Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (pendingRequests.isEmpty) Text('No pending requests'),
                ...pendingRequests
                    .map((request) => buildRequestCard(request))
                    .toList(),
                SizedBox(height: 16),
                Text(
                  'Accepted Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (acceptedRequests.isEmpty) Text('No accepted requests'),
                ...acceptedRequests
                    .map((request) => buildRequestCard(request))
                    .toList(),
                SizedBox(height: 16),
                Text(
                  'Completed Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (completedRequests.isEmpty) Text('No completed requests'),
                ...completedRequests
                    .map((request) => buildRequestCard(request))
                    .toList(),
                SizedBox(height: 16),
                Text(
                  'Rejected Requests',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (rejectedRequests.isEmpty) Text('No rejected requests'),
                ...rejectedRequests
                    .map((request) => buildRequestCard(request))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
