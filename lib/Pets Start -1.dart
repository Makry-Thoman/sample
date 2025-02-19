import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zootopia/Animaltype.dart';

import 'package:zootopia/function/AppbarZootioia.dart';
import 'package:zootopia/function/DrawerBar.dart';

class PetName extends StatefulWidget {
  const PetName({super.key});

  @override
  State<PetName> createState() => _PetNameState();
}

class _PetNameState extends State<PetName> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _dobController = TextEditingController();
  String? gender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('MMM d,yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: zootopiaAppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "It takes 20 seconds!",
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(
                      height: 200,
                      child: Image(image: AssetImage('asset/CreatePet.png'))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    // Space between label and TextField
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pet Name', // Label text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _petNameController,
                    decoration: InputDecoration(
                        hintText: 'Mr.Cuddles',
                        prefixIcon: Icon(Icons.pets),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a name';
                      }
                      return null;
                    },
                  ),
                  Row(children: [
                    Radio(
                      value: 'male',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(
                          () {
                            gender = value;
                          },
                        );
                      },
                    ),
                    Icon(
                      Icons.male,
                      color: Colors.blue,
                    ),
                    Text(
                      'Male',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 25),
                    Radio(
                      value: 'female',
                      groupValue: gender,
                      onChanged: (value) {
                        setState(() {
                          gender = value;
                        });
                      },
                    ),
                    Icon(Icons.female, color: Colors.pink),
                    Text(
                      'Female',
                      style: TextStyle(fontSize: 18),
                    )
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    // Space between label and TextField
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pet's date of birth", // Label text
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child:AbsorbPointer(child:  TextFormField(
                      controller: _dobController,
                      decoration: InputDecoration(
                          hintText: 'Select date of brith of your pet',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select date of birth';
                        }
                        return null;
                      },
                    ),
                    )
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                    style: ButtonStyle(     backgroundColor: MaterialStateProperty.all(Colors.black),
                        foregroundColor: MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                    if (_formKey.currentState!.validate() && gender != null) {
                      print(
                          'Pet Name: ${_petNameController.text}, Gender: $gender, DOB: ${_dobController.text}');
                      Navigator.push(context,MaterialPageRoute(builder: (context) => ChoosePetType(petName: _petNameController.text,
                        dob: _dobController.text,
                        gender: gender!,),));

                      // ScaffoldMessenger.of(context)
                      //     .showSnackBar(SnackBar(content: Text("Successful logged in${_petNameController.text}")));
                    }
                    else if (gender == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a gender $PetName')),
                      );
                    }

                  },
                    child: Text('Continue'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
