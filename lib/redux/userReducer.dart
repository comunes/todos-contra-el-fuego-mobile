import 'actions.dart';
import '../models/user.dart';

User userReducer(User user, action) {
  if (action is OnUserCreatedAction) return user.copyWith(userId: action.userId);
  if (action is OnUserTokenAction) return user.copyWith(token: action.token);
  if (action is OnUserLangAction) return user.copyWith(lang: action.lang);
  return user;
}
