//Importa las bibliotecas necesarias para su correcto funcionamiento
import 'package:color_app/presentacion/pantallas/juego.dart';
import 'package:color_app/presentacion/pantallas/juegopersonalizado.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:color_app/funciones/logica.dart';
import 'package:color_app/funciones/guardar_record.dart';
import 'package:color_app/presentacion/pantallas/inicio.dart';
import 'package:color_app/presentacion/pantallas/records.dart';

void main() {
  runApp(
    MultiProvider(
      // MultiProvider permite proporcionar múltiples objetos a la aplicación.
      providers: [
        ChangeNotifierProvider(create: (context) => RecordsNotifier()), // Proporciona el objeto RecordsNotifier para manejar los records.
        ChangeNotifierProvider(create: (context) => JuegoLogica()), // Proporciona el objeto JuegoLogica para manejar la lógica del juego.
      ],
      child: const MyApp(), // El widget principal de la aplicación.
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor de MyApp.

  @override
  Widget build(BuildContext context) {
    // Construye el widget principal de la aplicación.
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración en la esquina superior derecha.
      theme: ThemeData(
        useMaterial3: true, // Utiliza el diseño de Material 3 para la apariencia de la aplicación.
        colorSchemeSeed: const Color.fromARGB(255, 11, 112, 228), // Define un color base para la aplicación.
      ),
      home: const PantallaInicial(), // Pantalla inicial que se muestra cuando se abre la aplicación.
      routes: {
        // Definición de rutas para la navegación en la aplicación.
        '/inicio': (context) => const PantallaInicial(), // Ruta para la pantalla inicial.
        '/records': (context) => const RecordsPantalla(), // Ruta para la pantalla de records.
        '/juego': (context) => const Juego(), // Ruta para la pantalla del juego.
        '/juegopersonalizado': (context) => const JuegoPersonalizado(), // Ruta para la pantalla del juego personalizado.
      },
    );
  }
}