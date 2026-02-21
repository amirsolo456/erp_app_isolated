import 'dart:convert';
import 'package:erp_app/feature/drawer/data/dashboard_drawer_provider.dart';
import 'package:erp_app/index.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_svg/svg.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/base/drawer_item_model.dart';
import 'package:models_package/base/field_model.dart';
import 'package:models_package/base/radio_values_model.dart';
import 'package:resources_package/Resources/Assets/assets_manager.dart';
import 'package:resources_package/Resources/Assets/icons_manager.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';
import 'package:services_package/index.dart';
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/extensions.dart';
import 'package:ui_components_package/index.dart';
import 'field_renderer.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart' hide sl;

bool builded = false;

class DynamicFormGenerator extends StatefulWidget {
  final Future Function(Map<String, dynamic> values)? onSubmit;
  final Map<String, dynamic> initialValues;
  final String jsonString; // JSON کامل از سرور
  final int repoId;
  final int systemId;
  final int type;

  final String? selectedFormDesc;

  const DynamicFormGenerator({
    super.key,
    this.onSubmit,
    this.initialValues = const {},
    required this.jsonString,
    this.selectedFormDesc,
    required this.repoId,
    required this.systemId,
    required this.type,
  });

  @override
  State<DynamicFormGenerator> createState() => _DynamicFormGeneratorState();
}

