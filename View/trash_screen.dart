// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Model/drawer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<Map<String, dynamic>> trashList = [];

  @override
  void initState() {
    super.initState();
    fetchTrashData();
  }

  void fetchTrashData() async {
    QuerySnapshot response =
        await FirebaseFirestore.instance.collection("Trash").get();
    for (var val in response.docs) {
      Map<String, dynamic> data = {};
      data = val.data() as Map<String, dynamic>;
      data["id"] = val.id;
      trashList.add(data);
    }
    setState(() {});
  }

  void myDialogBox(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Delete Transaction",
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
              "Are you sure want to delete the selected transaction?",
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
                String docId = trashList[index]["id"];
                await FirebaseFirestore.instance
                    .collection("Trash")
                    .doc(docId)
                    .delete();
                trashList.removeAt(index);
                Navigator.of(context).pop();
                setState(() {});
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            ),
            const SizedBox(width: 25),
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
          "Trash",
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
      body: ListView.builder(
        itemCount: trashList.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(10),
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
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Icon(
                              Icons.remove_circle_outlined,
                              color: Color.fromARGB(255, 207, 207, 207),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trashList[index]["category"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(33, 33, 33, 1),
                                  ),
                                ),
                                Text(
                                  trashList[index]["description"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(33, 33, 33, 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "₹${trashList[index]["amount"]}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(33, 33, 33, 1),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        trashList[index]["date"],
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
      drawer: myDrawer(context),
    );
  }
}
