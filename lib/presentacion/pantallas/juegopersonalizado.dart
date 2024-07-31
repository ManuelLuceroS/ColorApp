import 'package:color_app/presentacion/pantallas/juego.dart'; // Importa la pantalla del juego
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y estilos
import 'package:provider/provider.dart'; // Importa Provider para manejar el estado
import 'package:color_app/funciones/logica.dart'; // Importa la lógica del juego

// Define la pantalla de configuración del juego personalizado
class JuegoPersonalizado extends StatefulWidget {
  const JuegoPersonalizado({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JuegoPersonalizadoState createState() => _JuegoPersonalizadoState();
}

class _JuegoPersonalizadoState extends State<JuegoPersonalizado> {
  int tiempo = 10; // Tiempo inicial por pregunta en segundos
  int vidas = 3; // Número inicial de vidas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego Personalizado', style: TextStyle(color: Colors.white),), // Título de la barra de aplicaciones
        backgroundColor: Colors.blue, // Color de fondo de la barra de aplicaciones
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenido
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
          children: [
            const Text('Configura tu juego', style: TextStyle(fontSize: 24)), // Texto principal
            const SizedBox(height: 20), // Espacio entre el texto principal y el primer selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye los elementos a los extremos
              children: [
                const Text('Tiempo por pregunta (segundos):', style: TextStyle(fontSize: 18)), // Texto para el selector de tiempo
                DropdownButton<int>(
                  value: tiempo, // Valor actual del selector de tiempo
                  items: [10, 20, 30, 40, 50, 60].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'), // Muestra el valor en el dropdown
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      tiempo = newValue!; // Actualiza el valor del tiempo cuando se selecciona una opción
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20), // Espacio entre los selectores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribuye los elementos a los extremos
              children: [
                const Text('Cantidad de vidas:', style: TextStyle(fontSize: 18)), // Texto para el selector de vidas
                DropdownButton<int>(
                  value: vidas, // Valor actual del selector de vidas
                  items: [1, 2, 3, 4, 5].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'), // Muestra el valor en el dropdown
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      vidas = newValue!; // Actualiza el valor de las vidas cuando se selecciona una opción
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40), // Espacio entre los selectores y el botón de iniciar juego
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) => JuegoLogica(customTime: tiempo, customLives: vidas), // Proporciona la lógica del juego con los valores personalizados
                      child: const Juego(), // Navega a la pantalla del juego
                    ),
                  ),
                );
              },
              // ignore: sort_child_properties_last
              child: const Text('Iniciar Juego', style: TextStyle(color: Colors.white),), // Texto del botón
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Estilo del botón
            ),
          ],
        ),
      ),
    );
  }
}
