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

### 1.6. Corrección Definitiva en la Carga de Imágenes (`SmartArtworkImage`)
* **Problema Identificado:** En entornos web (`localhost:7357`), las tarjetas del catálogo mostraban el placeholder marrón con el icono de paleta debido a que `ArtworkCard` e `AnnotatedViewer` invocaban directamente `Image.network` hacia URLs de Wikimedia Commons, siendo bloqueadas por restricciones de **CORS** del navegador o caídas de certificados SSL locales.
* **Solución Implementada:**
  * Se conectó `SmartArtworkImage` tanto en `ArtworkCard` como en `AnnotatedViewer`.
  * Se configuraron los repositorios (`ArtworkRepository`) para apuntar directamente a los activos locales empaquetados (`assets/images/van_gogh.jpg`, `monet.jpg`, `vermeer.jpg`, `friedrich.jpg`), garantizando una carga instantánea a 0 ms, sin depender de internet ni de políticas externas.
  * Se agregó fallback con doble resolución de clave (`assets/images/...` y `packages/art_analyst_app/assets/images/...`) para asegurar compatibilidad en ejecución desde la raíz o desde el paquete.

### 1.7. Soporte para Despliegue en la Nube (Vercel), Rutas SPA y Analítica Web
* **Manejo de Rutas SPA (`vercel.json`):** Las aplicaciones Flutter Web operan como Single Page Applications. Se generó el archivo `vercel.json` con la regla de reescritura `{"source": "/(.*)", "destination": "/index.html"}` para evitar errores 404 cuando el usuario recarga la página o entra directamente a rutas profundas como `/study`, `/catalog` o `/artwork/:id`.
* **Causa del Error 404 Inicial en Vercel:** Al conectar GitHub con Vercel directamente, Vercel no encontraba la web porque `build/` está en `.gitignore` (no viaja a GitHub) y Vercel no incluye el SDK de Flutter en sus contenedores estándar. Se documentaron las dos soluciones: despliegue de la carpeta compilada mediante CLI (`npx vercel build/web --prod`) y compilación automática mediante script CI/CD (`scripts/vercel_build.sh`).
* **Integración de Vercel Web Analytics:** Se integró el script nativo de analíticas de Vercel (`/_vercel/insights/script.js`) en `web/index.html`, `packages/app/web/index.html` y `build/web/index.html` para monitorear visitas y páginas vistas sin impacto en el rendimiento.

### 1.8. Corrección de Legibilidad y Tipografía Móvil en Modo Oscuro
* **Detección del Problema en Dispositivos Móviles:** Mediante capturas de pantalla de un smartphone navegando en `artanalyst.vercel.app/#/study` bajo Modo Oscuro, se detectó que los contenedores de texto poseían fondos fijos claros (`Colors.white`, `Colors.grey.shade50`) mientras el tema global aplicaba texto blanco/crema por defecto, provocando texto invisible o con pésimo contraste. Asimismo, el tamaño de letra (11–13px) resultaba pequeño e incómodo de leer en celulares.
* **Solución de Contraste Adaptable al Tema (`isDark`):** Se refactorizaron completamente `StudyView` (`study_view.dart`) y el stepper interactivo de Panofsky (`panofsky_stepper.dart`), implementando selectores automáticos de color basados en `final isDark = Theme.of(context).brightness == Brightness.dark;`:
  * En Modo Oscuro se emplean fondos profundos cálidos (`#1E1B18`, `#241E19`, `#1E2A38`, `#142E1C`) con bordes atenuados y tipografías en blanco/crema de alta legibilidad (`Colors.white.withOpacity(0.92)`).
  * En Modo Claro se mantienen tonos suaves con texto oscuro (`Colors.black87`).
* **Incremento de Tipografía y Espaciado Móvil:**
  * Títulos de sección: aumentados a 18–22px con negrita (`FontWeight.bold`).
  * Subtítulos y preguntas guía: aumentados a 14–16px.
  * Texto de párrafos y citas metodológicas: aumentados a 14.5–16px con interlineado holgado (`height: 1.5–1.55`) para lectura fluida.
* **Tarjetas Sinópticas Adaptables vs. Tabla Rígida:** Se reemplazó el `DataTable` horizontal (que sufría desbordamiento horizontal en celulares) por tarjetas verticales modulares (`_buildSinopticCard`) que presentan el nivel, objeto de interpretación, acto de interpretación y principio correctivo en formato vertical perfectamente adaptado a cualquier pantalla de móvil.

