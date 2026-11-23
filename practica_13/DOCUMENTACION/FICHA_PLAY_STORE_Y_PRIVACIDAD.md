# Ficha de Publicación y Política de Privacidad — WayraUV Cusco

## 1. Metadatos de Google Play Console
- **Nombre de la aplicación:** WayraUV Cusco
- **Application ID / Package Name:** `io.github.gamolg.wayrauv`
- **Versión:** `1.0.0+1` (`versionName: 1.0.0`, `versionCode: 1`)
- **Categoría:** Clima / Salud y bienestar
- **Clasificación de contenido:** PEGI 3 / Todos (E)
- **Compatibilidad SDK:** `minSdk 23` (Android 6.0) – `targetSdk 36` (Android 16)
- **Artefactos generados:**
  - Android App Bundle: `build/app/outputs/bundle/release/app-release.aab` (53,920,835 bytes)
  - APK firmado de prueba: `build/app/outputs/flutter-apk/app-release.apk` (55,060,942 bytes)
- **Firma criptográfica (Upload Key):**
  - Propietario: `CN=Jhoel Alex Luicho Quispe, OU=Ingenieria Informatica y de Sistemas, O=UNSAAC, L=Cusco, ST=Cusco, C=PE`
  - Huella SHA-256: `CE:95:21:25:BC:AE:4F:58:F8:9B:B4:5C:1D:7A:0B:72:C6:65:BF:32:79:60:7E:36:8E:D8:B5:A2:93:ED:00:37`

## 2. Descripción Breve (máx. 80 caracteres)
Monitor de radiación UV en tiempo real y guía de protección solar para Cusco.

## 3. Descripción Completa
**WayraUV Cusco** es una herramienta meteorológica y preventiva diseñada específicamente para las condiciones de radiación solar en altitud de la ciudad del Cusco (3,399 m s. n. m.) y sus distritos.

### Funcionalidades principales:
- **Monitor UV en tiempo real:** Consulta el índice UV actual, temperatura, humedad relativa, velocidad del viento, nubosidad y curva horaria mediante la API abierta de Open-Meteo.
- **Asistente por fototipo Fitzpatrick (I–VI):** Calcula el tiempo estimado de exposición solar segura según tu tipo de piel y recomienda medidas de protección (FPS, sombrero, lentes UV).
- **Planificador de actividades al aire libre:** Evalúa el nivel de riesgo horario para caminatas, deporte o recorridos turísticos en Cusco.
- **Comparativa por sectores y distritos:** Visualiza simultáneamente los niveles UV en Centro Histórico, Wanchaq, San Sebastián, San Jerónimo y Sacsayhuamán.
- **Alertas locales configurables:** Notificaciones nativas en el dispositivo cuando la radiación alcanza umbrales altos o extremos.

## 4. Política de Privacidad y Seguridad de Datos
- **Recopilación de datos personales:** WayraUV Cusco **no** recopila, almacena en servidores externos ni comparte datos personales, cuentas de usuario ni identificadores publicitarios.
- **Ubicación:** Las coordenadas de Cusco y sus distritos están preconfiguradas en la aplicación; no se solicita acceso al GPS del dispositivo.
- **Almacenamiento local:** Las preferencias del usuario (fototipo seleccionado y configuración de alertas) se guardan exclusivamente de forma local en el dispositivo mediante `SharedPreferences`.
- **Servicios de terceros:** La aplicación realiza consultas anónimas vía HTTPS a `api.open-meteo.com` únicamente para obtener datos meteorológicos y de radiación ultravioleta.
- **Permisos declarados en `AndroidManifest.xml`:**
  - `android.permission.INTERNET`: Consulta de pronóstico UV en Open-Meteo.
  - `android.permission.POST_NOTIFICATIONS`: Envío de alertas locales de radiación UV.
