import 'package:meta/meta.dart';
import 'package:comunes_flutter/comunes_flutter.dart';

@immutable
class User {
  final String userId;
  final String lang;
  final String token;

  const User.initial()
      : this.userId = null,
        lang = null,
        token = null;

  User({this.userId, this.lang, this.token});

  User copyWith({String userId, String lang, String token}) {
    return new User(
        userId: userId ?? this.userId,
        token: token ?? this.token,
        lang: lang ?? this.lang);
  }

  @override
  String toString() {
    return 'User {userId: $userId, lang: $lang, token: ${ellipse(token)}';
  }

}