### 1.9. Scroll Infinito y Carga Progresiva en el Catálogo
* **Arquitectura de Carga Progresiva:** En `CatalogState` y `CatalogCubit` se introdujo el manejo de paginación reactiva (`visibleCount`, `pagedArtworks`, `hasMoreToLoad`, `totalMatchingCount`).
* **Scroll Continuo:** `CatalogView` escucha eventos de desplazamiento con `NotificationListener<ScrollNotification>`. Cuando el usuario se aproxima al 90% del scroll vertical, la aplicación solicita automáticamente el siguiente lote de obras maestras.
* **Control Visual y Contador Dinámico:** Se incorporó al pie del catálogo un botón interactivo *"Cargar más obras maestras"* junto a un contador en tiempo real (*"Mostrando X de Y obras maestras"*), permitiendo navegar grandes colecciones sin sobrecargar la memoria del navegador.

### 1.10. Búsqueda y Filtros Avanzados por Artista y Movimiento Artístico
* **Filtros Específicos por Artista:** Fila de chips de desplazamiento horizontal que permite filtrar al instante por artistas destacados (Van Gogh, Monet, Vermeer, Caspar David Friedrich, Leonardo da Vinci, Rembrandt, Francisco de Goya, Sandro Botticelli, Edgar Degas, Paul Cézanne, Katsushika Hokusai, Edvard Munch, Gustav Klimt).
* **Filtros Específicos por Movimiento:** Chips dedicados para filtrar por época o escuela estética (Renacimiento, Barroco, Romanticismo, Impresionismo, Postimpresionismo, Expresionismo, Ukiyo-e, Modernismo).
* **Búsqueda Global Unificada:** El campo de búsqueda principal ahora busca en simultáneo por título de la obra, nombre del artista y movimiento estético.
* **Botón de Limpieza Rápida:** Acceso rápido para restablecer todos los filtros y volver a la vista completa del catálogo con un solo clic.

### 1.11. Nueva Sección Metodológica: "Movimientos & Exponentes" (7 Corrientes y 1–2 Exponentes Clave)
* **Pestaña 4 en la Guía de Estudio (`StudyView`):** Módulo pedagógico exhaustivo que sintetiza las corrientes estéticas de mayor impacto en la historia del arte:
  1. **Renacimiento:** Leonardo da Vinci (*La Gioconda*) y Sandro Botticelli (*El nacimiento de Venus*).
  2. **Barroco:** Johannes Vermeer (*La joven de la perla*) y Rembrandt van Rijn (*La ronda de noche*).
  3. **Romanticismo:** Caspar David Friedrich (*El caminante sobre el mar de nubes*) y Francisco de Goya (*El 3 de mayo en Madrid*).
  4. **Impresionismo:** Claude Monet (*Nenúfares*) y Edgar Degas (*La clase de danza*).
  5. **Postimpresionismo:** Vincent van Gogh (*Autorretrato con sombrero de paja*) y Paul Cézanne (*Los jugadores de cartas*).
  6. **Vanguardias / Expresionismo:** Edvard Munch (*El grito*) y Pablo Picasso (*Las señoritas de Aviñón*).
  7. **Arte Oriental / Ukiyo-e:** Katsushika Hokusai (*La gran ola de Kanagawa*).
* **Estructura Didáctica por Movimiento:**
  * Período histórico y contexto sociocultural.
  * **Fórmula Óptica de Wölfflin:** Explicación concreta de qué pares contrapuestos rigen la visión del movimiento (ej. Lineal vs. Pictórico, Superficie vs. Profundidad, Forma Abierta vs. Cerrada).
  * Ficha biográfica sintética del exponente (años de vida, nacionalidad, aporte revolucionario y obra cumbre).
  * Botón interactivo de integración directa: *"Explorar obras de este movimiento en el Catálogo"*, que redirige al catálogo y activa el filtro correspondiente en un toque.

