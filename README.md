# Tod@s contra el Fuego (All Against Fire) mobile

This is app that notifies about fires detected in an area of your interest. It helps the early detection of fires and facilitates local mobilization, while the professional extinction services arrive.

## Install

Via Play

## Development

This app is developed with [flutter](https://flutter.io/). So if you want to contribute, please install it.

You also needs a:
- `assets/private-settings.json` see `assets/private-settings-sample.json`.
- `google-services.json` provided by firebase console (see also the sample).

Some json related code is generated via
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```
also you can run with `watch` instead of `build` to build with any code change.

Generate apk with:
```
flutter build apk -t lib/mainProd.dart --flavor production
```
also you can run with `-t lib/mainDev.dart --flavor development`. More info about flavors [here](https://medium.com/@salvatoregiordanoo/flavoring-flutter-392aaa875f36).

## Testing

Run `flutter test` for doing unit testing.

## Data source acknowledgements

*We acknowledge the use of data and imagery from LANCE FIRMS operated by the NASA/GSFC/Earth Science Data and Information System (ESDIS) with funding provided by NASA/HQ*.

## License

GNU APLv3. See our [LICENSE](https://github.com/comunes/todos-contra-el-fuego-web/blob/tcef-master/LICENSE.md), for a complete text.

## Thanks & other acknowlegments

(...)
