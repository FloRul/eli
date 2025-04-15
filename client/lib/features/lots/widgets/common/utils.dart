import 'package:client/features/lots/models/enums.dart';
import 'package:flutter/material.dart';

/// Returns a color based on the lot status
Color getStatusColor(Status status) {
  switch (status) {
    case Status.critical:
      return Colors.red.shade700;
    case Status.closefollowuprequired:
      return Colors.orange.shade700;
    case Status.ongoing:
      return Colors.blue.shade700;
    case Status.onhold:
      return Colors.grey.shade600;
    case Status.completed:
      return Colors.green.shade700;
  }
}

/// Returns a color based on the incoterm
Color getIncotermsColor(Incoterm incoterms) {
  String name = incoterms.name.toString().toLowerCase();
  if (name.contains('fob')) return Colors.purple.shade700;
  if (name.contains('cif')) return Colors.blue.shade700;
  if (name.contains('ex')) return Colors.teal.shade700;
  if (name.contains('dap')) return Colors.indigo.shade700;
  return Colors.blueGrey.shade700;
}
