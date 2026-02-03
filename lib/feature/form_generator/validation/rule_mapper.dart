
import 'package:shared_core/index.dart';

class RuleMapper {
  static String? validate(List<Rule> rules, String? value) {
    // اول بررسی کنیم که آیا required هست
    for (final rule in rules) {
      // بررسی rule.name (مثل "required") و rule.required
      if ((rule.name?.toLowerCase() == 'required' || rule.required == true) &&
          (value == null || value.isEmpty)) {
        return rule.message ?? 'این فیلد الزامی است';
      }

      // بررسی maxlength
      if (rule.type == 'maxlength' && value != null) {
        if (value.length > rule.len) {
          return rule.message ?? 'حداکثر ${rule.len} کاراکتر';
        }
      }

      // بررسی سایر ruleها
      if (rule.name == 'maxlength' && value != null) {
        if (value.length > rule.len) {
          return rule.message ?? 'حداکثر ${rule.len} کاراکتر';
        }
      }

      // بررسی minlength
      if (rule.type == 'minlength' && value != null) {
        if (value.length < rule.len) {
          return rule.message ?? 'حداقل ${rule.len} کاراکتر';
        }
      }
    }
    return null;
  }

  // متد کمکی برای بررسی required بودن
  static bool isRequired(List<Rule> rules) {
    for (final rule in rules) {
      if (rule.name?.toLowerCase() == 'required' || rule.required == true) {
        return true;
      }
    }
    return false;
  }
}