import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../transactionlistview/combinedlistview/combinedlistview.dart';

class ExpenseCatPage extends StatefulWidget {
  String useruid = "";

  ExpenseCatPage({required this.useruid});

  @override
  State<ExpenseCatPage> createState() => _ExpenseCatPageState();
}

class _ExpenseCatPageState extends State<ExpenseCatPage> {
  List<String> expenseCategories = [
    'Groceries',
    'Utilities',
    'Transportation',
    'Healthcare',
    'Entertainment',
    'Dining Out',
    'Shopping',
    'Home Maintenance',
    'Travel',
    'Miscellaneous',
    'Education'
  ];
  String selectedCategory = 'Groceries';
  List<Map<String, dynamic>> expenseList = [];
  DateTime? _selectedDate;
  String formattedDateString = "";
  bool showbydate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the category list
          CategoryList(
            categories: expenseCategories,
            onCategorySelected: (category) {
              // Update the selected category
              setState(() {
                selectedCategory = category;
              });

              // Fetch and display expense data based on the selected category
              fetchAndDisplayExpenseData(category);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = null;
                  });
                },
                child: const Text(
                  'Show All',
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(
                  '${_selectedDate != null ? "${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}" : "Select by date"}',
                  style: const TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ),
            ],
          ),
          // Display the income data in a ListView
          Expanded(
            child: Container(
              color: const Color(0xFF003366),
              child: FutureBuilder(
                future: _selectedDate != null
                    ? fetchAndDisplayExpenseDatabydate(selectedCategory)
                    : fetchAndDisplayExpenseData(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('Nothing to show.',
                            style: TextStyle(color: Colors.white)));
                  } else {
                    return ListView.builder(
                      itemCount: expenseList.length + 1,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        if (index < expenseList.length) {
                          return CombinedListItem(
                            data: expenseList[index],
                            documentId: expenseList[index]['id'],
                            useruid: widget.useruid,
                          );
                        } else {
                          // Display a message when there is no more data to show
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'No more data to show',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        formattedDateString = DateFormat.yMMMMd().format(_selectedDate!);
        showbydate = true;
      });
    }
    setState(() {
      FocusScope.of(context).unfocus();
    });

    // Format the DateTime object as needed
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayExpenseData(
      String category) async {
    try {
      // Fetch income documents from Firebase based on the selected category
      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('expenses')
              .where('category', isEqualTo: category)
              .get();

      // Extract data from documents
      List<Map<String, dynamic>> expenseData = expenseSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Sort the data by date
      expenseData.sort((a, b) {
        DateTime dateA = (a['date'] as Timestamp).toDate();
        DateTime dateB = (b['date'] as Timestamp).toDate();
        return dateB.compareTo(
            dateA); // Use dateB.compareTo(dateA) for descending order
      });

      // Update the expenseList
      expenseList = expenseData.map((expense) {
        return {'id': expense['id'], ...expense};
      }).toList();

      return expenseData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayExpenseDatabydate(
      String category) async {
    try {
      // Convert formatted date string to DateTime
      DateTime selectedDateTime =
          DateFormat('MMMM d, yyyy').parse(formattedDateString);

      QuerySnapshot<Map<String, dynamic>> expenseSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('expenses')
              .where('category', isEqualTo: category)
              .get();

      expenseList = expenseSnapshot.docs
          .where((doc) {
            DateTime expenseDate = (doc['date'] as Timestamp).toDate();
            DateTime expenseDateWithoutTime =
                DateTime(expenseDate.year, expenseDate.month, expenseDate.day);
            DateTime selectedDateWithoutTime = DateTime(selectedDateTime.year,
                selectedDateTime.month, selectedDateTime.day);
            return expenseDateWithoutTime
                .isAtSameMomentAs(selectedDateWithoutTime);
          })
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
      // If you also need the unfiltered data, you can use the following
      List<Map<String, dynamic>> expenseData = expenseSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      return expenseData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }
}

class CategoryList extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onCategorySelected;

  CategoryList({required this.categories, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.045.sh,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Call the onCategorySelected callback when a category is selected
                onCategorySelected(categories[index]);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categories[index],
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  Icon(incomeCategoryIcons[categories[index]],
                      color: Colors.black, size: 16.0.sp),
                ],
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            ),
          );
        },
      ),
    );
  }

  // Map of category icons
  final Map<String, IconData> incomeCategoryIcons = {
    'Groceries': Icons.shopping_cart,
    'Utilities': Icons.settings,
    'Transportation': Icons.directions_car,
    'Healthcare': Icons.local_hospital,
    'Entertainment': Icons.movie,
    'Dining Out': Icons.restaurant,
    'Shopping': Icons.shopping_bag,
    'Home Maintenance': Icons.home_repair_service,
    'Travel': Icons.airplane_ticket,
    'Miscellaneous': Icons.category,
    'Education': Icons.book,
  };
}
