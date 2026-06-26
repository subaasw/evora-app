import 'package:flutter/foundation.dart';

/// The signed-in attendee for this app session. UI-only: typing an email on
/// login/signup "creates" the account in memory; nothing is persisted.
class SessionStore extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _phone = '';

  // Default demo attendee until someone signs in with their own email.
  String get name => _name.isEmpty ? 'Subash Giri' : _name;
  String get email => _email.isEmpty ? 'subash.giri@gmail.com' : _email;
  String get phone => _phone;

  /// First letters of up to two name words, e.g. "Alex Tan" -> "AT".
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (parts.isEmpty) return '?';
    final letters = parts.take(2).map((w) => w[0].toUpperCase()).join();
    return letters;
  }

  /// Sign in / create account for the session. Missing name is derived from
  /// the email's local part so the profile never reads empty.
  void signIn({String? name, required String email, String? phone}) {
    _email = email.trim();
    final n = name?.trim() ?? '';
    _name = n.isNotEmpty ? n : _nameFromEmail(_email);
    if (phone != null && phone.trim().isNotEmpty) _phone = phone.trim();
    notifyListeners();
  }

  void update({required String name, required String email, required String phone}) {
    _name = name.trim();
    _email = email.trim();
    _phone = phone.trim();
    notifyListeners();
  }

  void signOut() {
    _name = '';
    _email = '';
    _phone = '';
    notifyListeners();
  }

  // "subash.giri@x.com" -> "Subash Giri"
  static String _nameFromEmail(String email) {
    final local = email.split('@').first;
    final words = local.split(RegExp(r'[._\-]+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return 'Subash Giri';
    return words.map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
