// ignore_for_file: unused_import, library_prefixes

import 'package:erp_app/feature/default_page/pages/default_event.dart';
import 'package:erp_app/feature/default_page/pages/default_state.dart';
import 'package:erp_app/feature/default_page/year/bloc/year_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources_package/Resources/Assets/assets_manager.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:shared_core/data/com/person/request.dart' as prefix0;
import 'package:shared_core/data/com/person/response.dart' as prefix0;
import 'package:shared_core/data/com/person/response_data.dart' as prefix0;
import 'package:shared_core/data/default/com/select/currency/request.dart'
    as prefixCur;
import 'package:shared_core/data/default/com/select/currency/response.dart'
    as prefixCur;
import 'package:shared_core/data/default/com/select/currency/response_data.dart'
    as prefixCur;
import 'package:shared_core/data/default/com/select/year/request.dart'
    as prefixYear;
import 'package:shared_core/data/default/com/select/year/response.dart'
    as prefixYear;
import 'package:shared_core/data/default/com/select/year/response_data.dart'
    as prefixYear;
import 'package:shared_core/data/default/mng/select/place/request.dart'
    as prefixPlace;
import 'package:shared_core/data/default/mng/select/place/response.dart'
    as prefixPlace;
import 'package:shared_core/data/default/mng/select/place/response_data.dart'
    as prefixPlace;
import 'package:shared_core/data/default/request.dart' as prefixDefault;
import 'package:shared_core/data/default/response.dart' as prefixDefault;
import 'package:shared_core/data/default/response_data.dart' as prefixDefault;
import 'package:shared_core/data/default/trh/select/cashier/request.dart'
    as prefixCash;
import 'package:shared_core/data/default/trh/select/cashier/response.dart'
    as prefixCash;
import 'package:shared_core/data/default/trh/select/cashier/response_data.dart'
    as prefixCash;
import 'package:ui_components_package/erp_app_componenets/common/Buttons/language_button_standalone/language_button_stand_alone.dart';
import 'package:ui_components_package/erp_app_componenets/common/Buttons/language_button_standalone/language_button_stand_alone_cubit.dart';

import '../../../core/network/injection_container.dart';
import '../cashier/bloc/cashier_bloc.dart';
import '../cashier/bloc/cashier_event.dart';
import '../cashier/bloc/cashier_state.dart';
import '../currency/bloc/currency_bloc.dart';
import '../currency/bloc/currency_event.dart';
import '../currency/bloc/currency_state.dart';
import '../place/bloc/place_bloc.dart';
import '../place/bloc/place_event.dart';
import '../place/bloc/place_state.dart';
import '../year/bloc/year_bloc.dart';
import '../year/bloc/year_event.dart';
import 'default_bloc.dart';

