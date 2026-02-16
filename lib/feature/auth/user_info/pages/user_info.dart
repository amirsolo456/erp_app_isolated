import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:erp_app/feature/form_generator/widgets/dynamic_form_generator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/erp_app_componenets/common/toast/toast.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Buttons/loading_button.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Buttons/small_button.dart';
import 'package:shared_core/index.dart' hide Request, Response;
import 'package:ui_components_package/erp_app_componenets/mobile/Components/field_title.dart';
import 'package:services_package/auth/user/user_info/user_info_service.dart';
import 'package:shared_core/data/auth/user/user_information/user_information.dart';
import 'package:services_package/api_client_service.dart';
import '../../../../core/network/injection_container.dart';

import '../../../form_generator/widgets/field_renderer.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});



  @override
  State<UserInfo> createState() => _UserInfoState();
}




class _UserInfoState extends State<UserInfo> {
  bool _isLoading = false;
  File? _profileImage;
  bool _showImageOptions = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  // late final UserInfoService _service;
  final UserInfoService _service = sl<UserInfoService>();


  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        _showImageOptions = false;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
      _showImageOptions = false;
    });
  }
  @override
  void initState() {
    super.initState();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final request = Request(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
          userId: 12,
      );

      final response = await _service.insert( request, Response.fromJson);

      if(response!.customResult){
        ModernToast().showToast(
          context,
          Text("اطلاعات با موفقیت ذخیره شد"),
          Text(""),
          ToastificationType.success,
        );
      }


      if (response!.data!.isNotEmpty ) {
        ModernToast().showToast(
          context,
          Text("اطلاعات با موفقیت ذخیره شد"),
          Text(""),
          ToastificationType.success,
        );
      } else {
        ModernToast().showToast(
          context,
          Text("پاسخ نامعتبر از سرور"),
          Text(""),
          ToastificationType.warning,
        );
      }
    } catch (e) {
      ModernToast().showToast(
        context,
        Text("خطا: ${e.toString()}"),
        Text(""),
        ToastificationType.warning,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  // void _save() async {
  //
  //
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isLoading = true);
  //     await Future.delayed(const Duration(seconds: 2));
  //     setState(() => _isLoading = false);
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text("اطلاعات ذخیره شد")));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: LoadingButton(
              text: 'ذخیره',
              autoLoading: true,
              isLoadingState: false,
              onPressed: () async {
                if ((_firstNameController.text.isNotEmpty) &&
                    (_lastNameController.text.isNotEmpty)) {
                 await _save();
                } else {
                  ModernToast().showToast(
                    context,
                    Text('لطفا همه فیلدهای الزامی را پر کنید'),
                    Text(' '),
                    ToastificationType.warning,
                  );
                }
              },
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
          // Scroll فرم
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: UserInfoPositionButton.left,
                right: UserInfoPositionButton.right,
                top: UserInfoPositionButton.top,
                bottom: UserInfoPositionButton.bottom,
              ),
              child: Column(
                children: [
                  DottedBorder(
                    options: RectDottedBorderOptions(
                      color: Colors.grey,
                      dashPattern: [8, 4],
                      strokeWidth: 1.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            /// CircleAvatar با دکمه‌های overlay
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showImageOptions = !_showImageOptions;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: 150,
                                    backgroundColor: const Color(0xFFF0F0F0),
                                    backgroundImage: _profileImage != null
                                        ? FileImage(_profileImage!)
                                        : null,
                                    child: _profileImage == null
                                        ? Icon(
                                            Icons.add_photo_alternate_outlined,
                                            color: Colors.grey[300],
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                ),

                                /// دکمه‌های overlay درست زیر تصویر
                                if (_showImageOptions)
                                  Positioned(
                                    top: UserInfoPositionButtonOnAvatar.top,
                                    left: UserInfoPositionButtonOnAvatar.left,
                                    right: UserInfoPositionButtonOnAvatar.right,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SmallOverlayButton(
                                          text: "افزودن تصویر",
                                          onPressed: _pickImage,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                        ),

                                        const SizedBox(width: 8),
                                        SmallOverlayButton(
                                          text: "حذف تصویر",
                                          onPressed: _removeImage,
                                          backgroundColor: Colors.white,
                                          textColor: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            FieldTitle(
                              caption: "نام",
                              // help: widget.field.help,
                              isRequired: true,
                            ),
                            FieldRenderer(
                              field: Field(name: "firstName", type: "text"),
                              initialValues: {
                                "firstName": _firstNameController.text,
                              },
                              onChanged: (value) {
                                _firstNameController.text = value;
                              },
                            ),
                            const SizedBox(height: 20),

                            FieldTitle(
                              caption: "نام خانوادگی",
                              // help: widget.field.help,
                              isRequired: true,
                            ),
                            FieldRenderer(
                              field: Field(name: "lastName", type: "text"),
                              initialValues: {
                                "lastName": _lastNameController.text,
                              },
                              onChanged: (value) {
                                _lastNameController.text = value;
                              },
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: UserInfoPositionDivider.top,
            left: UserInfoPositionDivider.left,
            right: UserInfoPositionDivider.right,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Colors.grey[300], height: 2, thickness: 5),
            ),
          ),
        ],
      ),
    );
  }
}
