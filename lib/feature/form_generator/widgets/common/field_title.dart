


import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {
  final String caption;
  final String? help;
  final bool isRequired;

  const FieldTitle({
    super.key,
    required this.caption,
    this.help,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (isRequired)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Text(
                '*',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          Text(
            caption,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),

          if (help != null && help!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Tooltip(
                message: help!,

                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.help_outline,
                      size: 20,
                      color: Colors.grey[500],
                    ),
                  ),
                )

              ),


        ],
      ),
    );
  }
}