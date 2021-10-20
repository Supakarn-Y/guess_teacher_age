import 'package:flutter/material.dart';

import 'package:flutter_spinbox/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guess_teacher_age/service/api.dart';
import 'package:http/http.dart' as http;

class guessAge extends StatefulWidget {
  const guessAge({Key? key}) : super(key: key);

  @override
  _guessAgeState createState() => _guessAgeState();
}

class _guessAgeState extends State<guessAge> {
  int year = 0;
  int month = 0;
  bool check = false;

  void _showMaterialDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: GoogleFonts.roboto()),
          content: Text(content, style: GoogleFonts.roboto()),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

   _guess() async {
    var data = (await Api()
            .submit("guess_teacher_age", {'year': year, 'month': month}))
        as Map<String, dynamic>;
    if (data == null) {
      return;
    } else {
      String text = data['text'];
      bool value = data['value'];
      if (value) {
        setState(() {
          check = true;
        });
      } else {
        _showMaterialDialog("ผลการทาย", text);
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER AGE"),
      ),
      body: Container(
        color: Colors.yellow.shade100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: check
                ? [
                    Text('อายุอาจารย์',style: TextStyle(fontSize: 40.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${year} ปี  ${month} เดือน',style: TextStyle(fontSize: 30.0)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.check,size: 40.0,),
                    )
                  ]
                : [
                    Text(
                      "อายุอาจารย์",
                      style: TextStyle(fontSize: 40.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          border: Border.all(width: 5.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Text("ปี", style: TextStyle(fontSize: 25.0)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SpinBox(
                                min: 0,
                                max: 100,
                                value: 0,
                                onChanged: (value) {
                                  setState(() {
                                    String str = value.toString();
                                    int index = str.indexOf(".");
                                    String ss = str.substring(0,index);
                                    year = int.parse(ss);
                                  });
                                },
                              ),
                            ),
                            Text("เดือน", style: TextStyle(fontSize: 25.0)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SpinBox(
                                min: 0,
                                max: 11,
                                value: 0,
                                onChanged: (value) {
                                  setState(() {
                                    String str = value.toString();
                                    int index = str.indexOf(".");
                                    String ss = str.substring(0,index);
                                    month = int.parse(ss);
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: _guess,
                                  child: const Text("ทาย",
                                      style: TextStyle(fontSize: 20.0))),
                            ),
                          ],
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
