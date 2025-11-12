import 'package:expense_manager/View/categories_screen.dart';
import 'package:expense_manager/View/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:expense_manager/View/trash_screen.dart";
import "package:expense_manager/View/graph_screen.dart";
import "package:expense_manager/View/about_us_screen.dart";

Widget myDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            children: [
              Text(
                "Expense Manager",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(14, 161, 125, 1),
                ),
              ),
              Text(
                "Saves all your Transactions",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                ),
              ),
            ],
          ),
        ),
        // ListTile(
        //   leading: Image.asset("assets/icons/Transaction icon.png"),
        //   title: Text(
        //     "Transaction",
        //     style: GoogleFonts.poppins(
        //       fontSize: 16,
        //       fontWeight: FontWeight.w400,
        //       color: const Color.fromRGBO(14, 161, 125, 1),
        //     ),
        //   ),
        //   onTap: () {},
        // ),
        ListTile(
          leading: Image.asset("assets/icons/Category icon.png"),
          title: Text(
            "Home",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const HomeScreen();
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Image.asset("assets/icons/Graphs.png"),
          title: Text(
            "Graphs",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const GraphScreen();
                }
              ),
            );
          },
        ),
        ListTile(
          leading: Image.asset("assets/icons/Category icon.png"),
          title: Text(
            "Category",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const CategoriesScreen();
                },
              ),
            );
          },
        ),
        ListTile(
          leading: Image.asset("assets/icons/Trash icon.png"),
          title: Text(
            "Trash",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const TrashScreen();
              }),
            );
          },
        ),
        ListTile(
          leading: Image.asset("assets/icons/About us icon.png"),
          title: Text(
            "About us",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(33, 33, 33, 1),
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const AboutUs();
                }
              ),
            );
          },
        ),
      ],
    ),
  );
}
