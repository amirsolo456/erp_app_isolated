import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Buttons/loading_button.dart';
import '../../feature/navigation_button/presentation/widget/app_navigation_button.dart';

enum NavButtonTypesEnum {
  navigatorButton,
  saveButton,
}

class NavigatorButtonHandler extends StatelessWidget {
  final NavButtonTypesEnum type;
  final NavButtonTabBarMode? selectedTab;
  final Function(NavButtonTabBarMode)? onTabSelected;
  final String? currentLocal;

  // مخصوص save (async support)
  final String? text;
  final Future<void> Function()? onPressed;

  // navigator constructor — مشخص و ساده
  const NavigatorButtonHandler.navigator({
    super.key,
    required Function(NavButtonTabBarMode) onTabSelected,
    required String currentLocal,
    this.selectedTab,
  })  : type = NavButtonTypesEnum.navigatorButton,
        onTabSelected = onTabSelected,
        currentLocal = currentLocal,
        text = null,
        onPressed = null;

  // save constructor — متن و handler اختیاری
  const NavigatorButtonHandler.save({
    super.key,
    this.text,
    this.onPressed,
    this.selectedTab,
  })  : type = NavButtonTypesEnum.saveButton,
        onTabSelected = null,
        currentLocal = null;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case NavButtonTypesEnum.navigatorButton:
        return AppNavigationButton(
          onTabSelected: onTabSelected!,
          currentLocal: Locale(currentLocal!),
          selectedTab: selectedTab ?? NavButtonTabBarMode.erpDashboardTabMode,
        );

      case NavButtonTypesEnum.saveButton:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: LoadingButton(
            text: text ?? 'ذخیره',
            onPressed: () => onPressed!(),
          ),
        );
    }
  }
}