### 1.12. Ampliación Curada del Repositorio de Obras Maestras
* **Expansión a 15 Obras Maestras Representativas (`ArtworkRepository`):** Se añadieron fichas técnicas y modelos de análisis pedagógico para obras cumbre de los movimientos citados:
  * *La Gioconda* (Leonardo da Vinci, Renacimiento).
  * *El nacimiento de Venus* (Sandro Botticelli, Renacimiento).
  * *La ronda de noche* (Rembrandt, Barroco).
  * *El 3 de mayo en Madrid* (Francisco de Goya, Romanticismo).
  * *La clase de danza* (Edgar Degas, Impresionismo).
  * *Los jugadores de cartas* (Paul Cézanne, Postimpresionismo).
  * *La gran ola de Kanagawa* (Katsushika Hokusai, Ukiyo-e).
  * *El grito* (Edvard Munch, Expresionismo).
  * *El beso* (Gustav Klimt, Modernismo/Secesión).
* **Vinculación con Licencias TASL y Fuentes:** Cada obra incluye metadatos de conservación, procedencia museográfica (The Met, Cleveland Museum of Art, Rijksmuseum, British Museum, Wikimedia Commons) y estado de semáforo legal.

### 1.13. Implementación de la Sesión Pedagógica Especial: "20 Autorretratos en Dominio Público"
* **Auditoría Legal Exhaustiva de 31 Autorretratos Fundamentales:**
  * Se auditó la selección curricular `100Autorretratos.docx` bajo el Convenio de Berna y la regla internacional de 70–80 años *post mortem auctoris* (p.m.a.).
  * Se determinó que **20 autorretratos** pertenecen plenamente al **Dominio Público (🟢 Semáforo Verde)** y pueden ser utilizados, proyectados y analizados sin restricciones ni regalías.
  * Se descartaron **11 obras protegidas por derechos vigentes o correspondientes a artistas vivos** (Frida Kahlo, Picasso, Chagall, Dalí, Lempicka, Warhol, Basquiat, Sherman, Kusama, Abramović).
* **Nueva Ruta y Vista Especializada (`/session/self-portraits` - `SelfPortraitsSessionView`):**
  * Vista interactiva con 3 pestañas pedagógicas:
    1. **Galería de los 20 Autorretratos:** Grid responsivo con filtrado dinámico por época/movimiento (Renacimiento, Manierismo, Barroco, Rococó, Romanticismo, Realismo, Impresionismo, Postimpresionismo, Expresionismo), badges de Dominio Público, focos de análisis visual del lenguaje artístico y botón directo *"Analizar en Visor Panofsky"*.
    2. **Ruta de las 4 Estaciones de Aprendizaje:**
       * *Estación 1 (Renacimiento & Barroco):* La afirmación profesional de la mujer artista (*Sofonisba Anguissola* y *Artemisia Gentileschi*).
       * *Estación 2 (Barroco & Romanticismo):* El claroscuro psicológico y la mirada introspectiva (*Rembrandt van Rijn* y *Francisco de Goya*).
       * *Estación 3 (Postimpresionismo & Simbolismo):* La pincelada expresiva y el color arbitrario (*Vincent van Gogh* y *Paul Gauguin*).
       * *Estación 4 (Realismo & Expresionismo):* La tensión expresionista de la línea y el cuerpo (*Egon Schiele* y *Gustave Courbet*).
       * Cada estación incluye los pares de Wölfflin correspondientes y preguntas de alto orden cognitivo estructuradas rigurosamente según la **Fórmula de las 4 Partes**: `[Disparador abierto] + [Verbo de habilidad] + [Contenido técnico] + [Contexto del alumno]`.
    3. **Taller Creativo & Rúbrica Formativa:**
       * Pauta para el trabajo práctico estudiantil *"Mi Autorretrato Intencionado"*, ofreciendo 3 estrategias técnicas (Claroscuro, Color Subjetivo y Línea Expresiva).
       * Ficha conceptual de reflexión en 3 preguntas al reverso.
       * Rúbrica formativa analítica con 4 niveles de desempeño (Destacado, Competente, Básico, Inicial) evaluando análisis formal, cognición alta, intención plástica y conciencia de propiedad intelectual.
* **Integración en Navegación y Catálogo:**
  * Nuevo destino permanente **"Autorretratos"** en el `NavigationRail` (escritorio/web) y en el `NavigationBar` (móvil).
  * Banner visual prominente al inicio del catálogo principal con acceso con un solo clic.
  * Tarjeta de acceso directo en la guía de estudio (`/study`).
* **Expansión del Repositorio (`ArtworkRepository`):**
  * Inclusión de las 20 fichas de autorretratos con resolución de imágenes verificadas de Wikimedia Commons y museos internacionales.
  * Modelos de guía Panofsky específicos para cada uno de los 20 autorretratos en sus 3 niveles (Formal, Iconográfico e Iconológico).

