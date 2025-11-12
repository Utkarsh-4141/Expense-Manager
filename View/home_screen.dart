// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Controller/category_controller.dart';
import 'package:expense_manager/Controller/transaction_controller.dart';
import 'package:expense_manager/Model/drawer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:intl/intl.dart";
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategoryData();
    fetchTransactionData();
    //log("Count");
  }

  void fetchCategoryData() async {
    List<Map<String, dynamic>> dataList = [];
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("Category").get();
    for (var val in response.docs) {
      Map<String, dynamic> data = val.data() as Map<String, dynamic>;
      data["id"] = val.id;
      dataList.add(data);
    }
    Provider.of<Category>(context, listen: false).changeData(dataList);
    setState(() {});
  }

  void fetchTransactionData() async {
    List<Map<String, dynamic>> dataList = [];
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("Transaction").get();
    for (var val in response.docs) {
      Map<String, dynamic> data = val.data() as Map<String, dynamic>;
      data["id"] = val.id;
      dataList.add(data);
    }
    Provider.of<TransactionDemo>(context, listen: false)
        .changeTransactionData(dataList);
    setState(() {});
  }

  void addTrashData(Map<String, dynamic> trashData) async {
    try {
      final docRef =
          await FirebaseFirestore.instance.collection("Trash").add(trashData);
      trashData["id"] = docRef.id;
    } catch (e) {
      log(e.toString());
    }
    setState(() {});
  }

  void clearControllers() {
    dateController.clear();
    amountController.clear();
    categoryController.clear();
    descriptionController.clear();
  }

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

  void myBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "Select a date",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: const Icon(Icons.calendar_month_outlined),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2026),
                  );
                  String formattedDate = DateFormat.yMMMd().format(pickedDate!);
                  setState(
                    () {
                      dateController.text = formattedDate;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Amount",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  hintText: "Enter an amount",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Category",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              TextField(
                controller: categoryController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Select a category",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.only(right: 5),
                      iconSize: 30,
                      items: Provider.of<Category>(context)
                          .categoryList
                          .map<DropdownMenuItem<String>>(
                        (category) {
                          return DropdownMenuItem<String>(
                            value: category["category"],
                            child: Text(category["category"]),
                          );
                        },
                      ).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            categoryController.text = newValue!;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Description",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Enter a description",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (dateController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        categoryController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      Map<String, dynamic> transactionData = {
                        "date": dateController.text,
                        "amount": amountController.text,
                        "category": categoryController.text,
                        "description": descriptionController.text,
                      };
                      try {
                        final docRef = await FirebaseFirestore.instance
                            .collection("Transaction")
                            .add(transactionData);
                        transactionData["id"] = docRef.id;
                        Provider.of<TransactionDemo>(context, listen: false)
                            .addTransaction(transactionData);
                      } catch (e) {
                        log(e.toString());
                      }
                    }
                    clearControllers();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(67),
                      color: const Color.fromRGBO(14, 161, 125, 1),
                    ),
                    child: Text(
                      "Add",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void myDialogBox(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Remove Transaction",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(14, 161, 125, 1),
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Are you sure want to trash the selected transaction?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(0, 0, 0, 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Map<String, dynamic> trashData =
                    Provider.of<TransactionDemo>(context, listen: false)
                        .transactionList[index];
                addTrashData(trashData);
                String docId =
                    Provider.of<TransactionDemo>(context, listen: false)
                        .transactionList[index]["id"];
                await FirebaseFirestore.instance
                    .collection("Transaction")
                    .doc(docId)
                    .delete();
                Provider.of<TransactionDemo>(context, listen: false)
                    .transactionList
                    .removeAt(index);
                Navigator.of(context).pop();
                setState(() {});
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              child: Text(
                "Remove",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(140, 128, 128, 0.2),
                ),
              ),
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            )
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
          "Expense Manager",
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
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: ListView.builder(
              itemCount:
                  Provider.of<TransactionDemo>(context).transactionList.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    myDialogBox(context, index);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Consumer(
                      builder: (context, value, key) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.network(findImage(index)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<TransactionDemo>(context)
                                            .transactionList[index]["category"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                              33, 33, 33, 1),
                                        ),
                                      ),
                                      Text(
                                        Provider.of<TransactionDemo>(context)
                                                .transactionList[index]
                                            ["description"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: const Color.fromRGBO(
                                              33, 33, 33, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Image.asset("assets/icons/value.png"),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "₹${Provider.of<TransactionDemo>(context).transactionList[index]["amount"]}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(33, 33, 33, 1),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              Provider.of<TransactionDemo>(context)
                                  .transactionList[index]["date"],
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey,
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            child: GestureDetector(
              onTap: () {
                myBottomSheet();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(67),
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.25),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_circle_rounded,
                      size: 40,
                      weight: 100,
                      color: Color.fromRGBO(14, 161, 125, 1),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Add Transaction",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(33, 33, 33, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: myDrawer(context),
    );
  }
}
