-- ============================================
-- Ejercicio Practico: Sistema de Biblioteca
-- Clase 6 - UPDATE, DELETE y Ciclo CRUD
-- ============================================
-- Este script contiene las operaciones de
-- actualizacion y eliminacion propuestas en
-- el ejercicio practico de la clase 6.
-- Requisito: ejecutar primero los scripts de
-- las clases 3 (DDL), 4 (INSERT) y 5 (SELECT).
-- ============================================

USE Biblioteca;
GO

------------------------------------------- OPERACIONES UPDATE -------------------------------------------

-- 1. Cambiar el email de un miembro
-- Paso 1: Verificar el registro antes de modificar
SELECT * FROM Miembro WHERE ID_Miembro = 1;

-- Paso 2: Ejecutar el UPDATE
UPDATE Miembro SET 
    Email = 'ana.martinez@biblioteca.com',
    DateUpdate = GETDATE()
WHERE ID_Miembro = 1;

-- Paso 3: Verificar el cambio
SELECT * FROM Miembro WHERE ID_Miembro = 1;

GO

-- 2. Actualizar el anio de publicacion de un libro
-- Paso 1: Verificar
SELECT * FROM Libro WHERE ISBN = '978-0-1234-005';

-- Paso 2: Actualizar
UPDATE Libro SET 
    Anio_Publicacion = 2020,
    DateUpdate = GETDATE()
WHERE ISBN = '978-0-1234-005';

-- Paso 3: Verificar
SELECT * FROM Libro WHERE ISBN = '978-0-1234-005';

GO

-- 3. Cambiar el estado de un prestamo de "Activo" a "Devuelto"
-- Paso 1: Verificar prestamos activos
SELECT * FROM Prestamo WHERE Estado = 'Activo';

-- Paso 2: Devolver un prestamo y registrar la fecha de devolucion
UPDATE Prestamo SET 
    Estado = 'Devuelto',
    Fecha_Devolucion = GETDATE(),
    DateUpdate = GETDATE()
WHERE ID_Miembro = 1 AND ISBN = '978-0-1234-001';

-- Paso 3: Verificar el cambio
SELECT * FROM Prestamo WHERE ID_Miembro = 1;

GO

-- 4. Actualizar el nombre de un miembro que tenia un error
-- Paso 1: Verificar
SELECT * FROM Miembro WHERE ID_Miembro = 4;

-- Paso 2: Corregir el nombre
UPDATE Miembro SET 
    Nombre = 'Roberto A. Flores',
    DateUpdate = GETDATE()
WHERE ID_Miembro = 4;

-- Paso 3: Verificar
SELECT * FROM Miembro WHERE ID_Miembro = 4;

GO

------------------------------------------- OPERACIONES DELETE -------------------------------------------

-- 5. Eliminar un prestamo especifico
-- Paso 1: Verificar que registro se va a eliminar
SELECT * FROM Prestamo WHERE ID_Miembro = 4 AND ISBN = '978-0-1234-005';

-- Paso 2: Eliminar
DELETE FROM Prestamo
WHERE ID_Miembro = 4 AND ISBN = '978-0-1234-005';

-- Paso 3: Verificar que fue eliminado
SELECT * FROM Prestamo WHERE ID_Miembro = 4;

GO

-- 6. Eliminar todos los prestamos con estado "Devuelto"
-- Paso 1: Contar cuantos son
SELECT COUNT(*) AS 'Prestamos Devueltos' FROM Prestamo WHERE Estado = 'Devuelto';

-- Paso 2: Ver cuales son
SELECT * FROM Prestamo WHERE Estado = 'Devuelto';

-- Paso 3: Eliminar
DELETE FROM Prestamo
WHERE Estado = 'Devuelto';

-- Paso 4: Verificar
SELECT * FROM Prestamo;

GO

-- 7. Intentar eliminar un libro que tiene prestamos activos
-- Nota: SQL Server impedira esta operacion porque la tabla Prestamo
-- tiene una clave foranea que apunta a Libro. Mientras existan
-- prestamos asociados, el libro no se puede eliminar.

-- Paso 1: Verificar prestamos del libro
SELECT * FROM Prestamo WHERE ISBN = '978-0-1234-001';

-- Paso 2: Intentar eliminar (dara error de FK)
-- Descomentar para ejecutar:
-- DELETE FROM Libro WHERE ISBN = '978-0-1234-001';
-- Error esperado: "The DELETE statement conflicted with the REFERENCE constraint..."

GO

-- 8. Eliminar un miembro que no tiene prestamos asociados
-- Paso 1: Verificar que no tenga prestamos
SELECT * FROM Prestamo WHERE ID_Miembro = 5;

-- Nota: Si el miembro 5 tiene prestamos, primero verifica el estado actual
-- de los datos despues de ejecutar los pasos anteriores.

-- Paso 2: Verificar el miembro
SELECT * FROM Miembro WHERE ID_Miembro = 5;

-- Paso 3: Eliminar
-- Descomentar para ejecutar:
-- DELETE FROM Miembro WHERE ID_Miembro = 5;

GO

------------------------------------------- CICLO CRUD COMPLETO -------------------------------------------

-- 9. Ejercicio CRUD completo: insertar, leer, actualizar y eliminar

-- C - CREATE: Insertar un nuevo miembro
INSERT INTO Miembro (Nombre, Email)
VALUES ('Fernando Castillo', 'fernando@biblioteca.com');

-- Obtener el ID generado
SELECT SCOPE_IDENTITY() AS NuevoIDMiembro;

GO

-- R - READ: Consultar el nuevo miembro
SELECT * FROM Miembro WHERE Nombre = 'Fernando Castillo';

GO

-- Hacer un prestamo para el nuevo miembro
-- Nota: reemplazar el numero 6 por el ID que devolvio SCOPE_IDENTITY()
INSERT INTO Prestamo (ID_Miembro, ISBN, Fecha_Prestamo, Estado)
VALUES (6, '978-0-1234-002', GETDATE(), 'Activo');

-- Verificar el prestamo
SELECT * FROM Prestamo WHERE ID_Miembro = 6;

GO

-- U - UPDATE: Actualizar el estado del prestamo a "Devuelto"
UPDATE Prestamo
SET Estado = 'Devuelto',
    Fecha_Devolucion = GETDATE(),
    DateUpdate = GETDATE()
WHERE ID_Miembro = 6 AND ISBN = '978-0-1234-002';

-- Verificar la actualizacion
SELECT * FROM Prestamo WHERE ID_Miembro = 6;

GO

-- D - DELETE: Eliminar el prestamo
DELETE FROM Prestamo
WHERE ID_Miembro = 6 AND ISBN = '978-0-1234-002';

-- Verificar la eliminacion
SELECT * FROM Prestamo WHERE ID_Miembro = 6;