class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  String? edLanguageId;
  int? edPlaceId;
  int? edCashierId;
  int? edCurrencyId;
  int? edYearId;

  @override
  void initState() {
    super.initState();
    // لود اولیه داده‌ها
    context.read<YearBloc>().add(const LoadYearEvent());
    context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
    context.read<CashierBloc>().add(const LoadCashierEvent());
    context.read<PlaceBloc>().add(const LoadPlaceEvent());
    // context.read<LanguageBloc>().add(const LoadLanguageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DefaultBloc, DefaultState>(
      listenWhen: (prev, curr) => prev.defaults != curr.defaults,
      listener: (context, state) {
        // هر بار Defaultion تغییر کرد، بلوک‌ها را ری‌لود کن
        context.read<YearBloc>().add(const LoadYearEvent());
        context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
        context.read<CashierBloc>().add(const LoadCashierEvent());
        context.read<PlaceBloc>().add(const LoadPlaceEvent());
        // context.read<LanguageBloc>().add(const LoadLanguageEvent());
      },
      bloc: context.read<DefaultBloc>(),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLanguageSection(),
            const SizedBox(height: 32),
            _buildCurrencySection(),
            const SizedBox(height: 32),
            // Text("aaa"),
            _buildYearSection(),
            const SizedBox(height: 32),
            _buildCashierSection(),
            const SizedBox(height: 32),
            _buildPlaceSection(),
          ],
        ),
      ),
    );
  }

  Widget horizontal<T>({
    required String title,
    required String iconTitle,
    required List<T> items,
    required Object? edId,
    required Object Function(T) getId,
    required String Function(T) getTitle,
    required void Function(Object id) on,
  }) {
    // اگر آیتمی وجود نداره، یک لیست خالی می‌سازیم ولی تیتر و آیکون همیشه نمایش داده می‌شود
    final displayItems = [...items];

    // 2. انتخاب شده را اول می‌آوریم
    if (edId != null) {
      displayItems.sort((a, b) {
        if (getId(a) == edId) return -1;
        if (getId(b) == edId) return 1;
        return 0;
      });
    }


        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 55,
                height: 55,
                child: Image.asset(iconTitle, package: 'resources_package'),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          displayItems.isEmpty
              ? Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'موردی موجود نیست',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayItems.length,
                    itemBuilder: (context, index) {
                      final item = displayItems[index];
                      final id = getId(item);
                      final ised = edId == id;
                      final text = getTitle(item);

                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: () => on((id is int ? (id as num).toInt() : Locale(id as String))),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ised
                                  ? const Color(0xFFECECEC)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  text,
                                  style: TextStyle(
                                    color: const Color(0xFF767676),
                                    fontWeight: ised
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                if (ised) ...[
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.check,
                                    color: Color(0xFF767676),
                                    size: 20,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],

    );
  }

  Widget _buildLanguageSection() {
    return BlocBuilder<LanguageButtonStandAloneCubit, Locale>(
      bloc: sl<LanguageButtonStandAloneCubit>(),
      builder: (context, state) {
        return horizontal<Locale>(
          iconTitle: AryanAssets.langIcon,
          title: 'زبان',
          items: AppLocalizations.supportedLocales.toList(),
          edId: edLanguageId ?? AppTheme.local.value ,
          getId: (e) => e.languageCode,
          getTitle: (e) => (e).languageCode,
          on: (id) {
            setState(() => edLanguageId = (id as Locale).languageCode);
            context.read<DefaultBloc>().add(LanguageChanged((id as Locale).languageCode));
            context.read<LanguageButtonStandAloneCubit>().setLocale(state);
          },
        );
      },
    );
  }

  Widget _buildPlaceSection() {
    return BlocBuilder<PlaceBloc, PlaceState>(
      builder: (context, state) {
        if (state is PlaceLoaded) {
          return horizontal<prefixPlace.ResponseData>(
            iconTitle: AryanAssets.buildings,
            title: 'شرکت',
            items: state.places,
            edId: edPlaceId,
            getId: (e) => e.placeId,
            getTitle: (e) => e.placeDesc ?? '',
            on: (id) {
              setState(() => edPlaceId = (id as num).toInt());
              context.read<DefaultBloc>().add(PlaceChanged((id as num).toInt()));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCashierSection() {
    return BlocBuilder<CashierBloc, CashierState>(
      builder: (context, state) {
        if (state is CashierLoaded) {
          return horizontal<prefixCash.ResponseData>(
            iconTitle: AryanAssets.cashOutIcon,
            title: 'صندوقدار اصلی',
            items: state.Cashier,
            edId: edCashierId,
            getId: (e) => (e).id,
            getTitle: (e) => (e).display ?? '',
            on: (id) {
              setState(() => edCashierId = (id as num).toInt());
              context.read<DefaultBloc>().add(CashierChanged((id as num).toInt()));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCurrencySection() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        if (state is CurrencyLoaded) {
          return horizontal<prefixCur.ResponseData>(
            iconTitle: AryanAssets.moneyIcon,
            title: 'ارز',
            items: (state).selectCurrency,
            edId: edCurrencyId,
            getId: (e) => (e).selectId,
            getTitle: (e) => (e).selectDisplay,
            on: (id) {
              setState(() => edCurrencyId = (id as num).toInt());
              context.read<DefaultBloc>().add(CurrencyChanged((id as num).toInt()));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildYearSection() {
    return BlocBuilder<YearBloc, YearState>(
      builder: (context, state) {
        if (state is YearLoaded) {
          return horizontal<prefixYear.ResponseData>(
            iconTitle: AryanAssets.calendarIcon,
            title: 'سال مالی',
            items: (state).selectYears,
            edId: edYearId,
            getId: (e) => (e).yearId,
            getTitle: (e) => (e).yearDesc,
            on: (id) {
              setState(() => edYearId = (id as num).toInt());
              context.read<DefaultBloc>().add(YearChanged((id as num).toInt()));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
