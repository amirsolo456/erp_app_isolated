import 'package:flutter/material.dart';

import 'package:shared_core/index.dart';
import '../../validation/rule_mapper.dart';
import '../common/field_title.dart';

class SelectOptionField extends StatefulWidget {
  final Field field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

  const SelectOptionField({
    Key? key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  }) : super(key: key);

  @override
  _SelectOptionFieldState createState() => _SelectOptionFieldState();
}

class _SelectOptionFieldState extends State<SelectOptionField> {
  dynamic _selectedValue;
  String _selectedLabel = '';
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  void _initializeValue() {
    final initialValue = widget.initialValues[widget.field.name];

    if (initialValue != null && initialValue.toString().isNotEmpty) {
      if (initialValue is Map) {
        final value = initialValue['value'];
        final label = initialValue['label'];

        final hasValue = value != null && value.toString().isNotEmpty;
        final hasLabel = label != null && label.toString().isNotEmpty;

        if (hasValue || hasLabel) {
          _selectedValue = value ?? label;
          _selectedLabel = label?.toString() ?? value?.toString() ?? '';
        }
      } else {
        _selectedValue = initialValue;
        final labelKey = '${widget.field.name}_label';
        if (widget.initialValues.containsKey(labelKey)) {
          _selectedLabel = widget.initialValues[labelKey]?.toString() ?? '';
        }
      }
    }

    _isInitialized = true;
  }

  Future<void> _navigateToSelectionPage() async {
    if (widget.field.selectEndpoint == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(Duration(milliseconds: 500));
      await _showSampleSelectionPage();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطا در بارگذاری داده‌ها'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showSampleSelectionPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SampleSelectionPage(field: widget.field),
      ),
    );

    if (result != null && result is Map) {
      _onItemSelected(result['value'], result['label']);
    }
  }

  void _onItemSelected(dynamic value, String label) {
    setState(() {
      _selectedValue = value;
      _selectedLabel = label;
    });

    widget.onChanged({'value': value, 'label': label});
  }

  void _clearSelection() {
    setState(() {
      _selectedValue = null;
      _selectedLabel = '';
    });
    widget.onChanged(null);
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = RuleMapper.isRequired(widget.field.rules);

    if (!_isInitialized) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        FieldTitle(
          caption: widget.field.caption ?? '',
          help: widget.field.help,
          isRequired: isRequired,
        ),

        // فیلد انتخاب
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [

              Expanded(
                child: InkWell(
                  onTap: _isLoading ? null : _navigateToSelectionPage,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getDisplayText(),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        if (_isLoading)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),


              if (_selectedValue != null && !_isLoading)
                IconButton(
                  icon: Icon(Icons.clear, size: 20),
                  onPressed: _clearSelection,
                  color: Colors.grey[600],
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (_selectedValue == null) {
      return 'انتخاب کنید';
    }

    if (_selectedLabel.isNotEmpty) {
      return _selectedLabel;
    }

    return _selectedValue.toString();
  }


}

class _SampleSelectionPage extends StatefulWidget {
  final Field field;

  const _SampleSelectionPage({required this.field});

  @override
  __SampleSelectionPageState createState() => __SampleSelectionPageState();
}

class __SampleSelectionPageState extends State<_SampleSelectionPage> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    await Future.delayed(Duration(milliseconds: 800));

    setState(() {
      _items = List.generate(20, (index) {
        return {
          'id': index + 1,
          'name': 'آیتم ${index + 1}',
          'description': 'توضیحات برای آیتم ${index + 1}',
        };
      });
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;

    return _items.where((item) {
      final name = item['name']?.toString() ?? '';
      final description = item['description']?.toString() ?? '';
      return name.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: Color(0xff848484),
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _searchQuery = '';
                  });
                  _loadItems();
                },
              ),


              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Flexible(
                        child: Text(
                          widget.field.caption.toString() + ' را انتخاب کنید',
                          style: TextStyle(
                            color: Color(0xff848484),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),


                      IconButton(
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Color(0xff848484),
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.all(0),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: _searchQuery.isNotEmpty
                    ? Border.all(
                  color: Colors.black,
                  width: 1.0,
                )
                    : null,
              ),
              child: Row(
                children: [

                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12)),


                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'جستجو',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff848484),
                        ),
                        hintTextDirection: TextDirection.rtl,

                        border: InputBorder.none,

                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        color: _searchQuery.isNotEmpty
                            ? Colors.black
                            : Colors.black87,
                      ),
                    ),
                  ),


                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      color: Colors.grey[600],
                    ),
                ],
              ),
            ),
          ),


          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _searchQuery.isEmpty
                        ? 'داده‌ای برای نمایش وجود ندارد'
                        : 'نتیجه‌ای برای "$_searchQuery" یافت نشد',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      item['name'],
                      textAlign: TextAlign.right,

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  onTap: () {
                    Navigator.pop(context, {
                      'value': item['id'],
                      'label': item['name'],
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
