// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_manager/Controller/category_controller.dart';
import 'package:expense_manager/Model/drawer_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  XFile? image;
  TextEditingController urlController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  Map<String, dynamic> myList = {};

  Future<void> pickImage() async {
    final ImagePicker pickedImage = ImagePicker();
    final selectedImage =
        await pickedImage.pickImage(source: ImageSource.gallery);
    image = selectedImage;
  }

  void myBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        await pickImage();
                        urlController.text = image!.path;
                        setModalState(() {});
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(140, 128, 128, 0.2),
                        ),
                        child: (image == null)
                            ? Image.asset("assets/icons/img icon.png")
                            : Image.file(
                                File(image!.path),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Image URL",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(14, 161, 125, 1),
                    ),
                  ),
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: "Enter URL",
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
                    decoration: InputDecoration(
                      hintText: "Enter category name",
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
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (categoryController.text.isNotEmpty &&
                            image != null) {
                          try {
                            Reference ref = FirebaseStorage.instance
                                .ref()
                                .child("Categories/${categoryController.text}");
                            UploadTask uploadTask =
                                ref.putFile(File(image!.path));
                            await uploadTask.whenComplete(() => null);
                            String url = await ref.getDownloadURL();

                            myList = {
                              "imageUrl": url,
                              "category": categoryController.text
                            };

                            final docRef = await FirebaseFirestore.instance
                                .collection("Category")
                                .add(myList);
                            myList["id"] = docRef.id;
                            Provider.of<Category>(context, listen: false).addCategory(myList);
                          } catch (e) {
                            log(e.toString());
                          }

                          //log("CategoryScreen : $myList");
                          urlController.clear();
                          categoryController.clear();
                          image = null;
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(67),
                          color: const Color.fromRGBO(14, 161, 125, 1),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              offset: Offset(1, 2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
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
              "Delete Category",
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
              "Are you sure want to delete the selected category?",
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
                await FirebaseStorage.instance
                    .ref()
                    .child(
                        "Categories/${Provider.of<Category>(context, listen: false).categoryList[index]["category"]}")
                    .delete();
                String docId =
                    Provider.of<Category>(context, listen: false).categoryList[index]["id"];
                await FirebaseFirestore.instance
                    .collection("Category")
                    .doc(docId)
                    .delete();
                Provider.of<Category>(context, listen: false)
                    .categoryList
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
          "Categories",
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(20),
                itemCount: Provider.of<Category>(context).categoryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      myDialogBox(context, index);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            offset: Offset(1, 2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Consumer(
                        builder: (context, value, key) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  Provider.of<Category>(context)
                                      .categoryList[index]["imageUrl"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                Provider.of<Category>(context)
                                    .categoryList[index]["category"],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(33, 33, 33, 1),
                                ),
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
            const SizedBox(height: 20),
            GestureDetector(
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
                      "Add Category",
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
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}
