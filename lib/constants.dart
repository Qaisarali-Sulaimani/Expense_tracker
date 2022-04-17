// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

const kmycolor = Color(0xff7F3DFF);
const kbtncolor = Color(0xffEEE5FF);
const ktextcolor = Color(0xff91919F);
const kgreen = Color(0xff00A86B);
const kred = Color(0xffFD3C4A);
const kicon = Color(0xffC6C6C6);

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

class MyButton extends StatelessWidget {
  final String text;
  final Color mycolor;
  final Color mytextcolor;
  final Function() onpress;
  BuildContext? context;

  MyButton({
    required this.text,
    required this.mycolor,
    required this.mytextcolor,
    required this.onpress,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        elevation: 1.0,
        color: mycolor,
        borderRadius: BorderRadius.circular(18.0),
        child: MaterialButton(
          onPressed: onpress,
          minWidth: double.infinity,
          height: 52.0,
          child: Text(
            text,
            style: TextStyle(
              color: mytextcolor,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class MyInputField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboard;
  final bool protect;
  final TextEditingController? controller;
  int? lines = 1;
  MyInputField(
      {required this.hintText,
      required this.keyboard,
      required this.controller,
      this.protect = false,
      Key? key})
      : super(key: key);

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TextField(
        cursorColor: kmycolor,
        cursorHeight: 25,
        controller: widget.controller,
        keyboardType: widget.keyboard,
        obscureText: (widget.protect && !show),
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xff91919F),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(width: 2, color: kmycolor),
          ),
          suffix: widget.protect
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      show = !show;
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: Color(0xff91919F),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTile) {
          final value = options[optionTile];
          return MyButton(
            text: optionTile,
            mycolor: kmycolor,
            mytextcolor: Colors.white,
            onpress: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            context: context,
          );
        }).toList(),
      );
    },
  );
}

Future<void> showErrorDialog({
  required BuildContext context,
  required String text,
}) {
  return showGenericDialog(
    context: context,
    title: "An Error Occured",
    content: text,
    optionBuilder: () {
      return {
        'OK': null,
      };
    },
  );
}
