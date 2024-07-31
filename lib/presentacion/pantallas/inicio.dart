import 'package:color_app/presentacion/pantallas/juego.dart'; // Importa la pantalla del juego
import 'package:color_app/presentacion/pantallas/juegopersonalizado.dart'; // Importa la pantalla de juego personalizado
import 'package:color_app/presentacion/pantallas/records.dart'; // Importa la pantalla de records
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y estilos

// Define la pantalla inicial que se muestra al abrir la aplicación
class PantallaInicial extends StatelessWidget {
  const PantallaInicial({super.key}); // Constructor de la pantalla inicial

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'ColorApp', // Título de la aplicación en la barra superior
            style: TextStyle(color: Colors.white), // Estilo del texto del título
          ),
        ),
        backgroundColor: Colors.blue, // Color de fondo de la barra superior
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
          children: [
            const Text('Bienvenido a ', style: TextStyle(fontSize: 30)), // Texto de bienvenida
            const Text('ColorApp', style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 0, 132, 255))), // Texto del nombre de la aplicación con color personalizado
            Image.asset(
              "assets/images/LogoApp.png", // Ruta de la imagen del logo
              width: 1920, // Ancho de la imagen
              height: 300, // Altura de la imagen
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start, // Alinea los botones al inicio del contenedor
              children: [
                CustomButton1(
                  icon: Icons.sports_esports, // Icono para el botón de iniciar juego
                  text: 'Iniciar Juego', // Texto del botón
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Juego()), // Navega a la pantalla de juego al presionar el botón
                    );
                  },
                ),
                const SizedBox(width: 10.0), // Espacio entre los botones
                CustomButton1(
                  icon: Icons.settings_sharp, // Icono para el botón de juego personalizado
                  text: 'Juego Personalizado', // Texto del botón
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const JuegoPersonalizado()), // Navega a la pantalla de juego personalizado al presionar el botón
                    );
                  },
                ),
                CustomButton1(
                  icon: Icons.emoji_events, // Icono para el botón de mejores records
                  text: 'Mejores Records', // Texto del botón
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RecordsPantalla()), // Navega a la pantalla de records al presionar el botón
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Define un widget de botón personalizado
class CustomButton1 extends StatelessWidget {
  final IconData icon; // Icono del botón
  final String text; // Texto del botón
  final VoidCallback? onPressed; // Acción a realizar cuando se presiona el botón

  const CustomButton1({
    super.key,
    required this.icon,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed, // Acción que se ejecuta al presionar el botón
      icon: Icon(icon), // Icono del botón
      label: Text(text), // Texto del botón
      style: TextButton.styleFrom(
        foregroundColor: Colors.white, // Color del texto y del icono del botón
        backgroundColor: Colors.blue, // Color de fondo del botón
        padding: const EdgeInsets.symmetric(horizontal: 10.0), // Espaciado interno del botón
      ),
    );
  }
}
