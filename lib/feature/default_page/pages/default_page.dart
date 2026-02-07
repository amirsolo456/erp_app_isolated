// ignore_for_file: unused_import, library_prefixes

import 'package:erp_app/feature/default_page/pages/default_event.dart';
import 'package:erp_app/feature/default_page/pages/default_state.dart';
import 'package:erp_app/feature/default_page/year/bloc/year_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:resources_package/Resources/Assets/assets_manager.dart';
import 'package:services_package/default/mng/select/language_service.dart';
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

import '../../../core/network/injection_container.dart';
import '../cashier/bloc/cashier_bloc.dart';
import '../cashier/bloc/cashier_event.dart';
import '../cashier/bloc/cashier_state.dart';
import '../currency/bloc/currency_bloc.dart';
import '../currency/bloc/currency_event.dart';
import '../currency/bloc/currency_state.dart';
import '../language/bloc/language_bloc.dart';
import '../language/bloc/language_event.dart';
import '../language/bloc/language_state.dart';
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
  int? edLanguageId;
  int? edPlaceId;
  int? edCashierId;
  int? edCurrencyId;
  int? edYearId;

  @override
  void initState() {
    super.initState();
    if (!sl.isRegistered<LanguageBloc>()) {
      sl.registerLazySingleton(
        () => LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<YearBloc>().add(const LoadYearEvent());
      context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
      context.read<CashierBloc>().add(const LoadCashierEvent());
      context.read<PlaceBloc>().add(const LoadPlaceEvent());
      context.read<LanguageBloc>().add(const LoadLanguageEvent());
    });
    // لود اولیه داده‌ها
    // context.read<YearBloc>().add(const LoadYearEvent());
    // context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
    // context.read<CashierBloc>().add(const LoadCashierEvent());
    // context.read<PlaceBloc>().add(const LoadPlaceEvent());
    // context.read<LanguageBloc>().add(const LoadLanguageEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          // // اگر DefaultBloc از قبل در sl ثبت و ساخته شده و می‌خواهی همان instance را استفاده کنی:
          // BlocProvider<DefaultBloc>.value(value: sl<DefaultBloc>(),child: Provider<DefaultEvent,DefaultState>(
          //   create: (BuildContext context) {  },
          //   child: ,
          // )),

          // بقیه Blocها را با create و dispatch اولیه می‌سازیم
          BlocProvider<YearBloc>(create: (_) => sl<YearBloc>()..add(const LoadYearEvent())),
          BlocProvider<CurrencyBloc>(create: (_) => sl<CurrencyBloc>()..add(const LoadCurrencyEvent())),
          BlocProvider<CashierBloc>(create: (_) => sl<CashierBloc>()..add(const LoadCashierEvent())),
          BlocProvider<PlaceBloc>(create: (_) => sl<PlaceBloc>()..add(const LoadPlaceEvent())),
          BlocProvider<LanguageBloc>(create: (_) => sl<LanguageBloc>()..add(const LoadLanguageEvent())),
          // Menu / Profile / PersonList / ... اگر لازم است
        ],
        // همه providers را بالا دادیم؛ child نهایی را اینجا قرار می‌دهیم:
        child: BlocListener<DefaultBloc, DefaultState>(
          listenWhen: (prev, curr) {
            // فقط وقتی defaults واقعاً تغییر کردند listener اجرا شود.
            // این شرط نمونه است؛ متناسب با DefaultState خودت دقیق‌تر بنویس.
            return prev != curr && curr != DefaultState.initial();
          },bloc: sl<DefaultBloc>(),
          listener: (context, state) {
            // به جای reload همه چیز بی‌هدف، فقط در صورت نیاز هدفمند dispatch کن
            // مثال: اگر state.yearIdChanged => dispatch فقط LoadYearEvent
            // اینجا یک مثال ساده (ولی ممکن است باعث فراخوانی مجدد شود) — بهتر شرطی کن

            context.read<YearBloc>().add(const LoadYearEvent());
            context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
            context.read<CashierBloc>().add(const LoadCashierEvent());
            context.read<PlaceBloc>().add(const LoadPlaceEvent());
            context.read<LanguageBloc>().add(const LoadLanguageEvent());


            // و الی آخر؛ یا از listenWhen دقیق‌تر استفاده کن
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLanguageSection(),
                const SizedBox(height: 32),
                _buildCurrencySection(),
                const SizedBox(height: 32),
                _buildYearSection(),
                const SizedBox(height: 32),
                _buildCashierSection(),
                const SizedBox(height: 32),
                _buildPlaceSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget horizontal<T>({
    required String title,
    required String iconTitle,
    required List<T> items,
    required int? edId,
    required int Function(T) getId,
    required String Function(T) getTitle,
    required void Function(int id) on,
  }) {
    // اگر آیتمی وجود نداره، یک لیست خالی می‌سازیم ولی تیتر و آیکون همیشه نمایش داده می‌شود

    final selected = edId == null
        ? <T>[]
        : items.where((e) => getId(e) == edId).toList();
    final others = items.where((e) => getId(e) != edId).toList();
    final displayItems = [...selected, ...others];
    // 2. انتخاب شده را اول می‌آوریم
    if (edId != null) {
      displayItems.sort((a, b) {
        if (getId(a) == edId) return -1;
        if (getId(b) == edId) return 1;
        return 0;
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
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
                          onTap: () => on(id),
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
      ),
    );
  }

  Widget _buildLanguageSection() {
    return BlocBuilder<LanguageBloc, LanguageState>(
      bloc: sl<LanguageBloc>(),
      builder: (context, state) {
        if (state is LanguageLoaded) {
          return horizontal(
            iconTitle: AryanAssets.langIcon,
            title: 'زبان',
            items: state.languages,
            edId: edLanguageId,
            getId: (e) => (e).languageId,
            getTitle: (e) => (e).languageDesc,
            on: (id) {
              setState(() => edLanguageId = id);
              context.read<DefaultBloc>().add(LanguageChanged(id));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPlaceSection() {
    return BlocBuilder<PlaceBloc, PlaceState>(
      bloc: sl<PlaceBloc>(),
      builder: (context, state) {
        if (state is PlaceLoaded) {
          return horizontal<prefixPlace.ResponseData>(
            iconTitle: AryanAssets.buildingsIcon,
            title: 'شرکت',
            items: state.places,
            edId: edPlaceId,
            getId: (e) => e.placeId,
            getTitle: (e) => e.placeDesc ?? '',
            on: (id) {
              setState(() => edPlaceId = id);
              context.read<DefaultBloc>().add(PlaceChanged(id));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCashierSection() {
    return BlocBuilder<CashierBloc, CashierState>(
      bloc: sl<CashierBloc>(),
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
              setState(() => edCashierId = id);
              context.read<DefaultBloc>().add(CashierChanged(id));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCurrencySection() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      bloc: sl<CurrencyBloc>(),
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
              setState(() => edCurrencyId = id);
              context.read<DefaultBloc>().add(CurrencyChanged(id));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildYearSection() {
    return BlocBuilder<YearBloc, YearState>(
      bloc: sl<YearBloc>(),
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
              setState(() => edYearId = id);
              context.read<DefaultBloc>().add(YearChanged(id));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
