import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  List<Map<String, Object>> currencyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Adicionando um atraso de 0.5 segundos (500 milissegundos) para simular o carregamento
    Future.delayed(Duration(milliseconds: 500), () {
      fetchCurrencyList();
    });
  }

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
          };
        }).toList();
        isLoading = false; // Definindo isLoading como falso após o carregamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nome das Moedas',
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
          children: [
            // Exibindo o indicador de carregamento enquanto isLoading for verdadeiro
            if (isLoading)
              Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            else
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
                          DataCell(Text(entry['sigla'].toString())),
                          DataCell(Text(entry['nome'].toString())),
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
