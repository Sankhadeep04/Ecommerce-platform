import 'package:ecommerce_application/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  late AnimationController _controller;
  late Animation<Offset> _logoAnimation;
  late Animation<Offset> _textAnimation;
  late Animation<double> _emailFadeAnimation;
  late Animation<double> _passwordFadeAnimation;
  late Animation<double> _buttonFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    _textAnimation = Tween<Offset>(
      begin: const Offset(0, -4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.4, curve: Curves.easeOut),
      ),
    );

    _emailFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.6, curve: Curves.easeIn),
      ),
    );

    _passwordFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
      ),
    );

    _buttonFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/login');

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];

        print("Received token: $token");

        if (token == null) {
          _showSnackbar("No token received.");
          return;
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        await checkStoredToken();
        // Debug print to check if the token is saved in SharedPreferences
        print("Token saved in SharedPreferences: ${prefs.getString('token')}");

        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => AlertDialog(
                title: const Text('Login Successful 🎉'),
                content: const Text('You will be redirected to the homepage.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      print("✅ Navigating to /home...");
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushReplacementNamed('/home', arguments: token);
                    },
                    child: const Text('Continue'),
                  ),
                ],
              ),
        );
        await fetchUserProfile();
      } else {
        final message = jsonDecode(response.body)['message'] ?? "Login failed.";
        _showSnackbar(message);
      }
    } catch (e) {
      _showSnackbar("An error occurred. Please try again later.");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/api/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        debugPrint(
          "⚠️ Could not fetch user profile. Status: ${response.statusCode}",
        );
      } else {
        debugPrint("✅ Successfully fetched user profile.");
      }
    } catch (e) {
      debugPrint("🛑 Error fetching user profile: $e");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          _buildLoginForm(size),
          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLoginForm(Size size) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: kBackgroundGradient,
          stops: const [0.00, 0.33, 0.66, 1.00],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(size.height * 0.050),
        child: OverflowBar(
          overflowSpacing: size.height * 0.014,
          overflowAlignment: OverflowBarAlignment.center,
          children: [
            const SizedBox(height: 40),

            // 👇 Logo drops
            SlideTransition(
              position: _logoAnimation,
              child: Image.asset(
                'assets/logos/logo.png',
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            // 👇 Welcome text drops
            SlideTransition(
              position: _textAnimation,
              child: _buildHeaderText(),
            ),

            // 👇 Email field fades
            FadeTransition(
              opacity: _emailFadeAnimation,
              child: _buildTextField(
                controller: emailController,
                hintText: "Email",
                icon: Icons.email,
                isPassword: false,
              ),
            ),

            // 👇 Password field fades
            FadeTransition(
              opacity: _passwordFadeAnimation,
              child: _buildTextField(
                controller: passwordController,
                hintText: "Password",
                icon: Icons.lock,
                isPassword: true,
              ),
            ),

            // 👇 Login button fades
            FadeTransition(
              opacity: _buttonFadeAnimation,
              child: _buildContinueButton(size),
            ),

            _buildDivider(),
            FadeTransition(
              opacity: _buttonFadeAnimation,
              child: _buildCreateAccountButton(size),
            ),
            // "Create new Account" button (no animation)
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      children: const [
        Text(
          "Welcome Back",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 32,
            fontFamily: 'PlayFair',
            color: Color.fromARGB(255, 8, 70, 68),
          ),
        ),
        SizedBox(height: 60),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isPassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType:
          isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
      style: const TextStyle(
        color: Color.fromARGB(255, 39, 39, 39),
        fontFamily: 'PlayFair',
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
        filled: true,
        fillColor: kWhiteColor,
        hintText: hintText,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Icon(icon, color: kInputColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildContinueButton(Size size) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed:
          isLoading
              ? null
              : () {
                String email = emailController.text.trim();
                String password = passwordController.text;
                if (email.isNotEmpty && password.isNotEmpty) {
                  loginUser(email, password);
                } else {
                  _showSnackbar("Please fill in both fields.");
                }
              },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          color: kButtonColor,
          borderRadius: BorderRadius.circular(37),
        ),
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: <Widget>[
        const Expanded(child: Divider(color: Colors.white70)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Or",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kWhiteColor.withOpacity(0.8),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.white70)),
      ],
    );
  }

  Widget _buildCreateAccountButton(Size size) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              blurRadius: 45,
              spreadRadius: 0,
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 25),
            ),
          ],
          color: Colors.white24,
          borderRadius: BorderRadius.circular(37),
        ),
        child: const Text(
          "Create new Account",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: kWhiteColor,
          ),
        ),
      ),
    );
  }

  Future<void> checkStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("🔍 Stored token: $token");
  }
}
