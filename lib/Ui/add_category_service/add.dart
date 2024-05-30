import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/category_provider.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      'Request to add categories & services',
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
                                      onPressed: _pickImage,
                                      child: Text('Choose Image'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();

                                          Provider.of<CategoryProvider>(context,
                                                  listen: false)
                                              .addCategory(context, name,
                                                  description, _imageFile!.path);
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
          future: Provider.of<CategoryProvider>(context, listen: false)
              .fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                            child: Image.network(image),
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
    );
  }
}