class _DynamicFormGeneratorState extends State<DynamicFormGenerator> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};

  Map<String, dynamic>? _parsedJson;
  List<FieldModel> _formFieldConfigs = [];
  List<ResponseData>? _data;
  DashboardDrawerProvider dashboardDrawerProvider =
      sl<DashboardDrawerProvider>();
  List<View> _allConfigs = [];
  List<View> _formConfigs = [];
  int selectedIndex = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();

    _values.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeRadioValues();
    });
  }

  Future<void> _initializeRadioValues() async {
    if (widget.initialValues.isNotEmpty || isLoaded) {
      return;
    }

    await _loadData();
    builded = isLoaded = true;
    for (var key in widget.initialValues.keys) {
      if (widget.initialValues[key] is bool) {
        _values[key] = widget.initialValues[key];
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      sl<ErpAppNotifier>().setLoading(true);
    });
    try {
      final newState = await sl<ToolbarService>().get(
        Request(repoId: widget.repoId, systemId: widget.systemId, type: 2),
        Response.fromJson,
      );
      _data = newState?.data ?? [];

      if (_data == null) {
        _data = [];
        return;
      }
      _allConfigs = _data!.first.list!.listProp;

      _formConfigs = _allConfigs;
      final viewFormConfig = View(
        config: _formConfigs.first.config,
        type: _formConfigs.first.type,
        id: _formConfigs.first.id,
        desc: _formConfigs.first.desc,
      ).formConfig;

      if (viewFormConfig == null) return;

      setState(() {
        _formFieldConfigs = viewFormConfig.fields
            .map((field) => FieldModel.fromField(field))
            .toList();
      });

      // cities = (await sl<CitiesService>().getCities()).data!.toList();
      // countries = (await sl<AreasService>().getAreas()).data!.toList();
    } catch (e) {
      ModernToast().showToast(
        context,
        Text(
          'خطا',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Text(e.toString()),
        ToastificationType.error,
      );
    } finally {
      setState(() {
        sl<ErpAppNotifier>().setLoading(false);
      });

      if (builded) {
        return;
      }
      var counter = 0;
      if (_data == null || _data!.first.list == null) {
        return;
      }

      dashboardDrawerProvider.addNEWItem(
        DrawerTittle(
          icon: SizedBox(),
          order: counter,
          title: 'نمایش',
          routeKey: 'title',
        ),
      );
      counter++;
      for (var i = 0; i < _data!.first.list!.listProp.length; i++) {
        dashboardDrawerProvider.addNEWItem(
          DrawerItemModel(
            order: counter,
            callBackType: () => {
              _formKey.currentState?.reset(),
              _values.clear(),
              Navigator.pop(context),
            },
            title: _data!.first.list!.listProp[i].desc ?? '',
            icon: SizedBox(),
            routeKey:
                _data!.first.list!.listProp[i].desc ??
                'index : ${i.toString()}',
          ),
        );
        counter++;
      }

      if (_data == null || _data!.first.moreMenu == null) {
        return;
      }

      dashboardDrawerProvider.addNEWItem(
        DrawerDivider(
          order: counter++,
          icon: SizedBox(),
          title: 'منو بیشتر',
          routeKey: 'more Menu',
        ),
      );
      dashboardDrawerProvider.addNEWItem(
        DrawerTittle(
          order: counter++,
          icon: SizedBox(),
          title: 'منو بیشتر',
          routeKey: 'more Menu',
        ),
      );
      counter++;
      for (var i = 0; i < _data!.first.moreMenu!.length; i++) {
        dashboardDrawerProvider.addNEWItem(
          DrawerItemModel(
            order: counter,
            callBackType: () => {
              _formKey.currentState?.reset(),
              _values.clear(),
              Navigator.pop(context),
            },
            title: _data!.first.moreMenu![i].menuDesc ?? '',
            icon: (_data!.first.moreMenu![i].icon != null
                ? SvgPicture.string(
                    _data!.first.moreMenu![i].icon!,
                    width: 24,
                    height: 24,
                  )
                : SvgPicture.network(
                    _data!.first.moreMenu![i].iconUrl ??
                        AryanAssets.defaultImage,
                    width: 24,
                    height: 24,
                  )),
            routeKey:
                _data!.first.moreMenu![i].menuDesc ?? 'index : ${i.toString()}',
          ),
        );
        counter++;
      }
      dashboardDrawerProvider.addNEWItem(
        DrawerDivider(
          order: counter++,
          icon: SizedBox(),
          title: 'منو بیشتر',
          routeKey: 'more Menu',
        ),
      );
      dashboardDrawerProvider.addNEWItem(
        DrawerTittle(
          order: counter++,
          icon: SizedBox(),
          title: 'چاپ',
          routeKey: 'print',
        ),
      );

      dashboardDrawerProvider.addNEWItems([
        DrawerItemModel(
          order: counter++,
          callBackType: () => {
            _formKey.currentState?.reset(),
            _values.clear(),
            Navigator.pop(context),
          },
          title: 'بازنشانی',
          icon: AryanAppAssets.images.imageByValue(AryanAssets.refresh),
          routeKey: 'reffresh',
        ),
        DrawerItemModel(
          order: counter++,
          callBackType: () => CustomEventBus.emit(
            ErpFormGeneratorEvent(widget.repoId, widget.systemId, widget.type),
          ),
          title: 'جدید',
          icon: AryanAppAssets.images.imageByValue(AryanAssets.add),
          routeKey: 'add',
        ),

        DrawerItemModel(
          order: counter++,
          callBackType: () => {
            if (_formKey.currentState?.validate() ?? false)
              {
                CustomEventBus.emit(
                  ErpFormGeneratorEvent(
                    widget.repoId,
                    widget.systemId,
                    widget.type,
                  ),
                ),
              },
          },
          title: 'ذخیره و جدید',
          icon: AryanAppAssets.images.imageByValue(AryanAssets.save),
          routeKey: 'save',
        ),
      ]);
      DrawerRegistry.instance.registerProvider(dashboardDrawerProvider);
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
      padding: FormSpacing.pagePadding,
      child: Divider(
        thickness: thickness,
        height: height,
        color: color,
        indent: indent,
        endIndent: endIndent,
      ),
    );
  }

  Widget _buildFormFields(FieldModel field, int index) {
    final indicesToSkip = <int>{};

    if (field.type == 'noshow') {
      indicesToSkip.add(index);
      return SizedBox(width: 10);
    }

    if (field.type == 'radio') {
      final radioOptions =
          (field.radioValues
              .map((e) => RadioValuesModel.fromRadioValues(e))
              .toList()) ??
          [];

      final rules = field.rules as List? ?? [];
      final isRequired = rules.any(
        (rule) =>
            rule is Map &&
            (rule['required'] == true || rule['rule'] == 'required'),
      );

      return Container(
        color: Colors.white,
        child: Padding(
          padding: FormSpacing.pagePadding,
          child: RadioInputField(
            caption: field.caption?.toString() ?? '',
            help: field.help?.toString() ?? '',
            fieldName: field.name ?? '',
            options: radioOptions,
            onChanged: (value) {
              _values[field.name ?? field.defaultValue] = value;
            },
            initialValue: _values[field.name ?? field.defaultValue],
            isRequired: isRequired,
          ),
        ),
      );
    }

    dynamic initialValue = _values[field.name] ?? field.defaultValue;

    if (field.type == 'treeoption' || field.type == 'selectoption') {
      var hasValidValue = false;

      if (initialValue is Map) {
        final value = initialValue['value'];
        final label = initialValue['label'];

        if (value != null && value.toString().isNotEmpty) {
          hasValidValue = true;
        } else if (label != null && label.toString().isNotEmpty) {
          hasValidValue = true;
        }
      }

      if (!hasValidValue) {
        initialValue = null;
      }

      if (initialValue is! Map) {
        final label = _values['${field.name}_label'];
        final path = _values['${field.name}_path'];

        if (initialValue != null || label != null) {
          initialValue = {
            'value': initialValue,
            'label': label ?? initialValue?.toString() ?? '',
          };
          if (field.type == 'treeoption' && path != null) {
            (initialValue)['path'] = path;
          }
        }
      }
    }

    if (!_values.containsKey(field.name) && initialValue != null) {
      _values[field.name ?? field.defaultValue] = initialValue;
    }

    final showWithoutBorder =
        field.type == 'checkbox' ||
        field.type == 'treeoption' ||
        field.type == 'selectoption';

    if (showWithoutBorder) {
      return Padding(
        padding: FormSpacing.pagePadding,
        child: FieldRenderer(
          onChanged: (value) {
            if (field.type == 'treeoption' && value is Map) {
              _values[field.name ?? field.defaultValue] = value['value'];
              _values['${field.name ?? field.defaultValue}_label'] =
                  value['label'];
              _values['${field.name ?? field.defaultValue}_path'] =
                  value['path'];
              final en = View(config: _formConfigs.first.config).formConfig;
              final endPoint = field.selectEndpoint;
              field.selectEndpoint = SelectEndPoint(
                endPoint?.repoViewId ?? 0,
                en?.addEndpoint ?? '',
                en?.addEndpoint,
                endPoint?.endpoint,
              );

              _values['selectEndPoint'] = View(
                config: _formConfigs[selectedIndex].config,
              ).formConfig;
            } else if (field.type == 'selectoption' && value is Map) {
              _values[field.name ?? field.defaultValue] = value['value'];
              _values['${field.name ?? field.defaultValue}_label'] =
                  value['label'];
              final en = View(config: _formConfigs.first.config).formConfig;
              final endPoint = field.selectEndpoint;
              field.selectEndpoint = SelectEndPoint(
                endPoint?.repoViewId ?? 0,
                en?.addEndpoint ?? '',
                en?.addEndpoint,
                endPoint?.endpoint,
              );

              _values['selectEndPoint'] = View(
                config: _formConfigs[selectedIndex].config,
              ).formConfig;
            } else {
              _values[field.name ?? field.defaultValue] = value;
            }
            // });
          },
          field: field,
          initialValues: _values,
        ),
      );
    } else {
      return Padding(
        padding: FormSpacing.pagePadding,
        child: Container(
          padding: FormSpacing.fieldPadding,
          decoration: BoxDecoration(color: context.colors.main),
          child: FieldRenderer(
            field: field,
            onChanged: (value) {
              if (!mounted) return;

                _values[field.name ?? field.defaultValue] = value;

            },
            initialValues: {
              field.name ?? field.defaultValue: initialValue ?? '',
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: FormSpacing.pagePadding,
                  itemCount: _formFieldConfigs.length,
                  itemBuilder: (context, index) {
                    final field = _formFieldConfigs[index];
                    return _buildFormFields(field, index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async => await submitForm(),
                  child: const Text('ذخیره'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getCurrencyRateCaption() {
    try {
      if (_parsedJson == null || !_parsedJson!.containsKey('Data')) {
        return '';
      }

      final data = _parsedJson!['Data'] as Map<String, dynamic>;
      if (!data.containsKey('List')) {
        return '';
      }

      final listData = data['List'] as Map<String, dynamic>;
      if (!listData.containsKey('Config')) {
        return '';
      }

      final configString = listData['Config'] as String;

      final cleanedConfigString = configString
          .replaceAll(r'\r', '')
          .replaceAll(r'\n', '')
          .replaceAll(r'\t', '')
          .trim();

      final List<dynamic> configList = json.decode(cleanedConfigString);

      for (var item in configList) {
        if (item['fieldName'] == 'CurrencyRate') {
          return item['fieldCaption'] as String;
        }
      }

      return '';
    } catch (e) {
      print('خطا در دریافت fieldCaption: $e');
      return '';
    }
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    if (widget.onSubmit != null) {
      try {
        await widget.onSubmit!(_values);
      } catch (e) {
        ModernToast().showToast(
          context,
          Text('خطا'),
          Text(e.toString()),
          ToastificationType.error,
        );
      }
    }
  }

  Map<String, dynamic> prepareErpPayload(Map<String, dynamic> formData) {
    final data = Map<String, dynamic>.from(formData);

    if (data['BirthLocationId'] is Map) {
      data['BirthLocationId'] = data['BirthLocationId']['Id'];
    }

    if (data['ForeignLocationId'] is Map) {
      data['ForeignLocationId'] = data['ForeignLocationId']['Id'];
    }

    return data;
  }
}

Widget paddedIcon(String assetPath) {
  const double iconSize = 40;
  return SizedBox(
    child: Image.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      package: 'resources_package',
    ),
  );
}

class FormSpacing {
  static const double horizontal = 16;
  static const double vertical = 12;
  static const double fieldGap = 16;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: horizontal,
    vertical: vertical,
  );

  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    vertical: fieldGap,
  );
}
