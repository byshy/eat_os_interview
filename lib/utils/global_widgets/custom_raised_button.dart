import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Widget child;
  final Color color;
  final bool borderStyle;

  const CustomRaisedButton({
    Key key,
    @required this.onTap,
    this.onLongPress,
    @required this.child,
    this.borderStyle = false,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50,
      child: RaisedButton(
        onPressed: onTap,
        onLongPress: onLongPress,
        child: child,
        color: borderStyle ? Color(0x00FFFFFF) : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          side: borderStyle ? BorderSide(color: Colors.white) : BorderSide.none,
        ),
      ),
    );
  }
}
