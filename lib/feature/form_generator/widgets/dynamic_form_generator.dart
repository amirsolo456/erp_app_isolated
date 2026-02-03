import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/chat_bot/chat_bot.dart';
import 'field_renderer.dart';
import 'input/radio_Input_field.dart';
import 'package:shared_core/index.dart';

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
  List<dynamic> _formConfigs = [];

  Map<String, dynamic>? _selectedFormConfig;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _values.addAll(widget.initialValues);

    _initializeRadioValues();
    _processJson();
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

  void _processJson() {
    try {
      _parsedJson = json.decode(widget.jsonString);
      _parsedJson!.forEach((key, value) {});

      if (_parsedJson!.containsKey('Data')) {
        final data = _parsedJson!['Data'] as Map<String, dynamic>;
        data.forEach((key, value) {
          if (value is List) {
          } else if (value is Map) {
          } else {}
        });

        if (data.containsKey('List')) {
          final listData = data['List'] as Map<String, dynamic>;
          listData.forEach((key, value) {});

          if (listData.containsKey('ListProp')) {
            _formConfigs = listData['ListProp'] as List<dynamic>;

            _selectForm();
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // setState(() => _isLoading = false);
    }
  }


  void _selectForm() {
    dynamic selectedForm;

    if (_formConfigs.length == 1) {
      selectedForm = _formConfigs[0];
    } else if (widget.selectedFormDesc != null) {
      selectedForm = _formConfigs.firstWhere(
        (form) =>
            (form as Map<String, dynamic>)['Desc'] == widget.selectedFormDesc,
        orElse: () => _formConfigs[0],
      );
    } else {
      final advancedForm = _formConfigs.firstWhere(
        (form) =>
            (form as Map<String, dynamic>)['Desc']?.contains('پیشرفته') ??
            false,
        orElse: () => _formConfigs[0],
      );
      selectedForm = advancedForm;
    }

    final formMap = selectedForm as Map<String, dynamic>;

    if (formMap.containsKey('Config') && formMap['Config'] is String) {
      final configString = formMap['Config'] as String;

      try {
        // if (!mounted) return;
        // setState(() {
          _selectedFormConfig =
              json.decode(configString) as Map<String, dynamic>;
        // });

        if (_selectedFormConfig!.containsKey('fields')) {
          final fields = _selectedFormConfig!['fields'] as List;

          if (fields.length > 3) {}
        } else {}
      } catch (e) {
        print(e);
      }
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
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),

            //نمایش
            Padding(
              padding: const EdgeInsets.only(
                right: 50,
                left: 0,
                top: 4,
                bottom: 4,
              ),
              child: Text(
                'نمایش',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.right,
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.only(right: 16, top: 4, bottom: 4),
                children: [
                  ..._formConfigs.map((form) {
                    print('TEST');
                    print(form);
                    final formMap = form as Map<String, dynamic>;
                    print(formMap);

                    return ListTile(
                      contentPadding: EdgeInsets.only(
                        right: 70,
                        left: 16,
                        top: 4,
                        bottom: 4,
                      ),
                      dense: true,
                      minVerticalPadding: 0,
                      visualDensity: VisualDensity.compact,

                      title: Text(
                        formMap['Desc'],
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToForm(formMap['Desc']);
                      },
                    );
                  }).toList(),

                  buildCustomDivider(),

                  //منو بیشتر
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      'منو بیشتر',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),

                  //برچسب
                  _buildMenuItem('برچسب', () {
                    _formKey.currentState?.reset();
                    _values.clear();

                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('فرم بازنشانی شد')),
                    // );
                    Navigator.pop(context);
                  }, 'assets/images/calendar.png'),

                  buildCustomDivider(),

                  //چاپ
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'چاپ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),

                  buildCustomDivider(),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildMenuItem('باز نشانی', () {
                        _formKey.currentState?.reset();
                        _values.clear();

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('فرم بازنشانی شد')),
                        // );
                        Navigator.pop(context);
                      }, 'assets/images/refresh.png'),
                      _buildMenuItem('جدید', () {
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
                      }, 'assets/images/add.png'),
                      _buildMenuItem('ذخیره و جدید', () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (widget.onSubmit != null) {
                            widget.onSubmit!(_values);
                          }
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
                      }, 'assets/images/save.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
      contentPadding: EdgeInsets.only(right: 60, left: 16),

      dense: true,
      visualDensity: VisualDensity.compact,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 10),
          Image.asset(
            assetPath,
            package: 'resources_package',
            width: 15,
            height: 15,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final currencyRateCaption = getCurrencyRateCaption();

    return AppBar(
      leading: InkWell(
        onTap: () => _scaffoldKey.currentState?.openEndDrawer(),
        child: paddedIcon('assets/images/more.png'),
      ),
      title: Row(
        children: [
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
          SizedBox(width: 10),
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
          Expanded(child: SizedBox()),
          Text(
            currencyRateCaption + ' - جدید',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(right: 10),
          // color: Colors.yellow,
          child: InkWell(
            onTap: () {},
            child: paddedIcon('assets/images/arrow_back.png'),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFormFields() {
    if (_selectedFormConfig == null ||
        !_selectedFormConfig!.containsKey('fields')) {
      return [Text('فیلدی یافت نشد')];
    }

    final List<dynamic> fields = _selectedFormConfig!['fields'];
    final widgets = <Widget>[];

    fields.sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));

    final fieldsToShow = <Map<String, dynamic>>[];

    final indicesToSkip = <int>{};

    for (var i = 0; i < fields.length; i++) {
      final field = fields[i] as Map<String, dynamic>;
      final fieldType = field['type']?.toString().toLowerCase() ?? 'text';

      if (fieldType == 'noshow') {
        indicesToSkip.add(i);

        if (i + 1 < fields.length) {
          indicesToSkip.add(i + 1);

          i++;
        }
      }
    }

    for (var i = 0; i < fields.length; i++) {
      if (!indicesToSkip.contains(i)) {
        final field = fields[i] as Map<String, dynamic>;
        fieldsToShow.add(field);
      }
    }

    for (var field in fieldsToShow) {
      final fieldMap = field;
      final fieldName = fieldMap['name']?.toString() ?? '';
      final fieldType = fieldMap['type']?.toString().toLowerCase() ?? 'text';

      if (fieldType == 'radio') {
        final radioOptions =
            (fieldMap['radioValues'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

        final rules = fieldMap['rules'] as List? ?? [];
        final isRequired = rules.any(
          (rule) =>
              rule is Map &&
              (rule['required'] == true || rule['rule'] == 'required'),
        );

        widgets.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: RadioInputField(
              caption: fieldMap['caption']?.toString() ?? '',
              help: fieldMap['help']?.toString() ?? '',
              fieldName: fieldName,
              options: radioOptions,
              onChanged: (value) {
                // if (!mounted) return;
                // setState(() {
                  _values[fieldName] = value;
                // });
              },
              initialValue: _values[fieldName] ?? fieldMap['defaultValue'],
              isRequired: isRequired,
            ),
          ),
        );
        continue;
      }

      final selectEndpointData = fieldMap['selectEndpoint'];
      final selectEndpoint =
          (selectEndpointData != null &&
              selectEndpointData is Map &&
              selectEndpointData.isNotEmpty)
          ? _convertSelectEndpoint(selectEndpointData)
          : null;

      final fieldModel = Field(
        name: fieldName,
        caption: fieldMap['caption']?.toString() ?? '',
        help: fieldMap['help']?.toString() ?? '',
        type: fieldType,
        placeHolder: fieldMap['placeHolder']?.toString() ?? '',
        defaultValue: fieldMap['defaultValue']?.toString() ?? '',
        showId: false,
        radioValues: [],
        order: fieldMap['order'] ?? 0,
        selectEndpoint: selectEndpoint,
        options: _convertOptions(fieldMap['options']),
        rules: _convertRules(fieldMap['rules']),
        icon: null,
        idValue: 0,
      );

      dynamic initialValue = _values[fieldName] ?? fieldModel.defaultValue;

      if (fieldType == 'treeoption' || fieldType == 'selectoption') {
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
          final label = _values['${fieldName}_label'];
          final path = _values['${fieldName}_path'];

          if (initialValue != null || label != null) {
            initialValue = {
              'value': initialValue,
              'label': label ?? initialValue?.toString() ?? '',
            };
            if (fieldType == 'treeoption' && path != null) {
              (initialValue)['path'] = path;
            }
          }
        }
      }

      if (!_values.containsKey(fieldName) && initialValue != null) {
        _values[fieldName] = initialValue;
      }

      final showWithoutBorder =
          fieldType == 'checkbox' ||
          fieldType == 'treeoption' ||
          fieldType == 'selectoption';

      if (showWithoutBorder) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FieldRenderer(
              field: fieldModel,
              onChanged: (value) {
                // if (!mounted) return;
                // setState(() {
                  if (fieldType == 'treeoption' && value is Map) {
                    _values[fieldName] = value['value'];
                    _values['${fieldName}_label'] = value['label'];
                    _values['${fieldName}_path'] = value['path'];
                  } else if (fieldType == 'selectoption' && value is Map) {
                    _values[fieldName] = value['value'];
                    _values['${fieldName}_label'] = value['label'];
                  } else {
                    _values[fieldName] = value;
                  }
                // });
              },
              initialValues: {fieldName: initialValue ?? ''},
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white),
              child: FieldRenderer(
                field: fieldModel,
                onChanged: (value) {
                  if (!mounted) return;
                    // setState(() {
                      _values[fieldName] = value;
                    // });

                },
                initialValues: {fieldName: initialValue ?? ''},
              ),
            ),
          ),
        );
      }
    }

    return widgets;
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

  List<Rule> _convertRules(dynamic rules) {
    if (rules == null) return [];

    final converted = <Rule>[];

    if (rules is List) {
      for (var rule in rules) {
        if (rule is Map) {
          final ruleName = rule['rule']?.toString();
          final isRequired = rule['required'] == true || ruleName == 'required';

          converted.add(
            Rule(
              name: ruleName ?? rule['name']?.toString() ?? '',
              condition: rule['condition']?.toString(),
              message: rule['message']?.toString() ?? '',
              required: isRequired,
              type: rule['type']?.toString() ?? (isRequired ? 'required' : ''),
              len: (rule['len'] as int?) ?? 0,
            ),
          );
        }
      }
    }

    return converted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: _buildDrawer(),
      body: SafeArea(
        child: _selectedFormConfig == null
            ? Center(child: Text('خطا در بارگذاری فرم'))
            : Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(children: [..._buildFormFields()]),
                  ),
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
