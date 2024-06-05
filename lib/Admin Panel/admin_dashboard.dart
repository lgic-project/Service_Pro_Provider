import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Provider/category_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Admin'),),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Add categories',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        final _formKey = GlobalKey<FormState>();
                        String name = '';
                        String description = '';

                        return await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Form(
                                key: _formKey,
                                child: Wrap(
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration:
                                          InputDecoration(labelText: 'Name'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            name = value!;
                                          },
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Description'),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter a description';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            description = value!;
                                          },
                                        ),

                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              _formKey.currentState!.save();

                                              Provider.of<CategoryProvider>(context,
                                                  listen: false)
                                                  .addCategory(context, name,
                                                  description );
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('Submit'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: Image.asset('assets/icons/add.png'))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: Provider.of<CategoryProvider>(context)
                  .fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.error != null) {
                  return const Center(child: Text('An error occurred!'));
                } else {
                  final data =
                      Provider.of<CategoryProvider>(context, listen: false).data;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final categoryItem = data[index];
                          String image = categoryItem['Image'].toString();
                          image = image.replaceFirst('localhost', '20.52.185.247');
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: ListTile(
                              leading: Container(
                                width: 50,
                                child: Image.network(image,

                                  errorBuilder: (context, error, stackTrace) =>  Lottie.asset('assets/lotties_animation/error.json'),),
                              ),
                              title: Text(categoryItem['Name']),
                              trailing: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/icons/edit.png'),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Image.asset('assets/icons/delete.png'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ],
        ),
      );
    }
}
