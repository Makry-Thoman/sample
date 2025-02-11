import 'package:flutter/material.dart';

Drawer MyDrawer() {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text('Akhil'),
          accountEmail: Text('akhilcanto@gamil.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage:
                AssetImage("asset/kitty-cat-kitten-pet-45201.jpeg"),
          ),
          decoration: BoxDecoration(
            color: Colors.grey, // Set your background color here
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(30),
              // bottom: Radius.circular(300), // Optional: gives rounded corners to the bottom
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text(
            "Logout",
            style: TextStyle(color: Colors.black),
          ),
        )
      ],
    ),
  );
}
