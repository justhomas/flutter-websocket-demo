import 'package:flutter/material.dart';

import 'functions.dart';

class StudentDetails extends StatefulWidget {
  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _percentageController = TextEditingController();

  final TextEditingController _qualificationController =
      TextEditingController();
  List students = [];

  @override
  void initState() {
    super.initState();
    _getStudent();
  }

  void _createStudent() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Adding Student')));
      createStudent(_nameController.text, _qualificationController.text,
              _percentageController.text)
          .then((value) => _getStudent());
    }
  }

  void _getStudent() async {
    List s = await fetchStudent();
    setState(() {
      students = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (name) {
                      if (name?.isEmpty ?? true) {
                        return "Name Should not be empty";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: _percentageController,
                      decoration: InputDecoration(labelText: 'Percentage'),
                      validator: (percentage) {
                        if (percentage?.isEmpty ?? true) {
                          return "Percentage Should not be empty";
                        }
                        try {
                          var i = int.parse(percentage!);
                          if (i > 100 || i < 0)
                            return "Percentage should be <= 100 and >= to 0";
                        } catch (e) {
                          return "Percentage should be a number";
                        }
                        return null;
                      }),
                  TextFormField(
                    controller: _qualificationController,
                    decoration: InputDecoration(labelText: 'Qualification'),
                    validator: (name) {
                      if (name?.isEmpty ?? true) {
                        return "Qualification Should not be empty";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  // StreamBuilder(
                  //   stream: _channel.stream,
                  //   builder: (context, snapshot) {
                  //     return Text(snapshot.hasData ? '${snapshot.data}' : 'no');
                  //   },
                  //)
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _createStudent();
                },
                child: Text('Add Student')),
            Padding(
              padding: const EdgeInsets.only(bottom: 15, top: 15),
              child: Text(
                'Students',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: students.length > 0
                  ? Table(
                      border: TableBorder.symmetric(
                          inside: BorderSide(color: Colors.grey)),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Name',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Qualification',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Percentage',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        for (var student in students)
                          TableRow(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(student["name"]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(student["qualification"]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(student["percentage"].toString()),
                              ),
                              IconButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text('Deleting Student')));
                                    deleteStudent(student["id"])
                                        .then((value) => _getStudent());
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
                      ],
                    )
                  : Center(child: Text('No Students Available')),
            )
          ],
        ),
      ),
    );
  }
}
