import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yugioh_app/view/yugioh_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Modo imersivo: esconde as barras do sistema e as recolhe automaticamente após interação
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(MaterialApp(
    home: const YugiohPage(),
    debugShowCheckedModeBanner: false,
  ));
}
