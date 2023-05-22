import 'package:flutter/material.dart';

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
    if (_formKey.currentState?.validate() ?? false) {
      // Perform save operation using API or other data source
      // ...
      widget.onFinish();
    }
  }

  void clearForm() {
    setState(() {
      show = false;
      widget.onFinish();
      formData = {
        'id': null,
        'division_id': '',
        'name': '',
        'description': '',
      };
      errors = [];
    });
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
                    decoration: InputDecoration(labelText: 'Division'),
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
                    decoration: InputDecoration(labelText: 'Name'),
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
                    decoration: InputDecoration(labelText: 'Description'),
                    initialValue: formData['description'],
                    onChanged: (value) {
                      setState(() {
                        formData['description'] = value;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: saveData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: clearForm,
                    child: Text('Clear'),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
