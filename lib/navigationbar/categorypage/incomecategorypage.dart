import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../transactionlistview/combinedlistview/combinedlistview.dart';


class IncomeCatPage extends StatefulWidget {
  String useruid="";
  IncomeCatPage({required this.useruid});

  @override
  State<IncomeCatPage> createState() => _IncomeCatPageState();
}

class _IncomeCatPageState extends State<IncomeCatPage> {
  List<String> incomeCategories = ['Salary', 'Freelance', 'Business', 'Investments','Gifts', 'Rent', 'Side Hustle', 'Refunds','Other'];
  String selectedCategory = 'Salary';
  List<Map<String, dynamic>> incomeList = [];
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
          // Display the income data in a ListView
          Expanded(
            child: Container(
              color: const Color(0xFF003366),
              child: FutureBuilder(
                future: fetchAndDisplayIncomeData(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.white,));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.white),));
                  }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No recent transactions.',style: TextStyle(color: Colors.white)));
                  }
                  else {
                    // Display the income data in a ListView
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // Customize the ListTile based on your data structure
                        return CombinedListItem(
                          data: snapshot.data![index],
                          documentId: snapshot.data![index]['id'],
                          useruid: widget.useruid,
                        );
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

  Future<List<Map<String, dynamic>>> fetchAndDisplayIncomeData(String category) async {
    try {
      // Fetch income documents from Firebase based on the selected category
      QuerySnapshot<Map<String, dynamic>> incomeSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.useruid)
          .collection('incomes')
          .where('category', isEqualTo: category)
          .get();
      incomeList = incomeSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data()
        }; // Add 'id' field to store document ID
      }).toList();
      // Extract data from documents
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
  CategoryList({required this.categories,required this.onCategorySelected});

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
                Text(categories[index],style: TextStyle(color: Colors.black),),
                SizedBox(width: 0.01.sw,),
                Icon(incomeCategoryIcons[categories[index]],color: Colors.black,size: 16.0.sp),
              ],),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow
              ),
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
