import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dummy/majorScreen/editUserProfile.dart';
import '../Login/login_or_register.dart';
import '../foodStores/orderScreen.dart';
import 'ResetPassword.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};

  Future<void> loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (userDoc.exists) {
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf2f2f2),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff252525),
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditUserProfile(),
                ),
              ).then((_) {
                loadUserData();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: CircleAvatar(
                radius: 80,
                backgroundImage: CachedNetworkImageProvider(
                  userData['profile_image'] ?? '',
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              userData['name'] ?? 'Name not provided',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              userData['email'] ?? 'Email not provided',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            ProfileSection(title: 'My Activity', children: [
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('My Orders'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text('My Events'),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Placeholder(),
                //     ),
                //   );
                // },
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('My Locations'),
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => Placeholder(),
                  //   ),
                  // );
                },
              ),
            ]),
            SizedBox(height: 24),
            ProfileSection(
              title: 'Account Info',
              children: [
                ProfileInfoItem(
                  icon: Icons.email,
                  label: 'Email',
                  value: userData['email'] ?? 'Email not provided',
                ),
                ProfileInfoItem(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: userData['phone'] ?? 'Phone not provided',
                ),
                ProfileInfoItem(
                  icon: Icons.location_on,
                  label: 'Location',
                  value: userData['address'] ?? 'Location not provided',
                ),
              ],
            ),
            SizedBox(height: 24),
            ProfileSection(
              title: 'Settings',
              children: [
                ProfileSettingsItem(
                  icon: Icons.lock,
                  label: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetPassword(),
                      ),
                    );
                  },
                ),
                ProfileSettingsItem(
                  icon: Icons.logout,
                  label: 'Log Out',
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginOrRegister(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xff252525),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Color(0xff252525),
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}

class ProfileSettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  ProfileSettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xff252525),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Color(0xff252525),
        ),
      ),
      onTap: onTap,
    );
  }
}
