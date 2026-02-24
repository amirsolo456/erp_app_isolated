

import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(child:
      Column(
        children: [
          Text('data'),

          buildCustomDivider(),
          Text('data')

        ],
      )
      ),
    );
  }
}


Widget buildCustomDivider({
  double thickness = 0.3,
  double height = 16,
  Color color = Colors.grey,
  double indent = 40,
  double endIndent = 16,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Divider(
      thickness: thickness,
      height: height,
      color: color,
      indent: indent,
      endIndent: endIndent,
    ),
  );
}



// import 'dart:io';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UserInfo extends StatefulWidget {
//   const UserInfo({super.key});
//
//   @override
//   State<UserInfo> createState() => _UserInfoState();
// }
//
// class _UserInfoState extends State<UserInfo> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//
//   File? _profileImage;
//
//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//
//     final XFile? image =
//     await picker.pickImage(source: ImageSource.gallery);
//
//     if (image != null) {
//       setState(() {
//         _profileImage = File(image.path);
//       });
//     }
//   }
//
//   void _save() {
//     if (_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("اطلاعات ذخیره شد")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: DottedBorder(
//             borderType: BorderType.RRect,
//             radius: const Radius.circular(16),
//             dashPattern: const [6, 4],
//             color: Colors.grey,
//             strokeWidth: 1.5,
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//
//                     /// پروفایل
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.grey.shade300,
//                         backgroundImage: _profileImage != null
//                             ? FileImage(_profileImage!)
//                             : null,
//                         child: _profileImage == null
//                             ? const Icon(Icons.camera_alt, size: 30)
//                             : null,
//                       ),
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     /// نام
//                     TextFormField(
//                       controller: _firstNameController,
//                       decoration: const InputDecoration(
//                         labelText: "نام",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "نام الزامی است";
//                         }
//                         return null;
//                       },
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     /// نام خانوادگی
//                     TextFormField(
//                       controller: _lastNameController,
//                       decoration: const InputDecoration(
//                         labelText: "نام خانوادگی",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "نام خانوادگی الزامی است";
//                         }
//                         return null;
//                       },
//                     ),
//
//                     const SizedBox(height: 30),
//
//                     /// دکمه ذخیره
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: _save,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                         ),
//                         child: const Text(
//                           "ذخیره",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
