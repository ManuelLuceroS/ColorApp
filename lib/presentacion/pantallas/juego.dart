import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y estilos
import 'package:provider/provider.dart'; // Importa Provider para manejar el estado
import 'package:color_app/funciones/logica.dart'; // Importa la lógica del juego
import 'package:color_app/funciones/guardar_record.dart'; // Importa la funcionalidad para guardar records

// Define la pantalla del juego
class Juego extends StatefulWidget {
  const Juego({super.key});

  @override
  State<Juego> createState() => _JuegoState();
}

class _JuegoState extends State<Juego> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final juegoLogica = Provider.of<JuegoLogica>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      juegoLogica.reiniciarJuego(); // Reinicia el juego después de construir el widget
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Juego de Colores'), // Título de la barra de aplicaciones
        backgroundColor: Colors.blue, // Color de fondo de la barra de aplicaciones
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), // Botón para reiniciar el juego
            onPressed: () {
              final juegoLogica = Provider.of<JuegoLogica>(context, listen: false);
              juegoLogica.reiniciarJuego(); // Reinicia el juego al presionar el botón
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause), // Botón para pausar el juego
            onPressed: () {
              final juegoLogica = Provider.of<JuegoLogica>(context, listen: false);
              if (juegoLogica.pausesLeft > 0 && !juegoLogica.isPaused) {
                juegoLogica.pausarJuego(); // Pausa el juego
                _mostrarDialogoPausa(context); // Muestra un diálogo informando que el juego está pausado
              }
            },
          ),
        ],
      ),
      body: Consumer<JuegoLogica>(
        builder: (context, juegoLogica, child) {
          // Verifica si el juego ha terminado y muestra un diálogo de fin de juego
          if (juegoLogica.intentosRestantes <= 0 || (juegoLogica.palabrasAcertadas + juegoLogica.palabrasErradas) >= juegoLogica.totalPalabras) {
            Future.delayed(Duration.zero, () {
              _mostrarDialogoFinJuego(context, juegoLogica.palabrasAcertadas, juegoLogica.palabrasErradas);
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
            children: [
              Text(
                juegoLogica.palabraActual, // Muestra la palabra actual
                style: TextStyle(
                  color: juegoLogica.colorPalabra, // Color del texto de la palabra actual
                  fontSize: 40, // Tamaño de la fuente
                ),
              ),
              const SizedBox(height: 20), // Espacio entre la palabra y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuye los botones de manera equidistante
                children: juegoLogica.opciones.map((opcion) {
                  return ElevatedButton(
                    onPressed: () {
                      if (!juegoLogica.isPaused) {
                        juegoLogica.verificarRespuesta(opcion); // Verifica la respuesta al presionar el botón
                      }
                    },
                    child: Text(opcion), // Muestra la opción en el botón
                    style: ElevatedButton.styleFrom(
                      backgroundColor: juegoLogica.obtenerColorOpcion(opcion), // Color de fondo del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Bordes redondeados del botón
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 70), // Espacio entre los botones y las estadísticas
              Text('Intentos restantes: ${juegoLogica.intentosRestantes}'), // Muestra los intentos restantes
              const SizedBox(width: 30), // Espacio entre las estadísticas
              Text('Puntaje: ${juegoLogica.puntaje}'), // Muestra el puntaje
              const SizedBox(height: 10), // Espacio entre las estadísticas
              Text('Tiempo restante: ${juegoLogica.tiempoRestante}'), // Muestra el tiempo restante
              const SizedBox(height: 10), // Espacio entre las estadísticas
              Text('Pausas restantes: ${juegoLogica.pausesLeft}'), // Muestra las pausas restantes
            ],
          );
        },
      ),
    );
  }

  void _mostrarDialogoPausa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Juego Pausado'), // Título del diálogo
          content: const Text('El juego se ha pausado. Solo puedes pausar el juego 2 veces.'), // Mensaje del diálogo
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                final juegoLogica = Provider.of<JuegoLogica>(context, listen: false);
                juegoLogica.reanudarJuego(); // Reanuda el juego
              },
              child: const Text('Continuar'), // Texto del botón para continuar
            ),
          ],
        );
      },
    );
  }

  void _mostrarDialogoFinJuego(BuildContext context, int correctas, int incorrectas) {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el diálogo se cierre al tocar fuera de él
      builder: (context) {
        final nombreController = TextEditingController(); // Controlador para el campo de texto del nombre
        return AlertDialog(
          title: const Text('Fin del Juego'), // Título del diálogo
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Correctas: $correctas'), // Muestra la cantidad de respuestas correctas
              Text('Incorrectas: $incorrectas'), // Muestra la cantidad de respuestas incorrectas
              TextField(
                controller: nombreController, // Asocia el controlador al campo de texto
                decoration: const InputDecoration(labelText: 'Nombre'), // Etiqueta del campo de texto
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _guardarRecordYReiniciar(context, nombreController.text, correctas); // Guarda el record y reinicia el juego
              },
              child: const Text('Guardar y volver al inicio'), // Texto del botón para guardar y volver al inicio
            ),
          ],
        );
      },
    );
  }

  void _guardarRecordYReiniciar(BuildContext context, String nombre, int puntaje) {
    final recordsNotifier = Provider.of<RecordsNotifier>(context, listen: false);
    final juegoLogica = Provider.of<JuegoLogica>(context, listen: false);
    recordsNotifier.agregarRecord(nombre, puntaje); // Agrega el record al listado
    juegoLogica.reiniciarJuego(); // Reinicia el juego
    Navigator.of(context).pushNamedAndRemoveUntil('/inicio', (route) => false); // Navega a la pantalla de inicio y elimina las pantallas anteriores
  }
}
