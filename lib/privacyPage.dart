import 'package:flutter/material.dart';

import 'fileUtils.dart';
import 'generated/i18n.dart';
import 'markdownPage.dart';

class PrivacyPage extends MarkdownPage {
  static const String routeName = '/privacy';

  PrivacyPage(context)
      : super(
            title: S.of(context).privacyPolicy,
            file: getFileNameOfLang(
                dir: 'assets/pages',
                fileName: 'privacy',
                ext: 'md',
                lang: Localizations.localeOf(context).languageCode));
}
