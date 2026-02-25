import 'package:flutter/material.dart';

class FieldTitle extends StatelessWidget {
  final String caption;
  final String? help;
  final bool isRequired;

  const FieldTitle({
    super.key,
    required this.caption,
    this.help,
    required this.isRequired ,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [


             Padding(
              padding: EdgeInsets.only(right: isRequired ? 4:0),


               child: Text(
                 (isRequired && caption != "مشارکت مدنی") ? " * " : "",
                 style: TextStyle(
                   color: Colors.blue,
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

        ],
      ),
    );
  }
}
