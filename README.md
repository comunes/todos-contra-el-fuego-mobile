# fires_flutter

All Against Fire

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


- google-services.json
- Manifest sample
- private keys in assets
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/i18n.dart
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/i18n.dart lib/l10n/intl_*.arb 
