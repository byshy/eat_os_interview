import 'package:flutter/material.dart';

const BoxDecoration curvedContainer = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(35),
  ),
);

OutlineInputBorder _border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(6),
  borderSide: BorderSide(color: Colors.transparent),
);

InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.grey[200],
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
  border: _border,
  enabledBorder: _border,
  focusedBorder: _border.copyWith(
    borderSide: BorderSide(
      width: 1.5,
    ),
  ),
  errorBorder: _border.copyWith(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
  ),
  focusedErrorBorder: _border.copyWith(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
  ),
  disabledBorder: _border,
);
