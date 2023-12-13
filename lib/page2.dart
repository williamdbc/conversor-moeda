import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late String selectedCurrency;
  late int selectedDays;
  List<Map<String, dynamic>> historicalData = [];
  bool isListVisible = false;

  // Lista de moedas pré-definidas
  List<String> currencies = ['USD', 'BTC', 'EUR', 'JPY', 'GBP'];
  List<int> daysOptions = [7, 15, 30];

  @override
  void initState() {
    super.initState();
    // Inicializar as moedas padrão
    selectedCurrency = currencies[0];
    selectedDays = daysOptions[0];
  }

  // Método para buscar o histórico da moeda
  Future<void> fetchHistoricalData() async {
    final response = await http.get(
        Uri.parse('https://economia.awesomeapi.com.br/json/daily/$selectedCurrency-BRL/$selectedDays'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        historicalData = data.map((entry) {
          final String date = _convertTimestampToDate(int.parse(entry['timestamp']));
          return {
            'moeda': selectedCurrency,
            'valorBRL': entry['bid'],
            'data': date,
            'animation': false, // Adicionado para controlar a animação
          };
        }).toList();
        isListVisible = true; // Mostra a lista gradualmente
      });

      // Adicionar animação de fade-in para as linhas da tabela
      for (var i = 0; i < historicalData.length; i++) {
        await Future.delayed(Duration(milliseconds: 50));
        setState(() {
          historicalData[i]['animation'] = true;
        });
      }
    }
  }

  // Método para converter timestamp para data
  String _convertTimestampToDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Histórico de Moedas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: selectedCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedCurrency = value!;
                      });
                    },
                    items: currencies.map((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(
                          currency,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                  ),
                  DropdownButton<int>(
                    value: selectedDays,
                    onChanged: (value) {
                      setState(() {
                        selectedDays = value!;
                      });
                    },
                    items: daysOptions.map((days) {
                      return DropdownMenuItem<int>(
                        value: days,
                        child: Text(
                          '$days dias',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Chamar a função para buscar os dados
                  await fetchHistoricalData();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.deepPurpleAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      'Exibir Histórico',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowHeight: 50, // Altura fixa para as linhas
                  columns: [
                    DataColumn(label: Text('Moeda')),
                    DataColumn(label: Text('Valor (BRL)')),
                    DataColumn(label: Text('Data')),
                  ],
                  rows: historicalData.map((entry) {
                    return DataRow(
                      cells: [
                        DataCell(
                          AnimatedOpacity(
                            opacity: entry['animation'] ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              entry['moeda'].toString(),
                              style: TextStyle(
                                color: Colors.black, // Cor do texto
                                fontWeight: FontWeight.bold, // Negrito
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          AnimatedOpacity(
                            opacity: entry['animation'] ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              entry['valorBRL'].toString(),
                              style: TextStyle(
                                color: Colors.black, // Cor do texto
                                fontWeight: FontWeight.bold, // Negrito
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          AnimatedOpacity(
                            opacity: entry['animation'] ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: Text(
                              entry['data'].toString(),
                              style: TextStyle(
                                color: Colors.black, // Cor do texto
                                fontWeight: FontWeight.bold, // Negrito
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
