// lib/core/network/get_it_bloc_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ✅ این خط را اضافه کنید

class GetItBlocProvider<T extends BlocBase> extends StatefulWidget {
  final Widget child;
  final T Function() getter;

  const GetItBlocProvider({Key? key, required this.child, required this.getter})
      : super(key: key);

  @override
  _GetItBlocProviderState<T> createState() => _GetItBlocProviderState<T>();
}

class _GetItBlocProviderState<T extends BlocBase>
    extends State<GetItBlocProvider<T>> {
  late T bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.getter();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>.value(
      // ✅ حالا BlocProvider شناخته می‌شود
      value: bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    bloc.close(); // بستن Bloc هنگام حذف ویجت
    super.dispose();
  }
}
