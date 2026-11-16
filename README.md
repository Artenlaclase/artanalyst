# ArtAnalyst 🎨

> **Herramienta pedagógica multiplataforma de análisis visual guiado (método Panofsky) y semáforo transparente de licencias y propiedad intelectual para educación artística.**

[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Hexagonal-purple.svg)]()
[![Tests](https://img.shields.io/badge/Tests-100%25%20Passing-brightgreen.svg)]()

---

## 1. Resumen Ejecutivo y Pilares Diferenciales

La mayoría de las aplicaciones de arte enseñan únicamente a reconocer obras (atribución, cronología, autoría). **ArtAnalyst** cubre un vacío en la educación formal:
1. **Análisis Visual Guiado en Tres Capas**: Estructura el pensamiento crítico del estudiante siguiendo el método iconográfico-iconológico de **Erwin Panofsky** y el análisis formal, acompañado de capas interactivas de composición, paleta cromática, marcado de regiones de interés (ROI) y respuestas modelo curadas por historiadores del arte.
2. **Transparencia Legal con Semáforo de Licencias**: Cada reproducción digital cuenta con un semáforo legal dinámico (🟢 Verde, 🟡 Amarillo, 🔴 Rojo) que evalúa los derechos de la *fotografía/reproducción digital* (no solo la antigüedad de la obra física original), educando activamente en derechos de autor y citación académica (TASL).

---

## 2. Arquitectura de Software y Monorepo

Se implementa una **arquitectura hexagonal (puertos y adaptadores)** en un monorepo basado en Dart y Flutter:

```
c:/proyectos/arteapp/
├── docker-compose.yml              # Orquestador: PostgreSQL 16 + Redis 7 + Microservicios
├── scripts/
│   ├── init_db.sql                 # Esquema DDL de PostgreSQL e inserción de datos semilla
│   └── run_all_tests.dart          # Ejecutor automatizado de todas las suites de prueba
└── packages/
    ├── shared/                     # Núcleo de dominio compartido (Frontend & Backend)
    │   ├── lib/
    │   │   ├── src/models/         # Artwork, ArtworkImage, AnalysisGuide, UserProgress, AnnotationRegion
    │   │   └── src/licensing/      # LicenseEvaluator, LicenseType, AttributionFormatter
    │   └── test/                   # Pruebas unitarias de evaluación legal y serialización
    │
    ├── server/
    │   ├── licensing/              # Microservicio de Medios y Licencias (Dart Frog / Shelf)
    │   │   ├── bin/server.dart     # Servidor HTTP (Puerto 8081)
    │   │   ├── lib/ports/          # MuseumApiPort
    │   │   ├── lib/adapters/       # The Met, Cleveland, Getty, Smithsonian, Wikimedia, Louvre
    │   │   ├── lib/services/       # LicensingService con orquestación y caché
    │   │   └── Dockerfile
    │   │
    │   └── catalog/                # Microservicio de Catálogo y Análisis (Serverpod / REST)
    │       ├── bin/server.dart     # Servidor HTTP (Puerto 8080)
    │       ├── lib/repositories/   # CatalogRepository con persistencia e in-memory store
    │       └── Dockerfile
    │
    └── app/                        # Aplicación Flutter Multiplataforma (Móvil, Web, Desktop)
        ├── lib/
        │   ├── core/theme/         # Material 3 con paleta accesible (Light & Dark)
        │   ├── core/router/        # GoRouter con ShellRoute adaptativo (Rail en Web, Bar en Móvil)
        │   ├── data/repositories/  # Conexión REST y fallback local
        │   └── features/
        │       ├── catalog/        # Catálogo, buscador y filtros por semáforo
        │       ├── analysis/       # Visor interactivo, capas geométricas, paleta y stepper Panofsky
        │       ├── licensing/      # LicenseBadge, LicenseEducationalDialog y CopyrightPlaceholder
        │       └── guide/          # Ficha educativa de propiedad intelectual y citación TASL
        └── web/                    # Configuración PWA / Web (index.html, manifest.json)
```

---

## 3. Módulo de Análisis Visual Guiado y Metodología (Panofsky & Wölfflin)

ArtAnalyst integra el marco metodológico canónico de la historia del arte estructurado en **4 pasos**, complementado con el análisis formal del esquema óptico de **Heinrich Wölfflin**:

```mermaid
flowchart TD
    P1["Paso 1: Descripción Pre-iconográfica y Análisis Formal<br/>(Motivos artísticos, significación fáctica/expresiva y 5 pares de Wölfflin)"] --> P2["Paso 2: Análisis Iconográfico<br/>(Temas, alegorías, personajes y consulta de fuentes textuales)"]
    P2 --> P3["Paso 3: Interpretación Iconológica<br/>(Significación intrínseca, valores simbólicos e intuición sintética)"]
    P3 --> P4["Paso 4: Verificación Histórica / Principios Correctivos<br/>(Historia del estilo, de los tipos y de los síntomas culturales)"]
```

### 3.1. Estructura de los 4 Pasos del Análisis

1. **Paso 1: Descripción Pre-iconográfica y Análisis Formal** (*Panofsky, 1979; Wölfflin, 1915/2017*):
   * **Motivos artísticos:** Identificación de formas puras (líneas, colores, volúmenes) que representan objetos, figuras humanas o paisajes.
   * **Significación fáctica y expresiva:** Distinción entre las acciones observables cotidianas y la atmósfera o cualidad psicológica.
   * **Esquema óptico de Heinrich Wölfflin (Los 5 pares de conceptos contrapuestos):**
     * **Lo lineal frente a lo pictórico:** Contornos plásticos tangibles vs. manchas de luz, sombra y bordes esfumados.
     * **Lo superficial frente a lo profundo:** Ordenación en franjas frontales paralelas vs. penetración espacial diagonal y escorzos.
     * **Forma cerrada frente a forma abierta:** Composición tectónica simétrica autosuficiente vs. atectónica dinámica orientada hacia el exterior.
     * **Pluralidad frente a unidad:** Cada componente mantiene su independencia formal vs. subordinación total a un motivo rector.
     * **Claridad absoluta frente a claridad relativa (oscuridad):** Formas plenamente reveladas vs. claroscuros, penumbras y misterios ópticos.

2. **Paso 2: Análisis Iconográfico** (*Panofsky, 1979*):
   * **Significado secundario o convencional:** Vinculación de los motivos visuales con historias, mitos, relatos bíblicos y alegorías.
   * **Consulta de fuentes:** Contrastación con textos literarios, teológicos, filosóficos o tradición oral conocida en la época.

3. **Paso 3: Interpretación Iconológica** (*Panofsky, 1979*):
   * **Significación intrínseca (Contenido):** Descubrimiento de los principios que revelan la mentalidad básica de una época, nación, clase social o religión, matizada por el artista.
   * **Valores simbólicos:** La forma y el tema como síntomas de una cosmovisión cultural profunda.
   * **Intuición sintética:** Integración articulada de formas, motivos y contexto en un discurso orgánico.

4. **Paso 4: Verificación Histórica (Principios Correctivos)** (*Panofsky, 1979*):
   * **Historia del estilo:** Corrige la descripción formal analizando cómo se configuraban las formas en cada época.
   * **Historia de los tipos:** Corrige el análisis iconográfico verificando cómo temas y alegorías se representaban convencionalmente.
   * **Historia de los síntomas culturales:** Corrige la interpretación iconológica confrontando la obra con la literatura y filosofía coetáneas para evitar el anacronismo.

---

## 4. Nueva Página de Estudio y Guía de la Aplicación (`/study`)

La aplicación cuenta con una sección interactiva de formación accesible desde la barra de navegación principal:

* 📚 **Pestaña 1: Metodología (Panofsky & Wölfflin):** Fichas didácticas exhaustivas con citas a *El significado en las artes visuales* (1979) y *Conceptos fundamentales de la historia del arte* (1915/2017), tarjetas desplegables para contrastar los 5 pares de Wölfflin y cuadro sinóptico de doble entrada.
* 📱 **Pestaña 2: ¿Cómo Funciona la App?:** Recorrido interactivo por las herramientas (buscador con semáforo, visor de alta resolución, overlay de regla de tercios/diagonales, overlay de paleta de colores HEX y armonías, herramienta de dibujo de regiones ROI y stepper de Panofsky con respuestas modelo).
* 🎯 **Pestaña 3: Taller y Autoevaluación:** Cuestionario formativo interactivo con retroalimentación inmediata sobre conceptos clave de Wölfflin y Panofsky.

---

## 5. Módulo de Semáforo de Licencias Transparente

| Semáforo | Estado Legal | Comportamiento en ArtAnalyst |
| :---: | :--- | :--- |
| 🟢 **Verde** | **Dominio Público / CC0 Mundial**<br>La institución liberó explícitamente la reproducción. | La imagen se visualiza en alta resolución, permite zoom profundo, anotación interactiva y descarga libre. |
| 🟡 **Amarillo** | **Creative Commons con Atribución**<br>(CC BY, CC BY-SA). | La imagen se visualiza acompañada automáticamente del bloque de atribución TASL (*Title, Author, Source, License*) y advertencias de ShareAlike. |
| 🔴 **Rojo** | **Derechos Reservados / Copyright**<br>La fotografía digital no puede redistribuirse. | **ArtAnalyst NO aloja ni muestra directamente la imagen**. Muestra el componente `CopyrightPlaceholder` con justificación pedagógica y un botón para abrir la ficha en la web oficial del museo. |

> **Filtro estricto en agregadores (Europeana y Wikimedia Commons):** La app rechaza automáticamente plantillas con restricciones territoriales (como `pd-us`, válida únicamente en EE.UU.) o licencias ambiguas, marcándolas en 🔴 Rojo para asegurar coherencia jurídica internacional.

---

## 5. Esquema de Base de Datos (PostgreSQL)

El archivo [`scripts/init_db.sql`](file:///c:/proyectos/arteapp/scripts/init_db.sql) define el esquema relacional normalizado:
- **`artworks`**: Metadatos universales de la obra (`id`, `external_id`, `source`, `title`, `artist_name`, `date_display`, `medium`, `dimensions`).
- **`artwork_images`**: Separa los derechos de la reproducción digital de la antigüedad de la obra (`image_url`, `thumbnail_url`, `license_type`, `is_worldwide`, `semaphore_color`).
- **`analysis_guides`**: Guiones educativos curados en 3 niveles de Panofsky con preguntas, pistas y respuestas modelo.
- **`user_analysis_progress`**: Registro persistente de respuestas de estudiantes y coordenadas JSON de las regiones ROI anotadas.

---

## 6. Puesta en Marcha Rápida (Quickstart)

### 6.1. Ejecución de la Suite de Pruebas Automatizada
Para verificar el 100% de los módulos de dominio, evaluador de licencias, adaptadores y repositorios:
```powershell
dart scripts/run_all_tests.dart
```

### 6.2. Levantar la Infraestructura con Docker Compose
Inicia PostgreSQL 16 con el esquema y datos semilla, Redis 7 y los dos microservicios:
```bash
docker compose up -d
```
- **Microservicio de Catálogo y Análisis:** `http://localhost:8080`
  - Health: `GET /health`
  - Obras: `GET /api/v1/artworks`
  - Guías Panofsky: `GET /api/v1/artworks/:id/guides`
- **Microservicio de Medios y Licencias:** `http://localhost:8081`
  - Resolución de licencia: `GET /api/v1/license/resolve?source=met&id=436535`
  - Resolución por lote: `POST /api/v1/license/batch`

### 6.3. Ejecutar los Microservicios Localmente con Dart
Si deseas ejecutarlos directamente sin Docker:
```powershell
# En una terminal (Microservicio de Medios y Licencias):
dart run packages/server/licensing/bin/server.dart

# En otra terminal (Microservicio de Catálogo y Análisis):
dart run packages/server/catalog/bin/server.dart
```

### 6.4. Ejecutar la Aplicación Flutter
```powershell
cd packages/app
flutter pub get
flutter run -d chrome      # Para Web
# o:
flutter run -d windows     # Para Windows Desktop
```

---

## 7. Obras Semilla Incluidas en la Demostración

1. 🟢 **Vincent van Gogh - Autorretrato con sombrero de paja (1887)**  
   *The Metropolitan Museum of Art (Open Access)* → Licencia CC0 1.0 Universal.  
   Incluye capas de análisis de pincelada, contraste de colores complementarios y reflexión sobre la ética del trabajo campesino.
2. 🟢 **Claude Monet - Nenúfares (1915–1926)**  
   *Cleveland Museum of Art (Open Access)* → Licencia CC0 1.0 Universal.  
   Análisis de la disolución del horizonte euclidiano y prefiguración del expresionismo abstracto.
3. 🟢 **Johannes Vermeer - La joven de la perla (c. 1665)**  
   *Mauritshuis / Wikimedia Commons* → Dominio Público Mundial verificado.  
   Estudio de claroscuro, técnica del empaste en la perla y comercio global en la Edad de Oro holandesa.
4. 🔴 **Leonardo da Vinci - Mona Lisa (La Gioconda)**  
   *Musée du Louvre* → Derechos Reservados de la reproducción fotográfica.  
   Demuestra el comportamiento ético del semáforo Rojo: bloqueo activo de imagen local, educación sobre copyright institucional y enlace al catálogo oficial del Louvre.

---

## 8. Licencia
Este proyecto educativo se distribuye bajo la licencia **MIT**, promoviendo el acceso abierto y el respeto riguroso a la propiedad intelectual.
