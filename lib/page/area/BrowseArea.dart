import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pltu/page/area/FormArea.dart';
import 'package:pltu/services/api_services.dart';

class BrowseArea extends StatefulWidget {
  const BrowseArea({Key? key}) : super(key: key);

  @override
  State<BrowseArea> createState() => _BrowseAreaState();
}

class _BrowseAreaState extends State<BrowseArea> {
  List<dynamic> dataArea = [];
  String mode = 'browse';
  Map<String, dynamic> queryData = {
    'page': 1,
    'name': '',
    'limit': 10,
    'order_col': '',
    'order_type': '',
  };
  Map<String, dynamic> paginationData = {};

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

  void onDelete(data) {
    // Delete data pakai api
    // ...
    loadData();
  }

  void addData() {
    final formAreaKey = GlobalKey<FormAreaState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormArea(
          key: formAreaKey,
          onFinish: () {
            Navigator.pop(context);
            onFormClose();
          },
        ),
      ),
    );
  }

  void onSelect(data) {
    final formAreaKey = GlobalKey<FormAreaState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormArea(
          key: formAreaKey,
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
    final url = Uri.parse("https://digitm.isoae.com/api/area");
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
        dataArea = responseData['records'];
        paginationData = responseData['paging'];
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        dataArea = [];
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
                'Area',
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
                    if (dataArea.isNotEmpty)
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Nama')),
                          DataColumn(label: Text('Nama Divisi')),
                          DataColumn(label: Text('Deskripsi')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: dataArea.map((a) {
                          final nama = a['name'].toString();
                          final deskripsi = a['description'].toString();
                          final namadivisi = a['division']['name'].toString();

                          return DataRow(cells: [
                            DataCell(Text(nama)),
                            DataCell(Text(namadivisi)),
                            DataCell(Text(deskripsi)),
                            DataCell(
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () => onSelect(a),
                                    child: const Text('Pilih'),
                                  ),
                                  TextButton(
                                    onPressed: () => onDelete(a),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                  ],
                ),
              const SizedBox(height: 12),
              if (mode == 'form')
                FormArea(
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
