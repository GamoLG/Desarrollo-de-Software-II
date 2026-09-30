//ejercicio propuesto 1
List<int> combinarListas(List<int> lista1, List<int> lista2) {
  // Combina las dos listas y elimina duplicados
  List<int> resultado=[];
  resultado.addAll(lista1);
  resultado.addAll(lista2);

  //ordenar
  resultado.sort();
  return resultado;
}

void main()
{
    //ejemplo 1:
    List<int> lista1=[1,2,3,4,5];
    List<int> lista2=[4,5,6,7,8];
    print('ejemplo 1: ${combinarListas(lista1, lista2)}');

    //Ejemplo 2:
    print('ejemplo 2: ${combinarListas([], [])}');

    //ejemplo 3:
    print('ejemplo 3: ${combinarListas([], [0])}');
}