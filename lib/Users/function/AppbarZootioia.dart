import 'package:flutter/material.dart';

AppBar zootopiaAppBar() {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor: Colors.black,
    toolbarHeight: 70,
    title: Image.asset('asset/ZootopiaAppWhite.png', height: 40),
    centerTitle: true,
    actions: [
      PopupMenuButton(
        icon: Icon(Icons.notifications),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("hi"),
            value: 1,
          )
        ],
      ),
    ]

  );
}


