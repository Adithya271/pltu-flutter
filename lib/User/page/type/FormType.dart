import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/services/api_services.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

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
  //ENUM('draft', 'publish', 'unpublish')
  List<Map<String, String>> listStatus = [
    {'text': "Draft", 'status': "draft"},
    {'text': "Publish", 'status': "publish"},
    {'text': "Unpublish", 'status': "unpublish"},
  ];

  bool show = false;
  int currentUser = 1;
  String? selectedStatus;

  // Variables for image and video handling
  List<PickedFile> _pickedImages = [];
  PickedFile? _pickedVideo;
  VideoPlayerController? videoController;

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

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
        'user_id': currentUser.toString(),
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
        'alasan':
            widget.selectedData != null ? widget.selectedData['alasan'] : '',
        'status': widget.selectedData != null
            ? widget.selectedData['status'].toString()
            : listStatus.isNotEmpty
                ? listStatus[0]['status'].toString()
                : null,
        'content':
            widget.selectedData != null ? widget.selectedData['content'] : '',
        'image':
            widget.selectedData != null ? widget.selectedData['image'] : '',
        'video':
            widget.selectedData != null ? widget.selectedData['video'] : '',
      };

      errors = [];

      // Update the division dropdown initial value
      if (formData['division_id'] != null) {
        final selectedDivisionId = int.parse(formData['division_id']);
        final selectedDivision = listDivisi.firstWhere(
          (division) => division['id'] == selectedDivisionId,
          orElse: () => null,
        );
        if (selectedDivision != null) {
          formData['division_id'] = selectedDivision['id'].toString();
          // Get the areas based on the initially selected division
          getOptionArea(selectedDivision['id'].toString());
        } else {
          formData['division_id'] = null;
        }
      }

// Update the area dropdown initial value
      if (formData['area_id'] != null) {
        final selectedAreaId = int.parse(formData['area_id']);
        final selectedArea = listArea.firstWhere(
          (area) => area['id'] == selectedAreaId,
          orElse: () => null,
        );
        if (selectedArea != null) {
          formData['area_id'] = selectedArea['id'].toString();
          // Get the group equipments based on the initially selected area
          getOptionGroupEquipment(selectedArea['id'].toString());
        } else {
          formData['area_id'] = null;
        }
      }

// Update the group equipment dropdown initial value
      if (formData['group_equipment_id'] != null) {
        final selectedGroupEquipmentId =
            int.parse(formData['group_equipment_id']);
        final selectedGroupEquipment = listGroupEquipment.firstWhere(
          (ge) => ge['id'] == selectedGroupEquipmentId,
          orElse: () => null,
        );
        if (selectedGroupEquipment != null) {
          formData['group_equipment_id'] =
              selectedGroupEquipment['id'].toString();
          // Get the equipments based on the initially selected group equipment
          getOptionEquipment(selectedGroupEquipment['id'].toString());
        } else {
          formData['group_equipment_id'] = null;
        }
      }

