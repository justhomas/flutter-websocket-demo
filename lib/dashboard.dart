import 'dart:convert';

import 'package:django_channels/functions.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'charts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List students = [];
  Map percentage = {};
  Map qualifications = {};
  @override
  void initState() {
    super.initState();
    _sendMessage();
    // _getStudent();
  }

  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://15.206.73.108:8001/ws/students/'),
  );
  String percentageGroup(double percentage) {
    if (percentage > 90)
      return "90+";
    else if (percentage > 80)
      return "80+";
    else if (percentage > 70)
      return "70+";
    else
      return "< 70";
  }

  void _getStudent() async {
    List s = await fetchStudent();

    setState(() {
      students = s;
    });
  }

  void _sendMessage() {
    _channel.sink.add('{"message":"fetch"}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            List s = [];
            students = [];
            qualifications.clear();
            percentage.clear();
            if (snapshot.hasData) {
              s = jsonDecode(jsonDecode(snapshot.data.toString())["message"]);

              for (var a in s)
                students.add({
                  "name": a["fields"]["name"],
                  "qualification": a["fields"]["qualification"],
                  "percentage": a["fields"]["percentage"]
                });
              students.forEach((element) {
                if (percentage[percentageGroup(element["percentage"])] != null)
                  percentage[percentageGroup(element["percentage"])] += 1;
                else
                  percentage[percentageGroup(element["percentage"])] = 1;
              });

              students.forEach((element) {
                if (qualifications[element["qualification"]] != null)
                  qualifications[element["qualification"]] += 1;
                else
                  qualifications[element["qualification"]] = 1;
              });
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.grey[200],
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        Text(
                          students.length.toString(),
                          style: TextStyle(fontSize: 40),
                        ),
                        Text(
                          'Students ',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Qualifications',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chart(data: qualifications),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'Percentages',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chart(data: percentage),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
