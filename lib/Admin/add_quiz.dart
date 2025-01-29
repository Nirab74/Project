import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({super.key});

  @override
  State<AddQuiz> createState() => _AddQuizState();
}

class _AddQuizState extends State<AddQuiz> {
  String? value; // selected category

  // Text editing controllers for quiz options and correct answer
  TextEditingController questionController = TextEditingController();
  TextEditingController option1controller = TextEditingController();
  TextEditingController option2controller = TextEditingController();
  TextEditingController option3controller = TextEditingController();
  TextEditingController option4controller = TextEditingController();
  TextEditingController correctanswercontroller = TextEditingController();

  // List of quiz categories
  final List<String> quizItems = [
    'Animal',
    'Sports',
    'Fruits',
    'Place',
    'Objects',
    'Random'
  ];

  // Function to upload the quiz to Firestore
  uploadItem() async {
    if (questionController.text != "" &&
        option1controller.text != "" &&
        option2controller.text != "" &&
        option3controller.text != "" &&
        option4controller.text != "" &&
        correctanswercontroller.text != "") {
      try {
        // Prepare the quiz data
        Map<String, dynamic> addQuiz = {
          "question": questionController.text,
          "option1": option1controller.text,
          "option2": option2controller.text,
          "option3": option3controller.text,
          "option4": option4controller.text,
          "correct": correctanswercontroller.text,
          "category": value,
        };

        // Add quiz data to Firestore
        FirebaseFirestore.instance
            .collection('quizzes')
            .add(addQuiz)
            .then((value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Quiz has been added successfully",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }).catchError((error) {
          print("Failed to add quiz: $error");
        });
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Quiz",
          style: TextStyle(
              color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter the Question",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700)),
              SizedBox(
                height: 20.0,
              ),
              TextFieldWidget(
                  controller: questionController, hintText: "Question"),
              SizedBox(height: 20.0),
              Text("Option 1",
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
              SizedBox(height: 20.0),
              TextFieldWidget(
                  controller: option1controller, hintText: "Option 1"),
              SizedBox(height: 20.0),
              Text("Option 2",
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
              SizedBox(height: 20.0),
              TextFieldWidget(
                  controller: option2controller, hintText: "Option 2"),
              SizedBox(height: 20.0),
              Text("Option 3",
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
              SizedBox(height: 20.0),
              TextFieldWidget(
                  controller: option3controller, hintText: "Option 3"),
              SizedBox(height: 20.0),
              Text("Option 4",
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
              SizedBox(height: 20.0),
              TextFieldWidget(
                  controller: option4controller, hintText: "Option 4"),
              SizedBox(height: 20.0),
              Text("Correct Answer",
                  style: TextStyle(color: Colors.black87, fontSize: 20.0)),
              SizedBox(height: 20.0),
              TextFieldWidget(
                  controller: correctanswercontroller,
                  hintText: "Enter correct Answer"),
              SizedBox(height: 20.0),
              CategoryDropdown(
                value: value,
                quizItems: quizItems,
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: uploadItem,
                child: Center(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const TextFieldWidget(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? value;
  final List<String> quizItems;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown(
      {Key? key,
      required this.value,
      required this.quizItems,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFececf8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: quizItems
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          hint: Text("Select Category"),
          iconSize: 36,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          value: value,
        ),
      ),
    );
  }
}
