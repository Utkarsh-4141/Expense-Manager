// ignore_for_file: unused_local_variable

import 'package:expense_manager/Controller/category_controller.dart';
import 'package:expense_manager/Controller/transaction_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:expense_manager/Model/drawer_model.dart";
import 'package:provider/provider.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late List<Map<String, dynamic>> catList;
  late List<Map<String, dynamic>> transList;
  //late List<Map<String, dynamic>> expenses = [];

  // @override
  // void initState() {
  //   super.initState();
  //   catList = Provider.of<Category>(context, listen: false).categoryList;
  //   //log("catLIST: $catList");
  //   transList =
  //       Provider.of<TransactionDemo>(context, listen: false).transactionList;
  //   for (int i = 0; i < transList.length; i++) {
  //     expenses[i]["label"] = transList[i]["category"];
  //     expenses[i]["amount"] = transList[i]["amount"];
  //     expenses[i]["icon"] = findImage(i);
  //   }
  //   log("transLIST: $transList");
  //   log("LIST: $expenses");
  // }

  final List<Map<String, dynamic>> expenses = [
    {
      'label': 'Food',
      'amount': 650.0,
      'color': Colors.red,
      'icon': Icons.restaurant
    },
    {
      'label': 'Fuel',
      'amount': 600.0,
      'color': Colors.blue,
      'icon': Icons.local_gas_station
    },
    {
      'label': 'Medicine',
      'amount': 500.0,
      'color': Colors.green,
      'icon': Icons.medical_services
    },
    {
      'label': 'Entertainment',
      'amount': 475.0,
      'color': Colors.purple,
      'icon': Icons.videogame_asset
    },
    {
      'label': 'Shopping',
      'amount': 325.0,
      'color': Colors.pink,
      'icon': Icons.shopping_cart
    },
  ];

  double get total => expenses.fold(
        0,
        (sum, item) => sum + (item['amount'] as double),
      );

  String findImage(int index) {
    String imagePath = "";
    for (int i = 0;
        i < Provider.of<Category>(context).categoryList.length;
        i++) {
      if (Provider.of<Category>(context).categoryList[i]["category"] ==
          Provider.of<TransactionDemo>(context).transactionList[index]
              ["category"]) {
        imagePath = Provider.of<Category>(context).categoryList[i]["imageUrl"];
      }
    }
    //log("IMAGEPATH: $imagePath");
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Graphs",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(14, 161, 125, 1),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(14, 161, 125, 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              // Pie chart and legend
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 220,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            centerSpaceColor: Colors.white,
                            //centerText: '₹ ${total.toStringAsFixed(2)}',
                            sections: expenses.map((data) {
                              final index = expenses.indexOf(data);
                              return PieChartSectionData(
                                color: data['color'],
                                value: data['amount'],
                                title: '',
                                radius: 30,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: expenses.map((e) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 6,
                                    backgroundColor: e['color'],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(e['label']),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
        
              const Divider(height: 30),
        
              // Expense List
              SizedBox(
                height: 350,
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: expense['color'],
                        child: Icon(
                          expense['icon'],
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(expense['label']),
                      trailing: Text(
                        "₹ ${expense['amount'].toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {}, // Optional detail page navigation
                    );
                  },
                ),
              ),
        
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "₹ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}



// Padding(
//         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         child: Column(
//           children: [
//             // Pie chart and legend
//             Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: SizedBox(
//                 height: 220,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: PieChart(
//                         PieChartData(
//                           sectionsSpace: 2,
//                           centerSpaceRadius: 50,
//                           centerSpaceColor: Colors.white,
//                           //centerText: '₹ ${total.toStringAsFixed(2)}',
//                           sections: expenses.map((data) {
//                             final index = expenses.indexOf(data);
//                             return PieChartSectionData(
//                               color: data['color'],
//                               value: data['amount'],
//                               title: '',
//                               radius: 30,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                     Expanded(
//                       flex: 2,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: expenses.map((e) {
//                           return Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 4.0),
//                             child: Row(
//                               children: [
//                                 CircleAvatar(
//                                   radius: 6,
//                                   backgroundColor: e['color'],
//                                 ),
//                                 const SizedBox(width: 6),
//                                 Text(e['label']),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),

//             const Divider(height: 30),

//             // Expense List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: expenses.length,
//                 itemBuilder: (context, index) {
//                   final expense = expenses[index];
//                   return ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: expense['color'],
//                       child: Icon(
//                         expense['icon'],
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                     title: Text(expense['label']),
//                     trailing: Text(
//                       "₹ ${expense['amount'].toStringAsFixed(2)}",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     onTap: () {}, // Optional detail page navigation
//                   );
//                 },
//               ),
//             ),

//             const Divider(),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Total",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     "₹ ${total.toStringAsFixed(2)}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),