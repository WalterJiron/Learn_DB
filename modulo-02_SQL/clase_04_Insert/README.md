# Clase 4: Insertar datos en SQL Server (INSERT)

<div align="center">
  <img src="https://img.shields.io/badge/Nivel-Basico-green" alt="Nivel Básico">
  <img src="https://img.shields.io/badge/Enfoque-DML INSERT-blue" alt="Enfoque DML INSERT">

  <h2>Llenando las tablas con información</h2>

  <p><em>Aprende a agregar registros a las tablas que creaste en la clase anterior</em></p>
</div>

---

## Objetivos de esta clase

Al finalizar esta sesión, serás capaz de:

- Insertar registros individuales con `INSERT INTO`
- Insertar múltiples registros en una sola sentencia
- Entender el orden correcto de inserción (por las claves foráneas)
- Manejar valores por defecto y columnas opcionales
- Verificar los datos insertados con `SELECT` básico

---

## Antes de empezar

### ¿Qué es DML?

**DML (Data Manipulation Language)** es el conjunto de comandos SQL que se usan para **manipular los datos** dentro de las tablas. A diferencia de DDL (que crea la estructura), DML trabaja con el contenido.

| Comando    | ¿Qué hace?                    |
| ---------- | ------------------------------ |
| `INSERT`   | Agregar nuevos registros       |
| `SELECT`   | Consultar datos existentes     |
| `UPDATE`   | Modificar datos existentes     |
| `DELETE`   | Eliminar registros             |

En esta clase nos enfocamos en `INSERT`. Los demás comandos los veremos en las clases siguientes.

### Requisito previo

Debes tener creadas las tablas de la clase anterior. Si no las tienes, ejecuta primero el script completo de la Clase 3.

```sql
-- Asegúrate de estar en la base de datos correcta
USE Escuela;
GO
```

---

## Sintaxis de INSERT INTO

### Forma básica (especificando columnas)

```sql
INSERT INTO NombreTabla (columna1, columna2, columna3)
VALUES ('valor1', 'valor2', 'valor3');
```

### Forma corta (sin especificar columnas)

```sql
INSERT INTO NombreTabla
VALUES ('valor1', 'valor2', 'valor3', 'valor4');
```

**Recomendación:** Usa siempre la forma con columnas especificadas. Es más clara y evita errores si la tabla cambia en el futuro.

---

## Insertar datos en el sistema de inscripción

### Orden de inserción

Igual que al crear tablas, al insertar datos debemos respetar el orden de dependencias:

```
1. Profesor     (independiente, sin FKs)
2. Estudiante   (independiente, sin FKs)
3. Curso        (depende de Profesor - tiene FK)
4. Inscripcion  (depende de Estudiante y Curso - tiene FKs)
```

**¿Por qué importa el orden?** Si intentas insertar un curso con `ID_Profesor = 1` pero no has insertado ningún profesor todavía, SQL Server te dará un error de clave foránea.

---

### Paso 1: Insertar profesores

```sql
-- Insertar un profesor
INSERT INTO Profesor (Nombre, Apellido, Departamento, Email, Telefono)
VALUES ('Carlos', 'Martínez', 'Ingeniería', 'carlos.martinez@uni.edu', '8888-1234');
```

**Nota:** No incluimos `ID_Profesor` porque tiene `IDENTITY(1,1)`, lo que significa que SQL Server genera ese valor automáticamente.

Insertemos más profesores:

```sql
-- Insertar varios profesores de una vez
INSERT INTO Profesor (Nombre, Apellido, Departamento, Email, Telefono)
VALUES
    ('María', 'López', 'Ciencias', 'maria.lopez@uni.edu', '8888-5678'),
    ('Roberto', 'García', 'Matemáticas', 'roberto.garcia@uni.edu', '8888-9012'),
    ('Ana', 'Fernández', 'Ingeniería', 'ana.fernandez@uni.edu', NULL);
```

**Puntos importantes:**

| Detalle                  | Explicación                                              |
| ------------------------ | -------------------------------------------------------- |
| Múltiples VALUES         | Separa cada registro con una coma                        |
| Texto entre comillas     | Los valores de texto siempre van entre comillas simples  |
| `NULL` sin comillas      | Para dejar un campo vacío, usa `NULL` (sin comillas)     |
| Sin `ID_Profesor`        | Lo genera el IDENTITY automáticamente                    |

### Paso 2: Insertar estudiantes

