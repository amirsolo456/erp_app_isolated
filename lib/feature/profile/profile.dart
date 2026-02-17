import 'package:erp_app/feature/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_core/index.dart';
import 'package:provider/provider.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:resources_package/l10n/app_localizations_en.dart';
import 'package:resources_package/l10n/app_localizations_fa.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:ui_components_package/erp_app_componenets/common/loadings/circle_loading.dart';
import 'package:ui_components_package/extensions.dart';

import '../../core/network/injection_container.dart';
import '../../micro_app/erp_events.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppLocalizations? loc;
  final storage = sl<StorageService>();

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    try {
      loc =
          AppLocalizations.of(context) ??
          (((await storage.loadLanguage()).languageCode ?? 'fa') == 'fa'
              ? AppLocalizationsFa('fa')
              : AppLocalizationsEn('en'));
    } catch (e) {
      print(e.toString());
    }
  }

  String? getLocalizedText(String Function(AppLocalizations loc) getter) {
    final loc = AppLocalizations.of(context);
    return loc != null ? getter(loc) : null;
  }

  final Widget userInfoIcon = Image.asset(
    'assets/images/userinfo.png',
    package: 'resources_package',
  );
  final Widget userPasswordChange = Image.asset(
    'assets/images/user_password_change.png',
    package: 'resources_package',
  );
  final Widget userWallet = Image.asset(
    'assets/images/user_wallet.png',
    package: 'resources_package',
  );
  final Widget userSettings = Image.asset(
    'assets/images/user_settings.png',
    package: 'resources_package',
  );
  final Widget userOtherAccounts = Image.asset(
    'assets/images/user_other_accounts.png',
    package: 'resources_package',
  );
  final Widget userTitle = Image.asset(
    'assets/images/user_title.png',
    package: 'resources_package',
  );
  final Widget userDevices = Image.asset(
    'assets/images/user_devices.png',
    package: 'resources_package',
  );
  final Widget userSignOut = Image.asset(
    'assets/images/user_sign_out.png',
    package: 'resources_package',
  );
  final TextStyle itemsProfileStyle = GoogleFonts.abel(
    color: Color(0xFF585858),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  final TextStyle itemsWalletStyle = GoogleFonts.abel(
    color: Color(0xFFb1b1b1),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileBloc>().add(ProfileInitialEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitialState) {
          return const Center(child: CircleLoading());
        } else if (state is ProfileLoadDataSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),

            child: Column(
              children: [
                //مشخصات کاربری
                ListTile(
                  // onTap: () => CustomEventBus.emit(ErpUserInfoEvent()),

                  title: Text(context.l10n.userInfo, style: itemsProfileStyle),
                  horizontalTitleGap: 10,
                  leading: userInfoIcon,
                ),

                Divider(height: 10, color: Color(0xFFB1B1B1)),

                //تغییر رمز عبور
                ListTile(
                  title: Text(
                    context.l10n.userPasswordChange,
                    style: itemsProfileStyle,
                  ),
                  horizontalTitleGap: 10,
                  leading: userPasswordChange,
                ),
                Divider(height: 10, color: Color(0xFFB1B1B1)),

                //کیف پول
                ListTile(
                  trailing: SizedBox(
                    width: 70,
                    child: Row(
                      children: [
                        Text(' 0 ', style: itemsWalletStyle),
                        Text(context.l10n.toman, style: itemsWalletStyle),
                      ],
                    ),
                  ),
                  title: Text(
                    context.l10n.userWallet,
                    style: itemsProfileStyle,
                  ),
                  horizontalTitleGap: 10,
                  leading: userWallet,
                ),
                Divider(height: 10, color: Color(0xFFB1B1B1)),
                ListTile(
                  title: Text(
                    context.l10n.userSettings,
                    style: itemsProfileStyle,
                  ),
                  horizontalTitleGap: 10,
                  leading: userSettings,
                ),
                Divider(height: 10, color: Color(0xFFB1B1B1)),

                ListTile(
                  title: Text(
                    context.l10n.usersDevices,
                    style: itemsProfileStyle,
                  ),
                  horizontalTitleGap: 10,
                  leading: userDevices,
                ),
                Divider(height: 10, color: Color(0xFFB1B1B1)),
                ListTile(
                  title: Text(
                    context.l10n.usersSignOut,
                    style: TextStyle(
                      color: Color(0xFFDC3545),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  horizontalTitleGap: 10,
                  leading: userSignOut,
                  onTap: () async => {await onSignoutPressed(context)},
                ),
              ],
            ),
          );
        } else if (state is ProfileLoadDataError) {
          return Text('Error');
        } else if (state is ProfileLoadDataSource) {
          return Text('Error');
        } else {
          return SizedBox();
        }
      },
    );
  }

  Future<void> onSignoutPressed(BuildContext context) async {
    final cacheProvider = Provider.of<AppNotifier>(context, listen: false);
    await cacheProvider.signOut(context, force: true);

    // clearToken();

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginPage()),
    // );
  }
}
