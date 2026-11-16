-- ==============================================================================
-- ArtAnalyst: Esquema de Base de Datos PostgreSQL
-- Módulo de Catálogo, Análisis Visual Guiado (Panofsky) y Semáforo de Licencias
-- ==============================================================================

-- Extensión para generación de UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. Tabla de obras (Metadatos)
CREATE TABLE IF NOT EXISTS artworks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    external_id VARCHAR(255) NOT NULL, -- ID en la fuente original (ej. 436535 en The Met)
    source VARCHAR(50) NOT NULL,        -- 'met', 'cleveland', 'getty', 'smithsonian', 'louvre', 'wikimedia'
    title TEXT NOT NULL,
    artist_name TEXT,
    date_display TEXT,
    medium TEXT,
    dimensions TEXT,
    description TEXT,
    metadata_license VARCHAR(50) DEFAULT 'CC0',
    official_url TEXT,
    culture TEXT,
    department TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (source, external_id)
);

-- Índices de búsqueda
CREATE INDEX IF NOT EXISTS idx_artworks_source_external ON artworks(source, external_id);
CREATE INDEX IF NOT EXISTS idx_artworks_artist ON artworks(artist_name);

-- 2. Tabla de imágenes asociadas a una obra
CREATE TABLE IF NOT EXISTS artwork_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artwork_id UUID REFERENCES artworks(id) ON DELETE CASCADE,
    image_url TEXT,
    thumbnail_url TEXT,
    deep_zoom_manifest_url TEXT,         -- DZI o IIIF info.json
    license_type VARCHAR(50) NOT NULL,   -- 'CC0', 'PD', 'CC_BY', 'CC_BY_SA', 'COPYRIGHT'
    license_uri TEXT,                    -- URI oficial de Creative Commons
    attribution_text TEXT,               -- Texto de atribución pre-generado según TASL
    is_worldwide BOOLEAN DEFAULT false,  -- true solo si la licencia es mundial
    semaphore_color CHAR(1) NOT NULL,    -- 'G' (verde), 'Y' (amarillo), 'R' (rojo)
    width INTEGER,
    height INTEGER,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_artwork_images_artwork ON artwork_images(artwork_id);
CREATE INDEX IF NOT EXISTS idx_artwork_images_semaphore ON artwork_images(semaphore_color);

-- 3. Tabla de guiones de análisis (Contenido educativo curado - Panofsky)
CREATE TABLE IF NOT EXISTS analysis_guides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artwork_id UUID REFERENCES artworks(id) ON DELETE CASCADE,
    level VARCHAR(20) NOT NULL,          -- 'formal', 'iconographic', 'iconological'
    prompt TEXT NOT NULL,                -- Pregunta guía para el estudiante
    model_answer TEXT NOT NULL,          -- Respuesta modelo curada por el equipo educativo
    hints JSONB DEFAULT '[]'::jsonb,     -- Pistas pedagógicas
    exercise_type VARCHAR(50) DEFAULT 'openReflection', -- 'focalPointSelect', 'colorPaletteInspect', etc.
    exercise_config JSONB,               -- Parámetros del ejercicio interactivo
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_analysis_guides_artwork_level ON analysis_guides(artwork_id, level);

-- 4. Tabla de progreso del estudiante en un análisis
CREATE TABLE IF NOT EXISTS user_analysis_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    artwork_id UUID REFERENCES artworks(id) ON DELETE CASCADE,
    level VARCHAR(20) NOT NULL,          -- 'formal', 'iconographic', 'iconological'
    user_response TEXT,                  -- Respuesta escrita por el estudiante
    regions JSONB DEFAULT '[]'::jsonb,   -- Regiones anotadas en el visor (coordenadas normalizadas, notas)
    is_completed BOOLEAN DEFAULT false,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (user_id, artwork_id, level)
);

CREATE INDEX IF NOT EXISTS idx_user_progress_user ON user_analysis_progress(user_id);

-- ==============================================================================
-- DATOS SEMILLA (SEED DATA) DE PRUEBA Y APRENDIZAJE
-- ==============================================================================

-- Obra 1: Vincent van Gogh (The Met - Verde CC0)
INSERT INTO artworks (id, external_id, source, title, artist_name, date_display, medium, dimensions, description, official_url, department)
VALUES (
    'a1000000-0000-0000-0000-000000000001',
    '436535',
    'met',
    'Autorretrato con sombrero de paja',
    'Vincent van Gogh',
    '1887',
    'Óleo sobre lienzo montado sobre tabla',
    '40.6 x 31.8 cm',
    'Pintado en París en el verano de 1887, este autorretrato demuestra el dominio de Van Gogh de la técnica postimpresionista y el uso expresivo de colores complementarios.',
    'https://www.metmuseum.org/art/collection/search/436535',
    'European Paintings'
) ON CONFLICT (source, external_id) DO NOTHING;

INSERT INTO artwork_images (id, artwork_id, image_url, thumbnail_url, license_type, license_uri, attribution_text, is_worldwide, semaphore_color, width, height)
VALUES (
    'b1000000-0000-0000-0000-000000000001',
    'a1000000-0000-0000-0000-000000000001',
    'https://images.metmuseum.org/CRDImages/ep/original/DT1502_cropped2.jpg',
    'https://images.metmuseum.org/CRDImages/ep/web-large/DT1502_cropped2.jpg',
    'CC0',
    'https://creativecommons.org/publicdomain/zero/1.0/',
    '"Autorretrato con sombrero de paja" por Vincent van Gogh. Colección: The Metropolitan Museum of Art (Open Access). Licencia: Dominio Público (Creative Commons Zero (CC0 1.0)). Fuente: https://www.metmuseum.org/art/collection/search/436535',
    true,
    'G',
    2718,
    3420
) ON CONFLICT DO NOTHING;

