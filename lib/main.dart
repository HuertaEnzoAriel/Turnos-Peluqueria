import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/app_theme.dart';
import 'src/pages/routes/routes.dart';
import 'src/services/supabase_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    publishableKey: dotenv.get('SUPABASE_PUBLISHABLE_KEY'),
  );
  // Cierra la sesión restaurada si no se pidió mantenerla o ya expiró
  await revisarSesion();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peluquería',
      theme: appTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es', 'ES')],
      // Supabase guarda la sesión en el dispositivo y la restaura en initialize();
      // revisarSesion() ya la cerró si correspondía.
      // Si queda sesión, se entra directo a 'home'; si no, al login.
      // Cada toque o gesto en cualquier pantalla (también diálogos y selectores)
      // cuenta como actividad y reinicia los 5 minutos de la sesión
      builder: (context, child) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => registrarActividad(),
        onPointerMove: (_) => registrarActividad(),
        child: child,
      ),
      initialRoute: Supabase.instance.client.auth.currentSession != null ? 'home' : '/',
      routes: getAplicationRoutes(),
    );
  }
}
