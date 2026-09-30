import 'dart:math';

void main()
{
    //lista literal
List<int> numeros=[1,2,3,4,5];
//lista vacia con tipo generico
List<String> nombres=[];

//con var
var frutas=['manzana','pera','platano'];

//lista de longitud fija
List<int> fija=.filled(3, 0); //[0,0,0]

//lista con generador
List<int> cuadrados=List.generate(5,(i)=>i*i); //[0,1,4,9,16]


List<String> estudiantes=['Ana','Luis','Pedro'];
//agregar elementos
estudiantes.add('Maria');
//recorrero por foreach
estudiantes.forEach((e)=> print('Estudiante: ${e}'));

//filtrar nombres con mas de 4 letras
var largos=estudiantes.where((e)=>e.length>4).toList();
print(largos);

//transformar a mayusculas
var mayusculas= estudiantes.map((e)=>e.toUpperCase()).toList();
print(mayusculas);

//ordenar
estudiantes.sort();
print(estudiantes);
}