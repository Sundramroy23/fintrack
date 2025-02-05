import 'package:flutter/material.dart';
import 'accounts.dart';
import 'stats.dart';
import 'home.dart';
// import 'package:restart_app/restart_app.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadIncomeAndExpense();
  }

  void _loadIncomeAndExpense() async {
    await loadIncomeAndExpense();
    trs = await getAllTransactions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      Home(incm: income, exp: expense),
      myStats(),
      account(),
      Scaffold(
        appBar: AppBar(
          title: Center(child: Text('More Options')),
        ),
        body: Align(
          alignment: Alignment(0, -0.8),
          child: Container(
            width: 240,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.settings, size: 30),
                  title: Text('Settings', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to the settings screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, size: 30),
                  title: Text('Delete & Reset', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    clearData();
                    // Restart.restartApp();
                    setState(() {
                      Home(incm: income, exp: expense);
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.upload_file, size: 30),
                  title: Text('Export Records', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Implement export records functionality
                  },
                ),
                ListTile(
                  leading: Icon(Icons.backup, size: 30),
                  title:
                      Text('Backup & Restore', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Implement backup and restore functionality
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help, size: 30),
                  title: Text('Help', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // Navigate to the help screen
                  },
                ),
              ],
            ),
          ),
        ),
      )
    ];

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.query_stats,
            ),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}