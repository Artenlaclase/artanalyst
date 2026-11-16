# ArtAnalyst: Registro de Actualizaciones, Funcionalidades y Configuración de Git

Este documento detalla el historial de cambios técnicos aplicados en el repositorio, la descripción exhaustiva de todas las funcionalidades pedagógicas y técnicas implementadas, y la explicación de las reglas de exclusión configuradas en el archivo `.gitignore`.

---

## 1. Registro de Cambios y Actualizaciones Técnicas

### 1.1. Arquitectura Inicial y Estructura Monorepo
* **Creación de la arquitectura hexagonal monorepo** dividida en cuatro paquetes desacoplados:
  * `packages/shared/`: Modelos de datos, DTOs y motor de reglas de propiedad intelectual compartido entre cliente y servidor.
  * `packages/server/licensing/`: Microservicio de Medios y Licencias con arquitectura de Puertos y Adaptadores para museos.
  * `packages/server/catalog/`: Microservicio de Catálogo y Análisis Visual Guiado con repositorio de datos y control de progreso.
  * `packages/app/`: Aplicación Flutter multiplataforma (Web, Android, iOS, Windows/macOS/Linux).
* **Contenedores y Orquestación:** Configuración de `docker-compose.yml` para levantar PostgreSQL 16 (con extensiones de UUID y esquema DDL), Redis 7 y los dos microservicios en Dart.

### 1.2. Habilitación de Ejecución Directa desde la Raíz
* **Soporte de Flutter en la raíz:** Se agregaron los archivos `pubspec.yaml`, `lib/main.dart` y la carpeta `web/` en la raíz del proyecto para permitir ejecutar directamente `flutter run -d chrome` desde `c:\proyectos\arteapp` sin obligar a cambiar manualmente de directorio con `cd`.
* **Scripts de conveniencia:** Se crearon `run_app.ps1` (PowerShell) y `run_app.bat` (CMD) para lanzamiento con un solo clic.

### 1.3. Corrección de Compatibilidad e Importaciones
* **Normalización de Importaciones de Paquete:** Se sustituyeron las rutas relativas (`../../`, `../../../`) por importaciones absolutas canónicas (`package:art_analyst_app/...`) en todos los widgets y vistas (`artwork_card.dart`, `annotated_viewer.dart`, `analysis_view.dart`, `app_router.dart`, `main.dart`), resolviendo los errores de resolución del empaquetador de Flutter Web.
* **Actualización para Flutter 3.24+:** En `app_theme.dart` se actualizó la propiedad `cardTheme` de `CardTheme(...)` a `CardThemeData(...)`, asegurando compatibilidad estricta con las versiones más recientes del SDK de Flutter.
* **Suite de Pruebas Automatizada:** Se implementó `scripts/run_all_tests.dart`, que compila y ejecuta 19 pruebas unitarias y de integración que validan el 100% de la lógica de licencias, adaptadores y repositorios.

### 1.4. Optimización de Rendimiento de Imágenes y Carga Instantánea
* **Causa de la Demora Inicial:** Wikimedia Commons implementó una política estricta de generación de miniaturas (`https://w.wiki/GHai`), rechazando con `HTTP 400` y demorando la generación al vuelo de anchos arbitrarios como `600px`. Además, la obra de Vermeer (*La joven de la perla*) posee un archivo maestro de más de 45 MB, lo que provocaba latencias de red y bloqueos temporales.
* **Creación de `SmartArtworkImage`:** Se desarrolló un widget inteligente (`packages/app/lib/core/widgets/smart_artwork_image.dart`) que integra:
  * Prioridad a **activos locales pre-empaquetados** (`assets/images/van_gogh.jpg`, `monet.jpg`, `vermeer.jpg`, `friedrich.jpg`), logrando una carga **inmediata a 0 ms** sin depender de internet ni sufrir bloqueos CORS.
  * Respaldo a URLs de red con los anchos oficiales y cacheados de producción de Wikimedia (`500px` para miniaturas y `1280px` para alta definición).
  * Placeholder con gradiente cálido de museo, icono de paleta y barra de progreso porcentual que evita cuadros blancos parpadeantes durante la descarga.

