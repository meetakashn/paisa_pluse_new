import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paisa_pluse_new/incomewidget/incomecategoryselect.dart';

import '../homepage/homepage.dart';
import '../utils/routes.dart';

class EditIncomeTransactionDialog extends StatefulWidget {
  final String useruid;
  final Map<String, dynamic> transactionData;
  final String documentId;

  EditIncomeTransactionDialog({
    required this.useruid,
    required this.transactionData,
    required this.documentId,
  });

  @override
  _EditIncomeTransactionDialogState createState() =>
      _EditIncomeTransactionDialogState();
}

class _EditIncomeTransactionDialogState
    extends State<EditIncomeTransactionDialog> {
  String selectedCategory = 'Select Category';
  IconData selectedCategoryIcon = Icons.category; // Default icon
  String selectedOption = 'cash';
  String paymentmethod = "cash";
  int addincome = 0;
  String totalIncomeString = "";
  String noteshow = "";
  DateTime? _selectedDate;
  TextEditingController _totalincome = TextEditingController();
  TextEditingController _noteincome = TextEditingController();

  // for verification
  int currentincome = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    populateFields();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF002447),
      title: Center(
        child: Text(
          "Add Income",
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
                  controller: _totalincome,
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
                      addincome = int.parse(value);
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
                        color: Colors.green),
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
                            controller: _noteincome,
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
                    if (_totalincome.text.isEmpty) {
                      _amountemptymsg(context);
                    } else if (_selectedDate == null) {
                      _dateisempty(context);
                    } else if (_noteincome.text.isEmpty) {
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

                      // Call the function to update the details
                      addeditedincome().then((_) {
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
                    "Update Income",
                    style: TextStyle(
                        color: Colors.green,
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
    _totalincome.text = widget.transactionData['amount'].toString();
    currentincome = widget.transactionData['amount'];
    addincome = widget.transactionData['amount'];
    _noteincome.text = noteshow = widget.transactionData['note'];
    _selectedDate = (widget.transactionData['date'] as Timestamp).toDate();
    selectedOption = widget.transactionData['paymentmethod'];
    selectedCategory = widget.transactionData['category'];
    selectedCategoryIcon = categoryIcons[selectedCategory]!;
    // Optionally, update the UI to reflect the changes
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
        return IncomeCategorySelectionDialog(
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

  Future<void> addeditedincome() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.useruid)
        .get();

    int currentTotalAmount = userDoc['totalamount'];
    int totalincome = userDoc['totalincome'];
    try {
      if (addincome > currentincome) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('incomes')
            .doc(widget.documentId)
            .update({
          'amount': addincome,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteincome.text,
          'type': 'income',
        });
        int Amount = currentTotalAmount + (addincome - currentincome);
        int income = totalincome + (addincome - currentincome);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .update({
          'totalamount': Amount,
          'totalincome': income,
        });
      } else if (addincome < currentincome) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('incomes')
            .doc(widget.documentId)
            .update({
          'amount': addincome,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteincome.text,
          'type': 'income',
        });
        int Amount = currentTotalAmount - (currentincome - addincome);
        int income = totalincome - (currentincome - addincome);
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .update({
          'totalamount': Amount,
          'totalincome': income,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(widget.useruid)
            .collection('incomes')
            .doc(widget.documentId)
            .update({
          'amount': addincome,
          'date': _selectedDate,
          'category': selectedCategory,
          'paymentmethod': selectedOption,
          'note': _noteincome.text,
          'type': 'income',
        });
      }
    } catch (e) {
      print('Error adding expense: $e');
    }
    setState(() {});
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
    'Salary': Icons.attach_money,
    'Freelance': Icons.work,
    'Business': Icons.business,
    'Investments': Icons.trending_up,
    'Gifts': Icons.card_giftcard,
    'Rent': Icons.home,
    'Side Hustle': Icons.star,
    'Refunds': Icons.refresh,
    'Other': Icons.category,
    'Initial Amount': Icons.account_balance,
  };
}
