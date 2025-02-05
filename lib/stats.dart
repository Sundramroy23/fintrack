import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class myStats extends StatelessWidget {
  const myStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade200,
        appBar: AppBar(
          title: const Text('Satistics'),
          backgroundColor: Colors.grey.shade300,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 280,
                child: PieChart(
                  PieChartData(
                      centerSpaceRadius: 70,
                      centerSpaceColor: Colors.yellow,
                      borderData: FlBorderData(show: false),
                      sections: [
                        PieChartSectionData(value: 20, color: Colors.blue),
                        PieChartSectionData(value: 10, color: Colors.orange),
                        PieChartSectionData(value: 10, color: Colors.red),
                        PieChartSectionData(value: 10, color: Colors.purple),
                        PieChartSectionData(value: 20, color: Colors.amber),
                        PieChartSectionData(value: 30, color: Colors.green)
                      ]),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: Color.fromARGB(255, 6, 162, 21),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Food"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: Color.fromARGB(255, 102, 192, 224),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Clothes"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: Color.fromARGB(255, 217, 223, 57),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Rent"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: Color.fromARGB(255, 195, 70, 209),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Insurance"),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            color: Color.fromARGB(255, 218, 74, 49),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Stocks"),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        color: Color.fromARGB(255, 233, 139, 56),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Miscellaneous"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 200,
                child: AspectRatio(
                  aspectRatio: 2,
                  child: BarChart(
                    BarChartData(
                      barGroups: _chartGroups(),
                      borderData: FlBorderData(
                          border: const Border(
                              bottom: BorderSide(), left: BorderSide())),
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                        leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }

  List<BarChartGroupData> _chartGroups() {
    return points
        .map((point) => BarChartGroupData(
            x: point.toInt(), barRods: [BarChartRodData(toY: point)]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Food';
              break;
            case 2:
              text = 'Clothes';
              break;
            case 3:
              text = 'Rent';
              break;
            case 4:
              text = 'Insurance';
              // text='ance';
              break;
            case 5:
              text = 'Stocks';
              break;
            case 6:
              text = 'Misc.';
              break;
          }

          return Text(text);
        },
      );
}

List<double> points = [10, 30, 20, 10, 20, 10];

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<double> points;

  @override
  State<BarChartWidget> createState() =>
      _BarChartWidgetState(points: this.points);
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<double> points;

  _BarChartWidgetState({required this.points});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: BarChart(
        BarChartData(
          barGroups: _chartGroups(),
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _chartGroups() {
    return points
        .map((point) => BarChartGroupData(
            x: point.toInt(), barRods: [BarChartRodData(toY: point)]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = 'Jan';
              break;
            case 2:
              text = 'Mar';
              break;
            case 4:
              text = 'May';
              break;
            case 6:
              text = 'Jul';
              break;
            case 8:
              text = 'Sep';
              break;
            case 10:
              text = 'Nov';
              break;
          }

          return Text(text);
        },
      );
}