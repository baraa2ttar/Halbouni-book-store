import 'package:supabase_flutter/supabase_flutter.dart';

abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

/// Maps a raw thrown error to a user-facing message.
///
/// Avoids leaking raw `e.toString()` frames to the UI. Supabase exceptions
/// already carry a human-readable `message` (e.g. an RPC `raise exception`
/// text), so those are surfaced directly; everything else becomes a generic
/// message.
String failureMessage(Object error) {
  if (error is PostgrestException) {
    final message = error.message.trim();
    if (message.isNotEmpty) return message;
    if (error.details != null) return error.details.toString();
    return 'Something went wrong. Please try again.';
  }
  if (error is AuthException) {
    final message = error.message.trim();
    if (message.isNotEmpty) return message;
    return 'Authentication failed. Please try again.';
  }
  return 'Something went wrong. Please try again.';
}