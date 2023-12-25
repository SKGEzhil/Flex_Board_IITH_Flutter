import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.onTextChanged});

  final Function(String) onTextChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(60)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.7),
              size: 23,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  widget.onTextChanged(value);
                },
                decoration: InputDecoration.collapsed(
                  hintText: "Search",
                  hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
