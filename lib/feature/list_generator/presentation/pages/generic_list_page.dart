import 'package:erp_app/feature/list_generator/data/models/field_display_config.dart';
import 'package:erp_app/feature/list_generator/data/models/generic_list_entity_state.dart';
import 'package:flutter/material.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Expanders/list_datas_expander.dart';
import 'package:shared_core/data/com/person/person.dart' as person;

class GenericListPage<D> extends StatefulWidget {
  final FieldDisplayConfig<D> fieldConfigs;
  final String screenTitle;
  final Widget Function(D item)? customItemBuilder;
  final bool enablePagination;
  final bool enableSearch;
  final bool enableSorting;
  final Future<GenericListEntityState> Function()? onFetchData;

  const GenericListPage({
    Key? key,
    required this.fieldConfigs,
    this.screenTitle = 'لیست داده‌ها',
    this.customItemBuilder,
    this.enablePagination = true,
    this.enableSearch = true,
    this.enableSorting = true,
    this.onFetchData,
  }) : super(key: key);

  @override
  _GenericEntityScreenState<D> createState() => _GenericEntityScreenState<D>();
}

class _GenericEntityScreenState<D> extends State<GenericListPage<D>> {
  GenericListEntityState? _state;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newState = await widget.onFetchData!();
      setState(() {
        _state = newState;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      _error = null;
    }

    if (_state == null || _state!.fetchData.isEmpty) {
      return const Center(child: Text('داده‌ای یافت نشد'));
    }
    return _buildContent(_state!);
  }

  Widget _buildContent(GenericListEntityState state) {
    var data = state.fetchData as List<D>;
    return Container(
      color: Colors.transparent,
      child: Expanded(
        child: ListView.builder(
          itemCount: data.length,

          padding: EdgeInsetsGeometry.all(10),
          primary: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            if (D is person.ResponseData) {
              final item = data[index] as person.ResponseData;

              if (widget.customItemBuilder != null) {
                return widget.customItemBuilder!.call(item as D);
              }

              // final firstField = widget.fieldConfigs;
              ListDataExpander(data: (item).toJson());
            }

            return null;
            // return ListTile(title: Text(firstField.valueGetter(item)));
          },
        ),
      ),
    );
  }
}
