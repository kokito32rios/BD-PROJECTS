-- =============================================
-- CREAR LA BASE DE DATOS
-- =============================================
CREATE DATABASE
IF NOT EXISTS spa_unas 
CHARACTER
SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE spa_unas;

-- =============================================
-- 1. ROLES (catálogo pequeño)
-- =============================================
CREATE TABLE roles
(
    nombre_rol VARCHAR(50) PRIMARY KEY,
    descripcion VARCHAR(150) DEFAULT NULL,
    INDEX idx_nombre (nombre_rol)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Roles del sistema: admin, manicurista, cliente';

-- =============================================
-- 2. USUARIOS (email como PK principal)
-- =============================================
CREATE TABLE usuarios
(
    email VARCHAR(255) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20) DEFAULT NULL,
    nombre_rol VARCHAR(50) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT(1) DEFAULT 1
    COMMENT '1=activo, 0=inactivo/bloqueado',
    
    FOREIGN KEY
    (nombre_rol) REFERENCES roles
    (nombre_rol) 
        ON
    DELETE RESTRICT ON
    UPDATE CASCADE,
    
    INDEX idx_rol (nombre_rol),
    INDEX idx_activo (activo)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Todos los usuarios: admin, manicuristas y clientes';

    -- =============================================
    -- 3. SERVICIOS
    -- =============================================
    CREATE TABLE servicios
    (
        id_servicio INT
        AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
        (120) NOT NULL UNIQUE,
    precio DECIMAL
        (10,2) NOT NULL,
    duracion_minutos SMALLINT NOT NULL CHECK
        (duracion_minutos > 0),
    descripcion TEXT DEFAULT NULL,
    activo TINYINT
        (1) DEFAULT 1,
    
    INDEX idx_nombre
        (nombre),
    INDEX idx_activo
        (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Tipos de servicios ofrecidos (manicura, gel, etc.)';

        -- =============================================
        -- 4. HORARIOS DE TRABAJO (semanal recurrente)
        -- =============================================
        CREATE TABLE horarios_trabajo
        (
            id INT
            AUTO_INCREMENT PRIMARY KEY,
    email_manicurista VARCHAR
            (255) NOT NULL,
    dia_semana TINYINT NOT NULL CHECK
            (dia_semana BETWEEN 1 AND 7), -- 1=lunes, 7=domingo
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    activo TINYINT
            (1) DEFAULT 1,
    
    FOREIGN KEY
            (email_manicurista) REFERENCES usuarios
            (email) 
        ON
            DELETE CASCADE ON
            UPDATE CASCADE,
    
    UNIQUE KEY uk_manicurista_dia (email_manicurista, dia_semana
            ),
    INDEX idx_manicurista
            (email_manicurista)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Horarios laborales semanales por manicurista';

            -- =============================================
            -- 5. EXCEPCIONES DE HORARIO (vacaciones, feriados, etc.)
            -- =============================================
            CREATE TABLE excepciones_horario
            (
                id INT
                AUTO_INCREMENT PRIMARY KEY,
    email_manicurista VARCHAR
                (255) NOT NULL,
    fecha DATE NOT NULL,
    todo_el_dia TINYINT
                (1) DEFAULT 1 COMMENT '1=bloquea todo el día',
    hora_inicio TIME DEFAULT NULL,
    hora_fin TIME DEFAULT NULL,
    motivo VARCHAR
                (150) DEFAULT NULL,
    
    FOREIGN KEY
                (email_manicurista) REFERENCES usuarios
                (email) 
        ON
                DELETE CASCADE ON
                UPDATE CASCADE,
    
    UNIQUE KEY uk_excepcion (email_manicurista, fecha
                ),
    INDEX idx_fecha
                (fecha),
    INDEX idx_manicurista_fecha
                (email_manicurista, fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Días o rangos bloqueados (no laborables)';

                -- =============================================
                -- 6. CITAS (núcleo del sistema)
                -- =============================================
                CREATE TABLE citas
                (
                    id_cita BIGINT
                    AUTO_INCREMENT PRIMARY KEY,
    email_cliente VARCHAR
                    (255) NOT NULL,
    email_manicurista VARCHAR
                    (255) NOT NULL,
    id_servicio INT NOT NULL,
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR
                    (20) NOT NULL DEFAULT 'pendiente' 
        CHECK
                    (estado IN
                    ('pendiente', 'confirmada', 'completada', 'cancelada', 'no_asistio')),
    notas_cliente TEXT DEFAULT NULL,
    notas_manicurista TEXT DEFAULT NULL,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY
                    (email_cliente) REFERENCES usuarios
                    (email) 
        ON
                    DELETE RESTRICT ON
                    UPDATE CASCADE,
    FOREIGN KEY (email_manicurista) REFERENCES usuarios(email)
                    ON
                    DELETE RESTRICT ON
                    UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES servicios(id_servicio)
                    ON
                    DELETE RESTRICT ON
                    UPDATE CASCADE,
    
    INDEX idx_manicurista_fecha_hora (email_manicurista, fecha, hora_inicio),
    INDEX idx_cliente_fecha (email_cliente, fecha),
    INDEX idx_fecha_estado (fecha, estado),
    INDEX idx_estado (estado)
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Registro de citas - validar solapamientos en backend';

                    -- =============================================
                    -- 7. COMISIONES POR MANICURISTA (variable por año)
                    -- =============================================
                    CREATE TABLE comisiones_manicuristas
                    (
                        id INT
                        AUTO_INCREMENT PRIMARY KEY,
    email_manicurista VARCHAR
                        (255) NOT NULL,
    anio YEAR NOT NULL,
    porcentaje DECIMAL
                        (5,2) NOT NULL CHECK
                        (porcentaje BETWEEN 0 AND 100),
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY
                        (email_manicurista) REFERENCES usuarios
                        (email) 
        ON
                        DELETE CASCADE ON
                        UPDATE CASCADE,
    
    UNIQUE KEY uk_comision_anio (email_manicurista, anio
                        ),
    INDEX idx_manicurista
                        (email_manicurista),
    INDEX idx_anio
                        (anio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Porcentaje de comisión anual por manicurista (cambia cada año)';

                        -- =============================================
                        -- 8. PAGOS (pagos de clientes + comisiones a manicuristas)
                        -- =============================================
                        CREATE TABLE pagos
                        (
                            id_pago BIGINT
                            AUTO_INCREMENT PRIMARY KEY,
    id_cita BIGINT NOT NULL,
    monto_total DECIMAL
                            (10,2) NOT NULL COMMENT 'Precio del servicio (copiado para histórico)',
    comision_manicurista DECIMAL
                            (10,2) NOT NULL COMMENT 'Calculada: monto_total * porcentaje/100',
    estado_pago_cliente VARCHAR
                            (20) NOT NULL DEFAULT 'pendiente' 
        CHECK
                            (estado_pago_cliente IN
                            ('pendiente', 'pagado', 'reembolsado')),
    estado_pago_manicurista VARCHAR
                            (20) NOT NULL DEFAULT 'pendiente' 
        CHECK
                            (estado_pago_manicurista IN
                            ('pendiente', 'pagado')),
    metodo_pago_cliente VARCHAR
                            (50) DEFAULT NULL,
    fecha_pago_cliente DATETIME DEFAULT NULL,
    fecha_pago_manicurista DATETIME DEFAULT NULL,
    notas TEXT DEFAULT NULL,
    
    FOREIGN KEY
                            (id_cita) REFERENCES citas
                            (id_cita) 
        ON
                            DELETE CASCADE ON
                            UPDATE CASCADE,
    
    INDEX idx_cita (id_cita),
    INDEX idx_estado_cliente (estado_pago_cliente),
    INDEX idx_estado_manicurista (estado_pago_manicurista),
    INDEX idx_fecha_pago_cliente (fecha_pago_cliente)
                            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Pagos recibidos y comisiones a pagar a manicuristas';

                            -- =============================================
                            -- 9. TRABAJOS_IMAGENES (galería / catálogo público)
                            -- =============================================
                            CREATE TABLE trabajos_imagenes
                            (
                                id_imagen BIGINT
                                AUTO_INCREMENT PRIMARY KEY,
    id_servicio INT NOT NULL,
    email_manicurista VARCHAR
                                (255) DEFAULT NULL,
    id_cita BIGINT DEFAULT NULL,
    url_imagen VARCHAR
                                (500) NOT NULL COMMENT 'Ruta relativa ej: /uploads/trabajo-123.jpg',
    descripcion TEXT DEFAULT NULL,
    fecha_subida DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT
                                (1) DEFAULT 1,
    orden SMALLINT DEFAULT 0 COMMENT 'Para orden manual dentro de la categoría',
    
    FOREIGN KEY
                                (id_servicio) REFERENCES servicios
                                (id_servicio) 
        ON
                                DELETE RESTRICT ON
                                UPDATE CASCADE,
    FOREIGN KEY (email_manicurista) REFERENCES usuarios(email)
                                ON
                                DELETE
                                SET NULL
                                ON
                                UPDATE CASCADE,
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)
                                ON
                                DELETE
                                SET NULL
                                ON
                                UPDATE CASCADE,
    
    INDEX idx_servicio (id_servicio),
    INDEX idx_activo (activo),
    INDEX idx_fecha_subida (fecha_subida)
                                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='Galería de trabajos realizados - visible públicamente agrupado por servicio';

                                INSERT INTO roles
                                    (nombre_rol, descripcion)
                                VALUES
                                    ('admin', 'Administrador del sistema'),
                                    ('manicurista', 'Profesional que atiende servicios'),
                                    ('cliente', 'Usuario que agenda citas');

                                INSERT INTO servicios
                                    (nombre, precio, duracion_minutos, descripcion, activo)
                                VALUES
                                    ('Manicura Tradicional', 35000, 60, 'Limado, cutícula, esmaltado y crema hidratante', 1),
                                    ('Manicura en Gel', 55000, 60, 'Aplicación de esmalte semipermanente con secado UV, duración hasta 3 semanas', 1),
                                    ('Pedicura Spa', 45000, 60, 'Baño de pies, exfoliación, limado, cutícula y esmaltado', 1),
                                    ('Uñas Acrílicas', 80000, 120, 'Extensión con acrílico, forma personalizada y diseño básico incluido', 1),
                                    ('Diseño de Uñas', 15000, 30, 'Diseño artístico sobre manicura o pedicura (adicional)', 1),
                                    ('Kapping Gel', 70000, 90, 'Recubrimiento de gel para fortalecer y dar brillo natural', 1)
                                ON DUPLICATE KEY
                                UPDATE precio = VALUES
                                (precio);

                                SET SQL_SAFE_UPDATES
                                = 1;


                                USE spa_unas;

                                -- Agregar columna imagen_principal
                                ALTER TABLE trabajos_imagenes 
ADD COLUMN imagen_principal TINYINT
                                (1) DEFAULT 0 
COMMENT '1 = imagen principal del servicio, 0 = imagen secundaria'
AFTER activo;

                                -- Crear índice para búsquedas rápidas
                                CREATE INDEX idx_servicio_principal ON trabajos_imagenes(id_servicio, imagen_principal, activo);

                                -- IMPORTANTE: Solo puede haber UNA imagen principal por servicio
                                -- Esto se validará en el backend, pero podemos crear un trigger (opcional)

                                -- Actualizar imágenes existentes: marcar la primera de cada servicio como principal
                                UPDATE trabajos_imagenes ti
                                SET imagen_principal
                                = 1
WHERE id_imagen IN
                                (
    SELECT *
                                FROM (
        SELECT MIN(id_imagen)
                                    FROM trabajos_imagenes
                                    WHERE activo = 1
                                    GROUP BY id_servicio
    ) as temp
);

                                DROP TABLE trabajos_imagenes;

                                INSERT INTO trabajos_imagenes
                                    (id_servicio, url_imagen, descripcion, activo, orden)
                                VALUES
                                    (1, '/uploads/manicura-tradicional.jpg', 'Manicura clásica francesa', 1, 1),
                                    (2, '/uploads/manicura-gel.jpg', 'Esmalte gel color nude', 1, 1),
                                    (3, '/uploads/pedicura-spa.jpg', 'Pedicura relajante con exfoliación', 1, 1),
                                    (4, '/uploads/unas-acrilicas.jpg', 'Uñas acrílicas con diseño elegante', 1, 1),
                                    (5, '/uploads/diseno-unas.jpg', 'Nail art personalizado', 1, 1),
                                    (6, '/uploads/kapping-gel.jpg', 'Acabado natural brillante', 1, 1);