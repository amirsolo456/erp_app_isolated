// ignore_for_file: library_prefixes

import 'package:erp_app/feature/list_generator/data/models/field_display_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/data/com/person/person.dart' as person;
import 'package:shared_core/index.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Expanders/list_datas_expander.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../list_generator/data/models/generic_list_entity_state.dart';

class Person extends ChangeNotifier {
  final int id;
  final String name;
  final String email;
  final String phone;
  final DateTime birthDate;
  final double salary;

  Person({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.salary,
  });
}

final personFieldConfigs = <String, FieldDisplayConfig<Person>>{
  'id': FieldDisplayConfig<Person>(
    label: 'شناسه',
    valueGetter: (person) => person.id.toString(),
    width: 80,
    isSortable: true,
  ),
  'name': FieldDisplayConfig<Person>(
    label: 'نام',
    valueGetter: (person) => person.name,
    width: 150,
    isSortable: true,
  ),
  'email': FieldDisplayConfig<Person>(
    label: 'ایمیل',
    valueGetter: (person) => person.email,
    cellBuilder: (value) => InkWell(
      onTap: () => launchUrl(
        Uri(path: 'mailto:${value}'),
        mode: LaunchMode.platformDefault,
      ),
      child: Text(value, style: const TextStyle(color: Colors.blue)),
    ),
  ),
  'phone': FieldDisplayConfig<Person>(
    label: 'تلفن',
    valueGetter: (person) => person.phone,
    cellBuilder: (value) => Row(
      children: [
        const Icon(Icons.phone, size: 16),
        const SizedBox(width: 4),
        Text(value),
      ],
    ),
  ),
  'birthDate': FieldDisplayConfig<Person>(
    label: 'تاریخ تولد',
    valueGetter: (person) => '',
    isSortable: true,
  ),
  'salary': FieldDisplayConfig<Person>(
    label: 'حقوق',
    valueGetter: (person) => '',
    cellBuilder: (value) => Text(
      '$value تومان',
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
    ),
    isSortable: true,
  ),
};

class PersonsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<
      GenericListEntityState<
        person.Response,
        person.ResponseData,
        person.Request
      >
    >(
      create: (context) =>
          GenericListEntityState<
            person.Response,
            person.ResponseData,
            person.Request
          >(
            totalCount: 0,
            request: person.Request(repoViewId: 0),
            loading: false,
            response: null,
            fields: [],
          ),
      child:
          Consumer<
            GenericListEntityState<BaseResponse<Person>, Person, BaseRequest>
          >(
            builder: (context, state, child) {
              return _GenericEntityScreenInternal<Person>(
                state: state,
                fieldConfigs: personFieldConfigs,
              );
            },
          ),
    );
  }
}

class _GenericEntityScreenInternal<D> extends StatelessWidget {
  final GenericListEntityState state;
  final Map<String, FieldDisplayConfig<D>> fieldConfigs;

  const _GenericEntityScreenInternal({
    Key? key,
    required this.state,
    required this.fieldConfigs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = state.fetchData as List<D>;

    return Scaffold(
      body: Column(
        children: [
          // ... نوار آمار و ...
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final firstField = fieldConfigs.values.first;
                return PersonExpander(person: item as person.ResponseData);
              },
            ),
          ),
        ],
      ),
    );
  }
}