### 1.14. Optimización de Interfaz Móvil: Menú Desplegable de Filtros y Priorización Visual de la Obra de Arte
* **Detección del Problema en Pantallas Móviles:**
  * En dispositivos móviles, la acumulación simultánea de la barra de búsqueda, tres filas horizontales completas de chips de filtrado (Movimiento, Artista, Semáforo) y dos banners informativos voluminosos consumía más del 65% del alto visible de la pantalla, dejando únicamente visible una mínima franja del marco superior de la primera obra de arte.
* **Menú Desplegable Plegable y Animado (`_isFiltersExpanded`):**
  * Se rediseñó la barra superior de `CatalogView` a una altura ultracompacta (~48 px), integrando el campo de búsqueda con un botón desplegable con icono de afinación (`Icons.tune_rounded`), contador dinámico de filtros activos (`Filtros (N)`) e indicador de flecha desplegable.
  * Al pulsar el botón, se despliega suavemente un contenedor con diseño de tarjeta que reúne:
    1. Selector de Movimiento Estético (11 movimientos artísticos).
    2. Selector de Artista (25 artistas clave).
    3. Selector de Semáforo Legal (Dominio Público, Creative Commons y Derechos Reservados).
    4. Botón rápido *"Limpiar todo"* y botón de cierre *"Cerrar menú y ver N obras"*.
* **Eliminación de Banners Redundantes:**
  * Se removieron los banners fijos de la cabecera del catálogo, ya que tanto la sesión especial de autorretratos como la guía metodológica de movimientos cuentan con accesos directos persistentes en la barra de navegación inferior (`NavigationBar`) y superior (`AppBar`).
* **Mayor Tamaño y Protagonismo de la Imagen en `ArtworkCard`:**
  * Se incrementó la proporción dedicada a la imagen de la obra (`flex: 6` frente a `flex: 4` de ficha técnica) y la relación de aspecto (`aspectRatio: 0.95` en móvil).
  * Ahora, al entrar al catálogo desde un celular, la obra de arte ocupa de inmediato el centro de la pantalla en alta resolución y con total claridad.

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

# Enlace y credenciales de despliegue en Vercel
.vercel/

# Documentación interna
ACTUALIZACIONES_Y_FUNCIONALIDADES.md
```

### Justificación detallada de las exclusiones:
1. **Artefactos de compilación (`build/`, `.dart_tool/`, `.packages`, `.pub_cache/`):**
   * Son regenerados automáticamente por Flutter al compilar.
   * **Relación con Vercel:** La carpeta `build/` contiene cientos de megabytes de binarios compilados que no deben subirse a Git. Debido a esto, al conectar Vercel directamente con GitHub, Vercel no encuentra `build/web` a menos que se configure el comando de compilación con Flutter (`scripts/vercel_build.sh`) o se despliegue directamente la carpeta compilada desde la terminal (`npx vercel build/web --prod`).
2. **Archivos de IDE y sistema (`.vscode/`, `.idea/`, `*.iml`, `*.class`, `*.log`, `.DS_Store`):**
   * Evitan colisiones de preferencias de editor entre diferentes desarrolladores o sistemas operativos (Windows / macOS / Linux).
3. **`*.lock`:**
   * En bibliotecas y esquemas monorepo desacoplados, se omite para permitir la resolución flexible de versiones compatibles de paquetes.
4. **Almacenamiento persistente de Docker (`postgres_data/`, `redis_data/`):**
   * Carpetas donde Docker monta los volúmenes locales de almacenamiento físico de PostgreSQL y Redis, impidiendo almacenar bases de datos binarias pesadas en el repositorio.
5. **Variables de entorno y secretos (`.env`, `.env.*`):**
   * Medida de seguridad esencial para evitar exponer tokens, contraseñas de base de datos o credenciales de servicios en repositorios públicos.
6. **Caché y enlace de Vercel (`.vercel/`):**
   * Almacena identificadores del proyecto local y tokens de sesión de Vercel CLI que son propios del entorno del desarrollador.
7. **Documentación interna (`ACTUALIZACIONES_Y_FUNCIONALIDADES.md`):**
   * Registro técnico de cambios y arquitectura para consulta local sin interferir en los despliegues de producción.
