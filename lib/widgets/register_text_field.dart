import 'package:flutter/material.dart';

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    super.key,
    required this.nameText,
    required this.hintText,
    required this.subText,
    required this.field,
  });

  /// Declarations
  final TextEditingController nameText;
  final String hintText;
  final String subText;
  final String field;

  Widget textFieldIcon() {
    switch (field) {
      case "name":
        return Image.asset(
          'assets/profile.png',
          width: 30,
          height: 30,
        );
      case "roll_no":
        return Image.asset(
          'assets/roll_no.png',
          width: 30,
          height: 30,
        );
      case "email":
        return Image.asset(
          'assets/email.png',
          width: 30,
          height: 30,
        );
      case "password":
        return Image.asset(
          'assets/password.png',
          width: 30,
          height: 30,
        );
      default:
        return Image.asset(
          'assets/profile.png',
          width: 30,
          height: 30,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subText,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontSize: 16),
            )),
        TextFormField(
          controller: nameText,
          cursorColor: Colors.deepOrange,
          obscureText: field == 'password' ? true : false,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.3),
              filled: true,
              hintText: hintText,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 0,
                    color: Colors.white.withOpacity(0)), //<-- SEE HERE
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    width: 0,
                    color: Colors.white.withOpacity(0)), //<-- SEE HERE
              ),
              prefixIcon:
              Padding(padding: const EdgeInsets.all(15), child: textFieldIcon())),
        ),
      ],
    );
  }
}
