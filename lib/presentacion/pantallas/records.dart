import 'package:color_app/presentacion/pantallas/inicio.dart'; // Importa la pantalla de inicio
import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para usar widgets y estilos
import 'package:provider/provider.dart'; // Importa Provider para manejar el estado
import 'package:color_app/funciones/guardar_record.dart'; // Importa la lógica para manejar los records

// Define la pantalla de registros
class RecordsPantalla extends StatelessWidget {
  const RecordsPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene la lista de records del estado gestionado por Provider
    final records = Provider.of<RecordsNotifier>(context).records;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Color de fondo de la barra de aplicaciones
        title: const Text('Records', style: TextStyle(color: Colors.white),), // Título de la barra de aplicaciones
      ),
      body: Column(
        children: [
          const SizedBox(height: 50,), // Espacio superior
          const Text('5 Mejores Records!', style: TextStyle(fontSize: 30),), // Título de la pantalla
          const SizedBox(height: 50,), // Espacio entre el título y la lista
          // Lista de records
          Expanded(
            child: ListView.builder(
              itemCount: records.length, // Número de elementos en la lista
              itemBuilder: (context, index) {
                final record = records[index]; // Obtiene el record en el índice actual
                return ListTile(
                  title: Text(record.nombre, style: const TextStyle(fontSize: 20)), // Nombre del record
                  trailing: Text(record.puntaje.toString(), style: const TextStyle(fontSize: 20),), // Puntaje del record
                );
              },
            ),
          ),
          // Fila con el botón para volver a inicio
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centra el botón horizontalmente
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PantallaInicial()), // Navega a la pantalla de inicio
                  );
                },
                // ignore: sort_child_properties_last
                child: const Text('Volver a Inicio', style: TextStyle(color: Colors.white),), // Texto del botón
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), // Estilo del botón
              ),
              const SizedBox(height: 500,) // Espacio inferior
            ],
          ),
        ],
      ),
    );
  }
}
