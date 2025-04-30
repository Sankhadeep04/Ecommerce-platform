import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dummy stored data (replace with real data later)
  String name = "John Doe";
  String dob = "01/01/2000";
  String email = "johndoe@example.com";
  String phone = "+91 1234567890";
  String password = "********";
  String address = "123, Flutter Street, India";

  // Track editable fields
  Map<String, bool> isEditing = {
    "name": false,
    "dob": false,
    "email": false,
    "phone": false,
    "password": false,
    "address": false,
  };

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = name;
    dobController.text = dob;
    emailController.text = email;
    phoneController.text = phone;
    passwordController.text = password;
    addressController.text = address;
  }

  @override
  void dispose() {
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    String key,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: isEditing[key]!,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(isEditing[key]! ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                if (isEditing[key]!) {
                  // Save the changes when clicking the check button
                  _saveField(key, controller.text);
                }
                isEditing[key] = !isEditing[key]!;
              });
            },
          ),
        ],
      ),
    );
  }

  void _saveField(String key, String value) {
    setState(() {
      switch (key) {
        case "name":
          name = value;
          break;
        case "dob":
          dob = value;
          break;
        case "email":
          email = value;
          break;
        case "phone":
          phone = value;
          break;
        case "password":
          password = value;
          break;
        case "address":
          address = value;
          break;
      }
    });
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileField("Name", nameController, "name"),
            _buildProfileField("Date of Birth", dobController, "dob"),
            _buildProfileField("Email", emailController, "email"),
            _buildProfileField("Phone Number", phoneController, "phone"),
            _buildProfileField("Password", passwordController, "password"),
            _buildProfileField("Address", addressController, "address"),

            const SizedBox(height: 30),
            const Divider(),

            _buildActionTile("Orders", Icons.shopping_bag_outlined, () {
              // Navigate to Orders
            }),
            _buildActionTile("Wishlist", Icons.favorite_border, () {
              // Navigate to Wishlist
            }),
            _buildActionTile("Settings", Icons.settings, () {
              // Navigate to Settings
            }),
            _buildActionTile("Log Out", Icons.logout, () {
              // Handle Logout
            }),
          ],
        ),
      ),
    );
  }
}
