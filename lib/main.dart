import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/app_theme.dart';
import 'data/demo_store.dart';
import 'pages/shell_page.dart';
import 'pages/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final store=DemoStore();
  await store.initialize();
  runApp(RsgmComalApp(store:store));
}

class RsgmComalApp extends StatelessWidget {
  final DemoStore store;
  const RsgmComalApp({super.key,required this.store});
  @override Widget build(BuildContext context)=>MaterialApp(
    title:'RSGM COMAL',debugShowCheckedModeBanner:false,theme:appTheme(),
    home:AnimatedBuilder(animation:store,builder:(context,_)=>store.patient==null?WelcomePage(store:store):ShellPage(store:store)),
  );
}
