import 'dart:math';

void main()
{
    //tipos numericos
int entero=100;
double decimal=3.14159;
num numero=42;   //puede ser int o double

//cadenas de texto
String texto="hola, Dart!";
String interpolado='el valor es:${entero}';
String multilinea='''
 esta es una cadena 
 en multiples lineas
''';

//Booleanos
bool esDart=true;
bool esPython=false;

//null safety
int? edadNula=null;
String? nombre='Ana';

//mostrar
print(entero);
print(decimal);
print(numero);
print('el entero es: ${entero}, el decimal es: ${decimal}, el numero es: ${numero}');
print(multilinea);
print(interpolado);

print('edad nula: ${edadNula}, nombre: ${nombre}');
}