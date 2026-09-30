Set<int> A={1,2,3,4,5};
Set<int> B={4,5,6,7,8};

//union
print('Union: ${A.union(B)}'); // {1,2,3,4,5,6,7,8}
//interseccion
print('Interseccion: ${A.intersection(B)}'); // {4,5}
//diferencia
print('Diferencia: ${A.difference(B)}'); // {1,2,
//subconjunto
Set<int> C={1,2};
print(C.isSubsetOf(A)); // true

//agregar elementos(ignorando si ya existe)
A.add(6);
A.addAll({7,8,9});