import 'package:redux/redux.dart';

import '../models/fireMapState.dart';
import 'actions.dart';

final fireMapReducer = combineReducers<FireMapState>([
  new TypedReducer<FireMapState, ShowYourLocationMapAction>(
      _showYourLocationMap),
]);

FireMapState _showYourLocationMap(
    FireMapState state, ShowYourLocationMapAction action) {
  if (action.loc.subscribed) {
    return state.copyWith(
        status: action.loc.subscribed
            ? FireMapStatus.unsubscribe
            : FireMapStatus.view,
        yourLocation: action.loc);
  }
}
