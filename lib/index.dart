// lib/core/index.dart
// ===== Micro-app / App-level helpers =====
export '/micro_app/erp_events.dart';
export '/micro_app/erp_inject.dart';
export '/micro_app/erp_resolver.dart';
export './core/messengers_services/exception_helper_service.dart';
export './core/messengers_services/snackbar_service.dart';
export './core/navigation/erp_navigator.dart';
export './core/navigation/navigation_service.dart';
export './core/navigation/navigation_setup.dart';
export './core/network/custom_http_override.dart';
export './core/network/get_it_bloc_provider.dart';
export './core/network/injection_container.dart';
export 'feature/add_new/add-new_page.dart';
export 'feature/auth/menu/pages/menu_page.dart';
export 'feature/com/person/presentation/features/person_list_page.dart';
export 'feature/dashboard_page/page/dashboard.dart';
// default page entry (convenience)
export 'feature/default_page/pages/default_page.dart'; // placeholder - اگر وجود نداره حذفش کنید
// redux UI helper
export 'feature/redux/generic_lists/ui/generic_list_page.dart';

// ===== Usage notes =====
// - این barrel برای export کردن بخش‌های کلیدی و صفحاتِ سطح بالا ساخته شده تا در سایر بسته‌ها
//   یا در قسمت‌های دیگر اپ راحت import شوند.
// - برای فایل‌های feature-specific (مثلاً blocها، مدل‌های محلی یا DTOها) توصیه می‌شود
//   آن‌ها را مستقیماً با مسیر package: یا relative و در همان فایل مصرف‌کننده import کنید تا
//   از مشکلات ambiguous import یا unused import جلوگیری شود.
// - اگر خواستی این فایل را دقیقاً روی فایل‌های موجود پروژهٔ تو تطبیق بدهم (حذف یا اضافه خطوط)،
//   نام فایل‌هایی که می‌خواهی export/عدم‌export شوند را بگو تا همان‌جا ویرایش کنم.
