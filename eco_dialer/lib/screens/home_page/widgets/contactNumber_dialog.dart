import 'package:flutter/material.dart';

class ContactNumberDialog extends StatefulWidget {
  const ContactNumberDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ContactNumberDialogState createState() => _ContactNumberDialogState();
}

class _ContactNumberDialogState extends State<ContactNumberDialog> {
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.unfocus();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        'Please enter the receiver\'s number:',
        style: Theme.of(context).textTheme.headline2,
      ),
      content: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLength: 7,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterStyle: TextStyle(color: Colors.green),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor))),
      ),
      actions: [
        TextButton(
          child: Text(
            'Ok',
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: Colors.green),
          ),
          onPressed: () {
            String number = controller.text;
            Navigator.pop(context, number);
          },
        ),
      ],
    );
  }
}
