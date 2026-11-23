class OutdoorActivity {
  final String id;
  final String name;
  final int durationHours;
  final String iconName;

  const OutdoorActivity({
    required this.id,
    required this.name,
    required this.durationHours,
    required this.iconName,
  });

  static const List<OutdoorActivity> presets = [
    OutdoorActivity(id: 'walk', name: 'Caminata urbana / Plaza de Armas', durationHours: 1, iconName: 'walk'),
    OutdoorActivity(id: 'trek', name: 'Excursión arqueológica (Sacsayhuamán)', durationHours: 3, iconName: 'trek'),
    OutdoorActivity(id: 'sport', name: 'Entrenamiento deportivo al aire libre', durationHours: 2, iconName: 'sport'),
    OutdoorActivity(id: 'bike', name: 'Ruta en bicicleta', durationHours: 2, iconName: 'bike'),
  ];
}