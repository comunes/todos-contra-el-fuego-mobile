import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:meta/meta.dart';

final esRegExp = new RegExp("^es-");

String getFallbackLang(String lang)  {
  if (lang == 'ast' || lang == 'gl' || lang == 'eu' ||
    lang == 'es' || lang == 'ca' || (esRegExp).allMatches(lang).length > 0) {
    return 'es';
  }
  return 'en';
}

Future<String> getFileNameOfLang({@required String dir,@required  String fileName,@required  String ext,@required  String lang}) async {
  String base = '$dir/$fileName';
  String fallback = getFallbackLang(lang);
  String file = '${base}-${lang}.${ext}';
  if (await assetNotExists(file)) {
    file = '${base}-${fallback}.${ext}';
    if (await assetNotExists(file)) {
      file = '${base}.${ext}';
    }
  }
  return file;
}

// https://github.com/flutter/flutter/issues/15325
Future<bool> assetNotExists(String asset) {
  print('Does not exists $asset ?');
  return rootBundle.load(asset).then((_) => false).catchError((err, stack) { print (err); print(stack); return true;});
}