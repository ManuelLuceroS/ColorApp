import 'dart:async'; // Importa la biblioteca para trabajar con temporizadores
import 'dart:math'; // Importa la biblioteca para generar números aleatorios
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y colores

// Define la clase JuegoLogica para manejar la lógica del juego
class JuegoLogica extends ChangeNotifier {
  List<String> colores = ['Rojo', 'Verde', 'Azul', 'Amarillo']; // Lista de nombres de colores
  List<Color> coloresHex = [Colors.red, Colors.green, Colors.blue, Colors.yellow]; // Lista de colores en formato Color
  String palabraActual = ''; // Almacena la palabra actual a adivinar
  Color colorPalabra = Colors.transparent; // Almacena el color asociado a la palabra actual
  List<String> opciones = []; // Lista de opciones de respuesta para la pregunta actual
  int intentosRestantes; // Número de intentos restantes
  int puntaje = 0; // Puntaje del jugador
  int palabrasAcertadas = 0; // Número de palabras acertadas
  int palabrasErradas = 0; // Número de palabras erradas
  int totalPalabras = 10; // Número total de palabras en el juego

  Timer? _timer; // Temporizador para el conteo regresivo
  int tiempoRestante; // Tiempo restante en el temporizador
  bool _isPaused = false; // Estado de si el juego está pausado
  int _pausesLeft = 2; // Número de pausas restantes
  bool _isDisposed = false; // Estado de si el objeto ha sido destruido

  // Constructor que recibe tiempo personalizado y número de vidas
  JuegoLogica({int customTime = 10, int customLives = 3})
      : tiempoRestante = customTime,
        intentosRestantes = customLives {
    generarNuevaPregunta(); // Genera la primera pregunta
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador si está activo
    _isDisposed = true; // Marca el objeto como destruido
    super.dispose(); // Llama al método dispose de la clase base
  }

  // Genera una nueva pregunta para el juego
  void generarNuevaPregunta() {
    if (_isPaused) return; // Si el juego está pausado, no hacer nada

    _timer?.cancel(); // Cancela el temporizador anterior si existe
    tiempoRestante = tiempoRestante; // Reinicia el tiempo restante

    final random = Random(); // Crea una instancia para generar números aleatorios
    palabraActual = colores[random.nextInt(colores.length)]; // Selecciona una palabra aleatoria
    colorPalabra = coloresHex[random.nextInt(coloresHex.length)]; // Selecciona un color aleatorio

    opciones = colores.toList()..shuffle(); // Baraja las opciones de colores

    // Configura un temporizador que se actualiza cada segundo
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) { // Si el juego no está pausado
        if (tiempoRestante > 0) {
          tiempoRestante--; // Reduce el tiempo restante
        } else { 
          intentosRestantes--; // Reduce el número de intentos restantes
          palabrasErradas++; // Incrementa el contador de palabras erradas
          verificarFinDelJuego(); // Verifica si el juego ha terminado
          if (intentosRestantes > 0 && (palabrasAcertadas + palabrasErradas) < totalPalabras) {
            generarNuevaPregunta(); // Genera una nueva pregunta si el juego no ha terminado
          }
        }
        _safeNotifyListeners(); // Notifica a los widgets que están escuchando sobre los cambios
      }
    });

    _safeNotifyListeners(); // Notifica a los widgets que están escuchando al inicio de una nueva pregunta
  }

  // Verifica la respuesta del usuario
  void verificarRespuesta(String respuesta) {
    _timer?.cancel(); // Cancela el temporizador actual

    final colorSeleccionado = obtenerColorOpcion(respuesta); // Obtiene el color asociado a la respuesta del usuario

    if (colorSeleccionado == colorPalabra) { // Si la respuesta es correcta
      puntaje++; // Incrementa el puntaje
      palabrasAcertadas++; // Incrementa el contador de palabras acertadas
    } else { 
      intentosRestantes--; // Reduce el número de intentos restantes
      palabrasErradas++; // Incrementa el contador de palabras erradas
    }

    verificarFinDelJuego(); // Verifica si el juego ha terminado
    if (intentosRestantes > 0 && (palabrasAcertadas + palabrasErradas) < totalPalabras) {
      generarNuevaPregunta(); // Genera una nueva pregunta si el juego no ha terminado
    }
    _safeNotifyListeners(); // Notifica a los widgets que están escuchando sobre los cambios
  }

  // Verifica si el juego ha terminado
  void verificarFinDelJuego() {
    if (intentosRestantes <= 0 || (palabrasAcertadas + palabrasErradas) >= totalPalabras) {
      _timer?.cancel(); // Cancela el temporizador si el juego ha terminado
    }
  }

  // Pausa el juego
  void pausarJuego() {
    if (_pausesLeft > 0 && !_isPaused) { // Si quedan pausas y el juego no está pausado
      _isPaused = true; // Marca el juego como pausado
      _pausesLeft--; // Reduce el número de pausas restantes
      _timer?.cancel(); // Cancela el temporizador
      _safeNotifyListeners(); // Notifica a los widgets que están escuchando sobre los cambios
    }
  }

  // Reanuda el juego
  void reanudarJuego() {
    if (_isPaused) { // Si el juego está pausado
      _isPaused = false; // Marca el juego como no pausado
      generarNuevaPregunta(); // Genera una nueva pregunta para continuar el juego
      _safeNotifyListeners(); // Notifica a los widgets que están escuchando sobre los cambios
    }
  }

  // Reinicia el juego con nuevos parámetros de tiempo y vidas
  void reiniciarJuego({int customTime = 10, int customLives = 3}) {
    puntaje = 0; // Reinicia el puntaje
    palabrasAcertadas = 0; // Reinicia el contador de palabras acertadas
    palabrasErradas = 0; // Reinicia el contador de palabras erradas
    intentosRestantes = customLives; // Establece el número de intentos restantes
    tiempoRestante = customTime; // Establece el tiempo restante
    _isPaused = false; // Marca el juego como no pausado
    _pausesLeft = 2; // Reinicia el número de pausas restantes
    generarNuevaPregunta(); // Genera una nueva pregunta para iniciar el juego
    _safeNotifyListeners(); // Notifica a los widgets que están escuchando sobre los cambios
  }

  // Obtiene el color asociado a una opción dada
  Color obtenerColorOpcion(String opcion) {
    switch (opcion) {
      case 'Rojo':
        return Colors.red; // Devuelve el color rojo
      case 'Verde':
        return Colors.green; // Devuelve el color verde
      case 'Azul':
        return Colors.blue; // Devuelve el color azul
      case 'Amarillo':
        return Colors.yellow; // Devuelve el color amarillo
      default:
        return Colors.transparent; // Devuelve un color transparente si la opción no es válida
    }
  }

  // Propiedad que indica si el juego está pausado
  bool get isPaused => _isPaused;

  // Propiedad que indica el número de pausas restantes
  int get pausesLeft => _pausesLeft;

  // Método privado para notificar a los widgets que están escuchando sobre los cambios
  void _safeNotifyListeners() {
    if (!_isDisposed) { // Solo notifica si el objeto no ha sido destruido
      notifyListeners();
    }
  }
}
