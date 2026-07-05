# Clase 5: Consultas básicas en SQL Server (SELECT)

<div align="center">
  <img src="https://img.shields.io/badge/Nivel-Basico-green" alt="Nivel Básico">
  <img src="https://img.shields.io/badge/Enfoque-DML SELECT-blue" alt="Enfoque DML SELECT">

  <h2>Recuperando información de las tablas</h2>

  <p><em>Aprende a hacer preguntas a tus datos y obtener exactamente lo que necesitas</em></p>
</div>

---

## Objetivos de esta clase

Al finalizar esta sesión, serás capaz de:

- Consultar todos los datos de una tabla con `SELECT`
- Filtrar resultados con `WHERE`
- Ordenar resultados con `ORDER BY`
- Buscar texto parcial con `LIKE`
- Usar funciones de agregación (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`)
- Agrupar resultados con `GROUP BY`
- Limitar la cantidad de resultados con `TOP`
- Usar alias para dar nombres legibles a las columnas

---

## Antes de empezar

### ¿Qué es SELECT?

`SELECT` es el comando más usado de SQL. Permite **recuperar datos** de una o más tablas. No modifica nada en la base de datos; solo lee y muestra información.

**Explicación sencilla:** Si INSERT es "meter datos", SELECT es "sacar datos". Es como buscar en un archivero: le dices qué carpeta quieres, qué datos necesitas, y te los muestra.

### Requisito previo

Debes tener las tablas del sistema de inscripción con datos insertados (Clase 4). Si no los tienes, ejecuta primero los scripts de las clases 3 y 4.

```sql
USE Escuela;
GO
```

---

## SELECT básico

### Ver todas las columnas de una tabla

```sql
-- El asterisco (*) significa "todas las columnas"
SELECT * FROM Profesor;
```

**Resultado esperado:**

| ID_Profesor | Nombre  | Apellido  | Departamento | Email                    | Telefono  |
| ----------- | ------- | --------- | ------------ | ------------------------ | --------- |
| 1           | Carlos  | Martínez  | Ingeniería   | carlos.martinez@uni.edu  | 8888-1234 |
| 2           | María   | López     | Ciencias     | maria.lopez@uni.edu      | 8888-5678 |
| 3           | Roberto | García    | Matemáticas  | roberto.garcia@uni.edu   | 8888-9012 |
| 4           | Ana     | Fernández | Ingeniería   | ana.fernandez@uni.edu    | NULL      |

### Ver solo algunas columnas

```sql
-- Solo nombre y apellido de los profesores
SELECT Nombre, Apellido FROM Profesor;
```

**Resultado:**

| Nombre  | Apellido  |
| ------- | --------- |
| Carlos  | Martínez  |
| María   | López     |
| Roberto | García    |
| Ana     | Fernández |

**Tip:** En aplicaciones reales, siempre especifica las columnas que necesitas en lugar de usar `*`. Es más eficiente y más claro.

---

## Alias: nombres más legibles

Puedes renombrar las columnas en el resultado usando `AS`:

```sql
SELECT
    Nombre        AS 'Nombre del Profesor',
    Apellido      AS 'Apellido del Profesor',
    Departamento  AS 'Área'
FROM Profesor;
```

**Resultado:**

| Nombre del Profesor | Apellido del Profesor | Área         |
| ------------------- | --------------------- | ------------ |
| Carlos              | Martínez              | Ingeniería   |
| María               | López                 | Ciencias     |

**Explicación sencilla:** Los alias no cambian nada en la base de datos. Solo cambian cómo se muestran los nombres de las columnas en el resultado.

---

## WHERE: filtrar resultados

`WHERE` permite mostrar solo los registros que cumplan una condición.

### Comparaciones básicas

```sql
-- Profesores del departamento de Ingeniería
SELECT * FROM Profesor
WHERE Departamento = 'Ingeniería';

-- Cursos con capacidad mayor a 30
SELECT * FROM Curso
WHERE Cantidad_Maxima > 30;

-- Inscripciones que NO están activas
SELECT * FROM Inscripcion
WHERE Estado != 'Activa';
```

### Operadores de comparación

| Operador | Significado       | Ejemplo                     |
| -------- | ----------------- | --------------------------- |
| `=`      | Igual a           | `WHERE Nombre = 'Carlos'`   |
| `!=`     | Diferente de      | `WHERE Estado != 'Activa'`  |
| `<>`     | Diferente de      | `WHERE Estado <> 'Activa'`  |
| `>`      | Mayor que         | `WHERE Cantidad_Maxima > 30`|
| `<`      | Menor que         | `WHERE Cantidad_Maxima < 20`|
| `>=`     | Mayor o igual que | `WHERE Cantidad_Maxima >= 30`|
| `<=`     | Menor o igual que | `WHERE Cantidad_Maxima <= 30`|

### Combinar condiciones: AND, OR, NOT

```sql
-- Profesores de Ingeniería que tengan teléfono
SELECT * FROM Profesor
WHERE Departamento = 'Ingeniería' AND Telefono IS NOT NULL;

-- Estudiantes que se llamen Pedro o Laura
SELECT * FROM Estudiante
WHERE Nombre = 'Pedro' OR Nombre = 'Laura';

-- Inscripciones que NO están canceladas
SELECT * FROM Inscripcion
WHERE NOT Estado = 'Cancelada';
```

**Explicación sencilla:**

- `AND` = ambas condiciones deben cumplirse
- `OR` = al menos una condición debe cumplirse
- `NOT` = lo contrario de la condición

### Buscar valores NULL

Para buscar campos vacíos (NULL), no se usa `=` sino `IS NULL` o `IS NOT NULL`:

```sql
-- Profesores sin teléfono registrado
SELECT * FROM Profesor
WHERE Telefono IS NULL;

-- Profesores que sí tienen teléfono
SELECT * FROM Profesor
WHERE Telefono IS NOT NULL;
```

**¿Por qué no funciona `WHERE Telefono = NULL`?** Porque NULL no es un valor, es la _ausencia_ de valor. En SQL, nada es "igual" a NULL, ni siquiera otro NULL.

### Buscar dentro de una lista: IN

```sql
-- Estudiantes con estas matrículas específicas
SELECT * FROM Estudiante
WHERE Matricula IN ('EST-001', 'EST-003', 'EST-005');

-- Inscripciones activas o completadas
SELECT * FROM Inscripcion
WHERE Estado IN ('Activa', 'Completada');
```

**Explicación sencilla:** `IN` es un atajo. En lugar de escribir `WHERE Matricula = 'EST-001' OR Matricula = 'EST-003' OR Matricula = 'EST-005'`, usas `IN (...)`.

### Buscar en un rango: BETWEEN

```sql
-- Cursos con capacidad entre 25 y 35 estudiantes
SELECT * FROM Curso
WHERE Cantidad_Maxima BETWEEN 25 AND 35;

-- Inscripciones de enero 2025
SELECT * FROM Inscripcion
WHERE Fecha_Inscripcion BETWEEN '2025-01-01' AND '2025-01-31';
```

**Nota:** `BETWEEN` incluye ambos extremos. `BETWEEN 25 AND 35` incluye 25 y 35.

---

## LIKE: buscar texto parcial

`LIKE` permite buscar texto que contenga un patrón. Usa caracteres especiales llamados **comodines**:

| Comodín | Significado                    | Ejemplo                               |
| ------- | ------------------------------ | ------------------------------------- |
| `%`     | Cualquier cantidad de caracteres | `'%ción'` = termina en "ción"        |
| `_`     | Un solo carácter               | `'_arlos'` = segundo carácter cualquiera |

### Ejemplos prácticos

```sql
-- Estudiantes cuyo nombre empiece con 'M'
SELECT * FROM Estudiante
WHERE Nombre LIKE 'M%';

-- Cursos que contengan la palabra 'datos' en su descripción
SELECT * FROM Curso
WHERE Descripcion LIKE '%datos%';

-- Emails que terminen en '@uni.edu'
SELECT * FROM Profesor
WHERE Email LIKE '%@uni.edu';

-- Matrículas que empiecen con 'EST-00' seguido de un solo dígito
SELECT * FROM Estudiante
WHERE Matricula LIKE 'EST-00_';
```

**Explicación sencilla:**

- `LIKE 'M%'` = empieza con M, seguido de lo que sea
- `LIKE '%datos%'` = tiene "datos" en cualquier parte
- `LIKE 'EST-00_'` = empieza con EST-00 y termina con exactamente un carácter

---

## ORDER BY: ordenar resultados

Por defecto, SQL no garantiza un orden específico. Usa `ORDER BY` para ordenar:

```sql
-- Estudiantes ordenados por nombre (A → Z)
SELECT * FROM Estudiante
ORDER BY Nombre ASC;

-- Estudiantes ordenados por nombre (Z → A)
SELECT * FROM Estudiante
ORDER BY Nombre DESC;

-- Cursos ordenados por capacidad (mayor a menor)
SELECT * FROM Curso
ORDER BY Cantidad_Maxima DESC;

-- Ordenar por múltiples columnas
SELECT * FROM Profesor
ORDER BY Departamento ASC, Apellido ASC;
```

| Palabra | Significado               |
| ------- | ------------------------- |
| `ASC`   | Ascendente (A→Z, 1→100)  |
| `DESC`  | Descendente (Z→A, 100→1) |

**Nota:** Si no escribes ASC o DESC, el orden por defecto es ASC.

---

## TOP: limitar resultados

```sql
-- Los primeros 3 estudiantes (por orden de matrícula)
SELECT TOP 3 * FROM Estudiante
ORDER BY Matricula;

-- El curso con mayor capacidad
SELECT TOP 1 * FROM Curso
ORDER BY Cantidad_Maxima DESC;
```

**Explicación sencilla:** `TOP` es útil cuando tienes miles de registros y solo quieres ver unos cuantos, o cuando quieres encontrar "el primero", "el más grande", etc.

---

## DISTINCT: valores únicos

`DISTINCT` elimina duplicados del resultado:

```sql
-- ¿En qué departamentos hay profesores?
SELECT DISTINCT Departamento FROM Profesor;

-- ¿Qué estados de inscripción existen?
SELECT DISTINCT Estado FROM Inscripcion;
```

**Resultado del primer ejemplo:**

| Departamento |
| ------------ |
| Ingeniería   |
| Ciencias     |
| Matemáticas  |

Sin `DISTINCT`, "Ingeniería" aparecería dos veces porque hay dos profesores en ese departamento.

---

## Funciones de agregación

Las funciones de agregación **calculan un valor** a partir de un conjunto de registros:

| Función   | ¿Qué calcula?                 | Ejemplo                               |
| --------- | ------------------------------ | ------------------------------------- |
| `COUNT()` | Cantidad de registros          | ¿Cuántos estudiantes hay?             |
| `SUM()`   | Suma de valores numéricos      | ¿Cuál es la capacidad total?          |
| `AVG()`   | Promedio de valores numéricos  | ¿Cuál es la capacidad promedio?       |
| `MIN()`   | Valor mínimo                   | ¿Cuál es la menor capacidad?          |
| `MAX()`   | Valor máximo                   | ¿Cuál es la mayor capacidad?          |

### Ejemplos prácticos

```sql
-- ¿Cuántos estudiantes hay en total?
SELECT COUNT(*) AS 'Total Estudiantes' FROM Estudiante;

-- ¿Cuántos cursos hay?
SELECT COUNT(*) AS 'Total Cursos' FROM Curso;

-- ¿Cuál es la capacidad máxima, mínima y promedio de los cursos?
SELECT
    MAX(Cantidad_Maxima) AS 'Capacidad Máxima',
    MIN(Cantidad_Maxima) AS 'Capacidad Mínima',
    AVG(Cantidad_Maxima) AS 'Capacidad Promedio',
    SUM(Cantidad_Maxima) AS 'Capacidad Total'
FROM Curso;

-- ¿Cuántas inscripciones están activas?
SELECT COUNT(*) AS 'Inscripciones Activas'
FROM Inscripcion
WHERE Estado = 'Activa';
```

---

## GROUP BY: agrupar resultados

`GROUP BY` agrupa los registros que comparten el mismo valor en una columna, y permite usar funciones de agregación por cada grupo.

```sql
-- ¿Cuántos profesores hay por departamento?
SELECT
    Departamento,
    COUNT(*) AS 'Cantidad de Profesores'
FROM Profesor
GROUP BY Departamento;
```

**Resultado:**

| Departamento | Cantidad de Profesores |
| ------------ | ---------------------- |
| Ingeniería   | 2                      |
| Ciencias     | 1                      |
| Matemáticas  | 1                      |

### Más ejemplos

```sql
-- ¿Cuántas inscripciones hay por estado?
SELECT
    Estado,
    COUNT(*) AS 'Cantidad'
FROM Inscripcion
GROUP BY Estado;

-- ¿Cuántos cursos imparte cada profesor?
SELECT
    ID_Profesor,
    COUNT(*) AS 'Cursos Asignados'
FROM Curso
GROUP BY ID_Profesor;
```

### HAVING: filtrar grupos

`HAVING` es como `WHERE`, pero para grupos. Se usa después de `GROUP BY`:

```sql
-- Departamentos que tengan más de 1 profesor
SELECT
    Departamento,
    COUNT(*) AS 'Cantidad'
FROM Profesor
GROUP BY Departamento
HAVING COUNT(*) > 1;
```

**¿Cuál es la diferencia entre WHERE y HAVING?**

| WHERE                             | HAVING                            |
| --------------------------------- | --------------------------------- |
| Filtra filas individuales         | Filtra grupos                     |
| Se usa ANTES de GROUP BY          | Se usa DESPUÉS de GROUP BY        |
| No puede usar funciones agregadas | Puede usar funciones agregadas    |

---

## Consultas combinadas: ejemplos prácticos

### Consulta 1: Estudiantes con email de gmail

```sql
SELECT Nombre, Apellido, Email
FROM Estudiante
WHERE Email LIKE '%@mail.com'
ORDER BY Apellido;
```

### Consulta 2: Cursos con capacidad alta, ordenados

```sql
SELECT Nombre, Cantidad_Maxima
FROM Curso
WHERE Cantidad_Maxima >= 30
ORDER BY Cantidad_Maxima DESC;
```

### Consulta 3: Resumen de inscripciones por estado

```sql
SELECT
    Estado,
    COUNT(*) AS 'Total',
    MIN(Fecha_Inscripcion) AS 'Primera Inscripción',
    MAX(Fecha_Inscripcion) AS 'Última Inscripción'
FROM Inscripcion
GROUP BY Estado
ORDER BY 'Total' DESC;
```

### Consulta 4: Los 3 cursos con mayor capacidad

```sql
SELECT TOP 3
    Codigo_Curso,
    Nombre,
    Cantidad_Maxima
FROM Curso
ORDER BY Cantidad_Maxima DESC;
```

---

## Orden de las cláusulas en SELECT

Las cláusulas de SELECT deben ir en un orden específico. Si cambias el orden, SQL Server dará un error.

```sql
SELECT [columnas]           -- 1. Qué columnas quieres ver
FROM [tabla]                -- 2. De qué tabla
WHERE [condición]           -- 3. Filtrar filas (opcional)
GROUP BY [columna]          -- 4. Agrupar (opcional)
HAVING [condición_grupo]    -- 5. Filtrar grupos (opcional)
ORDER BY [columna]          -- 6. Ordenar (opcional)
```

**Tip para recordar:** "Selecciona de la tabla donde se cumpla, agrupa y ordena" → SELECT FROM WHERE GROUP BY HAVING ORDER BY.

---

## Ejercicio práctico

### Caso: Sistema de Biblioteca

Usando las tablas de la Biblioteca con los datos que insertaste en la Clase 4, escribe las siguientes consultas:

**Consultas básicas:**

1. Muestra todos los libros ordenados por título
2. Muestra solo el nombre y email de todos los miembros
3. Busca libros publicados después del año 1950
4. Busca libros cuyo título contenga la letra "a"

**Consultas con filtros:**

5. Muestra los préstamos que están en estado "Activo"
6. Muestra los libros publicados entre 1900 y 1960
7. Busca miembros cuyo email termine en "@biblioteca.com"

**Consultas con agregación:**

8. ¿Cuántos libros hay en total?
9. ¿Cuál es el año de publicación más antiguo y más reciente?
10. ¿Cuántos préstamos hay por cada estado?

**Desafío:**

11. Muestra los estados de préstamo que tengan más de 1 registro
12. Muestra el top 3 de libros más recientes

---

## Resumen de lo aprendido

| Concepto          | Lo que aprendiste                                            |
| ----------------- | ------------------------------------------------------------ |
| **SELECT**        | Consultar datos de una tabla                                 |
| **WHERE**         | Filtrar resultados con condiciones                           |
| **AND, OR, NOT**  | Combinar múltiples condiciones                               |
| **LIKE**          | Buscar texto parcial con comodines (% y _)                   |
| **ORDER BY**      | Ordenar resultados ascendente o descendente                  |
| **TOP**           | Limitar la cantidad de resultados                            |
| **DISTINCT**      | Eliminar duplicados                                          |
| **COUNT, SUM...**| Funciones de agregación para calcular valores                |
| **GROUP BY**      | Agrupar resultados por una columna                           |
| **HAVING**        | Filtrar grupos después de GROUP BY                           |
| **IS NULL**       | Buscar campos vacíos                                         |
| **IN, BETWEEN**   | Buscar en listas o rangos                                    |

---

## Preparación para la próxima clase

En la siguiente clase (la última del curso) aprenderemos a **actualizar y eliminar datos** con `UPDATE` y `DELETE`, completando así el ciclo CRUD.

### Tarea para la próxima sesión

1. Completar todas las consultas del ejercicio
2. Inventar 5 consultas propias usando diferentes cláusulas
3. Practicar combinando WHERE, ORDER BY y funciones de agregación

---

<div align="center">

**Ahora puedes hacer preguntas a tus datos. SELECT es el comando que más usarás en tu carrera con bases de datos.**

</div>
