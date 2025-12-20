CREATE DATABASE
IF NOT EXISTS natillera CHARACTER
SET utf8mb4
COLLATE utf8mb4_unicode_ci;
USE natillera;

CREATE TABLE roles
(
    id_rol INT
    AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR
    (50) UNIQUE NOT NULL,
    descripcion VARCHAR
    (255),
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

    INSERT INTO roles
        (nombre_rol, descripcion)
    VALUES
        ('admin', 'Administrador del sistema con acceso completo'),
        ('cliente', 'Participante de la natillera');

    CREATE TABLE usuarios
    (
        id_usuario INT
        AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
        (100) NOT NULL,
    apellido VARCHAR
        (100) NOT NULL,
    email VARCHAR
        (255) UNIQUE NOT NULL,
    password VARCHAR
        (255) NOT NULL,
    telefono VARCHAR
        (20),
    direccion VARCHAR
        (255),
    id_rol INT NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    activo TINYINT
        (1) DEFAULT 1,
    FOREIGN KEY
        (id_rol) REFERENCES roles
        (id_rol),
    INDEX idx_usuario_activo
        (activo),
    INDEX idx_usuario_email
        (email)
);


        CREATE TABLE aportes
        (
            id_aporte INT
            AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    mes INT NOT NULL,
    anio INT NOT NULL,
    monto_aportado DECIMAL
            (10, 2) NOT NULL,
    interes_generado DECIMAL
            (10, 2) DEFAULT 0.00,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR
            (255),
    FOREIGN KEY
            (id_usuario) REFERENCES usuarios
            (id_usuario) ON
            DELETE CASCADE,
    INDEX idx_usuario_fecha (id_usuario, mes, anio
            )
);

            CREATE TABLE ahorros
            (
                id_ahorro INT
                AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    saldo_actual DECIMAL
                (10, 2) DEFAULT 0.00,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON
                UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY
                (id_usuario) REFERENCES usuarios
                (id_usuario) ON
                DELETE CASCADE,
    UNIQUE KEY unique_usuario (id_usuario),
    INDEX idx_ahorro_usuario
                (id_usuario)
);

                CREATE TABLE transacciones_ahorros
                (
                    id_transaccion INT
                    AUTO_INCREMENT PRIMARY KEY,
    id_ahorro INT NOT NULL,
    id_aporte INT NULL,
    tipo ENUM
                    ('aporte', 'interes', 'retiro', 'prestamo_desembolsado', 'pago_prestamo', 'bonificacion') NOT NULL,
    monto DECIMAL
                    (10, 2) NOT NULL,
    saldo_anterior DECIMAL
                    (10, 2) NOT NULL,
    saldo_nuevo DECIMAL
                    (10, 2) NOT NULL,
    descripcion VARCHAR
                    (255),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                    (id_ahorro) REFERENCES ahorros
                    (id_ahorro) ON
                    DELETE CASCADE,
    FOREIGN KEY (id_aporte)
                    REFERENCES aportes
                    (id_aporte) ON
                    DELETE
                    SET NULL
                    ,
    INDEX idx_transaccion_fecha
                    (fecha),
    INDEX idx_transaccion_tipo
                    (tipo)
);

                    CREATE TABLE actividades_extras
                    (
                        id_actividad_extra INT
                        AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                        (150) NOT NULL,
    tipo ENUM
                        ('rifa', 'bingo', 'venta', 'otro') NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    ganancia_total DECIMAL
                        (10, 2) DEFAULT 0.00,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM
                        ('planeada', 'realizada', 'cancelada') DEFAULT 'planeada',
    INDEX idx_actividad_estado
                        (estado),
    INDEX idx_actividad_fecha
                        (fecha)
);

                        CREATE TABLE bonificaciones
                        (
                            id_bonificacion INT
                            AUTO_INCREMENT PRIMARY KEY,
    id_actividad_extra INT NOT NULL,
    id_usuario INT NOT NULL,
    monto DECIMAL
                            (10, 2) NOT NULL,
    descripcion VARCHAR
                            (255),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    aplicada TINYINT
                            (1) DEFAULT 0,
    FOREIGN KEY
                            (id_actividad_extra) REFERENCES actividades_extras
                            (id_actividad_extra) ON
                            DELETE CASCADE,
    FOREIGN KEY (id_usuario)
                            REFERENCES usuarios
                            (id_usuario) ON
                            DELETE CASCADE,
    INDEX idx_bonificacion_aplicada (aplicada)
                            );

                            CREATE TABLE ganadores_rifas
                            (
                                id_ganador INT
                                AUTO_INCREMENT PRIMARY KEY,
    id_actividad_extra INT NOT NULL,
    id_usuario INT NOT NULL,
    numero_boleta VARCHAR
                                (50),
    monto_premio DECIMAL
                                (10, 2) NOT NULL,
    descripcion VARCHAR
                                (255),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                                (id_actividad_extra) REFERENCES actividades_extras
                                (id_actividad_extra) ON
                                DELETE CASCADE,
    FOREIGN KEY (id_usuario)
                                REFERENCES usuarios
                                (id_usuario) ON
                                DELETE CASCADE,
    INDEX idx_ganador_fecha (fecha)
                                );

                                CREATE TABLE prestamos
                                (
                                    id_prestamo INT
                                    AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    
    -- Datos ingresados por admin
    monto_solicitado DECIMAL
                                    (10, 2) NOT NULL,
    numero_cuotas INT NOT NULL,
    
    -- Calculados automáticamente por el sistema
    tasa_interes_aplicada DECIMAL
                                    (5, 2) NOT NULL,
    tasa_mora_aplicada DECIMAL
                                    (5, 2) NOT NULL,
    interes_total DECIMAL
                                    (10, 2) NOT NULL,
    monto_total DECIMAL
                                    (10, 2) NOT NULL,
    monto_cuota DECIMAL
                                    (10, 2) NOT NULL,
    monto_restante DECIMAL
                                    (10, 2) NOT NULL,
    
    -- Control de cuotas
    cuotas_pagadas INT DEFAULT 0,
    mora_acumulada DECIMAL
                                    (10, 2) DEFAULT 0.00,
    dias_atraso INT DEFAULT 0,
    
    -- Fechas
    fecha_desembolso DATE NOT NULL,
    fecha_primer_pago DATE NOT NULL,
    fecha_proximo_pago DATE,
    fecha_ultimo_pago DATE,
    
    -- Estado y auditoría
    estado ENUM
                                    ('pendiente', 'activo', 'pagado', 'moroso', 'cancelado') DEFAULT 'pendiente',
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    
    FOREIGN KEY
                                    (id_usuario) REFERENCES usuarios
                                    (id_usuario) ON
                                    DELETE CASCADE,
    INDEX idx_prestamo_estado (estado),
    INDEX idx_prestamo_usuario
                                    (id_usuario)
);

                                    CREATE TABLE pagos_prestamos
                                    (
                                        id_pago INT
                                        AUTO_INCREMENT PRIMARY KEY,
    id_prestamo INT NOT NULL,
    numero_cuota INT NOT NULL,
    monto_capital DECIMAL
                                        (10, 2) NOT NULL,
    monto_interes DECIMAL
                                        (10, 2) NOT NULL,
    monto_mora DECIMAL
                                        (10, 2) DEFAULT 0.00,
    monto_total DECIMAL
                                        (10, 2) NOT NULL,
    dias_atraso INT DEFAULT 0,
    descripcion VARCHAR
                                        (255),
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                                        (id_prestamo) REFERENCES prestamos
                                        (id_prestamo) ON
                                        DELETE CASCADE,
    INDEX idx_pago_prestamo (id_prestamo),
    INDEX idx_pago_fecha
                                        (fecha_pago)
);

                                        CREATE TABLE configuracion (
    id INT PRIMARY KEY AUTO_INCREMENT,
    clave VARCHAR
                                        (50) UNIQUE NOT NULL,
    valor VARCHAR
                                        (255) NOT NULL,
    descripcion VARCHAR
                                        (255),
    fecha_modificacion DATETIME DEFAULT CURRENT_TIMESTAMP ON
                                        UPDATE CURRENT_TIMESTAMP
                                        );

                                        INSERT INTO configuracion
                                            (clave, valor, descripcion)
                                        VALUES
                                            ('tasa_interes_prestamo', '2.00', 'Tasa de interés mensual para préstamos (%)'),
                                            ('tasa_mora', '3.00', 'Tasa de mora mensual por atraso en préstamos (%)'),
                                            ('tasa_interes_aporte', '0.00', 'Interés sobre aportes mensuales (%) - opcional'),
                                            ('monto_minimo_prestamo', '100000', 'Monto mínimo para solicitar préstamo'),
                                            ('monto_maximo_prestamo', '5000000', 'Monto máximo para solicitar préstamo'),
                                            ('cuotas_minimas', '3', 'Número mínimo de cuotas para préstamos'),
                                            ('cuotas_maximas', '24', 'Número máximo de cuotas para préstamos'),
                                            ('nombre_natillera', 'Mi Natillera', 'Nombre de la natillera'),
                                            ('moneda', 'COP', 'Moneda utilizada (COP, USD, etc.)');

                                        CREATE TABLE historial_configuracion
                                        (
                                            id INT
                                            AUTO_INCREMENT PRIMARY KEY,
    clave VARCHAR
                                            (50) NOT NULL,
    valor_anterior VARCHAR
                                            (255),
    valor_nuevo VARCHAR
                                            (255) NOT NULL,
    id_usuario_modifico INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                                            (id_usuario_modifico) REFERENCES usuarios
                                            (id_usuario),
    INDEX idx_historial_fecha
                                            (fecha)
);

                                            -- =====================================================
                                            -- ACTUALIZACIÓN BD - SISTEMA DE ADMINISTRADORES Y GANANCIAS
                                            -- =====================================================

                                            USE natillera;

                                            -- 1. AGREGAR RELACIÓN ADMIN-CLIENTE EN USUARIOS
                                            ALTER TABLE usuarios 
ADD COLUMN id_administrador INT NULL AFTER id_rol,
                                            ADD CONSTRAINT fk_usuario_administrador 
    FOREIGN KEY
                                            (id_administrador) 
    REFERENCES usuarios
                                            (id_usuario) 
    ON
                                            DELETE
                                            SET NULL;

                                            -- Índice para mejorar consultas
                                            CREATE INDEX idx_usuario_administrador ON usuarios(id_administrador);

                                            -- =====================================================
                                            -- 2. TABLA DE GANANCIAS MENSUALES (INGRESO GENERAL)
                                            -- =====================================================
                                            CREATE TABLE ganancias_mensuales
                                            (
                                                id_ganancia INT
                                                AUTO_INCREMENT PRIMARY KEY,
    mes INT NOT NULL,                           -- 1-12
    anio INT NOT NULL,                          -- 2024, 2025, etc.
    monto_total DECIMAL
                                                (10, 2) NOT NULL,        -- Ganancia total del mes
    descripcion VARCHAR
                                                (255),                   -- Descripción opcional
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario_registro INT NOT NULL,           -- Quién ingresó la ganancia
    FOREIGN KEY
                                                (id_usuario_registro) REFERENCES usuarios
                                                (id_usuario),
    UNIQUE KEY unique_ganancia_mes
                                                (mes, anio), -- Solo 1 ganancia por mes
    INDEX idx_ganancia_fecha
                                                (mes, anio)
);

                                                -- =====================================================
                                                -- 3. TABLA DE DISTRIBUCIÓN DE GANANCIAS (REPARTO POR ADMIN)
                                                -- =====================================================
                                                CREATE TABLE distribucion_ganancias
                                                (
                                                    id_distribucion INT
                                                    AUTO_INCREMENT PRIMARY KEY,
    id_ganancia INT NOT NULL,                   -- Referencia a ganancia mensual
    id_administrador INT NOT NULL,              -- Admin que recibe
    monto_asignado DECIMAL
                                                    (10, 2) NOT NULL,     -- Cuánto le toca
    fecha_distribucion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                                                    (id_ganancia) REFERENCES ganancias_mensuales
                                                    (id_ganancia) ON
                                                    DELETE CASCADE,
    FOREIGN KEY (id_administrador)
                                                    REFERENCES usuarios
                                                    (id_usuario) ON
                                                    DELETE CASCADE,
    UNIQUE KEY unique_distribucion (id_ganancia, id_administrador
                                                    ),
    INDEX idx_distribucion_admin
                                                    (id_administrador)
);

                                                    -- =====================================================
                                                    -- 4. VISTA ÚTIL - RESUMEN POR ADMINISTRADOR
                                                    -- =====================================================
                                                    CREATE VIEW vista_resumen_administradores
                                                    AS
                                                        SELECT
                                                            u.id_usuario as id_administrador,
                                                            u.nombre,
                                                            u.apellido,
                                                            CONCAT(u.nombre, ' ', u.apellido) as nombre_completo,
                                                            COUNT(DISTINCT c.id_usuario) as total_clientes,
                                                            COALESCE(SUM(a.saldo_actual), 0) as total_ahorrado_clientes,
                                                            (
        SELECT COALESCE(SUM(dg.monto_asignado), 0)
                                                            FROM distribucion_ganancias dg
                                                            WHERE dg.id_administrador = u.id_usuario
    ) as total_ganancias_recibidas
                                                        FROM usuarios u
                                                            LEFT JOIN usuarios c ON c.id_administrador = u.id_usuario AND c.activo = 1 AND c.id_rol = 2
                                                            LEFT JOIN ahorros a ON a.id_usuario = c.id_usuario
                                                        WHERE u.id_rol = 1 AND u.activo = 1
                                                        GROUP BY u.id_usuario, u.nombre, u.apellido;

                                                    -- =====================================================
                                                    -- 5. VISTA - GANANCIAS MENSUALES CON DETALLE
                                                    -- =====================================================
                                                    CREATE VIEW vista_ganancias_detalle
                                                    AS
                                                        SELECT
                                                            g.id_ganancia,
                                                            g.mes,
                                                            g.anio,
                                                            g.monto_total,
                                                            g.descripcion,
                                                            g.fecha_registro,
                                                            CONCAT(u.nombre, ' ', u.apellido) as registrado_por,
                                                            (
        SELECT COUNT(*)
                                                            FROM usuarios
                                                            WHERE id_rol = 1 AND activo = 1
    ) as total_administradores,
                                                            (g.monto_total / (
        SELECT COUNT(*)
                                                            FROM usuarios
                                                            WHERE id_rol = 1 AND activo = 1
    )) as monto_por_administrador
                                                        FROM ganancias_mensuales g
                                                            INNER JOIN usuarios u ON g.id_usuario_registro = u.id_usuario;