import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; // Importe esta biblioteca para usar TextInputFormatter

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  late String selectedFromCurrency;
  late String selectedToCurrency;
  TextEditingController amountController = TextEditingController();
  String result = "";

  // Lista de moedas pré-definidas
  List<String> currencies = ['BRL', 'USD', 'BTC', 'CAD', 'JPY'];

  @override
  void initState() {
    super.initState();
    // Inicializar as moedas padrão
    selectedFromCurrency = currencies[0];
    selectedToCurrency = currencies[1];
  }

  // Método para realizar a conversão usando a API
  Future<void> convertCurrency() async {
    if (amountController.text.isEmpty) {
      showPopup("A quantidade não pode estar vazia.");
      return;
    }

    if (selectedFromCurrency == selectedToCurrency) {
      showPopup("Selecione moedas diferentes.");
      return;
    }

    final fromCurrency = selectedFromCurrency;
    final toCurrency = selectedToCurrency;

    final response = await http.get(Uri.parse('https://economia.awesomeapi.com.br/last/$fromCurrency-$toCurrency'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final bidValue = double.parse(data['$fromCurrency$toCurrency']['bid']);
      final quantity = double.parse(amountController.text);
      final convertedValue = bidValue * quantity;

      setState(() {
        result =
        "${amountController.text} $fromCurrency\n=\n${convertedValue.toStringAsFixed(2)} $toCurrency";
      });
    } else {
      setState(() {
        result = "Erro na conversão";
      });
    }
  }

  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Aviso"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversor de Moedas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: selectedFromCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedFromCurrency = value!;
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
                  Text(
                    'para',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  DropdownButton<String>(
                    value: selectedToCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedToCurrency = value!;
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
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0),
                decoration: InputDecoration(
                  labelText: 'Digite a quantidade',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                convertCurrency();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.deepPurpleAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Center(
                  child: Text(
                    'Converter',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              splashColor: Colors.grey, // Adicionando o feedback de toque
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    result,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
