import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class CustomTxtField extends StatefulWidget {
  const CustomTxtField({
    Key? key,
    required this.hint,
    required this.ispassword,
    required this.controller,
  }) : super(key: key);

  final String hint;
  final bool ispassword;
  final TextEditingController controller;

  @override
  State<CustomTxtField> createState() => _CustomTxtFieldState();
}

class _CustomTxtFieldState extends State<CustomTxtField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.ispassword;
    super.initState();
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextFormField(
        controller: widget.controller,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'Please fill ${widget.hint}';
          }
          return null;
        },
        cursorHeight: 20,
        obscureText: widget.ispassword ? _obscureText : false,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          suffixIcon: widget.ispassword
              ? GestureDetector(
            onTap: _togglePassword,
            child: Icon(
              _obscureText
                  ? CupertinoIcons.eye_fill // 👁️ si masqué
                  : CupertinoIcons.eye_slash_fill, // 👁️‍🗨️ si visible
              color: Colors.black,
            ),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.black, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(color: Colors.black, width: 3),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.black),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
