import 'dart:async';
import 'dart:io';

import 'package:eco_dialer/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _themeData = Theme.of(context);
    var homePageProvider = Provider.of<HomePageProvider>(context);
    String serviceProvider = homePageProvider.serviceProvider;
    String selectedCategory = homePageProvider.selectedCategory;
    List numbers = homePageProvider.numbers[serviceProvider]![
        selectedCategory]!; //list of numbers depends on the selected service provider and selected category

    return ListView.builder(
      itemCount: numbers.length,
      physics: BouncingScrollPhysics(),
      // itemExtent: 2,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Card(
                color: Colors.transparent,
                child: ListTile(
                  title: Text(
                    numbers[index]['action']!,
                    style: _themeData.textTheme.headline2,
                  ),
                  subtitle: Text(numbers[index]['number']!,
                      style: _themeData.textTheme.headline3),
                  trailing: numbers[index]['cost'] != null
                      ? Text(
                          '${numbers[index]['cost']}',
                          style: GoogleFonts.montserrat(color: Colors.green),
                        )
                      : Icon(
                          Icons.call,
                          color: Color(0xFFCDCDCD),
                        ),
                  onTap: () {
                    _callNumber(
                        numbers[index]!['number'],
                        selectedCategory,
                        numbers[index]['cost'],
                        numbers[index]['action'],
                        context);
                  },
                )),
            SizedBox(height: 10)
          ],
        );
      },
    );
  }

  void _callNumber(String number, String selectedCategory, String? cost,
      String action, BuildContext context) async {
    if (selectedCategory == 'Combo Plans' || selectedCategory == 'Data Plans') {
      try {
        bool shouldContinue = await _confirmContinue(context, cost!, action);
        if (!shouldContinue) return;
        //Await confirmation from user on whether they would like auto-renew cancelled or not
        bool shouldCancel = await _confirmAutoCancel(context);

        _showToastMessage(
            'Do not Close the app until you Auto-renewal cancel confirmation');
        await FlutterPhoneDirectCaller.callNumber('*129*7*1#');

        Timer(Duration(seconds: 5), () async {
          if (shouldCancel) {
            await FlutterPhoneDirectCaller.callNumber('*120#');
          }
        });

        //*363*1#
      } catch (e) {
        print('Error ');
      }
    } else {
      FlutterPhoneDirectCaller.callNumber(number);
    }
    // print('Number Dialed');
    // await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<bool> _confirmAutoCancel(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            content: Text('Would you like to cancel Auto Renew?',
                style: Theme.of(context).textTheme.headline2),
            actions: [
              TextButton(
                child: Text(
                  'No',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(
                  'Yes',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }

  Future<bool> _confirmContinue(
      BuildContext context, String cost, String action) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).accentColor,
            content: Text(
                'Are you sure you want to purchase a $action plan for $cost?',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(height: 1.5)),
            actions: [
              TextButton(
                child: Text(
                  'No',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text(
                  'Yes',
                  style: Theme.of(context)
                      .textTheme
                      .headline3!
                      .copyWith(color: Colors.green),
                ),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          );
        });
  }

  void _showToastMessage(String message) => Fluttertoast.showToast(
      msg: message, fontSize: 13, gravity: ToastGravity.TOP);
}
