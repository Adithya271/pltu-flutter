import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pltu/page/divisi/FormDivisi.dart';
import 'package:pltu/services/api_services.dart';

class BrowseDivisi extends StatefulWidget {
  const BrowseDivisi({Key? key}) : super(key: key);

  @override
  State<BrowseDivisi> createState() => _BrowseDivisiState();
}

class _BrowseDivisiState extends State<BrowseDivisi> {
  List<dynamic> dataDivisi = [];
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
    final url = Uri.parse("https://digitm.isoae.com/api/division/${data['id']}");
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
    final formDivisiKey = GlobalKey<FormDivisiState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormDivisi(
          key: formDivisiKey,
          onFinish: () {
            Navigator.pop(context);
            onFormClose();
          },
        ),
      ),
    );
  }

  void onSelect(data) {
    final formDivisiKey = GlobalKey<FormDivisiState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormDivisi(
          key: formDivisiKey,
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
    final url = Uri.parse("https://digitm.isoae.com/api/division");
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
        dataDivisi = responseData['records'];
        paginationData = responseData['paging'];
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        dataDivisi = [];
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
                'Divisi',
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
                    if (dataDivisi.isNotEmpty)
                      SingleChildScrollView(
                        child: Column(
                          children: dataDivisi.map((a) {
                            final nama = a['name'].toString();
                            final deskripsi = a['description'].toString();
                           

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
                                          child: const Text('Hapus'),
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
                FormDivisi(
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
