import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/services/api_services.dart';
import 'dart:convert';

class FormDivisi extends StatefulWidget {
  final dynamic selectedData;
  final Function onFinish;

  const FormDivisi({Key? key, this.selectedData, required this.onFinish})
      : super(key: key);

  @override
  State<FormDivisi> createState() => FormDivisiState();
}

class FormDivisiState extends State<FormDivisi> {
  final _formKey = GlobalKey<FormState>();
  dynamic formData = {};
  List<dynamic> errors = [];
  
  bool show = false;

  @override
  void initState() {
    super.initState();
    
    newData(); // Move the selection logic inside newData()
  }

  
  void newData() {
    setState(() {
      show = true;
      formData = {
        'id': widget.selectedData != null ? widget.selectedData['id'] : null,
        
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
        // Data memiliki id,jadinya edit
        final url =
            Uri.parse("https://digitm.isoae.com/api/division/${formData['id']}");
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
        final url = Uri.parse("https://digitm.isoae.com/api/division");
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
            // bisa tambah logic ketika sudah berhasil tambah data
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
                    validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the name';
                          }
                          return null;
                        },
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
