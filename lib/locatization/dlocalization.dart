import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalization {
  final Locale local;
  DemoLocalization(this.local);

  static DemoLocalization? of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  late Map<String, String> _localizedValues;

  Future load() async {
    String jsonString =
        await rootBundle.loadString('lib/lang/${local.languageCode}.json');

    Map<String, dynamic> mappedjson = json.decode(jsonString);
    _localizedValues =
        mappedjson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<DemoLocalization> delegate =
      _DemoLocalizationsDelegate();
}

class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    DemoLocalization localization = DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}



// class DemoLocalization {
//   final Locale local;
//   DemoLocalization(this.local);

//   static DemoLocalization? of(BuildContext context) {
//     return Localizations.of<DemoLocalization>(context, DemoLocalization);
//   }

//   Map<String,String>_localizedValues;
//   Future load() async{
//     String jsonString=await rootBundle.loadString('lib/lang/${local.languageCode}.json');

//     Map<String,dynamic>  mappedjson=json.decode(jsonString);
//     _localizedValues= mappedjson.map((key, value) => MapEntry(key, value.toString()));
//   }


//     String? gettranslatedvalue(String key){
//   return  _localizedValues[key];

//     }

//     static const LocalizationsDelegate<DemoLocalization> delegate= _DemoLocalizationsDelegate();
// }




// class _DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalization>{
//   const _DemoLocalizationsDelegate();
//   @override
//   bool isSupported(Locale locale) {
//    return ['en','hi'].contains(locale.languageCode);

//   }

//   @override
//   Future <DemoLocalization>load(Locale locale)async {
//    DemoLocalization localization= DemoLocalization(locale);
//    await localization.load();
//    return localization;
//   }

//   @override
//   bool shouldReload(covariant LocalizationsDelegate old) => false;


  
  
// }