import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pltu/page/transaksi/FormTransaksi.dart';
import 'package:pltu/services/api_services.dart';

class BrowseTransaksi extends StatefulWidget {
  const BrowseTransaksi({Key? key}) : super(key: key);

  @override
  State<BrowseTransaksi> createState() => _BrowseTransaksiState();
}

class _BrowseTransaksiState extends State<BrowseTransaksi> {
  List<dynamic> dataTransaksi = [];
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
    final url = Uri.parse("https://digitm.isoae.com/api/transaksi/${data['id']}");
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
    final formTransaksiKey = GlobalKey<FormTransaksiState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormTransaksi(
          key: formTransaksiKey,
          onFinish: () {
            Navigator.pop(context);
            onFormClose();
          },
        ),
      ),
    );
  }

  void onSelect(data) {
    final formTransaksiKey = GlobalKey<FormTransaksiState>();
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: FormTransaksi(
          key: formTransaksiKey,
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
    final url = Uri.parse("https://digitm.isoae.com/api/transaksi");
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
        dataTransaksi = responseData['records'];
        paginationData = responseData['paging'];
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        dataTransaksi = [];
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
                'Transaksi',
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
                    if (dataTransaksi.isNotEmpty)
                      SingleChildScrollView(
                        child: Column(
                          children: dataTransaksi.map((a) {
                            final notrans = a['nomor'].toString();
                            final tgl = a['tgl'].toString();
                            final namadivisi = a['division']['name'].toString();
                            final total = a['total'].toString();

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Nomor Transaksi: $notrans'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Tanggal: $tgl'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Nama Divisi: $namadivisi'),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text('Total: $total'),
                                    const SizedBox(
                                      height: 8,
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
                                          child: const Text('Hapus',
                                              style:
                                                  TextStyle(color: Colors.red)),
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
                FormTransaksi(
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
