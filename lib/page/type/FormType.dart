import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/services/api_services.dart';
import 'dart:convert';

class FormType extends StatefulWidget {
  final dynamic selectedData;
  final Function onFinish;

  const FormType({Key? key, this.selectedData, required this.onFinish})
      : super(key: key);

  @override
  State<FormType> createState() => FormTypeState();
}

class FormTypeState extends State<FormType> {
  final _formKey = GlobalKey<FormState>();
  dynamic formData = {};
  List<dynamic> errors = [];
  List<dynamic> listDivisi = [];
  List<dynamic> listArea = [];
  List<dynamic> listGroupEquipment = [];
  List<dynamic> listEquipment = [];
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
          // Get the areas based on the initially selected division
          getOptionArea(listDivisi[0]['id'].toString());
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

  void getOptionArea(String divisionId) async {
    final url =
        Uri.parse("https://digitm.isoae.com/api/area?division_id=$divisionId");
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
            listArea = records;
          });
          // Get the groupequipment based on the initially selected area
          getOptionGroupEquipment(listArea[0]['id'].toString());
        } else {
          print('Error: Invalid response data');
          setState(() {
            listArea = [];
          });
        }
      } catch (e) {
        print('Error decoding response body: $e');
        setState(() {
          listArea = [];
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        listArea = [];
      });
    }
  }

  void getOptionGroupEquipment(String areaId) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/groupequipment?area_id=$areaId");
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
            listGroupEquipment = records;
          });
          // Get the equipment based on the initially selected groupeq
          getOptionEquipment(listGroupEquipment[0]['id'].toString());
        } else {
          print('Error: Invalid response data');
          setState(() {
            listGroupEquipment = [];
          });
        }
      } catch (e) {
        print('Error decoding response body: $e');
        setState(() {
          listGroupEquipment = [];
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        listGroupEquipment = [];
      });
    }
  }

  void getOptionEquipment(String groupEquipmentid) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/equipment?group_equipment_id=$groupEquipmentid");
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
            listEquipment = records;
          });
          
        } else {
          print('Error: Invalid response data');
          setState(() {
            listEquipment = [];
          });
        }
      } catch (e) {
        print('Error decoding response body: $e');
        setState(() {
          listEquipment = [];
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        listEquipment = [];
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
        'area_id': widget.selectedData != null
            ? widget.selectedData['area_id'].toString()
            : listArea.isNotEmpty
                ? listArea[0]['id'].toString()
                : null,
        'group_equipment_id': widget.selectedData != null
            ? widget.selectedData['group_equipment_id'].toString()
            : listGroupEquipment.isNotEmpty
                ? listGroupEquipment[0]['id'].toString()
                : null,
        'equipment_id': widget.selectedData != null
            ? widget.selectedData['equipment_id'].toString()
            : listEquipment.isNotEmpty
                ? listEquipment[0]['id'].toString()
                : null,
        'name': widget.selectedData != null ? widget.selectedData['name'] : '',
        'description': widget.selectedData != null
            ? widget.selectedData['description']
            : '',
      };
      errors = [];

      // Update the area dropdown options based on the selected division
      if (formData['division_id'] != null) {
        final selectedDivisionId = int.parse(formData['division_id']);
        final filteredAreas = listArea
            .where(
                (area) => area['division_id'] == selectedDivisionId.toString())
            .toList();

        if (filteredAreas.isNotEmpty) {
          formData['area_id'] = filteredAreas[0]['id'].toString();
        } else {
          formData['area_id'] = null;
        }
      }

      // Update the groupequipment dropdown options based on the selected area
      if (formData['area_id'] != null) {
        final selectedAreaId = int.parse(formData['area_id']);
        final filteredGroupEquipments = listGroupEquipment
            .where((groupequipment) =>
                groupequipment['area_id'] == selectedAreaId.toString())
            .toList();

        if (filteredGroupEquipments.isNotEmpty) {
          formData['group_equipment_id'] =
              filteredGroupEquipments[0]['id'].toString();
        } else {
          formData['group_equipment_id'] = null;
        }
      }

      // Update the equipment dropdown options based on the selected groupequipment
      if (formData['group_equipment_id'] != null) {
        final selectedGroupEquipmentId =
            int.parse(formData['group_equipment_id']);
        final filteredEquipments = listEquipment
            .where((equipment) =>
                equipment['group_equipment_id'] ==
                selectedGroupEquipmentId.toString())
            .toList();

        if (filteredEquipments.isNotEmpty) {
          formData['equipment_id'] = filteredEquipments[0]['id'].toString();
        } else {
          formData['equipment_id'] = null;
        }
      }
    });
  }

  void saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (formData['id'] != null) {
        // Data memiliki id,jadinya edit
        final url =
            Uri.parse("https://digitm.isoae.com/api/type/${formData['id']}");
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
        final url = Uri.parse("https://digitm.isoae.com/api/type");
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
        'division_id': '',
        'area_id': '',
        'group_equipment_id': '',
        'equipment_id': '',
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
                        // Call the getOptionArea() function to fetch areas based on the selected division
                        getOptionArea(value!);
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Area'),
                    value: formData['area_id'],
                    items: listArea.map((area) {
                      return DropdownMenuItem<String>(
                        value: area['id'].toString(),
                        child: Text(area['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an area';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['area_id'] = value;
                        // Call the getOptionGroupEquipment() function to fetch areas based on the selected division
                        getOptionGroupEquipment(value!);
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'GroupEquipment'),
                    value: formData['group_equipment_id'],
                    items: listGroupEquipment.map((groupequipment) {
                      return DropdownMenuItem<String>(
                        value: groupequipment['id'].toString(),
                        child: Text(groupequipment['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a groupequipment';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['group_equipment_id'] = value;
                        // Call the getOptionEquipment() function to fetch areas based on the selected division
                        getOptionEquipment(value!);
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Equipment'),
                    value: formData['equipment_id'],
                    items: listEquipment.map((equipment) {
                      return DropdownMenuItem<String>(
                        value: equipment['id'].toString(),
                        child: Text(equipment['name']),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an equipment';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['equipment_id'] = value;
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
