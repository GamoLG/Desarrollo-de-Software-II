// Función que resuelve la intersección usando un Map de frecuencias
List<int> interseccion(List<int> nums1, List<int> nums2) {
  // 1. Contar las frecuencias de cada número en nums1
  Map<int, int> mapaFrecuencias = {};
  for (int num in nums1) {
    // Si la clave ya existe, suma 1; si no, toma 0 y suma 1
    mapaFrecuencias[num] = (mapaFrecuencias[num] ?? 0) + 1;
  }

  List<int> resultado = [];

  // 2. Comprobar coincidencias contra nums2
  for (int num in nums2) {
    int conteoDisponible = mapaFrecuencias[num] ?? 0;

    if (conteoDisponible > 0) {
      resultado.add(num);
      // Disminuir la disponibilidad para respetar la cantidad de repeticiones
      mapaFrecuencias[num] = conteoDisponible - 1;
    }
  }

  return resultado;
}

void main() {
    
  print('EJERCICIO 4.5: INTERSECCIÓN CON MAPS');

  // Ejemplo 1:
  List<int> nums1 = [1, 2, 2, 1];
  List<int> nums2 = [2, 2];
  print('Ejemplo 1 -> Salida: ${interseccion(nums1, nums2)}'); 
  // Salida esperada: [2, 2]

  // Ejemplo 2:
  List<int> m1 = [4, 9, 5];
  List<int> m2 = [9, 4, 9, 8, 4];
  print('Ejemplo 2 -> Salida: ${interseccion(m1, m2)}'); 
  // Salida esperada: [9, 4] o [4, 9]
}