import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Question extends StatefulWidget {
  final String category;
  Question({required this.category});

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  bool show = false;
  Stream<QuerySnapshot>? QuizStream;

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  // Fetch quiz data from Firestore based on the category
  getontheload() async {
    QuizStream = FirebaseFirestore.instance
        .collection('quizzes') // Assuming 'quizzes' is the collection name
        .where('category', isEqualTo: widget.category)
        .snapshots();

    setState(() {}); // Update the state once the stream is set
  }

  PageController controller = PageController();

  Widget allQuiz() {
    return StreamBuilder<QuerySnapshot>(
      stream: QuizStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No questions available."));
        }

        return PageView.builder(
          controller: controller,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  SizedBox(height: 40.0),
                  Text(
                    ds['question'], // Assuming 'question' is the field name in Firestore
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.0),
                  buildOption(ds, "option1"),
                  SizedBox(height: 20.0),
                  buildOption(ds, "option2"),
                  SizedBox(height: 20.0),
                  buildOption(ds, "option3"),
                  SizedBox(height: 20.0),
                  buildOption(ds, "option4"),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        show = false;
                      });
                      controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: Icon(Icons.arrow_forward,
                              color: Color(0xFF004840)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Option builder
  Widget buildOption(DocumentSnapshot ds, String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          show = true;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                show && ds['correct'] == ds[option] ? Colors.green : Colors.red,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          ds[option], // Accessing options from Firestore document
          style: TextStyle(
              color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004840),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Color(0xFFf35b32)),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 110.0,
                  ),
                  Text(
                    widget.category,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(child: allQuiz()),
          ],
        ),
      ),
    );
  }
}
