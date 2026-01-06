CREATE DATABASE Constructora_El_Pino;

USE Constructora_El_Pino;

CREATE TABLE roles
(
    id INT
    AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
    (50) NOT NULL UNIQUE,
    descripcion VARCHAR
    (255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON
    UPDATE CURRENT_TIMESTAMP
    );

    CREATE TABLE usuarios
    (
        cedula VARCHAR(20) PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        rol_id INT NOT NULL,
        activo TINYINT(1) DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON
        UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY
        (rol_id) REFERENCES roles
        (id) ON
        DELETE RESTRICT
);

        CREATE TABLE tipos_vivienda
        (
            id INT
            AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
            (50) NOT NULL UNIQUE,  -- ej: 'Casa', 'Apartamento', 'Local comercial', 'Oficina', 'Terreno'
    descripcion VARCHAR
            (255),
    activo TINYINT
            (1) DEFAULT 1
);

            CREATE TABLE tipos_transaccion
            (
                id INT
                AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                (20) NOT NULL UNIQUE,  -- 'Venta', 'Arriendo'
    descripcion VARCHAR
                (255)
);

                CREATE TABLE estados_inmueble
                (
                    id INT
                    AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                    (30) NOT NULL UNIQUE,  -- 'Disponible', 'Vendido', 'Alquilado', 'Reservado', 'Retirado'
    descripcion VARCHAR
                    (255)
);

                    CREATE TABLE condiciones
                    (
                        id INT
                        AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                        (30) NOT NULL UNIQUE,  -- 'Nueva', 'Usada', 'En construcción'
    descripcion VARCHAR
                        (255)
);

                        CREATE TABLE ciudades
                        (
                            id INT
                            AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR
                            (100) NOT NULL UNIQUE,  -- 'Bogotá', 'Medellín', 'Cali', 'Barranquilla', etc.
    departamento VARCHAR
                            (100),            -- opcional: 'Bogotá D.C.', 'Antioquia', etc.
    pais VARCHAR
                            (50) DEFAULT 'Colombia'
);

                            CREATE TABLE inmuebles
                            (
                                id INT
                                AUTO_INCREMENT PRIMARY KEY,
    tipo_vivienda_id INT NOT NULL,
    medidas DECIMAL
                                (10,2) NOT NULL,
    tipo_transaccion_id INT NOT NULL,
    estado_id INT NOT NULL,
    precio DECIMAL
                                (15,2) NOT NULL,
    condicion_id INT NOT NULL,
    direccion VARCHAR
                                (255) NOT NULL,
    barrio VARCHAR
                                (100),
    ciudad_id INT NOT NULL,
    habitaciones TINYINT NOT NULL,
    banos TINYINT NOT NULL,
    descripcion TEXT,
    caracteristicas JSON,                 -- ej: {"garaje": true, "piscina": true}
    latitud DECIMAL
                                (10, 8),
    longitud DECIMAL
                                (11, 8),
    cedula_usuario VARCHAR
                                (20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON
                                UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY
                                (tipo_vivienda_id) REFERENCES tipos_vivienda
                                (id),
    FOREIGN KEY
                                (tipo_transaccion_id) REFERENCES tipos_transaccion
                                (id),
    FOREIGN KEY
                                (estado_id) REFERENCES estados_inmueble
                                (id),
    FOREIGN KEY
                                (condicion_id) REFERENCES condiciones
                                (id),
    FOREIGN KEY
                                (ciudad_id) REFERENCES ciudades
                                (id),
    FOREIGN KEY
                                (cedula_usuario) REFERENCES usuarios
                                (cedula) ON
                                DELETE RESTRICT
);

                                CREATE TABLE medios
                                (
                                    id INT
                                    AUTO_INCREMENT PRIMARY KEY,
    inmueble_id INT NOT NULL,
    tipo ENUM
                                    ('imagen', 'video') NOT NULL,
    url VARCHAR
                                    (500) NOT NULL,
    descripcion VARCHAR
                                    (255),
    es_principal TINYINT
                                    (1) DEFAULT 0,
    orden INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY
                                    (inmueble_id) REFERENCES inmuebles
                                    (id) ON
                                    DELETE CASCADE
);

                                    INSERT INTO tipos_vivienda
                                        (nombre)
                                    VALUES
                                        ('Casa'),
                                        ('Apartamento'),
                                        ('Apartaestudio'),
                                        ('Local comercial'),
                                        ('Oficina'),
                                        ('Bodega'),
                                        ('Terreno'),
                                        ('Finca'),
                                        ('Otros');

                                    INSERT INTO tipos_transaccion
                                        (nombre)
                                    VALUES
                                        ('Venta'),
                                        ('Arriendo');

                                    INSERT INTO estados_inmueble
                                        (nombre)
                                    VALUES
                                        ('Disponible'),
                                        ('Reservado'),
                                        ('Vendido'),
                                        ('Alquilado'),
                                        ('Retirado');

                                    INSERT INTO condiciones
                                        (nombre)
                                    VALUES
                                        ('Nueva'),
                                        ('Usada'),
                                        ('En construcción');



                                    INSERT INTO ciudades
                                        (nombre, departamento, pais)
                                    VALUES
                                        ('Abejorral', 'Antioquia', 'Colombia'),
                                        ('Abriaquí', 'Antioquia', 'Colombia'),
                                        ('Alejandría', 'Antioquia', 'Colombia'),
                                        ('Amagá', 'Antioquia', 'Colombia'),
                                        ('Amalfi', 'Antioquia', 'Colombia'),
                                        ('Andes', 'Antioquia', 'Colombia'),
                                        ('Angelópolis', 'Antioquia', 'Colombia'),
                                        ('Angostura', 'Antioquia', 'Colombia'),
                                        ('Anorí', 'Antioquia', 'Colombia'),
                                        ('Anzá', 'Antioquia', 'Colombia'),
                                        ('Apartadó', 'Antioquia', 'Colombia'),
                                        ('Arboletes', 'Antioquia', 'Colombia'),
                                        ('Argelia', 'Antioquia', 'Colombia'),
                                        ('Armenia', 'Antioquia', 'Colombia'),
                                        ('Barbosa', 'Antioquia', 'Colombia'),
                                        ('Bello', 'Antioquia', 'Colombia'),
                                        ('Belmira', 'Antioquia', 'Colombia'),
                                        ('Betania', 'Antioquia', 'Colombia'),
                                        ('Betulia', 'Antioquia', 'Colombia'),
                                        ('Ciudad Bolívar', 'Antioquia', 'Colombia'),
                                        ('Briceño', 'Antioquia', 'Colombia'),
                                        ('Buriticá', 'Antioquia', 'Colombia'),
                                        ('Cáceres', 'Antioquia', 'Colombia'),
                                        ('Caicedo', 'Antioquia', 'Colombia'),
                                        ('Caldas', 'Antioquia', 'Colombia'),
                                        ('Campamento', 'Antioquia', 'Colombia'),
                                        ('Cañasgordas', 'Antioquia', 'Colombia'),
                                        ('Caracolí', 'Antioquia', 'Colombia'),
                                        ('Caramanta', 'Antioquia', 'Colombia'),
                                        ('Carepa', 'Antioquia', 'Colombia'),
                                        ('El Carmen de Viboral', 'Antioquia', 'Colombia'),
                                        ('Carolina del Príncipe', 'Antioquia', 'Colombia'),
                                        ('Caucasia', 'Antioquia', 'Colombia'),
                                        ('Chigorodó', 'Antioquia', 'Colombia'),
                                        ('Cisneros', 'Antioquia', 'Colombia'),
                                        ('Cocorná', 'Antioquia', 'Colombia'),
                                        ('Concepción', 'Antioquia', 'Colombia'),
                                        ('Concordia', 'Antioquia', 'Colombia'),
                                        ('Copacabana', 'Antioquia', 'Colombia'),
                                        ('Dabeiba', 'Antioquia', 'Colombia'),
                                        ('Donmatías', 'Antioquia', 'Colombia'),
                                        ('Ebéjico', 'Antioquia', 'Colombia'),
                                        ('El Bagre', 'Antioquia', 'Colombia'),
                                        ('Entrerríos', 'Antioquia', 'Colombia'),
                                        ('Envigado', 'Antioquia', 'Colombia'),
                                        ('Fredonia', 'Antioquia', 'Colombia'),
                                        ('Frontino', 'Antioquia', 'Colombia'),
                                        ('Giraldo', 'Antioquia', 'Colombia'),
                                        ('Girardota', 'Antioquia', 'Colombia'),
                                        ('Gómez Plata', 'Antioquia', 'Colombia'),
                                        ('Granada', 'Antioquia', 'Colombia'),
                                        ('Guadalupe', 'Antioquia', 'Colombia'),
                                        ('Guarne', 'Antioquia', 'Colombia'),
                                        ('Guatapé', 'Antioquia', 'Colombia'),
                                        ('Heliconia', 'Antioquia', 'Colombia'),
                                        ('Hispania', 'Antioquia', 'Colombia'),
                                        ('Itagüí', 'Antioquia', 'Colombia'),
                                        ('Ituango', 'Antioquia', 'Colombia'),
                                        ('Jardín', 'Antioquia', 'Colombia'),
                                        ('Jericó', 'Antioquia', 'Colombia'),
                                        ('La Ceja', 'Antioquia', 'Colombia'),
                                        ('La Estrella', 'Antioquia', 'Colombia'),
                                        ('La Pintada', 'Antioquia', 'Colombia'),
                                        ('La Unión', 'Antioquia', 'Colombia'),
                                        ('Liborina', 'Antioquia', 'Colombia'),
                                        ('Maceo', 'Antioquia', 'Colombia'),
                                        ('Marinilla', 'Antioquia', 'Colombia'),
                                        ('Medellín', 'Antioquia', 'Colombia'),
                                        ('Montebello', 'Antioquia', 'Colombia'),
                                        ('Murindó', 'Antioquia', 'Colombia'),
                                        ('Mutatá', 'Antioquia', 'Colombia'),
                                        ('Nariño', 'Antioquia', 'Colombia'),
                                        ('Nechí', 'Antioquia', 'Colombia'),
                                        ('Necoclí', 'Antioquia', 'Colombia'),
                                        ('Olaya', 'Antioquia', 'Colombia'),
                                        ('Peñol', 'Antioquia', 'Colombia'),
                                        ('Peque', 'Antioquia', 'Colombia'),
                                        ('Pueblorrico', 'Antioquia', 'Colombia'),
                                        ('Puerto Berrío', 'Antioquia', 'Colombia'),
                                        ('Puerto Nare', 'Antioquia', 'Colombia'),
                                        ('Puerto Triunfo', 'Antioquia', 'Colombia'),
                                        ('Remedios', 'Antioquia', 'Colombia'),
                                        ('El Retiro', 'Antioquia', 'Colombia'),
                                        ('Rionegro', 'Antioquia', 'Colombia'),
                                        ('Sabanalarga', 'Antioquia', 'Colombia'),
                                        ('Sabaneta', 'Antioquia', 'Colombia'),
                                        ('Salgar', 'Antioquia', 'Colombia'),
                                        ('San Andrés de Cuerquia', 'Antioquia', 'Colombia'),
                                        ('San Carlos', 'Antioquia', 'Colombia'),
                                        ('San Francisco', 'Antioquia', 'Colombia'),
                                        ('San Jerónimo', 'Antioquia', 'Colombia'),
                                        ('San José de la Montaña', 'Antioquia', 'Colombia'),
                                        ('San Juan de Urabá', 'Antioquia', 'Colombia'),
                                        ('San Luis', 'Antioquia', 'Colombia'),
                                        ('San Pedro de Urabá', 'Antioquia', 'Colombia'),
                                        ('San Pedro de los Milagros', 'Antioquia', 'Colombia'),
                                        ('San Rafael', 'Antioquia', 'Colombia'),
                                        ('San Roque', 'Antioquia', 'Colombia'),
                                        ('San Vicente Ferrer', 'Antioquia', 'Colombia'),
                                        ('Santa Bárbara', 'Antioquia', 'Colombia'),
                                        ('Santa Fe de Antioquia', 'Antioquia', 'Colombia'),
                                        ('Santa Rosa de Osos', 'Antioquia', 'Colombia'),
                                        ('El Santuario', 'Antioquia', 'Colombia'),
                                        ('Segovia', 'Antioquia', 'Colombia'),
                                        ('Sonsón', 'Antioquia', 'Colombia'),
                                        ('Sopetrán', 'Antioquia', 'Colombia'),
                                        ('Támesis', 'Antioquia', 'Colombia'),
                                        ('Tarazá', 'Antioquia', 'Colombia'),
                                        ('Tarso', 'Antioquia', 'Colombia'),
                                        ('Titiribí', 'Antioquia', 'Colombia'),
                                        ('Toledo', 'Antioquia', 'Colombia'),
                                        ('Turbo', 'Antioquia', 'Colombia'),
                                        ('Uramita', 'Antioquia', 'Colombia'),
                                        ('Urrao', 'Antioquia', 'Colombia'),
                                        ('Valdivia', 'Antioquia', 'Colombia'),
                                        ('Valparaíso', 'Antioquia', 'Colombia'),
                                        ('Vegachí', 'Antioquia', 'Colombia'),
                                        ('Venecia', 'Antioquia', 'Colombia'),
                                        ('Vigía del Fuerte', 'Antioquia', 'Colombia'),
                                        ('Yalí', 'Antioquia', 'Colombia'),
                                        ('Yarumal', 'Antioquia', 'Colombia'),
                                        ('Yolombó', 'Antioquia', 'Colombia'),
                                        ('Zaragoza', 'Antioquia', 'Colombia');

                                    CREATE TABLE clientes
                                    (
                                        id INT
                                        AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR
                                        (20) UNIQUE NOT NULL,
    nombre VARCHAR
                                        (150) NOT NULL,
    telefono VARCHAR
                                        (20),
    email VARCHAR
                                        (255),
    direccion VARCHAR
                                        (255),
    notas TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON
                                        UPDATE CURRENT_TIMESTAMP
                                        );

                                        -- Luego agregas estos campos a la tabla inmuebles
                                        ALTER TABLE inmuebles 
ADD COLUMN cliente_id INT NULL,
                                        ADD COLUMN fecha_transaccion DATE NULL,
                                        -- fecha en que se vendió/alquiló
                                        ADD COLUMN valor_transaccion DECIMAL
                                        (15,2) NULL,
                                        -- por si difiere del precio listado
                                        ADD COLUMN notas_transaccion TEXT NULL,

                                        ADD FOREIGN KEY
                                        (cliente_id) REFERENCES clientes
                                        (id) ON
                                        DELETE
                                        SET NULL;