-- Guías de Panofsky para Obra 1
INSERT INTO analysis_guides (artwork_id, level, prompt, model_answer, hints, exercise_type, exercise_config, order_index)
VALUES 
(
    'a1000000-0000-0000-0000-000000000001',
    'formal',
    'Observa el contraste cromático y la dirección de las pinceladas. ¿Cómo utiliza Van Gogh las líneas de fuerza y los colores complementarios para guiar la mirada hacia su rostro?',
    'Van Gogh yuxtapone amarillos ocres brillantes en el sombrero frente al azul violáceo y verde del fondo. Las pinceladas rítmicas y radiales emanan del rostro hacia afuera, creando un dinamismo centrífugo que focaliza la tensión en los ojos intensos del pintor.',
    '["Observa los tonos del sombrero frente al fondo", "Fíjate en la dirección de los trazos de óleo: ¿siguen una curva o líneas rectas?"]'::jsonb,
    'focalPointSelect',
    '{"targetX": 0.50, "targetY": 0.42, "tolerance": 0.12}'::jsonb,
    1
),
(
    'a1000000-0000-0000-0000-000000000001',
    'iconographic',
    'Identifica los atributos del artista: la indumentaria de campesino (sombrero de paja y chaqueta rústica). ¿Qué significado simbólico transmite esta vestimenta respecto a su autopercepción?',
    'El sombrero de paja y la chaqueta campesina distancian a Van Gogh del artista burgués académico, alineándolo con la dignidad del trabajo manual y los labradores de la tierra, motivo central de su ética vital y artística.',
    '["Compara esta vestimenta con la de un retrato cortesano o de estudio burgués."]'::jsonb,
    'regionAnnotationTag',
    '{"requiredTag": "symbol"}'::jsonb,
    2
),
(
    'a1000000-0000-0000-0000-000000000001',
    'iconological',
    '¿Qué revela este autorretrato sobre la vanguardia parisina de finales del siglo XIX y la crisis existencial del artista moderno?',
    'Refleja la asimilación del Neoimpresionismo y las teorías científicas del color de Chevreul, así como la emergencia de la subjetividad moderna: el arte deja de ser mímesis externa para convertirse en sismógrafo psicológico del individuo.',
    '["Considera el impacto de la industrialización y la soledad del artista en la metrópolis moderna."]'::jsonb,
    'openReflection',
    null,
    3
);

-- Obra 2: Claude Monet - Ninfeas (Cleveland Museum of Art - Verde CC0)
INSERT INTO artworks (id, external_id, source, title, artist_name, date_display, medium, dimensions, description, official_url, department)
VALUES (
    'a2000000-0000-0000-0000-000000000002',
    '1915.534',
    'cleveland',
    'Nenúfares (Water Lilies)',
    'Claude Monet',
    '1914–1917',
    'Óleo sobre lienzo',
    '166.1 x 142.2 cm',
    'Parte de la monumental serie de nenúfares pintados en su jardín de Giverny. Monet disuelve el horizonte tradicional para sumergir al espectador en el reflejo del agua.',
    'https://www.clevelandart.org/art/1915.534',
    'Modern European Painting'
) ON CONFLICT (source, external_id) DO NOTHING;

INSERT INTO artwork_images (id, artwork_id, image_url, thumbnail_url, license_type, license_uri, attribution_text, is_worldwide, semaphore_color, width, height)
VALUES (
    'b2000000-0000-0000-0000-000000000002',
    'a2000000-0000-0000-0000-000000000002',
    'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_web.jpg',
    'https://openaccess-cdn.clevelandart.org/1915.534/1915.534_thumb.jpg',
    'CC0',
    'https://creativecommons.org/publicdomain/zero/1.0/',
    '"Nenúfares (Water Lilies)" por Claude Monet. Colección: Cleveland Museum of Art (Open Access). Licencia: Dominio Público (Creative Commons Zero (CC0 1.0)). Fuente: https://www.clevelandart.org/art/1915.534',
    true,
    'G',
    2800,
    3274
) ON CONFLICT DO NOTHING;

-- Obra 3: Mona Lisa (Musée du Louvre - ROJO por Derechos Reservados de la reproducción fotográfica)
INSERT INTO artworks (id, external_id, source, title, artist_name, date_display, medium, dimensions, description, official_url, department)
VALUES (
    'a3000000-0000-0000-0000-000000000003',
    'cl010062370',
    'louvre',
    'Retrato de Lisa Gherardini (La Gioconda / Mona Lisa)',
    'Leonardo da Vinci',
    '1503–1519',
    'Óleo sobre tabla de álamo',
    '77 x 53 cm',
    'La obra cumbre del sfumato renacentista. La reproducción digital oficial se encuentra bajo derechos de la RMN-Grand Palais / Musée du Louvre.',
    'https://collections.louvre.fr/en/ark:/53355/cl010062370',
    'Peintures italiennes'
) ON CONFLICT (source, external_id) DO NOTHING;

INSERT INTO artwork_images (id, artwork_id, image_url, thumbnail_url, license_type, license_uri, attribution_text, is_worldwide, semaphore_color, width, height)
VALUES (
    'b3000000-0000-0000-0000-000000000003',
    'a3000000-0000-0000-0000-000000000003',
    NULL, -- No se aloja ni se sirve directamente por protección de derechos
    NULL,
    'COPYRIGHT',
    '',
    'Todos los derechos de reproducción reservados por Musée du Louvre / GrandPalaisRmn.',
    false,
    'R',
    NULL,
    NULL
) ON CONFLICT DO NOTHING;
