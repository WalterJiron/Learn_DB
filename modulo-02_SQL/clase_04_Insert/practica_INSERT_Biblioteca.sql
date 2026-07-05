-- ============================================
-- Ejercicio Practico: Sistema de Biblioteca
-- Clase 4 - INSERT (Data Manipulation Language)
-- ============================================
-- Este script inserta datos de prueba en las
-- tablas de la Biblioteca creadas en la clase 3.
-- Orden de insercion: Libro, Miembro, Prestamo.
-- ============================================

USE Biblioteca;

GO

------------------------------------------- INSERTAR LIBROS -------------------------------------------

-- Insertar libros del catalogo
INSERT INTO Libro (ISBN, Titulo, Autor, Anio_Publicacion)
VALUES
    ('978-0-1234-001', 'Cien años de soledad',          'Gabriel García Márquez',    1967),
    ('978-0-1234-002', 'Don Quijote de la Mancha',       'Miguel de Cervantes',       1605),
    ('978-0-1234-003', 'El principito',                  'Antoine de Saint-Exupéry',  1943),
    ('978-0-1234-004', '1984',                           'George Orwell',             1949),
    ('978-0-1234-005', 'Fundamentos de bases de datos',  'Abraham Silberschatz',      2019);

GO

------------------------------------------- INSERTAR MIEMBROS -------------------------------------------

-- Insertar miembros de la biblioteca
INSERT INTO Miembro (Nombre, Email)
VALUES
    ('Ana Martínez',   'ana@biblioteca.com'),
    ('Luis García',    'luis@biblioteca.com'),
    ('Carmen Ruiz',    'carmen@biblioteca.com'),
    ('Roberto Flores', 'roberto@biblioteca.com'),
    ('María López',    'maria@biblioteca.com');

GO

------------------------------------------- INSERTAR PRESTAMOS -------------------------------------------

-- Insertar prestamos con diferentes estados

INSERT INTO Prestamo (ID_Miembro, ISBN, Fecha_Prestamo, Fecha_Devolucion, Estado)
VALUES
    -- Ana (ID 1) tiene un prestamo activo
    (1, '978-0-1234-001', '2025-03-01', NULL, 'Activo'),

    -- Ana (ID 1) tiene un prestamo devuelto
    (1, '978-0-1234-003', '2025-02-10', '2025-02-25', 'Devuelto'),

    -- Luis (ID 2) tiene un prestamo activo
    (2, '978-0-1234-002', '2025-03-05', NULL, 'Activo'),

    -- Carmen (ID 3) tiene un prestamo vencido
    (3, '978-0-1234-004', '2025-01-15', NULL, 'Vencido'),

    -- Roberto (ID 4) tiene un prestamo devuelto
    (4, '978-0-1234-005', '2025-02-20', '2025-03-01', 'Devuelto'),

    -- Maria (ID 5) tiene un prestamo activo
    (5, '978-0-1234-001', '2025-03-10', NULL, 'Activo');

GO

------------------------------------------- EJERCICIOS EXTRA -------------------------------------------

-- Ejercicio 1: Insertar un prestamo usando valores por defecto
-- (Fecha_Prestamo tomara la fecha actual y Estado sera 'Activo')
INSERT INTO Prestamo (ID_Miembro, ISBN)
VALUES (2, '978-0-1234-005');

GO

/*
    Ejercicio 3: Intentar insertar un prestamo con un miembro inexistente
    Descomentar la siguiente linea para provocar el error de FK:
    INSERT INTO Prestamo (ID_Miembro, ISBN) VALUES (99, '978-0-1234-001');
    Error esperado: "The INSERT statement conflicted with the FOREIGN KEY constraint..."

    Ejercicio 4: Intentar insertar un libro con ISBN duplicado
    Descomentar la siguiente linea para provocar el error de PK:
    INSERT INTO Libro (ISBN, Titulo, Autor, Anio_Publicacion) VALUES ('978-0-1234-001', 'Otro libro', 'Otro autor', 2020);
    Error esperado: "Violation of PRIMARY KEY constraint..."

    Ejercicio 5: Intentar insertar un libro con anio invalido
    Descomentar la siguiente linea para provocar el error de CHECK:
    INSERT INTO Libro (ISBN, Titulo, Autor, Anio_Publicacion) VALUES ('978-0-1234-099', 'Test', 'Test', -5);
    Error esperado: "The INSERT statement conflicted with the CHECK constraint..."
*/