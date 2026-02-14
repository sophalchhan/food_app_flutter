import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_app/views/screen/history_screen.dart';
import 'package:food_app/views/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String userName = "User";
  String email = "No Email";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "User";
      email = prefs.getString("userEmail") ?? "No Email";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ===== PROFILE HEADER =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              color: Colors.red,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        size: 60, color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  _profileCard(Icons.phone, "Phone",
                      "+855 96 680 9340"),

                  _profileCard(Icons.location_on,
                      "Address", "Phnom Penh, Cambodia"),

                  _profileCard(Icons.payment,
                      "Payment", "Visa **** 1234"),

                  Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading:
                          const Icon(Icons.history),
                      title: const Text(
                        "Order History",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const HistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  _profileCard(Icons.lock,
                      "Change Password", ""),

                  Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.logout,
                          color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight:
                                FontWeight.bold),
                      ),
                      onTap: logout,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold),
        ),
        subtitle:
            subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16),
        onTap: () {},
      ),
    );
  }
}
