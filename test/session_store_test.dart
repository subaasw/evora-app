import 'package:flutter_test/flutter_test.dart';

import 'package:evora/data/mock/session_store.dart';

void main() {
  test('signIn without a name derives one from the email local part', () {
    final s = SessionStore()..signIn(email: 'alex.tan@mail.com');
    expect(s.name, 'Alex Tan');
    expect(s.email, 'alex.tan@mail.com');
    expect(s.initials, 'AT');
  });

  test('explicit name wins and update overwrites the session', () {
    final s = SessionStore()..signIn(name: 'Maya R', email: 'x@y.com');
    expect(s.name, 'Maya R');
    expect(s.initials, 'MR');

    s.update(name: 'New Name', email: 'new@y.com', phone: '123');
    expect(s.name, 'New Name');
    expect(s.email, 'new@y.com');
    expect(s.phone, '123');
  });

  test('empty session reads as the default attendee, signOut resets it', () {
    final s = SessionStore();
    expect(s.name, 'Subash Giri');
    expect(s.email, 'subash.giri@gmail.com');

    s.signIn(email: 'a@b.com');
    s.signOut();
    expect(s.name, 'Subash Giri');
  });
}
