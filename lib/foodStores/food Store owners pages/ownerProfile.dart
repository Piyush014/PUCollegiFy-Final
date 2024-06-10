import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../Login/login_or_register.dart';
import '../../majorScreen/ResetPassword.dart';
import 'editOwnerProfile.dart';

class OwnerProfileScreen extends StatefulWidget {
  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen> {
  Future<void> _navigateToEditProfile() async {
    final bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOwnerProfile(),
      ),
    );

    if (result == true) {
      // If result is true, it means the profile was edited, so reload the data
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!!'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text("Document doesn't exist."));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final profileImage = data['profile_image'] as String;
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
                      builder: (context) => EditOwnerProfile(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CachedNetworkImage( // Change this line
                  imageUrl: profileImage, // Change this line
                  placeholder: (context, url) => CircularProgressIndicator(), // Optional: Add a placeholder while loading
                  errorWidget: (context, url, error) => Icon(Icons.error), // Optional: Display an error widget when the image fails to load
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 80,
                    backgroundImage: imageProvider,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  data['name'],
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  data['email'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                ProfileSection(
                  title: 'Account Info',
                  children: [
                    ProfileInfoItem(
                      icon: Icons.email,
                      label: 'Email',
                      value: data['email'],
                    ),
                    ProfileInfoItem(
                      icon: Icons.phone,
                      label: 'Phone',
                      value:
                      data['phone'] != '' ? data['phone'] : 'Not provided',
                    ),
                    ProfileInfoItem(
                      icon: Icons.location_on,
                      label: 'Location',
                      value: data['location'] != ''
                          ? data['location']
                          : 'Not provided',
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
      },
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
