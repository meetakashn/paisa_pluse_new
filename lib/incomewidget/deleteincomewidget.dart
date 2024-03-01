import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../homepage/homepage.dart';
import '../utils/routes.dart';

class DeleteIncomeExpense extends StatefulWidget {
  final String useruid;
  final Map<String, dynamic> transactionData;
  final String documentId;

  DeleteIncomeExpense({
    required this.useruid,
    required this.transactionData,
    required this.documentId,
  });

  @override
  State<DeleteIncomeExpense> createState() => _DeleteIncomeExpenseState();
}

class _DeleteIncomeExpenseState extends State<DeleteIncomeExpense> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _isDeleting
        ? const AlertDialog(
            backgroundColor: Colors.transparent,
            actions: [
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          )
        : AlertDialog(
            title: const Text("Confirm Deletion"),
            content: Text(
                "Are you sure you want to delete the ${widget.transactionData['type']} entry for ${widget.transactionData['category']} with an amount of ${widget.transactionData['amount']}?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    HomePage.page = 1;
                    HomePage.initialpageindex = 1;
                    FocusScope.of(context).unfocus();
                  });
                  Navigator.pushReplacementNamed(
                      context, MyRoutes.homepage); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isDeleting = true; // Set to true when deletion starts
                  });

                  if (widget.transactionData['type'] == 'income') {
                    try {
                      await deleteIncomeTransaction(
                          widget.useruid, widget.documentId);
                      setState(() {
                        HomePage.page = 1;
                        HomePage.initialpageindex = 1;
                        FocusScope.of(context).unfocus();
                      });
                      Navigator.pushReplacementNamed(
                          context, MyRoutes.homepage);
                    } catch (error) {
                      // Handle error
                      print('Error deleting details: $error');
                    } finally {
                      setState(() {
                        _isDeleting =
                            false; // Set back to false after deletion completes
                      });
                    }
                  } else {
                    try {
                      await deleteExpenseTransaction(
                          widget.useruid, widget.documentId);
                      setState(() {
                        HomePage.page = 1;
                        HomePage.initialpageindex = 1;
                        FocusScope.of(context).unfocus();
                      });
                      Navigator.pushReplacementNamed(
                          context, MyRoutes.homepage);
                    } catch (error) {
                      // Handle error
                      print('Error deleting details: $error');
                    } finally {
                      setState(() {
                        _isDeleting =
                            false; // Set back to false after deletion completes
                      });
                    }
                  }
                },
                child: const Text("Delete"),
              ),
            ],
          );
  }

  Future<void> deleteIncomeTransaction(
      String userUid, String documentId) async {
    try {
      // Get a reference to the user's income transaction document
      DocumentReference incomeTransactionRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('incomes')
          .doc(documentId);

      // Get the current amount and date of the income transaction
      DocumentSnapshot incomeTransactionSnapshot =
          await incomeTransactionRef.get();
      int incomeAmount = incomeTransactionSnapshot['amount'];

      // Get a reference to the user's main document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('user').doc(userUid);

      // Update the total amount and total income in the user's main document
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        int currentTotalAmount =
            (await transaction.get(userDocRef))['totalamount'];
        int totalIncome = (await transaction.get(userDocRef))['totalincome'];

        // Update the total amount and total income
        transaction.update(userDocRef, {
          'totalamount': currentTotalAmount - incomeAmount,
          'totalincome': totalIncome - incomeAmount,
        });

        // Delete the income transaction document
        transaction.delete(incomeTransactionRef);
      });

      print('Income transaction deleted successfully!');
    } catch (e) {
      print('Error deleting income transaction: $e');
      // Handle errors as needed
    }
  }

  Future<void> deleteExpenseTransaction(
      String userUid, String documentId) async {
    try {
      // Get a reference to the user's income transaction document
      DocumentReference expenseTransactionRef = FirebaseFirestore.instance
          .collection('user')
          .doc(userUid)
          .collection('expenses')
          .doc(documentId);

      // Get the current amount and date of the income transaction
      DocumentSnapshot expenseTransactionSnapshot =
          await expenseTransactionRef.get();
      int expensesAmount = expenseTransactionSnapshot['amount'];

      // Get a reference to the user's main document
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('user').doc(userUid);

      // Update the total amount and total income in the user's main document
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        int currentTotalAmount =
            (await transaction.get(userDocRef))['totalamount'];
        int totalExpense = (await transaction.get(userDocRef))['totalexpense'];

        // Update the total amount and total income
        transaction.update(userDocRef, {
          'totalamount': currentTotalAmount + expensesAmount,
          'totalexpense': totalExpense - expensesAmount,
        });

        // Delete the income transaction document
        transaction.delete(expenseTransactionRef);
      });

      print('Income transaction deleted successfully!');
    } catch (e) {
      print('Error deleting income transaction: $e');
      // Handle errors as needed
    }
  }
}

class CustomLoadingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
