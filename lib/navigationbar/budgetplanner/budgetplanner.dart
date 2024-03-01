import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'alertbox.dart';
import 'editalertbox.dart';

class BudgetPlanner extends StatefulWidget {
  String useruid = "";
  BudgetPlanner({super.key, required this.useruid});

  @override
  State<BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner> {
  late DateTime selectedDate;
  int monthCount = 0;
  int totalBudgetAmount = 0;
  int totalSpentAmount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDate = DateTime.now();
    getTotalBudget();
    getTotalSpent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003366),
      body: Center(
        child: Column(
          children: [
            // Box for Month Selection and Showing Total Budget and Spent
            Container(
              height: 0.11.sh,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.orange.shade300,
                  border:
                      const Border(bottom: BorderSide(color: Colors.white))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: monthCount == 3
                            ? null
                            : () {
                                // Navigate to the previous month
                                setState(() {
                                  selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month - 1,
                                  );
                                  monthCount++;
                                  totalBudgetAmount = 0;
                                  totalSpentAmount = 0;
                                });
                                getTotalBudget();
                                getTotalSpent();
                              },
                        icon: Icon(
                          Icons.arrow_left,
                          size: 30,
                          color:
                              monthCount == 3 ? Colors.black54 : Colors.black,
                        ),
                      ),
                      Text(
                        '${getMonthName(selectedDate.month)}, ${selectedDate.year}',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontFamily: GoogleFonts.lexend().fontFamily),
                      ),
                      IconButton(
                        onPressed: getMonthName(selectedDate.month) ==
                                getMonthName(DateTime.now().month)
                            ? null
                            : () {
                                // Navigate to the next month
                                setState(() {
                                  selectedDate = DateTime(
                                    selectedDate.year,
                                    selectedDate.month + 1,
                                  );
                                  monthCount--;
                                  totalBudgetAmount = 0;
                                  totalSpentAmount = 0;
                                });
                                getTotalBudget();
                                getTotalSpent();
                              },
                        icon: Icon(
                          Icons.arrow_right,
                          size: 30,
                          color: getMonthName(selectedDate.month) ==
                                  getMonthName(DateTime.now().month)
                              ? Colors.black54
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("TOTAL BUDGET",
                              style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.akshar().fontFamily,
                                  letterSpacing: 2,
                                  color: Colors.black)),
                          Text(
                            "Rs,${totalBudgetAmount}",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: GoogleFonts.akshar().fontFamily,
                                color: Colors.black87),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("TOTAL SPENT",
                              style: TextStyle(
                                  fontSize: 15.0.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.akshar().fontFamily,
                                  letterSpacing: 2,
                                  color: Colors.black)),
                          Text(
                            "Rs,${totalSpentAmount}",
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontFamily: GoogleFonts.akshar().fontFamily),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Budget Categories : Month, Year
            SizedBox(
              height: 0.03.sh,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0.04.sw),
                  child: Text(
                      "Budgeted categories: ${getMonthName(selectedDate.month)}, ${selectedDate.year}",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: GoogleFonts.b612().fontFamily,
                          color: Colors.white70)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.02.sw, right: 0.02.sw),
              child: Divider(color: Colors.white54, height: 0.01.sw),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('budget')
                    .doc(widget.useruid)
                    .collection(getMonthName(selectedDate.month))
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  if (documents.isEmpty) {
                    return Center(
                      child: Text(
                          'No budgets available for ${getMonthName(selectedDate.month)} ${selectedDate.year}',
                          style: TextStyle(color: Colors.white)),
                    );
                  }
                  // Create a list of Future<int> for each category
                  List<Future<int>> spentAmountFutures =
                      documents.map((document) {
                    var category = document['category'];
                    return getSpentAmount(
                        widget.useruid, category, document.id);
                  }).toList();
                  return FutureBuilder<List<int>>(
                    future: Future.wait(spentAmountFutures),
                    builder: (context, snapshot) {
                      List<int> spentAmounts =
                          snapshot.data ?? List.filled(documents.length, 0);

                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var document = documents[index];
                          var category = document['category'];
                          var amount = document['amount'];
                          int spentAmount = spentAmounts[index];
                          double percentageSpent =
                              (spentAmount / amount).clamp(0.0, 1.0);
                          return Container(
                            width: 0.5.sw,
                            height: 0.15.sh,
                            margin: EdgeInsets.only(
                                left: 0.015.sw,
                                right: 0.020.sw,
                                bottom: 0.005.sw,
                                top: 0.01.sw),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      getMonthName(selectedDate.month) ==
                                              getMonthName(DateTime.now().month)
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      incomeCategoryIcons['${category}'],
                                      size: 20.0.sp,
                                      color: Colors.yellow,
                                    ),
                                    getMonthName(selectedDate.month) ==
                                            getMonthName(DateTime.now().month)
                                        ? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text("Delete Budget"),
                                                    content: Text(
                                                        "Are you sure you want to delete this budget?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the dialog
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          // Delete the budget and close the dialog
                                                          await deleteBudget(
                                                              widget.useruid,
                                                              document.id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Delete"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 18.0.sp,
                                            ))
                                        : SizedBox.shrink(),
                                    getMonthName(selectedDate.month) ==
                                            getMonthName(DateTime.now().month)
                                        ? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return EditBudget(
                                                      Category: category,
                                                      iconData:
                                                          incomeCategoryIcons[
                                                              '${category}'],
                                                      useruid: widget.useruid,
                                                      docid: document.id);
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 18.0.sp,
                                            ))
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: getMonthName(selectedDate.month) ==
                                              getMonthName(DateTime.now().month)
                                          ? 0.02.sw
                                          : 0.04.sw),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${category}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("limit: ${amount}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.0.sp)),
                                      Text("Spent: ${spentAmount}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.0.sp)),
                                      Text("Remaining: ${amount - spentAmount}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13.0.sp)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.01.sw),
                                        child: SizedBox(
                                          width: 0.8.sw,
                                          height: 0.01.sh,
                                          child: LinearProgressIndicator(
                                            value: percentageSpent,
                                            backgroundColor: Colors.grey,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.red),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      getMonthName(selectedDate.month) ==
                                          getMonthName(DateTime.now().month)
                                          ?SizedBox.shrink():Text("*Budget expired",style: TextStyle(color: Colors.yellow,fontSize: 12.0.sp),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            //Not budgeted yet text with set button
            getMonthName(selectedDate.month) ==
                    getMonthName(DateTime.now().month)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0.04.sw),
                        child: Text("Not Budgeted this month",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: GoogleFonts.b612().fontFamily,
                                color: Colors.white70)),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            getMonthName(selectedDate.month) ==
                    getMonthName(DateTime.now().month)
                ? Padding(
                    padding: EdgeInsets.only(left: 0.02.sw, right: 0.02.sw),
                    child: Divider(color: Colors.white54, height: 0.01.sw),
                  )
                : SizedBox.shrink(),
            if (getMonthName(selectedDate.month) ==
                getMonthName(DateTime.now().month))
              Expanded(
                child: FutureBuilder<List<String>>(
                  future: getCategoriesWithNoBudget(widget.useruid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Padding(
                        padding: EdgeInsets.only(left: 0.3.sw, right: 0.3.sw),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Loading..",
                              style: TextStyle(color: Colors.white),
                            ),
                            LinearProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )); // or another loading indicator
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<String> categoriesWithNoBudget = snapshot.data ?? [];

                    return ListView.builder(
                      itemCount: categoriesWithNoBudget.length,
                      itemBuilder: (context, index) {
                        final category = categoriesWithNoBudget[index];
                        final icon = incomeCategoryIcons[category];

                        return ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.black87,
                              child: Icon(icon, color: Colors.yellow.shade300)),
                          title: Text(category,
                              style: const TextStyle(color: Colors.white)),
                          trailing: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddingBudget(
                                      Category: category,
                                      iconData: icon,
                                      useruid: widget.useruid);
                                },
                              );
                            },
                            child: const Text('Set Budget',
                                style: TextStyle(color: Colors.black)),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
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
  // Getting not set budget list
  Future<List<String>> getCategoriesWithNoBudget(String userUid) async {
    List<String> categoriesWithNoBudget = [];

    // Fetch all budgets for the current month
    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
        .collection('budget')
        .doc(userUid)
        .collection(getMonthName(DateTime.now().month))
        .get();

    List<String> allCategories = incomeCategoryIcons.keys.toList();

    // Filter categories that don't have a budget
    for (String category in allCategories) {
      bool hasBudget =
          querySnapshot.docs.any((doc) => doc['category'] == category);
      if (!hasBudget) {
        categoriesWithNoBudget.add(category);
      }
    }

    return categoriesWithNoBudget;
  }

  Future<bool> checkIfCategoryHasBudget(String category, String userUid) async {
    // Reference to the Firestore collection
    CollectionReference budgetCollection = FirebaseFirestore.instance
        .collection('budget')
        .doc(userUid)
        .collection(getMonthName(DateTime.now().month));

    // Query to check if a document with the specified category exists
    QuerySnapshot<Object?> querySnapshot =
        await budgetCollection.where('category', isEqualTo: category).get();

    // Return true if there are documents, indicating that a budget exists
    return querySnapshot.docs.isNotEmpty;
  }

  // getting total budget and total spent list
  Future<void> getTotalBudget() async {
    int totalBudgetamount = 0;

    CollectionReference budgetCollection = FirebaseFirestore.instance
        .collection('budget')
        .doc(widget.useruid)
        .collection(getMonthName(selectedDate.month));

    QuerySnapshot<Object?> querySnapshot = await budgetCollection.get();

    querySnapshot.docs.forEach((DocumentSnapshot<Object?> document) {
      int amount = document['amount'] ?? 0;
      totalBudgetamount += amount;
    });
    setState(() {
      totalBudgetAmount = totalBudgetamount;
    });
  }

  // getting spent amount from expense collection
  Future<int> getSpentAmount(
      String userUid, String category, String docid) async {
    int spentAmount = 0;
    QuerySnapshot<Object?> querySnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userUid)
        .collection('expenses')
        .where('category', isEqualTo: category)
        .get();

    for (QueryDocumentSnapshot<Object?> document in querySnapshot.docs) {
      DateTime expenseDate = (document['date'] as Timestamp).toDate();

      // Check if the expense date is within the selected month
      if (expenseDate.month == selectedDate.month &&
          expenseDate.year == DateTime.now().year) {
        spentAmount += document['amount'] as int;
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('budget')
          .doc(widget.useruid)
          .collection(getMonthName(selectedDate.month))
          .doc(docid)
          .update({
        'spent': spentAmount,
      });
    } catch (e) {
      print('Error setting budget: $e');
    }
    return spentAmount;
  }

//function for delete
  Future<void> deleteBudget(String userUid, String documentId) async {
    await FirebaseFirestore.instance
        .collection('budget')
        .doc(userUid)
        .collection(getMonthName(selectedDate.month))
        .doc(documentId)
        .delete();
  }

  Future<void> getTotalSpent() async {
    int totalSpentamount = 0;
    CollectionReference budgetCollection = FirebaseFirestore.instance
        .collection('budget')
        .doc(widget.useruid)
        .collection(getMonthName(selectedDate.month));

    QuerySnapshot<Object?> querySnapshot = await budgetCollection.get();

    querySnapshot.docs.forEach((DocumentSnapshot<Object?> document) {
      int amount = document['spent'] ?? 0;
      totalSpentamount += amount;
    });
    setState(() {
      totalSpentAmount = totalSpentamount;
    });
  }

  Future<void> keepLastThreeMonths(String userUid) async {
    // If month is negative, wrap around to the previous year
    String monthToDelete = getMonthName(DateTime.now().month - 4);
    CollectionReference<Map<String, dynamic>> budgetCollection =
    FirebaseFirestore.instance.collection('budget').doc(userUid).collection(monthToDelete);

    // Get all documents within the collection
    QuerySnapshot<Map<String, dynamic>> documentsSnapshot = await budgetCollection.get();

    // Delete the entire subcollection
    for (QueryDocumentSnapshot<Map<String, dynamic>> document in documentsSnapshot.docs) {
      await budgetCollection.doc(document.id).delete();
    }
  }
  String getMonthName(int month) {
    if (month >= 1 && month <= 12) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
    else{
      return getMonthName(month + 12);
    }
  }


}
