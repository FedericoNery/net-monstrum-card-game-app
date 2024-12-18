import 'package:flutter/material.dart';

void showError(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade600,
      content: Text(
        message ?? "Ocurrió un error",
      )));
}

void showSuccess(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green.shade900,
      content: Text(
        message ?? "Realizó la acción correctamente",
      )));
}

void showWarning(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 2),
      backgroundColor: Colors.amber.shade600,
      content: Text(
        message ?? "Ocurrió un error",
      )));
}

void showDefault(BuildContext context, String? message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    message ?? "Ocurrió un error no identificado",
  )));
}
