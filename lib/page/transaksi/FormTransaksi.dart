import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/services/api_services.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FormTransaksi extends StatefulWidget {
  final dynamic selectedData;
  final Function onFinish;

  const FormTransaksi({Key? key, this.selectedData, required this.onFinish})
      : super(key: key);

  @override
  State<FormTransaksi> createState() => FormTransaksiState();
}

class FormTransaksiState extends State<FormTransaksi> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate; // Nullable DateTime
  dynamic formData = {};
  List<dynamic> errors = [];
  List<dynamic> listDivisi = [];
  bool show = false;

  @override
  void initState() {
    super.initState();
    getOptionDivisi();
    newData();
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

        if (responseData is Map<String, dynamic>) {
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
        'nomor':
            widget.selectedData != null ? widget.selectedData['nomor'] : '',
        'tgl': widget.selectedData != null ? widget.selectedData['tgl'] : '',
        'qty': widget.selectedData != null ? widget.selectedData['qty'] : '',
        'harga':
            widget.selectedData != null ? widget.selectedData['harga'] : '',
      };
      errors = [];
    });
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (formData['id'] != null) {
        final url = Uri.parse(
            "https://digitm.isoae.com/api/transaksi/${formData['id']}");
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
          }
        } catch (error) {
          print('Error: $error');
        }
      } else {
        final url = Uri.parse("https://digitm.isoae.com/api/transaksi");
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
          }
        } catch (error) {
          print('Error: $error');
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
        'nomor': '',
        'tgl': '',
        'qty': '',
        'harga': '',
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
                        decoration:
                            const InputDecoration(labelText: 'Nomor Transaksi'),
                        initialValue: formData['notrans'],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the nomor transaksi';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            formData['notrans'] = value;
                          });
                        },
                      );
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Tanggal'),
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : '',
                    ),
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030),
                      ).then((pickedDate) {
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                            formData['tgl'] =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the tanggal';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Qty'),
                    initialValue: formData['qty'],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quantity';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['qty'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Harga'),
                    initialValue: formData['harga'],
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['harga'] = value;
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            saveData();
                          },
                          child: const Text('Save'),
                        ),
                        const SizedBox(width: 15.0),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              clearForm();
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red),
                          ),
                          child: const Text('Exit'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }
}
