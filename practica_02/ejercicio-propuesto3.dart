// Funcion que calcula cuántas frutas quedan sin colocar usando un Set
int numDeFrutasSinColocar(List<int> frutas, List<int> cestas) {
  // Set para llevar el registro de índices de cestas ocupadas (O(1) búsqueda/inserción)
  Set<int> cestasOcupadas = <int>{};
  int sinColocar = 0;

  for (int cantidadFruta in frutas) {
    bool colocada = false;

    // Buscar de izquierda a derecha la cesta disponible con capacidad suficiente
    for (int j = 0; j < cestas.length; j++) {
      if (!cestasOcupadas.contains(j) && cestas[j] >= cantidadFruta) {
        cestasOcupadas.add(j); // Marcar cesta como ocupada
        colocada = true;
        break; // Detener búsqueda para esta fruta
      }
    }

    // Si no encontro cesta válida, no se pudo colocar
    if (!colocada) {
      sinColocar++;
    }
  }

  return sinColocar;
}

void main() {
  print('EJERCICIO 5.3: FRUTAS Y CESTAS (SET)');

  // Ejemplo 1:
  // frutas = [4, 2, 5], cestas = [3, 5, 4]
  List<int> frutas1 = [4, 2, 5];
  List<int> cestas1 = [3, 5, 4];
  int resultado1 = numDeFrutasSinColocar(frutas1, cestas1);
  print('Ejemplo 1 -> Frutas sin colocar: $resultado1'); // Salida esperada: 1

  // Ejemplo 2:
  // frutas = [3, 6, 1], cestas = [6, 4, 7]
  List<int> frutas2 = [3, 6, 1];
  List<int> cestas2 = [6, 4, 7];
  int resultado2 = numDeFrutasSinColocar(frutas2, cestas2);
  print('Ejemplo 2 -> Frutas sin colocar: $resultado2'); // Salida esperada: 0
}