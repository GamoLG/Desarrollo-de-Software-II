import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarea.dart';

typedef TareaMap = Map<String, dynamic>;

class TareaRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> leerSaludoInicial() async {
    final doc = await _db.collection('saludos').doc('bienvenida').get();
    return doc.data()?['mensaje'] ?? 'Sin mensaje en Firestore';
  }

  CollectionReference<TareaMap> _coleccionUsuario(String uid) {
    return _db.collection('usuarios').doc(uid).collection('tareas');
  }

  Stream<List<Tarea>> observarTareas(String uid) {
    return _coleccionUsuario(uid)
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snap) => snap.docs
        .map((doc) => Tarea.fromMap(doc.id, doc.data()))
        .toList());
  }

  Future<void> agregarTarea(String uid, Tarea tarea) async {
    await _coleccionUsuario(uid).add(tarea.toMap());
  }

  Future<void> alternarEstado(String uid, Tarea tarea) async {
    await _coleccionUsuario(uid)
        .doc(tarea.id)
        .update({'completada': !tarea.completada});
  }

  Future<void> eliminarTarea(String uid, String tareaId) async {
    await _coleccionUsuario(uid).doc(tareaId).delete();
  }
}