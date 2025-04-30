import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final List<Color> kBackgroundGradient = [
    Color(0xFFF2EFE7),
    Color(0xFF9ACBD0),
    Color(0xFF48A6A7),
    Color(0xFF006A71),
  ];
  final List<String> roles = ['Farmer', 'consumer'];
  String? selectedRole;

  final Color inputFillColor = const Color.fromARGB(255, 252, 255, 255);
  final Color buttonColor = const Color(0xFF006A71);
  final Color hintTextColor = const Color(0xFF006A71);
  final Color textColor = const Color.fromARGB(255, 3, 56, 60);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> registerUser() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/register');

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'mobile': mobileController.text.trim(),
          'password': passwordController.text,
          'role': selectedRole,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Successfully registered
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) => AlertDialog(
                title: const Text('Registration Successful 🎉'),
                // content: const Text('Please login to continue.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                      ); // Go to login
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        final message = data['message'] ?? "Registration failed.";
        _showSnackbar(message);
      }
    } catch (e) {
      _showSnackbar("An error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: kBackgroundGradient,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(
                  fontFamily: 'PlayFair',
                  color: Colors.black87,
                  fontSize: 45,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        children: [
                          _buildTextField(nameController, "Name"),
                          const SizedBox(height: 25),
                          _buildTextField(emailController, "Email"),
                          const SizedBox(height: 25),
                          _buildTextField(mobileController, "Mobile Number"),
                          const SizedBox(height: 25),
                          _buildTextField(
                            passwordController,
                            "Password",
                            isPassword: true,
                          ),
                          const SizedBox(height: 25),

                          // 🔥 Dropdown for selecting role
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: inputFillColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: DropdownButton<String>(
                              value: selectedRole,
                              isExpanded: true,
                              underline: SizedBox(),
                              hint: Text(
                                "Select Role",
                                style: TextStyle(
                                  fontFamily: 'PlayFair',
                                  color: hintTextColor,
                                ),
                              ),
                              items:
                                  roles.map((String role) {
                                    return DropdownMenuItem<String>(
                                      value: role,
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                          fontFamily: 'PlayFair',
                                          color: buttonColor,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRole = newValue;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 35),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/',
                                      );
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontFamily: 'PlayFair',
                                        color: textColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 150),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: buttonColor,
                                    child:
                                        isLoading
                                            ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                            : IconButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                if (_validateInputs()) {
                                                  registerUser();
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward,
                                              ),
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(fontFamily: 'PlayFair', color: buttonColor),
      decoration: InputDecoration(
        filled: true,
        fillColor: inputFillColor,
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'PlayFair', color: hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        selectedRole == null) {
      _showSnackbar("Please fill in all fields and select a role.");
      return false;
    }
    return true;
  }
}
