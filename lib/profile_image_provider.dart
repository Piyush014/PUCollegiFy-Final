import 'package:flutter/material.dart';

class ProfileImageProvider extends StatefulWidget {
  final Widget child;

  ProfileImageProvider({required this.child});

  static _ProfileImageProviderState of(BuildContext context) =>
      context.findAncestorStateOfType<_ProfileImageProviderState>()!;

  @override
  _ProfileImageProviderState createState() => _ProfileImageProviderState();
}

class _ProfileImageProviderState extends State<ProfileImageProvider> {
  String? profileImage; // This holds the profile_image URL

  // Function to update the profile_image
  void updateProfileImage(String imageUrl) {
    setState(() {
      profileImage = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