```sql
INSERT INTO Estudiante (Matricula, Nombre, Apellido, Telefono, Email)
VALUES
    ('EST-001', 'Pedro',   'Ramírez',  '7777-1111', 'pedro.ramirez@mail.com'),
    ('EST-002', 'Laura',   'Sánchez',  '7777-2222', 'laura.sanchez@mail.com'),
    ('EST-003', 'Miguel',  'Torres',   '7777-3333', 'miguel.torres@mail.com'),
    ('EST-004', 'Sofía',   'Mendoza',  NULL,        'sofia.mendoza@mail.com'),
    ('EST-005', 'Diego',   'Herrera',  '7777-5555', 'diego.herrera@mail.com');
```

**Nota:** Aquí sí incluimos la matrícula porque es una clave primaria natural (no tiene IDENTITY).

### Paso 3: Insertar cursos

```sql
INSERT INTO Curso (Codigo_Curso, Nombre, Descripcion, Cantidad_Maxima, ID_Profesor)
VALUES
    ('ING-101', 'Programación I',      'Fundamentos de programación',            30, 1),
    ('ING-102', 'Bases de Datos',      'Diseño y gestión de bases de datos',     25, 1),
    ('MAT-201', 'Cálculo I',           'Límites, derivadas e integrales',        40, 3),
    ('CIE-301', 'Física General',      'Mecánica, termodinámica y ondas',        35, 2);
```

**¿De dónde sale el `1` en `ID_Profesor`?** Es el ID que SQL Server generó automáticamente para el primer profesor que insertamos (Carlos Martínez). Si no estás seguro del ID, puedes consultarlo:

```sql
-- Ver los profesores y sus IDs
SELECT ID_Profesor, Nombre, Apellido FROM Profesor;
```

### Paso 4: Insertar inscripciones

```sql
INSERT INTO Inscripcion (Matricula_Estudiante, Codigo_Curso, Fecha_Inscripcion, Estado)
VALUES
    ('EST-001', 'ING-101', '2025-01-15', 'Activa'),
    ('EST-001', 'MAT-201', '2025-01-15', 'Activa'),
    ('EST-002', 'ING-101', '2025-01-16', 'Activa'),
    ('EST-002', 'ING-102', '2025-01-16', 'Activa'),
    ('EST-003', 'CIE-301', '2025-01-17', 'Completada'),
    ('EST-004', 'MAT-201', '2025-01-18', 'Activa'),
    ('EST-005', 'ING-102', '2025-01-18', 'Cancelada');
```

También puedes omitir la fecha y el estado para usar los valores por defecto:

```sql
-- Usando valores por defecto (fecha = hoy, estado = 'Activa')
INSERT INTO Inscripcion (Matricula_Estudiante, Codigo_Curso)
VALUES ('EST-003', 'ING-101');
```

---

## Verificar los datos insertados

Después de insertar, siempre verifica que los datos se guardaron correctamente:

```sql
-- Ver todos los profesores
SELECT * FROM Profesor;

-- Ver todos los estudiantes
SELECT * FROM Estudiante;

-- Ver todos los cursos
SELECT * FROM Curso;

-- Ver todas las inscripciones
SELECT * FROM Inscripcion;
```

**¿Qué es `SELECT *`?** El asterisco (`*`) significa "todas las columnas". Es útil para verificaciones rápidas, pero en aplicaciones reales es mejor especificar las columnas que necesitas.

---

## Errores comunes al insertar datos

### Error: "Violation of PRIMARY KEY constraint..."

**Causa:** Intentas insertar un registro con una clave primaria que ya existe.

```sql
-- Esto dará error si 'EST-001' ya existe
INSERT INTO Estudiante (Matricula, Nombre, Apellido)
VALUES ('EST-001', 'Otro', 'Estudiante');
```

**Solución:** Usa una matrícula diferente que no exista.

### Error: "The INSERT statement conflicted with the FOREIGN KEY constraint..."

**Causa:** El valor de la clave foránea no existe en la tabla referenciada.

```sql
-- Esto dará error si no existe un profesor con ID_Profesor = 99
INSERT INTO Curso (Codigo_Curso, Nombre, Descripcion, Cantidad_Maxima, ID_Profesor)
VALUES ('TST-999', 'Prueba', 'Test', 20, 99);
```

**Solución:** Verifica que el profesor con ese ID exista antes de insertar el curso.

### Error: "Cannot insert the value NULL into column..."

**Causa:** Intentas dejar vacía una columna que tiene NOT NULL y no tiene DEFAULT.

