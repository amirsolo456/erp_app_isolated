import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/index.dart' as prefix0;

import '../blocs/generic_cubit.dart';

class GenericPage<
  P extends GenericBloc<T, D, C>,
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends StatefulWidget {
  final P Function() createBloc;
  final Widget Function(BuildContext context, GenericState state, T bloc)
  builder;
  final bool autoLoad;
  final VoidCallback? onRefresh;

  const GenericPage({
    Key? key,
    required this.createBloc,
    required this.builder,
    this.autoLoad = true,
    this.onRefresh,
  }) : super(key: key);

  @override
  _GenericPageState<P, T, D, C> createState() =>
      _GenericPageState<P, T, D, C>();
}

class _GenericPageState<
  P extends GenericBloc<T, D, C>,
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends State<GenericPage<P, T, D, C>> {
  late P _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.createBloc();
    if (widget.autoLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bloc.loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<P>(
      create: (context) => _bloc,
      child: Scaffold(
        body: BlocBuilder<P, GenericState>(
          builder: (context, state) {
            final bloc = context.read<T>();
            return widget.builder(context, state, bloc);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
