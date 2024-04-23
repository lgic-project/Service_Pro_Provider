import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SERVICE PRO'),
      ),
      body: Container(
        height: screenHeight - appBarHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/loginimage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle sign up logic here
                  },
                  child: const Text('Sign Up'),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LoginScreen(onLoginSuccess: _getToken,),
                        //   ),
                        // );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
