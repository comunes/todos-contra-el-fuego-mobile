# Tod@s contra el Fuego (All Against Fire) mobile

This is app that notifies about fires detected in an area of your interest. It helps the early detection of fires and facilitates local mobilization, while the professional extinction services arrive.

## Install

Via Play

## Development

This app is developed with [flutter](https://flutter.io/). So if you want to contribute, please install it.

You also needs a:
- `assets/private-settings.json` see `assets/private-settings-sample.json`.
- `google-services.json` provided by firebase console.

Some json related code is generated via
```
flutter packages pub run build_runner build
```
also you can run with `watch` instead of `build` to build with any code change.

## Testing

Run `flutter test` for doing unit testing.

## Data source acknowledgements

*We acknowledge the use of data and imagery from LANCE FIRMS operated by the NASA/GSFC/Earth Science Data and Information System (ESDIS) with funding provided by NASA/HQ*.

## License

GNU APLv3. See our [LICENSE](https://github.com/comunes/todos-contra-el-fuego-web/blob/tcef-master/LICENSE.md), for a complete text.

## Thanks & other acknowlegments

(...)

flutter packages pub run build_runner build --delete-conflicting-outputs