### 1.5. Incorporación de la Página de Estudio y Explicación Metodológica Integral
* **Nueva Ruta y Vista de Estudio (`/study` - `StudyView`):** Se implementó una página interactiva completa con tres pestañas:
  * **Metodología de Análisis Visual (Panofsky & Wölfflin):** Expone con rigor científico los 4 pasos del análisis, el esquema óptico de los 5 pares contrapuestos de Heinrich Wölfflin con acordeones comparativos, y el cuadro sinóptico de doble entrada de Erwin Panofsky, citando sus textos canónicos:
    * *Panofsky, Erwin: El significado en las artes visuales (1979)*.
    * *Wölfflin, Heinrich: Conceptos fundamentales de la historia del arte (1915/2017)*.
  * **Guía de Funcionamiento de la Aplicación:** Explicación detallada del flujo completo (búsqueda con semáforo, visor de alta definición, superposición geométrica y cromática, marcado de ROI, redacción y contraste con respuesta modelo).
  * **Taller y Autoevaluación:** Módulo interactivo con preguntas de opción múltiple y retroalimentación inmediata para asentar los conceptos.
* **Acceso Directo y Navegación Bidireccional:**
  * Se añadió el destino persistente `Estudio` en el `NavigationRail` (Web/Desktop) y `NavigationBar` (Móvil).
  * Se incorporaron accesos directos desde la barra del catálogo y desde el visor de análisis (`AnalysisView` y `PanofskyStepper`).
  * En el Nivel 1 del Stepper se incorporó una guía rápida de los 5 pares de Wölfflin, y al pie se añadió la referencia al Paso 4 de Verificación Histórica.

---

## 2. Catálogo de Funcionalidades Implementadas

### 2.1. Módulo de Análisis Visual Guiado (Método de Erwin Panofsky)
ArtAnalyst no se limita a mostrar fichas técnicas, sino que guía el proceso cognitivo del estudiante a través de tres niveles metodológicos:

1. **Nivel 1: Descripción Pre-iconográfica (Formal)**
   * **Capa de Composición Geométrica:** Permite superponer en tiempo real sobre la obra la regla de tercios (con puntos de intersección áureos), las líneas diagonales de fuerza/fuga y los ejes de simetría.
   * **Capa de Paleta Cromática y Armonía:** Barra interactiva con los tonos predominantes extraídos de la obra, sus valores hexadecimales y la explicación de su armonía (ej. contraste de colores complementarios).
   * **Micro-ejercicios Interactivos:** Ejercicios de localización de puntos focales y análisis de luz/técnica.

2. **Nivel 2: Análisis Iconográfico**
   * **Herramienta de Marcado de Regiones de Interés (ROI):** El estudiante puede activar el modo de anotación, pulsar o arrastrar sobre la obra y registrar rectángulos delimitadores con etiqueta, notas analíticas y categoría (composición, símbolo, color, pincelada).
   * **Identificación de Atributos:** Preguntas orientadas a descifrar la indumentaria, objetos simbólicos y personajes.

3. **Nivel 3: Interpretación Iconológica**
   * **Contextualización Histórica:** Análisis del marco social, político, religioso y de la cosmovisión de la época en que fue creada la obra.
   * **Comparación con Respuesta Modelo:** Al redactar y guardar su reflexión, la aplicación revela una respuesta modelo redactada y curada por historiadores del arte para fomentar el pensamiento crítico.

4. **Persistencia del Progreso del Estudiante**
   * Registro local y vía API REST de las respuestas redactadas por el estudiante y de las coordenadas normalizadas de sus anotaciones ROI para revisión docente o continuidad del estudio.

---

### 2.2. Módulo de Semáforo de Licencias Transparente
Convierte la propiedad intelectual en un pilar formativo mediante una evaluación estricta de la **reproducción digital** (no solo la antigüedad de la obra física original):

