import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardUser extends StatefulWidget {
  const DashboardUser({Key? key}) : super(key: key);

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> {
  List<dynamic> errors = [];
  List<dynamic> listDivisi = [];
  List<dynamic> listArea = [];
  List<dynamic> listGroupEquipment = [];
  List<dynamic> listEquipment = [];

  String selectedDivisi = '';
  String selectedArea = '';
  String selectedGroupEquipment = '';
  String selectedEquipment = '';

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
    final url = Uri.parse(
        "https://digitm.isoae.com/api/area/getOption?division_id=$divisionId");

    final response = await http.get(url);

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
        "https://digitm.isoae.com/api/groupequipment/getOption?area_id=$areaId");

    final response = await http.get(url);

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

  void getOptionEquipment(String groupEquipmentId) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/equipment/getOption?group_equipment_id=$groupEquipmentId");

    final response = await http.get(url);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: selectedDivisi.isNotEmpty ? selectedDivisi : null,
              items: listDivisi.map((divisi) {
                return DropdownMenuItem<String>(
                  value: divisi['id'].toString(),
                  child: Text(divisi['name'].toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDivisi = value ?? '';
                  // Reset selected area, group equipment, and equipment
                  selectedArea = '';
                  selectedGroupEquipment = '';
                  selectedEquipment = '';
                  // Get the areas based on the selected division
                  getOptionArea(selectedDivisi);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Divisi',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedArea.isNotEmpty ? selectedArea : null,
              items: listArea.map((area) {
                return DropdownMenuItem<String>(
                  value: area['id'].toString(),
                  child: Text(area['name'].toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedArea = value ?? '';
                  // Reset selected group equipment and equipment
                  selectedGroupEquipment = '';
                  selectedEquipment = '';
                  // Get the group equipment based on the selected division and area
                  getOptionGroupEquipment(selectedArea);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Area',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedGroupEquipment.isNotEmpty
                  ? selectedGroupEquipment
                  : null,
              items: listGroupEquipment.map((groupEquipment) {
                return DropdownMenuItem<String>(
                  value: groupEquipment['id'].toString(),
                  child: Text(groupEquipment['name'].toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGroupEquipment = value ?? '';
                  // Reset selected equipment
                  selectedEquipment = '';
                  // Get the equipment based on the selected division, area, and group equipment
                  getOptionEquipment(selectedGroupEquipment);
                });
              },
              decoration: const InputDecoration(
                labelText: 'Group Equipment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: selectedEquipment.isNotEmpty ? selectedEquipment : null,
              items: listEquipment.map((equipment) {
                return DropdownMenuItem<String>(
                  value: equipment['id'].toString(),
                  child: Text(equipment['name'].toString()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedEquipment = value ?? '';
                });
              },
              decoration: const InputDecoration(
                labelText: 'Equipment',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
