import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pltu/page/type/ShowContent.dart';
import 'package:pltu/page/type/ShowImage.dart';
import 'package:pltu/page/type/ShowVideo.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:pltu/page/type/FormType.dart';
import 'package:pltu/services/api_services.dart';

class BrowseType extends StatefulWidget {
  const BrowseType({Key? key}) : super(key: key);

  @override
  State<BrowseType> createState() => _BrowseTypeState();
}

class _BrowseTypeState extends State<BrowseType> {
  List<dynamic> dataType = [];

  String mode = 'browse';
  Map<String, dynamic> paginationData = {};
  Map<String, dynamic> queryData = {
    'page': 1,
    'name': '',
    'limit': 10,
    'order_col': '',
    'order_type': '',
  };

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void onFormClose() {
    setState(() {
      mode = 'browse';
    });
    loadData();
  }

  void onDelete(data) async {
    final url = Uri.parse("https://digitm.isoae.com/api/type/${data['id']}");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${APIService.token}",
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Data deleted successfully');
        loadData(); // Refresh the data after deletion
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void addData() {
    final formTypeKey = GlobalKey<FormTypeState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormType(
          key: formTypeKey,
          onFinish: () {
            Navigator.pop(context);
            onFormClose();
          },
        ),
      ),
    );
  }

  void onSelect(data) {
    final formTypeKey = GlobalKey<FormTypeState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormType(
          key: formTypeKey,
          selectedData: data,
          onFinish: () {
            Navigator.pop(context);
            onFormClose();
          },
        ),
      ),
    );
  }

  void onSearching(String value) {
    setState(() {
      queryData['name'] = value;
    });
    loadData();
  }

  Future<void> loadData() async {
    final url = Uri.parse("https://digitm.isoae.com/api/type");
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${APIService.token}",
    };

    // Construct the query parameters
    final queryParameters = {
      'page': queryData['page'].toString(),
      'name': queryData['name'],
      'limit': queryData['limit'].toString(),
      'order_col': queryData['order_col'],
      'order_type': queryData['order_type'],
    };

    final urlWithQuery = url.replace(queryParameters: queryParameters);

    final response = await http.get(urlWithQuery, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final responseData = jsonData['data'];

      setState(() {
        dataType = responseData['records'];
        paginationData = responseData['paging'];
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        dataType = [];
        paginationData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (mode == 'browse')
                Column(
                  children: [
                    TextField(
                      onChanged: onSearching,
                      decoration: const InputDecoration(
                        hintText: 'Masukan nama untuk pencarian',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: addData,
                      child: const Text('Tambah Data'),
                    ),
                    const SizedBox(height: 12),
                    if (dataType.isNotEmpty)
                      SingleChildScrollView(
                        child: Column(
                          children: dataType.map((a) {
                            final nama = a['name'].toString();
                            final deskripsi = a['description'].toString();
                            final namadivisi = a['division']['name'].toString();
                            final namaarea = a['area']['name'].toString();
                            final namagroupEq =
                                a['group_equipment']['name'].toString();
                            final namaequipment =
                                a['equipment']['name'].toString();
                            final alasan = a['alasan'].toString();
                            final status = a['status'].toString();
                            final content = a['content'].toString();
                            final images = a['images'] as List<dynamic>?;
                            final videos = a['videos'] as List<dynamic>?;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nama: $nama'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Deskripsi: $deskripsi'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Nama Divisi: $namadivisi'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Nama Area: $namaarea'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Nama GroupEquipment: $namagroupEq'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Nama Equipment: $namaequipment'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Alasan: $alasan'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Status: $status'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        const Text('Content:'),
                                        const SizedBox(width: 8.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ShowContent(
                                                  nama: nama,
                                                  content: content,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Text('Lihat'),
                                        ),
                                      ],
                                    ),
                                    if (images != null && images.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: images.length,
                                        itemBuilder: (context, index) {
                                          final image = images[index];
                                          final imagePath =
                                              image['path'].toString();
                                          final imageUrl =
                                              'https://digitm.isoae.com/$imagePath';

                                          return Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowImage(
                                                            nama: nama,
                                                              imageUrl: imageUrl),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                    'Lihat Gambar'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    if (videos != null && videos.isNotEmpty)
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: videos.length,
                                        itemBuilder: (context, index) {
                                          final video = videos[index];
                                          final videoPath =
                                              video['path'].toString();
                                          final videoUrl =
                                              'https://digitm.isoae.com/$videoPath';

                                         return Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowVideo(
                                                              nama: nama,
                                                              videoUrl:
                                                                  videoUrl),
                                                    ),
                                                  );
                                                },
                                                child: Text('Lihat Video'),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () => onSelect(a),
                                          child: const Text('Pilih'),
                                        ),
                                        const SizedBox(width: 8.0),
                                        TextButton(
                                          onPressed: () => onDelete(a),
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 12),
              if (mode == 'form')
                FormType(
                  selectedData: null, // Pass the selected data here if needed
                  onFinish: () => onFormClose(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

