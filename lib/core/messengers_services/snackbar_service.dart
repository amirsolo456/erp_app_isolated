import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';
import 'package:models_package/base/question_button.dart';
import 'package:resources_package/Resources/Assets/assets_manager.dart';
import 'package:resources_package/Resources/Assets/icons_manager.dart';
import 'package:services_package/Interfaces/front_helper_services/isnackbar_service.dart';

class SnackBarService implements ISnackbarService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static Color successColor = const Color(0XFFE8F4E6);
  static Color infoColor = const Color(0XFFF2F8FF);
  static Color errorColor = const Color(0XFFFFF5F7);
  static Color questionBoxColor = const Color(0XFFF9F9F9);

  void _show(
    String message, {
    required MessageMode mode,
    required List<QuestionButton> buttons,
    Duration duration = const Duration(seconds: 3),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Color bg;
      String icon;

      switch (mode) {
        case MessageMode.successMode:
          bg = successColor;
          icon = AryanAssets.successIcon;
          break;
        case MessageMode.errorMode:
          bg = errorColor;
          icon = AryanAssets.errorIcon;
          break;
        case MessageMode.infoMode:
          bg = infoColor;
          icon = AryanAssets.infoIcon;
          break;
        case MessageMode.questionBoxMode:
        default:
          bg = questionBoxColor;
          icon = AryanAssets.questionBoxIcon;
          break;
      }

      messengerKey.currentState?.showSnackBar(
        SnackBar(
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(12),
          elevation: 0,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AryanAppAssets.images.imageByValue(icon),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(message, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
              if (buttons.isNotEmpty) const SizedBox(height: 8),
              if (buttons.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: buttons.map((button) {
                    return TextButton(
                      onPressed: button.onPressed,
                      style: TextButton.styleFrom(
                        foregroundColor: button.textColor,
                        backgroundColor: button.backgroundColor,
                      ),
                      child: Text(button.label),
                    );
                  }).toList(),
                ),
            ],
          ),
          duration: duration,
        ),
      );
    });
  }

  @override
  void showSuccess(
    String msg, {
    Duration? duration,
    List<QuestionButton>? buttons,
  }) {
    _show(
      msg,
      mode: MessageMode.successMode,
      buttons: buttons ?? const [],
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  @override
  void showError(
    String msg, {
    Duration? duration,
    List<QuestionButton>? buttons,
  }) {
    _show(
      msg,
      mode: MessageMode.errorMode,
      buttons: buttons ?? const [],
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  @override
  void showInfo(
    String msg, {
    Duration? duration,
    List<QuestionButton>? buttons,
  }) {
    _show(
      msg,
      mode: MessageMode.infoMode,
      buttons: buttons ?? const [],
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  @override
  void showQuestionBox(
    String msg, {
    Duration? duration,
    required List<QuestionButton> buttons,
  }) {
    _show(
      msg,
      mode: MessageMode.questionBoxMode,
      buttons: buttons,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}
