class UvClassification {
  final String level;
  final String summary;
  final String protectionAdvice;
  final int recommendedSpf;

  const UvClassification({
    required this.level,
    required this.summary,
    required this.protectionAdvice,
    required this.recommendedSpf,
  });

  static UvClassification fromIndex(double uv) {
    if (uv < 3) {
      return const UvClassification(
        level: 'BAJO',
        summary: 'Riesgo mínimo para exposición habitual.',
        protectionAdvice: 'Gafas de sol en días despejados. FPS 15+ opcional.',
        recommendedSpf: 15,
      );
    } else if (uv < 6) {
      return const UvClassification(
        level: 'MODERADO',
        summary: 'Riesgo moderado; la altitud andina incrementa la irradiancia.',
        protectionAdvice: 'Aplicar protector FPS 30+, usar gorra y gafas UV400.',
        recommendedSpf: 30,
      );
    } else if (uv < 8) {
      return const UvClassification(
        level: 'ALTO',
        summary: 'Daño dérmico posible en menos de 30 minutos sin protección.',
        protectionAdvice: 'Protector FPS 50+, sombrero de ala ancha y buscar sombra al mediodía.',
        recommendedSpf: 50,
      );
    } else if (uv < 11) {
      return const UvClassification(
        level: 'MUY ALTO',
        summary: 'Riesgo alto de quemadura solar y fatiga ocular.',
        protectionAdvice: 'FPS 50+ cada 2 horas, ropa de manga larga y evitar sol directo 10:00–15:00.',
        recommendedSpf: 50,
      );
    } else {
      return const UvClassification(
        level: 'EXTREMO',
        summary: 'Radiación crítica característica de alta montaña en Cusco.',
        protectionAdvice: 'Evitar exposición directa. Reaplicar FPS 50+ cada 90 min, usar lente UV400 y sombrero.',
        recommendedSpf: 50,
      );
    }
  }
}

class PhototypeOption {
  final int type;
  final String label;
  final String skinDescription;
  final int baseMedMinutes;
  final int colorHex;

  const PhototypeOption({
    required this.type,
    required this.label,
    required this.skinDescription,
    required this.baseMedMinutes,
    required this.colorHex,
  });

  static const List<PhototypeOption> all = [
    PhototypeOption(type: 1, label: 'Tipo I', skinDescription: 'Muy clara, se quema siempre', baseMedMinutes: 67, colorHex: 0xFFFFE0BD),
    PhototypeOption(type: 2, label: 'Tipo II', skinDescription: 'Clara, se quema fácilmente', baseMedMinutes: 100, colorHex: 0xFFFFCD94),
    PhototypeOption(type: 3, label: 'Tipo III', skinDescription: 'Intermedia, bronceado gradual', baseMedMinutes: 200, colorHex: 0xFFEAC086),
    PhototypeOption(type: 4, label: 'Tipo IV', skinDescription: 'Trigueña, rara vez se quema', baseMedMinutes: 300, colorHex: 0xFFC68642),
    PhototypeOption(type: 5, label: 'Tipo V', skinDescription: 'Morena oscura', baseMedMinutes: 400, colorHex: 0xFF8D5524),
    PhototypeOption(type: 6, label: 'Tipo VI', skinDescription: 'Muy oscura', baseMedMinutes: 500, colorHex: 0xFF5C3818),
  ];
}