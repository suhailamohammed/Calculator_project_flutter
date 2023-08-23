import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';


class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({Key? key}) : super(key: key);

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _input = '';
  String _output = '';

  void _handleButtonPress(String value) {
    if (value == '=') {
      _calculateResult();
    }
    else if (value == 'C' || value == 'x') {
      _clear();
    }
    else {
      setState(() {
        _input += value;
      });
    }
  }

  void _calculateResult() {
    try {
      Parser parser = Parser();
      Expression expression = parser.parse(_input);

      ContextModel contextModel = ContextModel();
      double result = expression.evaluate(EvaluationType.REAL, contextModel);

      setState(() {
        _output = result.toString();
      });
    } catch (e) {
      setState(() {
        _output = 'Incorrect input';
      });
    }
  }

  void _clear() {
    setState(() {
      _input = '';
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<SymbolOrIcon> symbolsAndIcons= [
      SymbolOrIcon(Icons.keyboard_arrow_down, isIcon: true),
      SymbolOrIcon("(", isIcon: false),
      SymbolOrIcon("1", isIcon: false),
      SymbolOrIcon("4", isIcon: false),
      SymbolOrIcon("7", isIcon: false),
      SymbolOrIcon("0", isIcon: false)
    ];
    final List<SymbolOrIcon> symbolsAndIcons1 = [
      SymbolOrIcon("C", isIcon: false),
      SymbolOrIcon(")", isIcon: false),
      SymbolOrIcon("2", isIcon: false),
      SymbolOrIcon("5", isIcon: false),
      SymbolOrIcon("8", isIcon: false),
      SymbolOrIcon("00", isIcon: false)
    ];
    final List<SymbolOrIcon> symbolsAndIcons2 = [
      SymbolOrIcon("x", isIcon: false),
      SymbolOrIcon("%", isIcon: false),
      SymbolOrIcon("3", isIcon: false),
      SymbolOrIcon("6", isIcon: false),
      SymbolOrIcon("9", isIcon: false),
      SymbolOrIcon(".", isIcon: false)
    ];
    final List<SymbolOrIcon> symbolsAndIcons3 = [
      SymbolOrIcon("/", isIcon: false),
      SymbolOrIcon("*", isIcon: false),
      SymbolOrIcon("-", isIcon: false),
      SymbolOrIcon("+", isIcon: false),
    ];

    return Scaffold(
      backgroundColor: Color(0xff0e2433),
      appBar: AppBar(
        toolbarHeight: 120.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu',
            );
          },
        ),
        centerTitle: true,
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xff0e2433),
      ),
      body: Column(
        children: [
          Padding (
            padding: const EdgeInsets.all(40),
            child: Container(
              width: double.infinity,
              child: Text(
                _input,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          Padding (
            padding: EdgeInsets.all(40),
            child: Container(
              width: double.infinity,
              child: Text(
                _output,
                textAlign: TextAlign.right,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Color(0xff0b344f),
              child: Row (
                children: [
                  CalculatorPadDesign(
                    symbolsAndIcons: symbolsAndIcons,
                    calculatorLogic: this,
                  ),
                  CalculatorPadDesign(
                    symbolsAndIcons: symbolsAndIcons1,
                    calculatorLogic: this,
                  ),
                  CalculatorPadDesign(
                    symbolsAndIcons: symbolsAndIcons2,
                    calculatorLogic: this,
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: CalculatorPadDesign(
                          symbolsAndIcons: symbolsAndIcons3,
                          calculatorLogic: this,
                        ),
                      ),
                      Container(
                        width: 96,
                        color: Color(0xff296d98),
                        child: GestureDetector(
                        onTap: () {
                          this._handleButtonPress('=');
                        },
                          child: Padding (
                            padding: EdgeInsets.fromLTRB(0, 50, 0, 50),child:
                            Center (
                              child:
                              Text('=', style: TextStyle(color: Colors.white, fontSize: 28))
                            )
                          )
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorPadDesign extends StatefulWidget {
  final List<SymbolOrIcon> symbolsAndIcons;
  final _CalculatorHomePageState calculatorLogic;

  const CalculatorPadDesign({
    Key? key,
    required this.symbolsAndIcons,
    required this.calculatorLogic,
  }) : super(key: key);

  @override
  State<CalculatorPadDesign> createState() => _CalculatorPadDesignState();
}

class _CalculatorPadDesignState extends State<CalculatorPadDesign> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 15, 37, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.symbolsAndIcons.map((symbolOrIcon) {
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.calculatorLogic._handleButtonPress(symbolOrIcon.data);
              });
            },
            child: Column(
              children: [
                if (symbolOrIcon.isIcon)
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Icon(
                        symbolOrIcon.data,
                        size: 30,
                        color: Colors.white,
                      )
                  )
                else
                    Text(
                      symbolOrIcon.data,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
               ],
             ),
           );
         }).toList(),
       ),
    );
  }
}

class SymbolOrIcon {
  final dynamic data;
  final bool isIcon;

  SymbolOrIcon(this.data, {required this.isIcon});
}