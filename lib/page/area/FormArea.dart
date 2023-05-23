import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/services/api_services.dart';
import 'dart:convert';


class FormArea extends StatefulWidget {
  final dynamic selectedData;
  final Function onFinish;

  const FormArea({Key? key, this.selectedData, required this.onFinish})
      : super(key: key);

  @override
  State<FormArea> createState() => FormAreaState();
}

class FormAreaState extends State<FormArea> {
  final _formKey = GlobalKey<FormState>();
  dynamic formData = {};
  List<dynamic> errors = [];
  List<dynamic> listDivisi = [];
  bool show = false;

  @override
  void initState() {
    super.initState();
    getOptionDivisi();
    if (widget.selectedData != null) {
      selectData(widget.selectedData);
    } else {
      newData();
    }
  }

  void getOptionDivisi() {
    // Fetch division options using API or other data source
    // ...
    setState(() {
      listDivisi = [];
    });
  }

  void newData() {
    setState(() {
      show = true;
      formData = {
        'id': null,
        'division_id': '',
        'name': '',
        'description': '',
      };
      errors = [];
    });
  }

  void selectData(dynamic data) {
    setState(() {
      show = true;
      formData = {
        'id': data['id'],
        'division_id': data['division_id'],
        'name': data['name'],
        'description': data['description'],
      };
      errors = [];
    });
  }

  void saveData() {
    if (formData['id'] != null) {
      // Data mempunyai id ,maka akan diedit
      final url = Uri.parse(
          "https://digitm.isoae.com/api/area/" + formData['id'].toString());
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${APIService.token}",
      };

      http
          .put(url, headers: headers, body: jsonEncode(formData))
          .then((response) {
        if (response.statusCode == 200) {
          clearForm();
          setState(() {
            show = false;
          });
          widget.onFinish();
        } else if (response.statusCode == 422) {
          setState(() {
            errors = jsonDecode(response.body)['errors'];
          });
        }
      }).catchError((error) {
        // Handle error
      });
    } else {
      // New data
      final url = Uri.parse("https://digitm.isoae.com/api/area");
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${APIService.token}",
      };

      http
          .post(url, headers: headers, body: jsonEncode(formData))
          .then((response) {
        if (response.statusCode == 200) {
          clearForm();
          setState(() {
            show = false;
          });
          widget.onFinish();
        } else if (response.statusCode == 422) {
          setState(() {
            errors = jsonDecode(response.body)['errors'];
          });
        }
      }).catchError((error) {
        // Handle error
      });
    }
  }


  void clearForm() {
    setState(() {
      show = false;
      formData = {
        'id': null,
        'division_id': '',
        'name': '',
        'description': '',
      };
      errors = [];
    });
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            // Replace with your form UI
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Division'),
                    initialValue: formData['division_id'].toString(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the division';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['division_id'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    initialValue: formData['name'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['name'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    initialValue: formData['description'],
                    onChanged: (value) {
                      setState(() {
                        formData['description'] = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: saveData,
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: clearForm,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
          )
        : Container(
            // Replace with your view UI
            child: Column(
              children: [
                Text('Division: ${formData['division_id']}'),
                Text('Name: ${formData['name']}'),
                Text('Description: ${formData['description']}'),
              ],
            ),
          );
  }
}
