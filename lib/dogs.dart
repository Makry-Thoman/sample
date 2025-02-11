import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:zootopia/MedicalHistory.dart';
import 'package:zootopia/Mypets.dart';

class Dogs extends StatelessWidget {
  const Dogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            enableInfiniteScroll: true,
          ),
          items: [
            Image.asset('asset/or.png', fit: BoxFit.fitWidth),
            Image.asset('asset/aaa.png', fit: BoxFit.fill),
            Image.asset('asset/a.png'),
            Image.asset('asset/White and Black.png'),
          ].map((item) {
            return Container(
              child: Center(
                child: item,
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: Size(170, 60), // Increase width and height
                    textStyle: TextStyle(fontSize: 20), // Increase font size
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mypets(),
                        ));
                  },
                  child: Text(
                    "My Pets",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,

                fixedSize: Size(170, 60), // Increase width and height
                textStyle: TextStyle(fontSize: 20), // Increase font size
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Medicalhistory(),
                    ));
              },
              child: Text(
                "Medical History",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: Size(170, 60), // Increase width and height
                    textStyle: TextStyle(fontSize: 20), // Increase font size
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Mypets(),
                        ));
                  },
                  child: Text(
                    "Hospital",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,

                fixedSize: Size(170, 60), // Increase width and height
                textStyle: TextStyle(fontSize: 20), // Increase font size
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Medicalhistory(),
                    ));
              },
              child: Text(
                "Vacination ",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class Cats extends StatelessWidget {
  const Cats({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          Container(
            width: 385,
            height: 70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/kitty-cat-kitten-pet-45201.jpeg"),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: 385,
            height:70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/kitty-cat-kitten-pet-45201.jpeg"),
                    fit: BoxFit.cover)),
          ),
          Container(
            width: 385,
            height: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("asset/kitty-cat-kitten-pet-45201.jpeg0"),
                    fit: BoxFit.cover)),
          ),
        ],

    );
  }
}
