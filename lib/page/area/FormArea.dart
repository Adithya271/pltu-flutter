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
    newData(); // Move the selection logic inside newData()
  }

  void getOptionDivisi() async {
    final url = Uri.parse("https://digitm.isoae.com/api/division");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${APIService.token}",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        final responseData = jsonData['data'];

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('records')) {
          final records = responseData['records'] as List<dynamic>;
          setState(() {
            listDivisi = records;
          });
        } else {
          print('Error: Invalid response data');
          setState(() {
            listDivisi = [];
          });
        }
      } catch (e) {
        print('Error decoding response body: $e');
        setState(() {
          listDivisi = [];
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        listDivisi = [];
      });
    }
  }

  void newData() {
    setState(() {
      show = true;
      formData = {
        'id': widget.selectedData != null ? widget.selectedData['id'] : null,
        'division_id': widget.selectedData != null
            ? widget.selectedData['division_id'].toString()
            : listDivisi.isNotEmpty
                ? listDivisi[0]['id'].toString()
                : null,
        'name': widget.selectedData != null ? widget.selectedData['name'] : '',
        'description': widget.selectedData != null
            ? widget.selectedData['description']
            : '',
      };
      errors = [];
    });
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (formData['id'] != null) {
        // Data has an ID, so it's an edit
        final url =
            Uri.parse("https://digitm.isoae.com/api/area/${formData['id']}");
        final headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${APIService.token}",
        };

        try {
          final response = await http.put(
            url,
            headers: headers,
            body: jsonEncode(formData),
          );

          if (response.statusCode == 200) {
            clearForm();
          } else if (response.statusCode == 422) {
            final responseData = jsonDecode(response.body);
            if (responseData is Map<String, dynamic>) {
              setState(() {
                errors = responseData['errors'] as List<dynamic>;
              });
            } else {
              print('Error: Invalid response data');
            }
          } else {
            print('Error: ${response.statusCode}');
            // Handle other status codes
          }
        } catch (error) {
          print('Error: $error');
          // Handle error
        }
      } else {
        // New data
        final url = Uri.parse("https://digitm.isoae.com/api/area");
        final headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${APIService.token}",
        };

        try {
          final response = await http.post(
            url,
            headers: headers,
            body: jsonEncode(formData),
          );

          if (response.statusCode == 200) {
            clearForm();
            // Add any additional logic you want to execute after successfully adding data
          } else if (response.statusCode == 422) {
            final responseData = jsonDecode(response.body);
            if (responseData is Map<String, dynamic>) {
              setState(() {
                errors = responseData['errors'] as List<dynamic>;
              });
            } else {
              print('Error: Invalid response data');
            }
          } else {
            print('Error: ${response.statusCode}');
            // Handle other status codes
          }
        } catch (error) {
          print('Error: $error');
          // Handle error
        }
      }
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Division'),
                    value: formData['division_id'],
                    items: listDivisi.map((division) {
                      return DropdownMenuItem<String>(
                        value: division['id'].toString(),
                        child: Text(division['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a division';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['division_id'] = value;
                      });
                    },
                  ),
                  FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return TextFormField(
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
                      );
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
                    onPressed: () {
                      saveData();
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        clearForm();
                      });
                    },
                    child: const Text('Exit'),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
