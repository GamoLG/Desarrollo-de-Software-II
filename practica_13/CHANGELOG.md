# Changelog — WayraUV Cusco

Todos los cambios relevantes de este proyecto se documentan siguiendo [Semantic Versioning 2.0.0](https://semver.org/) (`MAJOR.MINOR.PATCH+BUILD`).

## Estrategia de Versionado
- **MAJOR (`1.x.x`):** Cambios incompatibles en arquitectura, almacenamiento o API.
- **MINOR (`x.1.x`):** Nuevos módulos funcionales retrocompatibles (ej. comparador de distritos, alertas locales).
- **PATCH (`x.x.1`):** Correcciones de errores, ajustes visuales o mejoras de caché.
- **BUILD (`+1`):** `versionCode` (Android) y `CFBundleVersion` (iOS); se incrementa estrictamente en cada compilación enviada a canales de prueba o tiendas.

## [1.0.0+1] - 2026-11-23
### Agregado
- **Monitor Ambiental:** Índice UV actual, clasificación OMS, temperatura, humedad, viento, nubosidad y pronóstico horario con gráfico lineal (`fl_chart`) vía Open-Meteo y respaldo offline.
- **Asistente Inteligente Local:** Cálculo de minutos máximos de exposición según fototipo Fitzpatrick (I–VI), FPS recomendado y alertas térmicas andinas.
- **Planificador de Actividades:** Evaluación horaria y recomendación de franjas de menor radiación para caminatas, ciclismo, turismo y deporte.
- **Alertas Locales:** Configuración de umbral UV, recordatorios de reaplicación de protector solar y notificaciones nativas (`flutter_local_notifications`).
- **Comparador de Distritos:** Monitoreo simultáneo de Centro Histórico, Wanchaq, San Sebastián, San Jerónimo y Sacsayhuamán.