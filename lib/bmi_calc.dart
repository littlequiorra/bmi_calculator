import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(BMICalculatorApp());

//String gender = 'Male';

class BMICalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      home: BMICalculator(),
    );

  }
}

class BMICalculator extends StatefulWidget {
  const BMICalculator({Key? key}) : super(key: key);

  @override
  _BMICalculatorState createState() => _BMICalculatorState();
}
class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // Add variable for gender
  String? gender;
  String bmiResult = ''; // Store the BMI result in a variable
  String bmiStatus = '';

  String _calculateBMI() {
    String heightText = heightController.text;
    String weightText = weightController.text;

    try {
      double height = double.parse(heightText);
      double weight = double.parse(weightText);

      if (height <= 0 || weight <= 0) {
        // Handle the case where height or weight is not a positive number
        return '';
      }
      double bmi = weight / pow(height / 100, 2);
      String status = _bmiStatus(bmi, gender!);
      setState(() {
        bmiStatus = status;
        fullnameController.clear();
        heightController.clear();
        weightController.clear();
      } );
      return bmi.toStringAsFixed(2);


    } catch (e) {
      // Handle the case where parsing fails
      return '';
    }
  }

  String _bmiStatus(double bmi, String gender) {
    if (gender == "Male") {
      if (bmi < 18.5) {
        return "Underweight. Careful during strong wind!";
      } else if (bmi >= 18.5 && bmi <= 24.9) {
        return "That’s ideal! Please maintain";
      } else if (bmi >= 25.0 && bmi <= 29.9) {
        return "Overweight! Work out please";
      } else {
        return "Whoa Obese! Dangerous mate!";
      }
    } else {
      if (bmi < 16) {
        return "Underweight. Careful during strong wind!";
      } else if (bmi >= 16 && bmi <= 22) {
        return "That’s ideal! Please maintain";
      } else if (bmi > 22 && bmi <= 27) {
        return "Overweight! Work out please";
      } else {
        return "Whoa Obese! Dangerous mate!";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: fullnameController,
              decoration: InputDecoration(labelText: 'Your Fullname'),
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height in cm; 170'),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight in KG'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 250, top: 10.0),
              child: Text('BMI Value: $bmiResult'), // Display the BMI result here
            ),

            SizedBox(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 30),
                      child: Radio(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (value) {
                          // Update gender without triggering setState
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                    ),
                    Text('Male'),
                    Padding(
                      padding: const EdgeInsets.only(left: 35.0, right: 30),
                      child: Radio(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (value) {
                          // Update gender without triggering setState
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                    ),
                    Text('Female'),
                  ],
                ),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  // Call _calculateBMI when the button is pressed
                  String result = _calculateBMI();
                  setState(() {
                    bmiResult = result; // Update the BMI result variable
                  });
                },
                child: Text('Calculate BMI'),
              ),
            ),

            // Display the BMI status
        Text(
          ' $bmiStatus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
     ] ),
    )
    );
  }
}
