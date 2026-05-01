import 'package:flutter/widgets.dart';

const double _tabletBreakpoint = 600.0;

bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= _tabletBreakpoint;

/// Dar ekran için [phone], geniş ekran (≥600dp) için [tablet] döndürür.
T responsive<T>(BuildContext context, {required T phone, required T tablet}) =>
    isTablet(context) ? tablet : phone;