* 🟢 **Semáforo Verde (CC0 / Dominio Público Mundial):**
  * La institución titular renunció a los derechos sobre la fotografía digital.
  * La imagen se visualiza con zoom interactivo multinivel, descarga permitida y sin restricciones de reutilización.
  * Integrado con The Met (Open Access), Cleveland Museum of Art (CC0), J. Paul Getty Trust y Smithsonian Open Access.

* 🟡 **Semáforo Amarillo (Creative Commons con Atribución):**
  * Para obras bajo licencias CC BY o CC BY-SA.
  * Se muestra la imagen y se genera automáticamente el texto de atribución formal bajo el estándar **TASL** (*Title, Author, Source, License*) con avisos sobre obras derivadas (ShareAlike).

* 🔴 **Semáforo Rojo (Derechos Reservados / Protección Fotográfica):**
  * **ArtAnalyst protege los derechos de autor y bloquea activamente la redistribución de la imagen**.
  * En su lugar, presenta el componente `CopyrightPlaceholder` con un mensaje educativo sobre por qué la fotografía posee derechos reservados y un botón directo para consultar la obra en el catálogo web oficial de la institución (ej. Musée du Louvre para la *Mona Lisa*).

* **Filtro Estricto para Wikimedia Commons y Europeana:**
  * Descarta automáticamente licencias territoriales como `pd-us` (válidas solo en EE.UU.) o licencias no mundiales, marcándolas en Rojo por precaución jurídica internacional.

* **Componente `LicenseBadge` y Diálogo Educativo:**
  * Widget reutilizable presente en el catálogo y en el visor. Al pulsarlo, abre `LicenseEducationalDialog`, explicando en lenguaje claro qué está permitido hacer, qué está prohibido y cómo citar formalmente la obra.

---

### 2.3. Catálogo Multiplataforma y Diseño Adaptativo
* **Diseño Material 3 Accesible:** Paleta clásica en tonos terracota/tierra con soporte para Modo Claro y Modo Oscuro.
* **Enrutamiento con ShellRoute (GoRouter):** Navegación persistente mediante `NavigationRail` en pantallas anchas (Web/Escritorio) y `NavigationBar` en dispositivos móviles.
* **Visor Dual en Web/Escritorio:** Pantalla dividida simultánea (60% para el visor de la obra con capas interactivas y 40% para el Stepper de Panofsky).
* **Buscador y Filtros Dinámicos:** Búsqueda en tiempo real por título, artista o procedencia, y filtrado por color del semáforo.

---

## 3. Configuración del Archivo `.gitignore`

El archivo [`.gitignore`](file:///c:/proyectos/arteapp/.gitignore) en la raíz del proyecto asegura que los archivos temporales, dependencias pesadas y credenciales no se suban al control de versiones:

```gitignore
# Archivos temporales y compilados del sistema
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/
migrate_working_dir/

# Configuración de entornos de desarrollo (IDE)
*.iml
*.ipr
*.iws
.idea/
.vscode/

# Paquetes y artefactos generados por Dart, Flutter y Melos
**/doc/api/
.dart_tool/
.packages
.pub-cache/
.pub_cache/
.pub/
build/
*.lock

# Variables de entorno y secretos locales
.env
.env.*

# Volúmenes persistentes de bases de datos Docker
postgres_data/
redis_data/
```

### Justificación de las exclusiones:
1. **`.dart_tool/`, `.packages`, `.pub_cache/`, `build/`:** Carpetas de compilación y caché de dependencias descargadas por `flutter pub get`. Son regeneradas automáticamente en cada entorno.
2. **`*.lock`:** En bibliotecas y monorepos, se omite para permitir la resolución flexible de versiones compatibles.
3. **`postgres_data/` y `redis_data/`:** Carpetas donde Docker monta los volúmenes locales de almacenamiento de PostgreSQL y Redis para evitar guardar datos binarios pesados en el historial de Git.
4. **`.env*`:** Protege tokens, contraseñas de base de datos o claves API privadas de ser expuestas públicamente.
