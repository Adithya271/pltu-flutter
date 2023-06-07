import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/User/page/dashboard_user_show_type.dart';

class DashboardUser extends StatefulWidget {
  const DashboardUser({Key? key}) : super(key: key);

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  List<Map<String, dynamic>> listDivisi = [];
  List<Map<String, dynamic>> listArea = [];
  List<Map<String, dynamic>> listEquipment = [];
  List<Map<String, dynamic>> listGroupEq = [];

  String selectedDivisi = '';
  String selectedArea = '';
  String selectedEquipment = '';
  String selectedGroupEq = '';
  String typeData = '';

  @override
  void initState() {
    super.initState();
    getOptionDivisi();
  }

  void getOptionDivisi() async {
    final url = Uri.parse("https://digitm.isoae.com/api/division/getOption");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
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
            listDivisi = records
                .map<Map<String, dynamic>>((dynamic divisi) => {
                      'value': divisi['value'],
                      'text': divisi['text'],
                    })
                .toList();
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

  void getOptionArea(String selectedDivisi) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/area/getOption?division_id=$selectedDivisi");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
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
            listArea = records
                .map<Map<String, dynamic>>((dynamic area) => {
                      'value': area['value'],
                      'text': area['text'],
                    })
                .toList();
          });
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

  void getOptionGroupEq(String selectedDivisi, String selectedArea) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/groupequipment/getOption?division_id=$selectedDivisi&area_id=$selectedArea");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
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
            listGroupEq = records
                .map<Map<String, dynamic>>((dynamic groupEq) => {
                      'value': groupEq['value'],
                      'text': groupEq['text'],
                    })
                .toList();
          });
        } else {
          print('Error: Invalid response data');
          setState(() {
            listGroupEq = [];
          });
        }
      } catch (e) {
        print('Error decoding response body: $e');
        setState(() {
          listGroupEq = [];
        });
      }
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        listGroupEq = [];
      });
    }
  }

  void getOptionEquipment(String selectedDivisi, String selectedArea,
      String selectedGroupEq) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/equipment/getOption?division_id=$selectedDivisi&area_id=$selectedArea&group_equipment_id=$selectedGroupEq");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
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
            listEquipment = records
                .map<Map<String, dynamic>>((dynamic equipment) => {
                      'value': equipment['value'],
                      'text': equipment['text'],
                    })
                .toList();
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

  void fetchData(String selectedDivisi, String selectedArea,
      String selectedGroupEq, String selectedEquipment) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/type?division_id=$selectedDivisi&area_id=$selectedArea&group_equipment_id=$selectedGroupEq&equipment_id=$selectedEquipment");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        final responseData = jsonData['data'];

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('records')) {
          final records = responseData['records'] as List<dynamic>;
          if (records.isNotEmpty) {
            List<String> names = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final name = record['name'];

              names.add(name);
            }

            if (names.isNotEmpty) {
              setState(() {
                // Store the names in the state variable
                typeData = names.join(", ");
              });
            } else {
              print('Error: No records found');
            }
          } else {
            print('Error: No records found');
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: selectedDivisi.isNotEmpty ? selectedDivisi : null,
          items: listDivisi.map((divisi) {
            return DropdownMenuItem<String>(
              value: divisi['value'].toString(),
              child: Text(divisi['text'].toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedDivisi = value ?? '';
              selectedArea = '';
              selectedGroupEq = '';
              selectedEquipment = '';
              listArea = [];
              listGroupEq = [];
              listEquipment = [];
            });
            if (selectedDivisi.isNotEmpty) {
              getOptionArea(selectedDivisi);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Divisi',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedArea.isNotEmpty ? selectedArea : null,
          items: listArea.map((area) {
            return DropdownMenuItem<String>(
              value: area['value'].toString(),
              child: Text(area['text'].toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedArea = value ?? '';
              selectedGroupEq = '';
              selectedEquipment = '';
              listGroupEq = [];
              listEquipment = [];
            });
            if (selectedArea.isNotEmpty) {
              getOptionGroupEq(selectedDivisi, selectedArea);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Area',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedGroupEq.isNotEmpty ? selectedGroupEq : null,
          items: listGroupEq.map((groupEq) {
            return DropdownMenuItem<String>(
              value: groupEq['value'].toString(),
              child: Text(groupEq['text'].toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedGroupEq = value ?? '';
              selectedEquipment = '';
              listEquipment = [];
            });
            if (selectedGroupEq.isNotEmpty) {
              getOptionEquipment(selectedDivisi, selectedArea, selectedGroupEq);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Group Equipment',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedEquipment.isNotEmpty ? selectedEquipment : null,
          items: listEquipment.map((equipment) {
            return DropdownMenuItem<String>(
              value: equipment['value'].toString(),
              child: Text(equipment['text'].toString()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedEquipment = value ?? '';
            });

            if (selectedEquipment.isNotEmpty) {
              fetchData(selectedDivisi, selectedArea, selectedGroupEq,
                  selectedEquipment);
            }
          },
          decoration: const InputDecoration(
            labelText: 'Equipment',
            border: OutlineInputBorder(),
          ),
        ),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Type: $typeData',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    // Replace 'DashboardUserShowType' with the name of your next page class
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DashboardUserShowType(typeId: typeData),
                      ),
                    );
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
