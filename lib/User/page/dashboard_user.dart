import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/User/page/dashboard_user_show_type.dart';

class TypeData {
  final String imageUrl;
  final String name;
  final String description;
  final String content;

  TypeData({
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.content,
  });
}

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
  List<TypeData> typeData = [];
  String searchValue = '';

  @override
  void initState() {
    super.initState();
    fetchAllData();
    getOptionDivisi();
  }

  void onSearching(String value) {
    setState(() {
      searchValue = value;
    });
    loadData(selectedDivisi, selectedArea, selectedGroupEq, selectedEquipment);
  }

  Future<void> loadData(String selectedDivisi, String selectedArea,
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
          setState(() {
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;
              final videos = record['videos'] as List<dynamic>;
              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                if (name.toLowerCase().contains(searchValue.toLowerCase())) {
                  typeDataList.add(TypeData(
                    imageUrl: imageUrl,
                    name: name,
                    description: description,
                    content: content,
                  ));
                }
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                typeData = typeDataList;
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

  void fetchAllData() async {
    final url = Uri.parse("https://digitm.isoae.com/api/type");
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
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;
              final videos = record['videos'] as List<dynamic>;
              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                typeDataList.add(TypeData(
                  imageUrl: imageUrl,
                  name: name,
                  description: description,
                  content: content,
                ));
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                typeData = typeDataList;
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
          // Clear the typeData list before adding new data
          setState(() {
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;

              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                typeDataList.add(TypeData(
                  imageUrl: imageUrl,
                  name: name,
                  description: description,
                  content: content,
                ));
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                // Store the typeDataList in the state variable
                typeData = typeDataList;
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

  void fetchData2(String selectedDivisi, String selectedArea,
      String selectedGroupEq) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/type?division_id=$selectedDivisi&area_id=$selectedArea&group_equipment_id=$selectedGroupEq");
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
          // Clear the typeData list before adding new data
          setState(() {
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;

              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                typeDataList.add(TypeData(
                  imageUrl: imageUrl,
                  name: name,
                  description: description,
                  content: content,
                ));
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                // Store the typeDataList in the state variable
                typeData = typeDataList;
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

  void fetchData3(String selectedDivisi, String selectedArea) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/type?division_id=$selectedDivisi&area_id=$selectedArea");
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
          // Clear the typeData list before adding new data
          setState(() {
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;

              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                typeDataList.add(TypeData(
                  imageUrl: imageUrl,
                  name: name,
                  description: description,
                  content: content,
                ));
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                // Store the typeDataList in the state variable
                typeData = typeDataList;
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

  void fetchData4(String selectedDivisi) async {
    final url = Uri.parse(
        "https://digitm.isoae.com/api/type?division_id=$selectedDivisi");
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
          // Clear the typeData list before adding new data
          setState(() {
            typeData = [];
          });
          if (records.isNotEmpty) {
            List<TypeData> typeDataList = [];

            for (int i = 0; i < records.length; i++) {
              final record = records[i];
              final images = record['images'] as List<dynamic>;

              final typeDataList = <TypeData>[];

              for (int index = 0; index < images.length; index++) {
                final image = images[index];
                final imagePath = image['path'].toString();
                final imageUrl = 'https://digitm.isoae.com/$imagePath';
                final name = record['name'];
                final description = record['description'];
                final content = record['content'];

                typeDataList.add(TypeData(
                  imageUrl: imageUrl,
                  name: name,
                  description: description,
                  content: content,
                ));
              }

              setState(() {
                typeData.addAll(typeDataList);
              });
            }

            if (typeDataList.isNotEmpty) {
              setState(() {
                // Store the typeDataList in the state variable
                typeData = typeDataList;
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(right: 258.0),
              child: Text(
                'Filter Data',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
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
                  fetchData4(selectedDivisi);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Divisi',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
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
                  fetchData3(selectedDivisi, selectedArea);
                }
              },
              decoration: const InputDecoration(
                labelText: 'Area',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
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
                  getOptionEquipment(
                      selectedDivisi, selectedArea, selectedGroupEq);
                  fetchData2(
                    selectedDivisi,
                    selectedArea,
                    selectedGroupEq,
                  );
                }
              },
              decoration: const InputDecoration(
                labelText: 'Group Equipment',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 240.0),
              child: ElevatedButton(
                onPressed: () {
                  selectedDivisi = '';
                  selectedArea = '';
                  selectedGroupEq = '';
                  selectedEquipment = '';

                  listArea = [];
                  listGroupEq = [];
                  listEquipment = [];
                  fetchAllData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text(
                  'Reset Filter',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            TextField(
              onChanged: onSearching,
              decoration: const InputDecoration(
                hintText: 'Cari Nama Disini',
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: typeData.length,
              itemBuilder: (context, index) {
                final data = typeData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardUserShowType(
                          imageUrl: data.imageUrl,
                          name: data.name,
                          description: data.description,
                          content: data.content,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                data.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
