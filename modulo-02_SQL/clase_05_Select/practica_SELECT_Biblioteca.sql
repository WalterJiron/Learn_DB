-- ============================================
-- Ejercicio Practico: Sistema de Biblioteca
-- Clase 5 - SELECT (Consultas basicas)
-- ============================================
-- Este script contiene las consultas propuestas
-- en el ejercicio practico de la clase 5.
-- Requisito: ejecutar primero los scripts de
-- las clases 3 (DDL) y 4 (INSERT).
-- ============================================

USE Biblioteca;
GO

------------------------------------------- CONSULTAS BASICAS -------------------------------------------

-- 1. Mostrar todos los libros ordenados por titulo
SELECT * FROM Libro
ORDER BY Titulo ASC;

GO

-- 2. Mostrar solo el nombre y email de todos los miembros
SELECT
    Nombre AS [Nombre del Miembro],
    Email  AS [Correo Electronico]
FROM Miembro;

GO

-- 3. Buscar libros publicados despues del anio 1950
SELECT Titulo, Autor, Anio_Publicacion
FROM Libro
WHERE Anio_Publicacion > 1950;

GO

-- 4. Buscar libros cuyo titulo contenga la letra "a"
SELECT Titulo, Autor
FROM Libro
WHERE Titulo LIKE '%a%';

GO

------------------------------------------- CONSULTAS CON FILTROS -------------------------------------------

-- 5. Mostrar los prestamos que estan en estado "Activo"
SELECT * FROM Prestamo
WHERE Estado = 'Activo';

GO

-- 6. Mostrar los libros publicados entre 1900 y 1960
SELECT Titulo, Autor, Anio_Publicacion
FROM Libro
WHERE Anio_Publicacion BETWEEN 1900 AND 1960;

GO

-- 7. Buscar miembros cuyo email termine en "@biblioteca.com"
SELECT Nombre, Email
FROM Miembro
WHERE Email LIKE '%@biblioteca.com';

GO

-- 8. Mostrar prestamos que NO estan activos
SELECT * FROM Prestamo
WHERE Estado != 'Activo';

GO

-- 9. Buscar prestamos de un miembro especifico usando IN
SELECT * FROM Prestamo
WHERE ID_Miembro IN (1, 3);

GO

-- 10. Buscar libros cuyo autor empiece con la letra "G"
SELECT Titulo, Autor
FROM Libro
WHERE Autor LIKE 'G%';

GO

------------------------------------------- CONSULTAS CON AGREGACION -------------------------------------------

-- 11. Cuantos libros hay en total
SELECT COUNT(*) AS 'Total de Libros'
FROM Libro;

GO

-- 12. Cual es el anio de publicacion mas antiguo y mas reciente
SELECT
    MIN(Anio_Publicacion) AS 'Publicacion Mas Antigua',
    MAX(Anio_Publicacion) AS 'Publicacion Mas Reciente'
FROM Libro;

GO

-- 13. Cuantos prestamos hay por cada estado
SELECT
    Estado,
    COUNT(*) AS [Cantidad]
FROM Prestamo
GROUP BY Estado;

GO

-- 14. Cuantos prestamos tiene cada miembro
SELECT
    ID_Miembro,
    COUNT(*) AS [Total Prestamos]
FROM Prestamo
GROUP BY ID_Miembro
ORDER BY [Total Prestamos] DESC;

GO

-- 15. Promedio del anio de publicacion de los libros
SELECT
    AVG(Anio_Publicacion) AS [Promedio Anio Publicacion]
FROM Libro;

GO

------------------------------------------- DESAFIO -------------------------------------------

-- 16. Mostrar los estados de prestamo que tengan mas de 1 registro
SELECT
    Estado,
    COUNT(*) AS [Cantidad]
FROM Prestamo
GROUP BY Estado
HAVING COUNT(*) > 1;

GO

-- 17. Mostrar el top 3 de libros mas recientes
SELECT TOP 3
    Titulo,
    Autor,
    Anio_Publicacion
FROM Libro
ORDER BY Anio_Publicacion DESC;

GO

-- 18. Que estados de prestamo existen (valores unicos)
SELECT DISTINCT Estado
FROM Prestamo;

GO

-- 19. Cuantos miembros se inscribieron en cada mes (si hay datos suficientes)
SELECT
    MONTH(Fecha_Inscripcion) AS [Mes],
    COUNT(*) AS [Miembros Inscritos]
FROM Miembro
GROUP BY MONTH(Fecha_Inscripcion)
ORDER BY [Mes] ASC;

GO

-- 20. Libros publicados despues del anio 1950, ordenados del mas reciente al mas antiguo
SELECT TOP 5
    Titulo,
    Autor,
    Anio_Publicacion
FROM Libro
WHERE Anio_Publicacion > 1950
ORDER BY Anio_Publicacion DESC;