```sql
-- Esto dará error porque Nombre es NOT NULL
INSERT INTO Profesor (Nombre, Apellido, Departamento)
VALUES (NULL, 'Pérez', 'Arte');
```

**Solución:** Proporciona un valor para las columnas obligatorias.

### Error: "The CHECK constraint was violated..."

**Causa:** El valor no cumple la regla CHECK definida en la tabla.

```sql
-- Esto dará error porque Cantidad_Maxima debe ser > 0
INSERT INTO Curso (Codigo_Curso, Nombre, Descripcion, Cantidad_Maxima, ID_Profesor)
VALUES ('TST-000', 'Prueba', 'Test', 0, 1);
```

**Solución:** Usa un valor que cumpla la condición del CHECK.

---

## Tips prácticos

### Insertar y obtener el ID generado

Si necesitas saber qué ID asignó IDENTITY al último registro:

```sql
INSERT INTO Profesor (Nombre, Apellido, Departamento, Email)
VALUES ('Nuevo', 'Profesor', 'Historia', 'nuevo@uni.edu');

-- Ver el último ID generado
SELECT SCOPE_IDENTITY() AS UltimoID;
```

### Insertar fechas correctamente

En SQL Server, las fechas se escriben como texto en formato `'AAAA-MM-DD'`:

```sql
-- Fecha específica
INSERT INTO Inscripcion (Matricula_Estudiante, Codigo_Curso, Fecha_Inscripcion)
VALUES ('EST-005', 'MAT-201', '2025-06-15');

-- Fecha actual del servidor
INSERT INTO Inscripcion (Matricula_Estudiante, Codigo_Curso, Fecha_Inscripcion)
VALUES ('EST-005', 'CIE-301', GETDATE());
```

---

## Ejercicio práctico

### Caso: Sistema de Biblioteca

Usando las tablas que creaste en el ejercicio de la Clase 3 (Biblioteca), inserta los siguientes datos:

**Libros (al menos 5):**

| ISBN           | Título                         | Autor              | Año  |
| -------------- | ------------------------------ | ------------------- | ---- |
| 978-0-1234-001 | Cien años de soledad           | Gabriel García M.   | 1967 |
| 978-0-1234-002 | Don Quijote de la Mancha       | Miguel de Cervantes | 1605 |
| 978-0-1234-003 | El principito                  | Antoine de Saint-E. | 1943 |
| 978-0-1234-004 | 1984                           | George Orwell       | 1949 |
| 978-0-1234-005 | Fundamentos de bases de datos  | Abraham Silberschatz| 2019 |

**Miembros (al menos 3):**

| ID  | Nombre         | Email                  |
| --- | -------------- | ---------------------- |
| 1   | Ana Martínez   | ana@biblioteca.com     |
| 2   | Luis García    | luis@biblioteca.com    |
| 3   | Carmen Ruiz    | carmen@biblioteca.com  |

**Préstamos (al menos 4):**

Crea préstamos variados con diferentes estados (Activo, Devuelto).

**Tu tarea:**

1. Escribe las sentencias INSERT respetando el orden de dependencias
2. Verifica los datos con SELECT
3. Intenta provocar al menos un error a propósito (FK inválida, PK duplicada) y documenta qué mensaje te dio SQL Server

---

## Resumen de lo aprendido

| Concepto                | Lo que aprendiste                                            |
| ----------------------- | ------------------------------------------------------------ |
| **INSERT INTO**         | Cómo agregar registros a una tabla                           |
| **Inserción múltiple**  | Cómo insertar varios registros en una sola sentencia         |
| **Orden de inserción**  | Tablas independientes primero, dependientes después          |
| **Valores por defecto** | Cómo aprovechar DEFAULT para campos opcionales               |
| **NULL**                | Cómo dejar campos vacíos cuando son opcionales               |
| **SCOPE_IDENTITY()**    | Cómo obtener el último ID generado por IDENTITY              |
| **Verificación**        | Usar SELECT para confirmar que los datos se insertaron bien  |

---

## Preparación para la próxima clase

En la siguiente clase aprenderemos a **consultar datos** con `SELECT`: filtrar, ordenar y buscar información específica en las tablas.

### Tarea para la próxima sesión

1. Completar el ejercicio de la Biblioteca
2. Insertar al menos 10 registros en cada tabla del sistema de inscripción
3. Experimentar con diferentes errores y anotar los mensajes

---

<div align="center">

**Tus tablas ya tienen datos reales. En la siguiente clase aprenderás a hacer preguntas a esos datos con SELECT.**

</div>
