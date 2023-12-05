import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  List<String> str = [
    "C",
    "*",
    "/",
    "<-",
    "1",
    "2",
    "3",
    "+",
    "4",
    "5",
    "6",
    "-",
    "7",
    "8",
    "9",
    "*",
    "%",
    "0",
    ".",
    "=",
  ];

  final TextEditingController _textController = TextEditingController();
  String _displayText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _textController,
              readOnly: true,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(18),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                for (int i = 0; i < str.length; i++) ...{
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    child: Text(
                      str[i],
                      style: const TextStyle(fontSize: 25),
                    ),
                    onPressed: () {
                      _handleButtonPress(str[i]);
                    },
                  )
                }
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(String value) {
    setState(() {
      if (value == "C") {
        _displayText = '';
      } else if (value == "<-") {
        if (_displayText.isNotEmpty) {
          _displayText = _displayText.substring(0, _displayText.length - 1);
        }
      } else if (value == "=") {
        try {
          _displayText = _evaluateExpression(_displayText).toString();
        } catch (e) {
          _displayText = 'Error';
        }
      } else {
        _displayText += value;
      }

      _textController.text = _displayText;
    });
  }

  double _evaluateExpression(String expression) {
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expression.length; i++) {
      if (expression[i] == '+' ||
          expression[i] == '-' ||
          expression[i] == '*' ||
          expression[i] == '/') {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
        }
        tokens.add(expression[i]);
        currentToken = '';
      } else {
        currentToken += expression[i];
      }
    }

    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '*':
          result *= operand;
          break;
        case '/':
          if (operand != 0) {
            result /= operand;
          } else {
            // Handle division by zero
            return double.infinity;
          }
          break;
      }
    }

    return result;
  }
}
