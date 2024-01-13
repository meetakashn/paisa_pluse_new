import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/homepage/homepage.dart';
import 'package:paisa_pluse_new/utils/routes.dart';

import 'categoryselect.dart';

class EditExpenseTransactionDialog extends StatefulWidget {
  final String useruid;
  final Map<String, dynamic> transactionData;
  final String documentId;
  EditExpenseTransactionDialog({
    required this.useruid,
    required this.transactionData,
    required this.documentId,
  });

  @override
  State<EditExpenseTransactionDialog> createState() =>
      _EditExpenseTransactionDialogState();
}

class _EditExpenseTransactionDialogState
    extends State<EditExpenseTransactionDialog> {
  TextEditingController _totalexpense = TextEditingController();
  TextEditingController _noteexpense = TextEditingController();

  String selectedCategory = 'Select Category';
  IconData selectedCategoryIcon = Icons.category; // Default icon
  String selectedOption = 'cash';
  String paymentmethod = "cash";
  int addexpense = 0;
  String noteshow = "";
  DateTime? _selectedDate;

  // for verification
  int currentexpense = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateFields();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF003366),
      title: Center(
        child: Text(
          "Add Expense",
          style: TextStyle(
              fontFamily: GoogleFonts.akshar().fontFamily,
              letterSpacing: 2,
              fontSize: 18.0.sp,
              color: Colors.white),
        ),
      ),
      actions: [
        SizedBox(
          height: 0.4.sh,
          width: 1.0.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 0.6.sw,
                height: 0.061.sh,
                child: TextFormField(
                  style: TextStyle(
                      fontFamily: GoogleFonts.akshar().fontFamily,
                      color: Colors.white,
                      letterSpacing: 2),
                  cursorColor: Colors.white,
                  keyboardType: TextInputType.number,
                  controller: _totalexpense,
                  decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.currency_rupee,
                        size: 0.024.sh,
                        color: Colors.white,
                      ),
                      hintText: "Amount",
                      hintStyle: TextStyle(
                          fontFamily: GoogleFonts.akshar().fontFamily,
                          color: Colors.white70,
                          letterSpacing: 2),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                      )),
                  onChanged: (value) {
                    setState(() {
                      addexpense = int.parse(value);
                    });
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 0.25.sh,
                    width: 0.4.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 0.01.sh,
                        ),
                        SizedBox(
                          width: 0.35.sw,
                          height: 0.04.sh,
                          child: TextButton(
                            onPressed: () async {
                              setState(() {
                                FocusScope.of(context).unfocus();
                              });
                              await Future.delayed(
                                Duration(milliseconds: 50),
                                () {
                                  _showCategorySelectionDialog(context);
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white60,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  selectedCategoryIcon,
                                  size: 0.0155.sh,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 0.01.sw,
                                ),
                                Text(
                                  selectedCategory ?? 'Select Category',
                                  style: TextStyle(
                                      fontSize: 0.014.sh,
                                      color: Colors.black,
                                      fontFamily:
                                          GoogleFonts.akshar().fontFamily),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 0.37.sw,
                          height: 0.04.sh,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white60),
                          child: TextButton(
                            onPressed: () {
                              _selectDateTime(context);
                              FocusScope.of(context).unfocus();
                            },
                            child: Text(
                              '${_selectedDate != null ? DateFormat('on yyyy-MM-dd @HH:mm').format(_selectedDate!) : "Select the date and time"}',
                              style: TextStyle(
                                fontSize:
                                    _selectedDate != null ? 11.0.sp : 10.0.sp,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        Container(
                          width: 0.35.sw,
                          height: 0.04.sh,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white60),
                          child: Padding(
                            padding: EdgeInsets.only(left: 0.041.sw),
                            child: DropdownButton<String>(
                              alignment: Alignment.center,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.black45,
                                size: 20.0.sp,
                              ),
                              underline: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0XFFff9f00),
                                      Color(0XFFff7f00)
                                    ],
                                  ),
                                ),
                              ),
                              value: selectedOption,
                              items: <String>[
                                'cash',
                                'online payment',
                                'credit - debit'
                              ]
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      alignment: Alignment.center,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0.sp),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedOption = newValue!;
                                  // Perform actions based on the selected option
                                  switch (selectedOption) {
                                    case 'cash':
                                      paymentmethod = "cash";
                                      break;
                                    case 'online payment':
                                      paymentmethod = "online payment";
                                      break;
                                    case 'credit - debit':
                                      paymentmethod = "credit - debit";
                                      break;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0.01.sh,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 0.01.sw,
                  ),
                  Container(
                    height: 0.25.sh,
                    width: 0.25.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white60),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 0.25.sw,
                          height: 0.1.sh,
                          child: TextFormField(
                            controller: _noteexpense,
                            decoration: InputDecoration(
                                hintText: "note",
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            onChanged: (value) {
                              setState(() {
                                noteshow = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 0.01.sw, right: 0.01.sw),
                            child: Text("$noteshow",
                                style: TextStyle(
                                    fontFamily: GoogleFonts.akshar().fontFamily,
                                    letterSpacing: 1),
                                textAlign: TextAlign.start),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 0.05.sh,
                width: 0.8.sw,
                child: ElevatedButton(
                  onPressed: () {
                    if (_totalexpense.text.isEmpty) {
                      _amountemptymsg(context);
                    } else if (_selectedDate == null) {
                      _dateisempty(context);
                    } else if (_noteexpense.text.isEmpty) {
                      _noteisempty(context);
                    } else {
                      // Show a circular progress indicator during the update
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      addeditedexpense().then((_) {
                        setState(() {
                          HomePage.page = 1;
                          HomePage.initialpageindex = 1;
                          FocusScope.of(context).unfocus();
                        });
                        Navigator.pushReplacementNamed(
                            context, MyRoutes.homepage);
                      }).catchError((error) {
                        setState(() {
                          HomePage.page = 1;
                          HomePage.initialpageindex = 1;
                          FocusScope.of(context).unfocus();
                        });
                        Navigator.pushReplacementNamed(
                            context, MyRoutes.homepage);

                        // You can display an error message if needed
                        print('Error updating details: $error');
                      });
                    }
                  },
                  child: Text(
                    "Update Expense",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: GoogleFonts.akshar().fontFamily,
                        letterSpacing: 2,
                        fontSize: 15.0.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void populateFields() {
    // Set values from transactionData to the controllers and variables
    _totalexpense.text = widget.transactionData['amount'].toString();
    currentexpense = widget.transactionData['amount'];
    addexpense = widget.transactionData['amount'];
    _noteexpense.text = noteshow = widget.transactionData['note'];
    _selectedDate = (widget.transactionData['date'] as Timestamp).toDate();
    selectedOption = widget.transactionData['paymentmethod'];
    selectedCategory = widget.transactionData['category'];
    selectedCategoryIcon = categoryIcons[selectedCategory]!;
    // Optionally, update the UI to reflect the changes
    setState(() {});
  }

  Future<void> addeditedexpense() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.useruid)
        .get();

    int currentTotalAmount = userDoc['totalamount'];
    int totalexpense = userDoc['totalexpense'];
    try {
      if (addexpense > currentexpense) {
        print("1");
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('expenses')
            .doc(widget.documentId)
            .update({
          'amount': addexpense,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteexpense.text,
          'type': 'expense',
        });
        int Amount = currentTotalAmount - (addexpense - currentexpense);
        int expense = totalexpense + (addexpense - currentexpense);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .update({
          'totalamount': Amount,
          'totalexpense': expense,
        });
      } else if (addexpense < currentexpense) {
        print("2");
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('expenses')
            .doc(widget.documentId)
            .update({
          'amount': addexpense,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteexpense.text,
          'type': 'expense',
        });
        int Amount = currentTotalAmount + (currentexpense - addexpense);
        int expense = totalexpense - (currentexpense - addexpense);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .update({
          'totalamount': Amount,
          'totalexpense': expense,
        });
      } else if (addexpense == currentexpense) {
        print("3");
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('expenses')
            .doc(widget.documentId)
            .update({
          'amount': currentexpense,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteexpense.text,
          'type': 'expense',
        });
      }
    } catch (e) {
      print('Error adding expense: $e');
    }
    setState(() {});
  }

  void _amountemptymsg(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Amount should not be empty"),
      ),
    );
  }

  void _dateisempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("date & time should not be empty"),
      ),
    );
  }

  void _noteisempty(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("note should not be empty"),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine pickedDate and pickedTime into a single DateTime
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDateTime;
        });
      }
    }
  }

  Future<void> _showCategorySelectionDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return CategorySelectionDialog(
            selectedCategoryIcon: selectedCategoryIcon);
      },
    );

    if (result != null) {
      setState(() {
        selectedCategory = result['category'];
        selectedCategoryIcon = result['icon'];
        FocusScope.of(context).unfocus();
      });
    }
  }

  final Map<String, IconData> categoryIcons = {
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
