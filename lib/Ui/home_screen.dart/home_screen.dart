import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/category_provider/service_provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/get_service_request.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/login_logout_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color tabColor = Colors.black;

  final List<Color> tabColors = [
    Colors.orange,
    Colors.green,
    Colors.blue,
    Colors.red
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          tabColor = tabColors[_tabController.index];
        });
      }
    });
    fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('Pending',
                  style: TextStyle(
                      color: Colors.orange)), // Specific color for this tab
            ),
            Tab(
              child: Text('Accepted',
                  style: TextStyle(
                      color: Colors.green)), // Specific color for this tab
            ),
            Tab(
              child: Text('Completed',
                  style: TextStyle(
                      color: Colors.blue)), // Specific color for this tab
            ),
            Tab(
              child: Text('Rejected',
                  style: TextStyle(
                      color: Colors.red)), // Specific color for this tab
            ),
          ],
          indicatorColor: tabColor,
        ),
      ),
      body: Consumer4<ChatUserProvider, GetServiceRequest, ServiceProvider,
          LoginLogoutProvider>(
        builder: (context, chatUserProvider, getServiceRequest, serviceProvider,
            loginLogoutProvider, child) {
          final userData = chatUserProvider.users;
          final requestData = getServiceRequest.serviceRequests;
          final serviceData = serviceProvider.service;
          final token = loginLogoutProvider.token;

          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          final id = decodedToken['id'];

          List getFilteredRequests(String status) {
            return requestData
                .where((request) =>
                    request['ProviderId'] == id && request['Status'] == status)
                .toList();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              RequestList(
                  requests: getFilteredRequests('pending'),
                  status: 'pending',
                  userData: userData,
                  serviceData: serviceData),
              RequestList(
                  requests: getFilteredRequests('accepted'),
                  status: 'accepted',
                  userData: userData,
                  serviceData: serviceData),
              RequestList(
                  requests: getFilteredRequests('completed'),
                  status: 'completed',
                  userData: userData,
                  serviceData: serviceData),
              RequestList(
                  requests: getFilteredRequests('rejected'),
                  status: 'rejected',
                  userData: userData,
                  serviceData: serviceData),
            ],
          );
        },
      ),
    );
  }
}

class RequestList extends StatelessWidget {
  final List requests;
  final String status;
  final List userData;
  final List serviceData;

  const RequestList({
    Key? key,
    required this.requests,
    required this.status,
    required this.userData,
    required this.serviceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? Center(child: Text('No $status requests'))
        : ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) => RequestCard(
              request: requests[index],
              userData: userData,
              serviceData: serviceData,
            ),
          );
  }
}

class RequestCard extends StatelessWidget {
  final Map<String, dynamic> request;
  final List userData;
  final List serviceData;

  const RequestCard({
    Key? key,
    required this.request,
    required this.userData,
    required this.serviceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = userData.firstWhere(
      (user) => user['_id'] == request['UserId'],
      orElse: () => {'Name': 'Unknown'},
    );
    final service = serviceData.firstWhere(
      (service) => service['_id'] == request['ServiceId'],
      orElse: () => {'Name': 'Unknown'},
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User: ${user['Name']}',
                style: Theme.of(context).textTheme.subtitle1),
            Text('Service: ${service['Name']}',
                style: Theme.of(context).textTheme.subtitle1),
            Text('Status: ${request['Status']}',
                style: Theme.of(context).textTheme.subtitle2),
            if (request['Status'] == 'pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _showConfirmationDialog(
                        context, 'Accept', request['_id']),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () => _showConfirmationDialog(
                        context, 'Reject', request['_id']),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String action, String requestId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Request'),
        content: Text('Are you sure you want to $action this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final getServiceRequest =
                  Provider.of<GetServiceRequest>(context, listen: false);
              if (action == 'Accept') {
                await getServiceRequest.acceptRequest(context, requestId);
              } else {
                await getServiceRequest.rejectRequest(context, requestId);
              }
              Navigator.pop(context);
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
