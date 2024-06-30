import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/service_provider/service_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:service_pro_provider/Provider/login_signup_provider/signup_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? _profileImage;
  final List<XFile> _documentImages = [];
  final List<String> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    await serviceProvider.getServices();
    print('services fetched ${serviceProvider.service}');
  }

  Future<XFile> _compressImage(XFile file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 25,
    );

    return result!;
  }

  Future<void> _pickImage(ImageSource source, bool isProfileImage) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final compressedFile = await _compressImage(pickedFile);
      setState(() {
        if (isProfileImage) {
          _profileImage = XFile(compressedFile.path);
        } else {
          _documentImages.add(XFile(compressedFile.path));
        }
      });
    }
  }

  Future<void> _signUp() async {
    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    String? profileImgUrl;
    List<String?> documentUrls = [];

    if (_profileImage != null) {
      profileImgUrl =
          await signUpProvider.uploadImage(context, _profileImage!.path);
    }

    for (var doc in _documentImages) {
      final docUrl = await signUpProvider.uploadImage(context, doc.path);
      if (docUrl != null) {
        documentUrls.add(docUrl);
      }
    }

    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    final selectedServiceIds = serviceProvider.service
        .where((service) => _selectedItems.contains(service['Name']))
        .map((service) => service['_id'])
        .toList();

    try {
      await signUpProvider.signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _addressController.text,
        _phoneController.text,
        'provider',
        profileImgUrl ?? '',
        documentUrls,
        selectedServiceIds,
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      print('Sign up failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIGN UP'),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep < 3) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() => _currentStep += 1);
            }
          } else {
            _signUp();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: <Step>[
          Step(
            title: const Text('Step 1'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone No'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 2'),
            content: Column(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery, true),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null
                        ? FileImage(File(_profileImage!.path))
                        : null,
                    child: _profileImage == null
                        ? const Text('Select Profile Image')
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  children: _documentImages.map((file) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        image: DecorationImage(
                          image: FileImage(File(file.path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery, false),
                  child: const Text('Select Documents'),
                ),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 3'),
            content: Consumer<ServiceProvider>(
              builder: (context, serviceProvider, _) {
                final services = serviceProvider.service;
                return services.isNotEmpty
                    ? Column(
                        children: services.map((service) {
                          return CheckboxListTile(
                            title: Text(service['Name']),
                            value: _selectedItems.contains(service['Name']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedItems.add(service['Name']);
                                } else {
                                  _selectedItems.remove(service['Name']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      )
                    : const CircularProgressIndicator();
              },
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 4'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${_nameController.text}'),
                Text('Email: ${_emailController.text}'),
                Text('Phone: ${_phoneController.text}'),
                Text('Address: ${_addressController.text}'),
                Text('Selected Services: ${_selectedItems.join(', ')}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Submit'),
                ),
              ],
            ),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
