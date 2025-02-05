import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'home.g.dart';

double income = 0;
double expense = 0;

Future<void> saveInteger(double inc, double exp) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('income', inc);
  await prefs.setDouble('expense', exp);
}

void clearData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<double?> getIncome() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('income');
}

Future<double?> getExpense() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('expense');
}

double? inc;
double? exp;

Future<void> loadIncomeAndExpense() async {
  inc = await getIncome();
  exp = await getExpense();
  income = inc!;
  expense = exp!;
}

void saveValues() async {
  await saveInteger(income, expense);
  await loadIncomeAndExpense();
}

List<String> list = <String>['Daily', 'Weekly', 'Monthly', 'Annually'];

const List<Widget> fruits = <Widget>[Text('INCOME'), Text('EXPENSE')];

@JsonSerializable()
class Transaction {
  DateTime dateTime;
  double amount;
  String type;
  int account;
  int category;
  String notes;

  Transaction(this.dateTime, this.amount, this.type, this.account,
      this.category, this.notes);

  // From JSON
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

Future<void> saveTransaction(Transaction transaction) async {
  final prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(transaction.toJson());

  // Save transaction with unique key
  await prefs.setString(
      'transaction_${transaction.dateTime.toIso8601String()}', jsonString);

  // Get the list of all transaction keys
  List<String>? transactionKeys = prefs.getStringList('transaction_keys');
  if (transactionKeys == null) {
    transactionKeys = [];
  }

  // Add the new transaction key and sort the list by timestamp in descending order
  transactionKeys.add(transaction.dateTime.toIso8601String());
  transactionKeys.sort((a, b) => b.compareTo(a)); // Sort in descending order

  // Save the updated list of transaction keys
  await prefs.setStringList('transaction_keys', transactionKeys);
}

Future<List<Transaction>> getAllTransactions() async {
  final prefs = await SharedPreferences.getInstance();

  // Get the list of all transaction keys
  List<String>? transactionKeys = prefs.getStringList('transaction_keys');
  if (transactionKeys == null) {
    return [];
  }

  // Retrieve each transaction by its key
  List<Transaction> transactions = [];
  for (String key in transactionKeys) {
    String? jsonString = prefs.getString('transaction_$key');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      transactions.add(Transaction.fromJson(jsonMap));
    }
  }

  return transactions;
}

List<Transaction> trs = [];

class Home extends StatefulWidget {
  const Home({Key? key, required this.incm, required this.exp})
      : super(key: key);

  final double incm;
  final double exp;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<FlSpot> data1 = [];
  final List<FlSpot> data2 = [];

  String dropdownval = list.first;

  void _navigateAndAddTransaction(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondRoute()),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> transactionWidgets = trs.map((transaction) {
      return SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.money),
              ),
              title: Text("${transaction.amount}"),
              subtitle: Text("${transaction.type}"),
              trailing: Text("Utility"),
              tileColor: Colors.deepPurple.shade100,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }).toList();

    for (int i = 0; i < trs.length; i++) {
      Transaction t = trs[i];
      double x = i.toDouble();

      if (t.type == 'income') {
        data1.add(FlSpot(x, t.amount));
        data2.add(FlSpot(x, 0));
      } else if (t.type == 'expense') {
        data2.add(FlSpot(x, t.amount));
        data1.add(FlSpot(x, 0));
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: const Text('FINTRACK'),
              centerTitle: true,
              backgroundColor: Colors.blueGrey.shade200,
              elevation: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: DropdownButton<String>(
                value: dropdownval,
                style: TextStyle(color: Colors.purple.shade900, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.purple.shade900,
                ),
                items: list.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownval = value!;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Income: ${income}",
                      style: TextStyle(
                        fontFamily: 'JosefinSans',
                        fontSize: 24.0,
                        color: Colors.white,
                        // backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 170,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red.shade400),
                  child: Center(
                    child: Text(
                      "Expense: ${expense}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'JosefinSans',
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 160,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.cyan),
              child: Center(
                child: Text(
                  "Total: ${income - expense}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'JosefinSans',
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              // Within the `FirstRoute` widget
              onPressed: () {
                _navigateAndAddTransaction(context);
              },
              child: Text("Add Transaction"),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(6),
              width: 340,
              height: 260,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    //expense data
                    LineChartBarData(
                      spots: data2,
                      isCurved: false,
                      barWidth: 3,
                      color: Colors.red,
                    ),
                    //income data
                    LineChartBarData(
                      spots: data1,
                      isCurved: false,
                      barWidth: 3,
                      color: Colors.green,
                    ),
                  ],
                  titlesData: FlTitlesData(),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Recent Transactions",
              style: TextStyle(
                fontFamily: 'JosefinSans',
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            Divider(
              color: Colors.black, // Color of the divider
              thickness: 1.5, // Thickness of the divider
              indent: 10, // Empty space to the leading edge of the divider
              endIndent: 10, // Empty space to the trailing edge of the divider
            ),
            Container(
              width: 350,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[] + transactionWidgets,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  SecondRoute({super.key});

  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  final List<bool> selected_trs = <bool>[true, false];
  bool vertical = false;

  TextEditingController amtcontrol = TextEditingController();
  TextEditingController notecontrol = TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accounts'),
          content: SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(Icons.credit_card),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
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
        title: const Text('Second Route'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: ToggleButtons(
              direction: vertical ? Axis.vertical : Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < selected_trs.length; i++) {
                    selected_trs[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ),
              isSelected: selected_trs,
              children: fruits,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.cyan.shade100,
                textStyle: TextStyle(fontSize: 20)),
            onPressed: () {
              _showMyDialog();
            },
            child: Text("Select  Account"),
          ),
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.green.shade100,
                textStyle: TextStyle(fontSize: 20)),
            onPressed: () {
              _showMyDialog();
            },
            child: Text("Select Category"),
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: amtcontrol,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter the amount',
              constraints: BoxConstraints(
                maxWidth: 320,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: notecontrol,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Add Notes',
              constraints: BoxConstraints(
                maxWidth: 320,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontSize: 20)),
                onPressed: () {
                  DateTime dt = new DateTime.now();
                  double amt = double.parse(amtcontrol.text);
                  String nt = notecontrol.text;
                  String ie;
                  if (selected_trs.first == true) {
                    income += amt;
                    ie = "income";
                  } else {
                    ie = "expense";
                    expense += amt;
                  }
                  Transaction newtrs = Transaction(dt, amt, ie, 0, 0, nt);
                  setState(() {
                    saveValues();
                    saveTransaction(newtrs);
                    trs.add(newtrs);
                  });

                  amtcontrol.clear();
                  notecontrol.clear();
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          )
        ],
      )),
    );
  }
}