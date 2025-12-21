-- Base de datos mejorada con optimizaciones
CREATE DATABASE
IF NOT EXISTS registro_horas_docentes;
USE registro_horas_docentes;

-- 1. Roles (admin, docente)
CREATE TABLE roles
(
    id_rol INT
    AUTO_INCREMENT PRIMARY KEY,
    nombre   VARCHAR
    (30) NOT NULL UNIQUE,
    creado_el DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

    -- 2. Usuarios (admin y docentes)
    CREATE TABLE usuarios
    (
        id_usuario INT
        AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR
        (100) NOT NULL,
    documento    VARCHAR
        (20) UNIQUE NOT NULL,
    email        VARCHAR
        (100) UNIQUE,
    telefono     VARCHAR
        (15),
    password     VARCHAR
        (255) NOT NULL,
    id_rol       INT NOT NULL,
    activo       TINYINT
        (1) DEFAULT 1,
    creado_el    DATETIME DEFAULT CURRENT_TIMESTAMP,
    actualizado_el DATETIME DEFAULT CURRENT_TIMESTAMP ON
        UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY
        (id_rol) REFERENCES roles
        (id_rol),
    INDEX idx_documento
        (documento),
    INDEX idx_email
        (email),
    INDEX idx_rol
        (id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

        -- 3. Tipos de curso (valor por hora)
        CREATE TABLE tipos_curso
        (
            id_tipo INT
            AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR
            (50) NOT NULL,
    valor_hora   DECIMAL
            (10,2) NOT NULL,
    activo       TINYINT
            (1) DEFAULT 1,
    creado_el    DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

            -- 4. Grupos (cada grupo tiene un tipo de curso y un docente asignado)
            CREATE TABLE grupos
            (
                id_grupo INT
                AUTO_INCREMENT PRIMARY KEY,
    codigo       VARCHAR
                (20) NOT NULL UNIQUE,
    nombre       VARCHAR
                (100) NOT NULL,
    id_tipo      INT NOT NULL,
    id_docente   INT NOT NULL,
    activo       TINYINT
                (1) DEFAULT 1,
    creado_el    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                (id_tipo)    REFERENCES tipos_curso
                (id_tipo),
    FOREIGN KEY
                (id_docente) REFERENCES usuarios
                (id_usuario) ON
                DELETE RESTRICT,
    INDEX idx_docente (id_docente),
    INDEX idx_codigo
                (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

                -- 5. Registro diario de horas (historial completo)
                CREATE TABLE registros_horas
                (
                    id_registro INT
                    AUTO_INCREMENT PRIMARY KEY,
    id_docente       INT NOT NULL,
    id_grupo         INT NOT NULL,
    fecha            DATE NOT NULL,
    hora_ingreso     TIME NOT NULL,
    hora_salida      TIME NULL,
    horas_trabajadas DECIMAL
                    (5,2) DEFAULT 0.00,
    observaciones    VARCHAR
                    (255),
    finalizado       TINYINT
                    (1) DEFAULT 0,
    creado_el        DATETIME DEFAULT CURRENT_TIMESTAMP,
    actualizado_el   DATETIME DEFAULT CURRENT_TIMESTAMP ON
                    UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY
                    (id_docente) REFERENCES usuarios
                    (id_usuario),
    FOREIGN KEY
                    (id_grupo)   REFERENCES grupos
                    (id_grupo),
    UNIQUE KEY unico_dia
                    (id_docente, id_grupo, fecha),
    INDEX idx_fecha
                    (fecha),
    INDEX idx_docente_fecha
                    (id_docente, fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

                    -- 6. Cuentas de cobro generadas (histórico de PDFs)
                    CREATE TABLE cuentas_cobro
                    (
                        id_cuenta INT
                        AUTO_INCREMENT PRIMARY KEY,
    id_docente   INT NOT NULL,
    mes          INT NOT NULL,
    anio         INT NOT NULL,
    total_horas  DECIMAL
                        (10,2) NOT NULL,
    total_pagar  DECIMAL
                        (12,2) NOT NULL,
    generado_el  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                        (id_docente) REFERENCES usuarios
                        (id_usuario),
    INDEX idx_docente_periodo
                        (id_docente, anio, mes),
    UNIQUE KEY unico_periodo
                        (id_docente, mes, anio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

                        -- Insertar roles iniciales
                        INSERT INTO roles
                            (nombre)
                        VALUES
                            ('admin'),
                            ('docente');

                        -- Insertar usuario admin por defecto (contraseña: admin123)
                        -- Hash bcrypt de 'admin123': $2b$10$YourHashHere
                        INSERT INTO usuarios
                            (nombre, documento, email, password, id_rol)
                        VALUES
                            ('Administrador', '43925613', '2@sistema.com',
                                '$2b$10$QNf.W2LYDqa4l95bTl6.te2XjXhNdQAk6ipIGWcay2Z3fqhN/BWzG', 1);

                        -- Insertar tipos de curso de ejemplo
                        INSERT INTO tipos_curso
                            (nombre, valor_hora)
                        VALUES
                            ('Curso Básico', 25000.00),
                            ('Curso Avanzado', 35000.00),
                            ('Curso Especializado', 45000.00);

                        -- Tabla de bancos
                        CREATE TABLE bancos
                        (
                            id_banco INT
                            AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                            (50) NOT NULL UNIQUE,
    activo TINYINT
                            (1) DEFAULT 1,
    creado_el DATETIME DEFAULT CURRENT_TIMESTAMP
);

                            -- Tabla de tipos de cuenta
                            CREATE TABLE tipos_cuenta
                            (
                                id_tipo_cuenta INT
                                AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                                (30) NOT NULL UNIQUE,  -- 'Ahorros', 'Corriente'
    activo TINYINT
                                (1) DEFAULT 1,
    creado_el DATETIME DEFAULT CURRENT_TIMESTAMP
);

                                -- Modificar tabla usuarios
                                ALTER TABLE usuarios
ADD COLUMN id_banco INT NULL,
                                ADD COLUMN id_tipo_cuenta INT NULL,
                                ADD COLUMN numero_cuenta VARCHAR
                                (20) NULL,
                                ADD FOREIGN KEY
                                (id_banco) REFERENCES bancos
                                (id_banco),
                                ADD FOREIGN KEY
                                (id_tipo_cuenta) REFERENCES tipos_cuenta
                                (id_tipo_cuenta);

                                USE registro_horas_docentes;

                                -- 1. Agregar campo 'programa' a tipos_curso
                                ALTER TABLE tipos_curso
ADD COLUMN programa VARCHAR
                                (100) NULL AFTER nombre;

                                ALTER TABLE tipos_curso
CHANGE COLUMN nombre modulo VARCHAR
                                (50) NOT NULL;



                                -- 2. Agregar campo 'tema_desarrollado' a registros_horas
                                ALTER TABLE registros_horas 
ADD COLUMN tema_desarrollado TEXT NULL AFTER horas_trabajadas;