import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../transactionlistview/combinedlistview/combinedlistview.dart';

class IncomeCatPage extends StatefulWidget {
  String useruid = "";

  IncomeCatPage({required this.useruid});

  @override
  State<IncomeCatPage> createState() => _IncomeCatPageState();
}

class _IncomeCatPageState extends State<IncomeCatPage> {
  List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Business',
    'Investments',
    'Gifts',
    'Rent',
    'Side Hustle',
    'Refunds',
    'Other'
  ];
  String selectedCategory = 'Salary';
  List<Map<String, dynamic>> incomeList = [];
  DateTime? _selectedDate;
  String formattedDateString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF003366),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the category list
          CategoryList(
            categories: incomeCategories,
            onCategorySelected: (category) {
              // Update the selected category
              setState(() {
                selectedCategory = category;
              });

              // Fetch and display income data based on the selected category
              fetchAndDisplayIncomeData(category);
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
                    ? fetchAndDisplayIncomeDatabydate(selectedCategory)
                    : fetchAndDisplayIncomeData(selectedCategory),
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
                    // Display the income data in a ListView
                    return ListView.builder(
                      itemCount: incomeList.length + 1,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        if (index < incomeList!.length) {
                          return CombinedListItem(
                            data: incomeList[index],
                            documentId: incomeList[index]['id'],
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
      });
    }
    setState(() {
      FocusScope.of(context).unfocus();
    });

    // Format the DateTime object as needed
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayIncomeData(
      String category) async {
    try {
      // Fetch income documents from Firebase based on the selected category
      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('incomes')
              .where('category', isEqualTo: category)
              .get();

      // Extract data from documents
      List<Map<String, dynamic>> incomeData = incomeSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      // Sort the data by date in descending order
      incomeData.sort((a, b) {
        DateTime dateA = (a['date'] as Timestamp).toDate();
        DateTime dateB = (b['date'] as Timestamp).toDate();
        return dateB.compareTo(
            dateA); // Use dateB.compareTo(dateA) for descending order
      });

      // Update the incomeList
      incomeList = incomeData.map((income) {
        return {'id': income['id'], ...income};
      }).toList();

      return incomeData;
    } catch (e) {
      print('Error fetching income data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAndDisplayIncomeDatabydate(
      String category) async {
    try {
      // Convert formatted date string to DateTime
      DateTime selectedDateTime =
          DateFormat('MMMM d, yyyy').parse(formattedDateString);

      QuerySnapshot<Map<String, dynamic>> incomeSnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .doc(widget.useruid)
              .collection('incomes')
              .where('category', isEqualTo: category)
              .get();

      incomeList = incomeSnapshot.docs
          .where((doc) {
            DateTime incomeDate = (doc['date'] as Timestamp).toDate();
            DateTime incomeDateWithoutTime =
                DateTime(incomeDate.year, incomeDate.month, incomeDate.day);
            DateTime selectedDateWithoutTime = DateTime(selectedDateTime.year,
                selectedDateTime.month, selectedDateTime.day);
            return incomeDateWithoutTime
                .isAtSameMomentAs(selectedDateWithoutTime);
          })
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
      // If you also need the unfiltered data, you can use the following
      List<Map<String, dynamic>> incomeData = incomeSnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      return incomeData;
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
    'Salary': Icons.attach_money,
    'Freelance': Icons.work,
    'Business': Icons.business,
    'Investments': Icons.trending_up,
    'Gifts': Icons.card_giftcard,
    'Rent': Icons.home,
    'Side Hustle': Icons.star,
    'Refunds': Icons.refresh,
    'Other': Icons.category,
  };
}
