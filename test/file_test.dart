import 'package:test/test.dart';
import 'package:fires_flutter/fileUtils.dart';

void main() {
  test('test es-ES fallback', () {
    String answer = getFallbackLang('es-ES');
    expect(answer, 'es');
  });

  test('test en-GB fallback', () {
    String answer = getFallbackLang('en-GB');
    expect(answer, 'en');
  });

  test('test gl fallback', () {
    String answer = getFallbackLang('gl');
    expect(answer, 'es');
  });

  test('test fr fallback', () {
    String answer = getFallbackLang('fr');
    expect(answer, 'en');
  });

  test('test privacy English md page', () async {
    String answer = await getFileNameOfLang(dir: 'assets/pages', fileName: 'privacy', ext: 'md', lang: 'en');
    expect(answer, 'assets/pages/privacy-en.md');
  });

}
