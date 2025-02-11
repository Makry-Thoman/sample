import 'package:flutter/material.dart';

class ChoosePetType extends StatefulWidget {
  const ChoosePetType({super.key});

  @override
  State<ChoosePetType> createState() => _ChoosePetTypeState();
}

class _ChoosePetTypeState extends State<ChoosePetType> {
  final List<Map<String, String>> petTypes = [
    {'name': 'Dog', 'icon': '🐶'},
    {'name': 'Cat', 'icon': '🐱'},
    {'name': 'Mouse', 'icon': '🐭'},
    {'name': 'Lizard', 'icon': '🦎'},
    {'name': 'Fish', 'icon': '🐟'},
    {'name': 'Ferret', 'icon': '🦦'},
    {'name': 'Chinchilla', 'icon': '🐹'},
    {'name': 'Snake', 'icon': '🐍'},
    {'name': 'Turtle', 'icon': '🐢'},
    {'name': 'Rabbit', 'icon': '🐰'},
    {'name': 'Guinea pig', 'icon': '🐹'},
    {'name': 'Horse', 'icon': '🐴'},
    {'name': 'Donkey', 'icon': '🐴'},
    {'name': 'Pig', 'icon': '🐷'},
    {'name': 'Goat', 'icon': '🐐'},
    {'name': 'Sheep', 'icon': '🐑'},
    {'name': 'Cattle', 'icon': '🐄'},
    {'name': 'Bird', 'icon': '🐦'},
    {'name': 'Chicken', 'icon': '🐔'},
    {'name': 'Duck', 'icon': '🦆'},
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Choose a pet type'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 10), // Added padding to prevent overflow
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: petTypes.length,
                itemBuilder: (context, index) {
                  final pet = petTypes[index];
                  if (pet['name']!.toLowerCase().contains(searchQuery)) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.amber,
                          child: Text(
                            pet['icon']!,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          pet['name']!,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
