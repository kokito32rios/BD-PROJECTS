CREATE DATABASE control_creditos_tecnologia;
USE control_creditos_tecnologia;
-- 1. roles
CREATE TABLE roles
(
    id_rol INT
    AUTO_INCREMENT PRIMARY KEY,
    name_rol  VARCHAR
    (50) UNIQUE NOT NULL
);
    -- 2. users (clientes y administradores)
    CREATE TABLE users
    (
        id_user INT
        AUTO_INCREMENT PRIMARY KEY,
    name_user  VARCHAR
        (100) NOT NULL,
    email_user VARCHAR
        (100) UNIQUE NOT NULL,
    cel_user   VARCHAR
        (20),
    password   VARCHAR
        (255), -- guardar hash (bcrypt, argon2, etc.)
    id_rol     INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_rol FOREIGN KEY
        (id_rol) REFERENCES roles
        (id_rol)
);
        -- 3. categorias
        CREATE TABLE categorias
        (
            id_categoria INT
            AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR
            (50) UNIQUE NOT NULL,
    descripcion  TEXT
);
            -- 4. products
            CREATE TABLE products
            (
                id_product INT
                AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR
                (100) NOT NULL,
    descripcion  TEXT,
    precio       DECIMAL
                (12,2) NOT NULL,
    id_categoria INT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_categoria FOREIGN KEY
                (id_categoria) REFERENCES categorias
                (id_categoria)
);
                -- 5. inventarios (stock actual - 1:1 con products)
                CREATE TABLE inventarios
                (
                    id_inventario INT
                    AUTO_INCREMENT PRIMARY KEY,
    id_product       INT UNIQUE NOT NULL,
    stock_actual     INT NOT NULL DEFAULT 0,
    stock_minimo     INT DEFAULT 0,
    fecha_ultimo_mov DATETIME DEFAULT CURRENT_TIMESTAMP ON
                    UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventario_product
                    FOREIGN KEY
                    (id_product) REFERENCES products
                    (id_product) ON
                    DELETE CASCADE
);
                    -- 6. creditos (facturas / ventas a crédito)
                    CREATE TABLE creditos
                    (
                        id_credit INT
                        AUTO_INCREMENT PRIMARY KEY,
    id_user           INT NOT NULL,
    fecha_emision     DATE NOT NULL,
    fecha_vencimiento DATE,
    total             DECIMAL
                        (12,2) NOT NULL,
    estado            ENUM
                        ('pendiente','pagado','moroso','anulado') DEFAULT 'pendiente',
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_credito_user FOREIGN KEY
                        (id_user) REFERENCES users
                        (id_user)
);
                        -- 7. detalle_creditos (items de cada factura)
                        CREATE TABLE detalle_creditos
                        (
                            id_detalle INT
                            AUTO_INCREMENT PRIMARY KEY,
    id_credit       INT NOT NULL,
    id_product      INT NOT NULL,
    cantidad        INT NOT NULL,
    precio_unitario DECIMAL
                            (12,2) NOT NULL,
    subtotal        DECIMAL
                            (12,2) NOT NULL,
    CONSTRAINT fk_detalle_credito FOREIGN KEY
                            (id_credit) REFERENCES creditos
                            (id_credit) ON
                            DELETE CASCADE,
    CONSTRAINT fk_detalle_product FOREIGN KEY
                            (id_product) REFERENCES products
                            (id_product)
);
                            -- 8. historial (pagos / abonos)
                            CREATE TABLE historial
                            (
                                id_historial INT
                                AUTO_INCREMENT PRIMARY KEY,
    id_credit    INT NOT NULL,
    monto        DECIMAL
                                (12,2) NOT NULL,
    fecha        DATE NOT NULL,
    descripcion  VARCHAR
                                (255),
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_credito FOREIGN KEY
                                (id_credit) REFERENCES creditos
                                (id_credit) ON
                                DELETE CASCADE
);
                                -- 9. movimientos_inventario (auditoría de stock)
                                CREATE TABLE movimientos_inventario
                                (
                                    id_movimiento INT
                                    AUTO_INCREMENT PRIMARY KEY,
    id_product       INT NOT NULL,
    tipo_movimiento  ENUM
                                    ('entrada','salida','ajuste','devolucion') NOT NULL,
    cantidad         INT NOT NULL, -- positivo o negativo según tipo
    id_credit        INT NULL,
    id_historial     INT NULL,
    fecha            DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacion      VARCHAR
                                    (255),
    CONSTRAINT fk_mov_product FOREIGN KEY
                                    (id_product) REFERENCES products
                                    (id_product),
    CONSTRAINT fk_mov_credito FOREIGN KEY
                                    (id_credit) REFERENCES creditos
                                    (id_credit) ON
                                    DELETE
                                    SET NULL
                                    ,
    CONSTRAINT fk_mov_historial FOREIGN KEY
                                    (id_historial) REFERENCES historial
                                    (id_historial) ON
                                    DELETE
                                    SET NULL
                                    );