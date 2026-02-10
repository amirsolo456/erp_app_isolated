import 'dart:convert';
import 'package:flutter/material.dart' hide View;
import 'package:micro_app_commons/app_notifier.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/chat_bot/chat_bot.dart';
import '../../../core/network/injection_container.dart';
import 'field_renderer.dart';
import 'input/radio_Input_field.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Drawer/drawer_design.dart';


class DynamicFormGenerator extends StatefulWidget {
  final void Function(Map<String, dynamic> values)? onSubmit;
  final Map<String, dynamic> initialValues;
  final String jsonString; // JSON کامل از سرور
  final String? selectedFormDesc;

  const DynamicFormGenerator({
    super.key,
    this.onSubmit,
    this.initialValues = const {},
    required this.jsonString,
    this.selectedFormDesc,
  });

  @override
  State<DynamicFormGenerator> createState() => _DynamicFormGeneratorState();
}

class _DynamicFormGeneratorState extends State<DynamicFormGenerator> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  Map<String, dynamic>? _parsedJson;
  List<Field> _formConfigs = [];
  List<View> _allConfigs = [];

  Map<String, dynamic>? _selectedFormConfig;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _values.addAll(widget.initialValues);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeRadioValues();
      _loadData();
    });

    // _processJson();
  }

  void _initializeRadioValues() {
    if (widget.initialValues.isNotEmpty) {
      return;
    }

    for (var key in widget.initialValues.keys) {
      if (widget.initialValues[key] is bool) {
        _values[key] = widget.initialValues[key];
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newState = await sl<ToolbarService>().get(
        Request(repoId: 106045, systemId: 106, type: 2),
        Response.fromJson,
      );
      final data = newState?.data ?? [];

      _allConfigs = data.first.list!.listProp;
      for (final view in _allConfigs) {
        if (view.isForm) {
          final form = view.formConfig;
          setState(() {
            _formConfigs = view.formConfig!.fields;
          });

          print('Form endpoint: ${form?.addEndpoint}');
        }

        if (view.isList) {
          final list = view.listConfig;
          // _formConfigs = view.listConfig!.fields;
          print('List columns count: ${list?.column.length}');
        }
      }

      // _allConfigs = data.toList().first.list?.listProp ?? [];

      // if (_allConfigs.length > 1) {
      //   setState(() {
      //     _formConfigs = _allConfigs.last.formConfig  ?? _allConfigs.last.formConfig.;
      //   });
      // } else {
      //   setState(() {
      //     _formConfigs = _allConfigs.first.formConfig!.fields;
      //   });
      // }

      // _selectForm();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  void _navigateToForm(String formDesc) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DynamicFormGenerator(
          jsonString: widget.jsonString,
          selectedFormDesc: formDesc,
          onSubmit: widget.onSubmit,
          initialValues: widget.initialValues,
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final isFa = sl<AppNotifier>().currentLocal().languageCode == "fa";

    return Directionality(
      textDirection: isFa ? TextDirection.rtl : TextDirection.ltr,
      child: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 16),

              /// عنوان: نمایش
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 50,
                  top: 4,
                  bottom: 4,
                ),
                child: const Text(
                  'نمایش',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),

              /// لیست فرم‌ها
              ..._allConfigs.map((item) {
                return ListTile(
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 70,
                    end: 16,
                    top: 4,
                    bottom: 4,
                  ),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  title: Text(
                    item.desc ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToForm(item.desc ?? '');
                  },
                );
              }).toList(),

              buildCustomDivider(),

              /// منو بیشتر
              Padding(
                padding:  EdgeInsetsDirectional.only(
                  start: isFa ?50 : 55,
                  end: isFa ?50 : 0,
                  top: 4,
                  bottom: 4,
                ),
                child: const Text(
                  'منو بیشتر',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),

              _buildMenuItem(
                'برچسب',
                    () {
                  _formKey.currentState?.reset();
                  _values.clear();
                  Navigator.pop(context);
                },
                'assets/images/calendar.png',
              ),

              buildCustomDivider(),

              /// چاپ
              ListTile(
                contentPadding: const EdgeInsetsDirectional.only(
                  start: 60,
                  end: 16,
                ),
                dense: true,
                visualDensity: VisualDensity.compact,
                title: const Text(
                  'چاپ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),

              buildCustomDivider(),

              /// عملیات‌ها
              _buildMenuItem(
                'باز نشانی',
                    () {
                  _formKey.currentState?.reset();
                  _values.clear();
                  Navigator.pop(context);
                },
                'assets/images/refresh.png',
              ),

              _buildMenuItem(
                'جدید',
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DynamicFormGenerator(
                        jsonString: widget.jsonString,
                        onSubmit: widget.onSubmit,
                      ),
                    ),
                  );
                },
                'assets/images/add.png',
              ),

              _buildMenuItem(
                'ذخیره و جدید',
                    () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onSubmit?.call(_values);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DynamicFormGenerator(
                          jsonString: widget.jsonString,
                          onSubmit: widget.onSubmit,
                        ),
                      ),
                    );
                  }
                },
                'assets/images/save.png',
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildMenuItem(String title, VoidCallback onTap, String assetPath) {
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(
        start: 60,
        end: 16,
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Row(
        children: [
          Image.asset(
            assetPath,
            package: 'resources_package',
            width: 15,
            height: 15,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final currencyRateCaption = getCurrencyRateCaption();

    return AppBar(
      leading: Container(
        padding: EdgeInsets.only(left: 10),
        child: InkWell(
          onTap: () {},
          child: paddedIcon('assets/images/arrow_back.png'),
        ),
      ),
      title: Row(
        children: [
          Text(
            currencyRateCaption + ' - جدید',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Expanded(child: SizedBox()),

          InkWell(
            onTap: () {
              print('chat bot');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatPage();
                  },
                ),
              );
            },
            child: paddedIcon('assets/images/chat.png'),
          ),
          SizedBox(width: 10),

          InkWell(
            onTap: () {
              print('PanelForm');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Center(); // be jaye pannelform
                  },
                ),
              );
            },
            child: paddedIcon('assets/images/futures.png'),
          ),
        ],
      ),
      actions: [
        InkWell(
          onTap: () {
            final lang = sl<AppNotifier>().currentLocal().languageCode;
            if (lang == 'fa') {
              _scaffoldKey.currentState?.openDrawer();
            } else {
              _scaffoldKey.currentState?.openEndDrawer();
            }
          },
          child: paddedIcon('assets/images/more.png'),
        ),
      ],
    );

  }

  Widget _buildFormFields(Field field, int index) {
    // if (_selectedFormConfig == null ||
    //     !_selectedFormConfig!.containsKey('fields')) {
    //   return Text('فیلدی یافت نشد');
    // }

    final indicesToSkip = <int>{};

    if (field.type == 'noshow') {
      indicesToSkip.add(index);
      return SizedBox(width: 10);
    }


    if (field.type == 'radio') {
      final radioOptions =
          (field.radioValues as List?)?.cast<Map<String, dynamic>>() ?? [];

      final rules = field.rules as List? ?? [];
      final isRequired = rules.any(
        (rule) =>
            rule is Map &&
            (rule['required'] == true || rule['rule'] == 'required'),
      );

      final selectEndpointData = field.selectEndpoint;
      final selectEndpoint =
          (selectEndpointData != null && selectEndpointData is Map)
          ? _convertSelectEndpoint(selectEndpointData)
          : null;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: RadioInputField(
          caption: field.caption?.toString() ?? '',
          help: field.help?.toString() ?? '',
          fieldName: field.name ?? '',
          options: radioOptions,
          onChanged: (value) {
            // if (!mounted) return;
            // setState(() {
            _values[field.name ?? field.defaultValue] = value;
            // });
          },
          initialValue: _values[field.name ?? field.defaultValue],
          isRequired: isRequired,
        ),
      );
    }

    // final fieldModel = Field(
    //   name: fieldName,
    //   caption: fieldMap['caption']?.toString() ?? '',
    //   help: fieldMap['help']?.toString() ?? '',
    //   type: fieldType,
    //   placeHolder: fieldMap['placeHolder']?.toString() ?? '',
    //   defaultValue: fieldMap['defaultValue']?.toString() ?? '',
    //   showId: false,
    //   radioValues: [],
    //   order: fieldMap['order'] ?? 0,
    //   selectEndpoint: selectEndpoint,
    //   options: _convertOptions(fieldMap['options']),
    //   rules: _convertRules(fieldMap['rules']),
    //   icon: null,
    //   idValue: 0,
    // );

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
        padding: const EdgeInsets.only(bottom: 20),
        child: FieldRenderer(
          field: field,
          onChanged: (value) {
            // if (!mounted) return;
            // setState(() {
            if (field.type == 'treeoption' && value is Map) {
              _values[field.name ?? field.defaultValue] = value['value'];
              _values['${field.name ?? field.defaultValue}_label'] =
                  value['label'];
              _values['${field.name ?? field.defaultValue}_path'] =
                  value['path'];
            } else if (field.type == 'selectoption' && value is Map) {
              _values[field.name ?? field.defaultValue] = value['value'];
              _values['${field.name ?? field.defaultValue}_label'] =
                  value['label'];
            } else {
              _values[field.name ?? field.defaultValue] = value;
            }
            // });
          },
          initialValues: {field.name ?? field.defaultValue: initialValue ?? ''},
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white),
          child: FieldRenderer(
            field: field,
            onChanged: (value) {
              if (!mounted) return;
              // setState(() {
              _values[field.name ?? field.defaultValue] = value;
              // });
            },
            initialValues: {
              field.name ?? field.defaultValue: initialValue ?? '',
            },
          ),
        ),
      );
    }
  }

  SelectEndpoint? _convertSelectEndpoint(dynamic endpoint) {
    if (endpoint == null || !(endpoint is Map) || endpoint.isEmpty) return null;

    final repoViewId = endpoint['repoViewId'];
    String? repoViewIdStr;

    if (repoViewId != null) {
      repoViewIdStr = repoViewId.toString();
    }

    return SelectEndpoint(
      endpoint: endpoint['endpoint']?.toString() ?? '',
      repoViewId: repoViewIdStr,
      addAppUrl: endpoint['addAppUrl']?.toString(),
      addWebUrl: endpoint['addWebUrl']?.toString(),
    );
  }

  List<Select> _convertOptions(dynamic options) {
    if (options == null || !(options is List)) return [];

    final result = <Select>[];
    for (var item in options) {
      if (item is Map) {
        result.add(
          Select(
            caption: item['caption']?.toString() ?? '',
            value: item['value'],
          ),
        );
      }
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    final lang = sl<AppNotifier>().currentLocal().languageCode;
    final isFa = lang == 'fa';

     return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: isFa
          ? DynamicFormDrawer(
        allConfigs: _allConfigs,
        formKey: _formKey,
        values: _values,
        onNavigateToForm: _navigateToForm,
        onSubmit: widget.onSubmit,
        appNotifier: sl<AppNotifier>(),
      )
          : null,
      endDrawer: !isFa
          ? DynamicFormDrawer(
        allConfigs: _allConfigs,
        formKey: _formKey,
        values: _values,
        onNavigateToForm: _navigateToForm,
        onSubmit: widget.onSubmit,
        appNotifier: sl<AppNotifier>(),
      )
          : null,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 10,
            ),
            itemCount: _formConfigs.length,
            itemBuilder: (context, index) {
              final item = _formConfigs[index];
              return _buildFormFields(item, index);
            },
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
}

Widget paddedIcon(String assetPath) {
  const double iconSize = 40;
  return Padding(
    padding: const EdgeInsets.only(top: 0),
    child: Image.asset(
      assetPath,
      width: iconSize,
      height: iconSize,
      package: 'resources_package',
    ),
  );
}
