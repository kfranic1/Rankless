import 'package:flutter/material.dart';

class KeepAliveThis extends StatefulWidget {
  KeepAliveThis({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAliveThisState createState() => _KeepAliveThisState();
}

class _KeepAliveThisState extends State<KeepAliveThis> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
