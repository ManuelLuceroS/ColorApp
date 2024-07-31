import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y otras funcionalidades

// Define una clase para representar un registro de puntaje
class Record {
  final String nombre; // Nombre del jugador
  final int puntaje;   // Puntaje del jugador

  // Constructor para crear un objeto Record con nombre y puntaje
  Record({required this.nombre, required this.puntaje});
}

// Define una clase para manejar la lista de records y notificar a los widgets sobre cambios
class RecordsNotifier extends ChangeNotifier {
  List<Record> _records = []; // Lista privada de registros de puntajes

  // Getter para obtener la lista de registros
  List<Record> get records => _records;

  // Método para agregar un nuevo registro y mantener solo los 5 mejores
  void agregarRecord(String nombre, int puntaje) {
    _records.add(Record(nombre: nombre, puntaje: puntaje)); // Agrega el nuevo registro a la lista
    _records.sort((a, b) => b.puntaje.compareTo(a.puntaje)); // Ordena los registros por puntaje de mayor a menor
    if (_records.length > 5) {
      _records = _records.sublist(0, 5); // Mantiene solo los 5 registros con mayor puntaje
    }
    notifyListeners(); // Notifica a los widgets que están escuchando que los datos han cambiado
  }
}
