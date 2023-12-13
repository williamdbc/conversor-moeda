import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, Object>> currencyList = [];

  Future<void> fetchCurrencyList() async {
    final response = await http.get(
        Uri.parse('https://economia.awesomeapi.com.br/json/available/uniq'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        currencyList = data.entries.map((entry) {
          return {
            'sigla': entry.key,
            'nome': entry.value.toString(),
            'animation': false,
          };
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadCurrencyNames() async {
    await fetchCurrencyList();
    for (var entry in currencyList) {
      entry['animation'] = true;
      setState(() {});
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

// ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nomes das Moedas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Adicionado para centralizar na vertical
          children: [
            ElevatedButton.icon(
              onPressed: loadCurrencyNames,
              icon: Icon(Icons.cloud_download),
              label: Text('Carregar Nomes'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Sigla')),
                    DataColumn(label: Text('Nome da Moeda')),
                  ],
                  rows: currencyList.map((entry) {
                    return DataRow(
                      cells: [
                        DataCell(
                          AnimatedOpacity(
                            opacity: entry['animation'] == true ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Text(entry['sigla'].toString()),
                          ),
                        ),
                        DataCell(
                          AnimatedOpacity(
                            opacity: entry['animation'] == true ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 200),
                            child: Text(entry['nome'].toString()),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// ...