// Update the equipment dropdown initial value
      if (formData['equipment_id'] != null) {
        final selectedEquipmentId = int.parse(formData['equipment_id']);
        final selectedEquipment = listEquipment.firstWhere(
          (equipment) => equipment['id'] == selectedEquipmentId,
          orElse: () => null,
        );
        if (selectedEquipment != null) {
          formData['equipment_id'] = selectedEquipment['id'].toString();
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
        // Data has an id, indicating it's an edit operation
        final url =
            Uri.parse("https://digitm.isoae.com/api/type/${formData['id']}");
        final headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${APIService.token}",
        };

        try {
          var request = http.MultipartRequest('PUT', url);
          request.headers.addAll(headers);

          // Add image files to the request
          for (PickedFile pickedImage in _pickedImages) {
            var file = await pickedImage.readAsBytes();
            var fileName = path.basename(pickedImage.path);
            var fileExtension = path.extension(fileName).toLowerCase();

            // Validate file extension
            if (fileExtension == '.jpg' ||
                fileExtension == '.jpeg' ||
                fileExtension == '.png' ||
                fileExtension == '.bmp') {
              // Append the file extension to the image field name
              var fieldName = 'image[]';
              var fieldNameWithExtension = '$fieldName.$fileExtension';

              request.files.add(http.MultipartFile.fromBytes(
                fieldName,
                file,
                filename: fieldNameWithExtension,
                contentType: MediaType('image', fileExtension.substring(1)),
              ));
            } else {
              print('Error: Invalid file extension: $fileExtension');
              continue; // Skip this file and proceed to the next one
            }
          }

          // Add text fields to the request
          formData.forEach((key, value) {
            if (key != 'image') {
              request.fields[key] = value.toString();
            }
          });

          print('Request payload: ${request.fields}');
          final response = await request.send();
          print('Response statusCode: ${response.statusCode}');
          final responseData = await response.stream.bytesToString();
          print('Response body: $responseData');

          if (response.statusCode == 200) {
            final parsedData = jsonDecode(responseData);
            if (parsedData is Map<String, dynamic> &&
                parsedData.containsKey('image')) {
              final images = [parsedData['image']];
              // Update the form data with the image details
              setState(() {
                formData['image'] = images;
              });
            }
            clearForm();
            print('Data updated successfully.');
            // Add logic for successful data update
          } else if (response.statusCode == 422) {
            final parsedData = jsonDecode(responseData);
            if (parsedData is Map<String, dynamic> &&
                parsedData.containsKey('errors')) {
              final errors = parsedData['errors'];
              print('Error: $errors');
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
        //new data
        final url = Uri.parse("https://digitm.isoae.com/api/type");
        final headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${APIService.token}",
        };
        try {
          var request = http.MultipartRequest('POST', url);
          request.headers.addAll(headers);

          // Add image files to the request
          for (http.MultipartFile imageFile in formData['image']) {
            request.files.add(imageFile);
          }

          // Add video file to the request
          if (formData['video'] != null) {
            var videoFile = File(formData['video']);
            var fileName = videoFile.path.split('/').last;
            var fileExtension = fileName.split('.').last.toLowerCase();
            request.files.add(http.MultipartFile(
              'video',
              videoFile.readAsBytes().asStream(),
              videoFile.lengthSync(),
              filename: fileName,
              contentType: MediaType('video', fileExtension),
            ));
          }

          // Add other text fields to the request
          formData.forEach((key, value) {
            if (key != 'image' && key != 'video') {
              request.fields[key] = value.toString();
            }
          });

          print('Request payload: ${request.fields}');

          final response = await request.send();
          final responseStream = await response.stream.bytesToString();

          print('Response statusCode: ${response.statusCode}');
          print('Response body: $responseStream');

          if (response.statusCode == 200) {
            final parsedData = jsonDecode(responseStream);
            if (parsedData is Map<String, dynamic> &&
                parsedData.containsKey('data')) {
              final images = parsedData['data']['image'];
              // Update the form data with the image details
              setState(() {
                formData['image'] = images;
              });
            }
            clearForm();
            print('Data updated successfully.');
            // Add logic for successful data update
          } else if (response.statusCode == 422) {
            final parsedData = jsonDecode(responseStream);
            if (parsedData is Map<String, dynamic> &&
                parsedData.containsKey('errors')) {
              final errors = parsedData['errors'];
              if (errors.containsKey('image')) {
                print('Error: ${errors['image'].join(', ')}');
              } else if (errors.containsKey('video')) {
                print('Error: ${errors['video'].join(', ')}');
              } else {
                print('Error: Invalid response data');
              }
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

  Future<void> pickImage() async {
    List<XFile>? pickedFiles =
        await ImagePicker().pickMultiImage(imageQuality: 50);
    setState(() {
      _pickedImages =
          pickedFiles.map((file) => PickedFile(file.path)).toList() ?? [];
      formData['image'] = _pickedImages.map((pickedImage) {
        var file = File(pickedImage.path);
        var fileName = file.path.split('/').last;
        var fileExtension = fileName.split('.').last.toLowerCase();
        return http.MultipartFile(
          'image',
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: fileName,
          contentType: MediaType('image', fileExtension),
        );
      }).toList();
    });
  }

  Future<void> pickVideo() async {
    final pickedFile = await _imagePicker.getVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedVideo = pickedFile;
        formData['video'] = pickedFile.path;
        videoController = VideoPlayerController.file(File(pickedFile.path));
        videoController!.initialize().then((_) {
          setState(() {});
        });
      });
    }
  }

  // Widget to display the picked image dan video
  Widget buildPickedMedia() {
    if (_pickedImages.isNotEmpty) {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _pickedImages.map((pickedImage) {
          return Image.file(File(pickedImage.path));
        }).toList(),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget buildPickedMedia2() {
    if (_pickedVideo != null && videoController != null) {
      return Column(
        children: [
          AspectRatio(
            aspectRatio: videoController!.value.aspectRatio,
            child: VideoPlayer(videoController!),
          ),
          ElevatedButton(
            child: Text(videoController!.value.isPlaying
                ? 'Pause Video'
                : 'Play Video'),
            onPressed: () {
              if (videoController!.value.isPlaying) {
                videoController!.pause();
              } else {
                videoController!.play();
              }
            },
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  void clearForm() {
    setState(() {
      show = false;
      formData = {
        'id': null,
        'user_id': '',
        'division_id': '',
        'area_id': '',
        'group_equipment_id': '',
        'equipment_id': '',
        'name': '',
        'description': '',
        'alasan': '',
        'status': '',
        'content': '',
        'image': '',
        'video': '',
      };
      errors = [];
    });
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? SingleChildScrollView(
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
                        // Call the getOptionArea() function to fetch areas based on the selected division
                        getOptionGroupEquipment(value!);
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'GE'),
                    value: formData['group_equipment_id'],
                    items: listGroupEquipment.map((ge) {
                      return DropdownMenuItem<String>(
                        value: ge['id'].toString(),
                        child: Text(ge['name']),
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
                        formData['group_equipment_id'] = value;
                        // Call the getOptionArea() function to fetch areas based on the selected division
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
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Alasan'),
                    initialValue: formData['alasan'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the alasan';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['alasan'] = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: 'Status'), // Add a label
                    value: formData['status'],
                    items: listStatus.map((status) {
                      return DropdownMenuItem<String>(
                        value: status['status'],
                        child: Text(status['text']!),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a status';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['status'] = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Content'),
                    initialValue: formData['content'],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the content';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        formData['content'] = value;
                      });
                    },
                  ),
                  // Button to pick an image
                  ElevatedButton(
                    onPressed: pickImage,
                    child: const Text('Pick Image'),
                  ),
                  // Button to pick a video
                  ElevatedButton(
                    onPressed: pickVideo,
                    child: const Text('Pick Video'),
                  ),
                  // Display the picked image or video
                  buildPickedMedia(),
                  buildPickedMedia2(),
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