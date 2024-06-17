import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Provider/category_provider/category_provider.dart';
import 'package:service_pro_provider/Provider/category_provider/put_category_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  final ImagePicker _picker = ImagePicker();
  String? _compressedImageUrl;

  Future<void> _pickAndCompressImage(
      BuildContext context, String categoryId) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getTemporaryDirectory();
      final targetPath = path.join(directory.path,
          '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
      );

      if (compressedFile != null) {
        final imageUrl =
            await Provider.of<UpdateCategory>(context, listen: false)
                .uploadCategoryImage(context, compressedFile.path);
        if (imageUrl != null) {
          setState(() {
            _compressedImageUrl = imageUrl;
            print('Compressed and uploaded image URL: $_compressedImageUrl');
          });
        } else {
          print('Image upload failed');
        }
      } else {
        print('Image compression failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildAddCategoryButton(context),
            const SizedBox(height: 10),
            _buildCategoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueAccent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Add Categories',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              setState(() {
                _compressedImageUrl = null;
              });
              await _showAddCategoryDialog(context);
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
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
                  decoration: const InputDecoration(labelText: 'Description'),
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
                const SizedBox(height: 10),
                if (_compressedImageUrl != null)
                  Image.network(
                    _compressedImageUrl!,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        Lottie.asset('assets/lotties_animation/error.json'),
                  ),
                ElevatedButton(
                  onPressed: () => _pickAndCompressImage(context, ''),
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  Provider.of<CategoryProvider>(context, listen: false)
                      .addCategory(context, name, description);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<CategoryProvider>(context).fetchCategories(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(
        //     child: CircularProgressIndicator(),
        //   );
        // } else if (snapshot.error != null) {
        //   return const Center(child: Text('An error occurred!'));
        // } else {
        final data = Provider.of<CategoryProvider>(context, listen: false).data;
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
                    child: Image.network(
                      image,
                      errorBuilder: (context, error, stackTrace) =>
                          Lottie.asset('assets/lotties_animation/error.json'),
                    ),
                  ),
                  title: Text(categoryItem['Name']),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            _compressedImageUrl = null;
                          });
                          await _showEditCategoryDialog(context, categoryItem);
                        },
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      ),
                      IconButton(
                        onPressed: () {
                          // Delete functionality can be added here
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
        //}
      },
    );
  }

  Future<void> _showEditCategoryDialog(
      BuildContext context, dynamic categoryItem) async {
    final _formKey = GlobalKey<FormState>();
    String updatedName = categoryItem['Name'];
    String? imageUrl;

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: categoryItem['Name'],
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    updatedName = value!;
                  },
                ),
                const SizedBox(height: 10),
                if (_compressedImageUrl != null)
                  Image.network(
                    _compressedImageUrl!,
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) =>
                        Lottie.asset('assets/lotties_animation/error.json'),
                  ),
                ElevatedButton(
                  onPressed: () =>
                      _pickAndCompressImage(context, categoryItem['_id']),
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  imageUrl = _compressedImageUrl ?? categoryItem['Image'];

                  bool isSuccess = await Provider.of<UpdateCategory>(context,
                          listen: false)
                      .updateCategory(
                          context, categoryItem['_id'], updatedName, imageUrl!);

                  if (isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category updated successfully!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category update failed.'),
                      ),
                    );
                  }

                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
