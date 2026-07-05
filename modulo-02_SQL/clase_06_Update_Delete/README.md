# Clase 6: Actualizar y eliminar datos en SQL Server (UPDATE y DELETE)

<div align="center">
  <img src="https://img.shields.io/badge/Nivel-Basico-green" alt="Nivel Básico">
  <img src="https://img.shields.io/badge/Enfoque-DML UPDATE DELETE-blue" alt="Enfoque DML UPDATE DELETE">

  <h2>Completando el ciclo CRUD</h2>

  <p><em>Aprende a modificar y eliminar registros de forma segura</em></p>
</div>

---

## Objetivos de esta clase

Al finalizar esta sesión, serás capaz de:

- Actualizar registros existentes con `UPDATE`
- Eliminar registros con `DELETE`
- Entender por qué `WHERE` es fundamental en UPDATE y DELETE
- Comprender el ciclo completo de CRUD
- Aplicar buenas prácticas para evitar pérdida de datos

---

## ¿Qué es CRUD?

CRUD es un acrónimo que representa las cuatro operaciones básicas que se realizan con datos:

| Letra | Operación  | Comando SQL | Clase donde lo vimos |
| ----- | ---------- | ----------- | -------------------- |
| **C** | Create     | `INSERT`    | Clase 4              |
| **R** | Read       | `SELECT`    | Clase 5              |
| **U** | Update     | `UPDATE`    | Esta clase           |
| **D** | Delete     | `DELETE`    | Esta clase           |

Con esta clase completarás las cuatro operaciones y podrás gestionar datos de principio a fin.

### Requisito previo

Debes tener las tablas del sistema de inscripción con datos (clases 3 y 4).

```sql
USE Escuela;
GO
```

---

## UPDATE: actualizar datos existentes

### Sintaxis básica

```sql
UPDATE NombreTabla
SET columna1 = 'nuevo_valor',
    columna2 = 'otro_valor'
WHERE condición;
```

**Las tres partes de UPDATE:**

| Parte    | ¿Qué hace?                                  |
| -------- | -------------------------------------------- |
| `UPDATE` | Indica qué tabla quieres modificar           |
| `SET`    | Define qué columnas cambiar y sus nuevos valores |
| `WHERE`  | Filtra qué registros se van a modificar      |

---

### La regla de oro: SIEMPRE usa WHERE

> **IMPORTANTE:** Si ejecutas un UPDATE sin WHERE, se modificarán TODOS los registros de la tabla. Esto puede causar pérdida de datos irreversible.

```sql
-- PELIGROSO: Cambia el departamento de TODOS los profesores
UPDATE Profesor
SET Departamento = 'Ingeniería';

-- CORRECTO: Cambia solo el departamento del profesor con ID 3
UPDATE Profesor
SET Departamento = 'Ingeniería'
WHERE ID_Profesor = 3;
```

**Buena práctica:** Antes de ejecutar un UPDATE, ejecuta primero un SELECT con el mismo WHERE para verificar qué registros se van a afectar:

```sql
-- Paso 1: Verificar qué registro se va a modificar
SELECT * FROM Profesor WHERE ID_Profesor = 3;

-- Paso 2: Si es el correcto, ejecutar el UPDATE
UPDATE Profesor
SET Departamento = 'Ingeniería'
WHERE ID_Profesor = 3;
```

---

### Ejemplos prácticos de UPDATE

#### Actualizar un solo campo

```sql
-- Cambiar el teléfono de un profesor
UPDATE Profesor
SET Telefono = '8888-0000'
WHERE ID_Profesor = 4;
```

#### Actualizar varios campos a la vez

```sql
-- Cambiar nombre y email de un estudiante
UPDATE Estudiante
SET Nombre = 'Pedro Antonio',
    Email = 'pedro.antonio@mail.com'
WHERE Matricula = 'EST-001';
```

#### Actualizar con una condición más amplia

```sql
-- Cancelar todas las inscripciones activas de un estudiante
UPDATE Inscripcion
SET Estado = 'Cancelada'
WHERE Matricula_Estudiante = 'EST-002' AND Estado = 'Activa';
```

#### Actualizar usando el valor actual

```sql
-- Aumentar la capacidad máxima de todos los cursos en 5
UPDATE Curso
SET Cantidad_Maxima = Cantidad_Maxima + 5
WHERE Cantidad_Maxima < 35;
```

**Explicación:** `Cantidad_Maxima = Cantidad_Maxima + 5` toma el valor actual y le suma 5. Si un curso tenía capacidad 30, ahora tendrá 35.

#### Completar una inscripción

```sql
-- Marcar una inscripción como completada
UPDATE Inscripcion
SET Estado = 'Completada'
WHERE Matricula_Estudiante = 'EST-001' AND Codigo_Curso = 'ING-101';
```

---

### Verificar los cambios

Siempre verifica después de un UPDATE:

```sql
-- Ver el registro modificado
SELECT * FROM Profesor WHERE ID_Profesor = 4;

-- Ver cuántos registros fueron afectados (SQL Server lo muestra automáticamente)
-- Verás un mensaje como: "(1 row affected)"
```

---

## DELETE: eliminar registros

### Sintaxis básica

```sql
DELETE FROM NombreTabla
WHERE condición;
```

### La misma regla de oro: SIEMPRE usa WHERE

> **IMPORTANTE:** Si ejecutas un DELETE sin WHERE, se eliminarán TODOS los registros de la tabla. La tabla seguirá existiendo pero quedará vacía.

```sql
-- PELIGROSO: Elimina TODOS los estudiantes
DELETE FROM Estudiante;

-- CORRECTO: Elimina solo un estudiante específico
DELETE FROM Estudiante
WHERE Matricula = 'EST-005';
```

**Buena práctica:** Igual que con UPDATE, primero verifica con SELECT:

```sql
-- Paso 1: Verificar qué se va a eliminar
SELECT * FROM Estudiante WHERE Matricula = 'EST-005';

-- Paso 2: Si es el correcto, eliminar
DELETE FROM Estudiante
WHERE Matricula = 'EST-005';
```

---

### Ejemplos prácticos de DELETE

#### Eliminar un registro específico

```sql
-- Eliminar una inscripción cancelada
DELETE FROM Inscripcion
WHERE Matricula_Estudiante = 'EST-005' AND Codigo_Curso = 'ING-102';
```

#### Eliminar varios registros con una condición

```sql
-- Eliminar todas las inscripciones canceladas
DELETE FROM Inscripcion
WHERE Estado = 'Cancelada';
```

#### Eliminar registros por fecha

```sql
-- Eliminar inscripciones anteriores a una fecha
DELETE FROM Inscripcion
WHERE Fecha_Inscripcion < '2025-01-16';
```

---

### Restricciones al eliminar: claves foráneas

Al intentar eliminar un registro que es referenciado por otra tabla, SQL Server lo impedirá:

```sql
-- Esto dará error si el profesor tiene cursos asignados
DELETE FROM Profesor
WHERE ID_Profesor = 1;
```

**Error:** "The DELETE statement conflicted with the REFERENCE constraint..."

**¿Por qué?** Porque hay cursos que tienen `ID_Profesor = 1`. Si eliminas al profesor, esos cursos quedarían apuntando a un profesor que no existe.

**¿Cómo solucionarlo?** Tienes dos opciones:

**Opción 1: Eliminar primero los registros dependientes**

```sql
-- 1. Eliminar inscripciones de los cursos del profesor
DELETE FROM Inscripcion
WHERE Codigo_Curso IN (
    SELECT Codigo_Curso FROM Curso WHERE ID_Profesor = 1
);

-- 2. Eliminar los cursos del profesor
DELETE FROM Curso WHERE ID_Profesor = 1;

-- 3. Ahora sí, eliminar el profesor
DELETE FROM Profesor WHERE ID_Profesor = 1;
```

**Opción 2: Reasignar los cursos a otro profesor**

```sql
-- Reasignar cursos a otro profesor antes de eliminar
UPDATE Curso
SET ID_Profesor = 2
WHERE ID_Profesor = 1;

-- Ahora sí, eliminar el profesor
DELETE FROM Profesor WHERE ID_Profesor = 1;
```

---

## Diferencia entre DELETE y TRUNCATE

| Característica        | DELETE                            | TRUNCATE                       |
| --------------------- | --------------------------------- | ------------------------------ |
| Acepta WHERE          | Sí                                | No                             |
| Elimina               | Filas específicas o todas         | Siempre todas las filas        |
| Velocidad             | Más lento (registro por registro) | Más rápido                     |
| Reinicia IDENTITY     | No                                | Sí                             |

```sql
-- DELETE: elimina todos los registros pero mantiene el contador de IDENTITY
DELETE FROM Inscripcion;

-- TRUNCATE: elimina todos los registros Y reinicia el contador de IDENTITY
TRUNCATE TABLE Inscripcion;
```

**¿Cuándo usar cada uno?** Usa `DELETE` cuando quieras borrar registros específicos. Usa `TRUNCATE` solo cuando quieras vaciar la tabla por completo y empezar de cero.

---

## Resumen del ciclo CRUD completo

Ahora que conoces las cuatro operaciones, aquí está el ciclo completo con ejemplos:

### C - Create (Crear)

```sql
-- Agregar un nuevo estudiante
INSERT INTO Estudiante (Matricula, Nombre, Apellido, Email)
VALUES ('EST-010', 'Valentina', 'Ríos', 'valentina@mail.com');
```

### R - Read (Leer)

```sql
-- Consultar los datos del estudiante
SELECT * FROM Estudiante
WHERE Matricula = 'EST-010';
```

### U - Update (Actualizar)

```sql
-- Actualizar su teléfono
UPDATE Estudiante
SET Telefono = '7777-0010'
WHERE Matricula = 'EST-010';
```

### D - Delete (Eliminar)

```sql
-- Eliminar el estudiante
DELETE FROM Estudiante
WHERE Matricula = 'EST-010';
```

---

## Buenas prácticas de seguridad

### 1. Siempre verifica antes de modificar

```sql
-- Antes de UPDATE o DELETE, ejecuta SELECT con el mismo WHERE
SELECT * FROM [tabla] WHERE [condición];
```

### 2. Haz respaldos antes de operaciones masivas

Antes de hacer un UPDATE o DELETE que afecte muchos registros, respalda los datos:

```sql
-- Crear una copia de la tabla antes de modificarla
SELECT * INTO Inscripcion_Respaldo
FROM Inscripcion;

-- Ahora puedes hacer tus cambios con confianza
-- Si algo sale mal, los datos están en Inscripcion_Respaldo
```

### 3. Cuenta antes de eliminar

```sql
-- ¿Cuántos registros voy a eliminar?
SELECT COUNT(*) AS 'Registros a eliminar'
FROM Inscripcion
WHERE Estado = 'Cancelada';

-- Si el número es el esperado, procede
DELETE FROM Inscripcion
WHERE Estado = 'Cancelada';
```

---

## Errores comunes

### Error: UPDATE sin WHERE

```sql
-- PELIGRO: Esto cambia TODOS los registros
UPDATE Estudiante
SET Nombre = 'Juan';
-- Ahora TODOS los estudiantes se llaman Juan
```

**Prevención:** Siempre revisa tu query antes de ejecutarla. Si no tiene WHERE, pregúntate si realmente quieres afectar todos los registros.

### Error: DELETE con FK activa

```sql
-- Error: No puedes eliminar un profesor que tiene cursos asignados
DELETE FROM Profesor WHERE ID_Profesor = 1;
```

**Solución:** Elimina o reasigna los registros dependientes primero.

### Error: Usar = en lugar de IN para múltiples valores

```sql
-- INCORRECTO
DELETE FROM Estudiante
WHERE Matricula = 'EST-001', 'EST-002';

-- CORRECTO
DELETE FROM Estudiante
WHERE Matricula IN ('EST-001', 'EST-002');
```

---

## Ejercicio práctico

### Caso: Sistema de Biblioteca

Usando las tablas de la Biblioteca con datos de las clases anteriores, realiza las siguientes operaciones:

**Operaciones UPDATE:**

1. Cambia el email de un miembro
2. Actualiza el año de publicación de un libro
3. Cambia el estado de un préstamo de "Activo" a "Devuelto"
4. Actualiza el nombre de un miembro que tenía un error

**Operaciones DELETE:**

5. Elimina un préstamo específico
6. Elimina todos los préstamos con estado "Devuelto"
7. Intenta eliminar un libro que tiene préstamos activos (documenta el error)
8. Elimina un miembro que no tiene préstamos asociados

**Operación completa (CRUD):**

9. Inserta un nuevo miembro, haz un préstamo para él, actualiza el estado del préstamo a "Devuelto", y finalmente elimina ese préstamo. Documenta cada paso con su SELECT de verificación.

**Buenas prácticas:**

10. Para cada operación, escribe primero el SELECT de verificación y luego el UPDATE o DELETE

---

## Resumen del curso completo

Has completado el ciclo de aprendizaje desde el diseño hasta la manipulación de datos:

| Clase | Tema                            | Lo que aprendiste                                     |
| ----- | ------------------------------- | ----------------------------------------------------- |
| 1     | Diagramas ER                    | Diseñar la estructura antes de construirla            |
| 2     | Transformación ER a Relacional  | Convertir diagramas en tablas con reglas claras       |
| 3     | DDL - CREATE TABLE              | Crear tablas reales con restricciones en SQL Server   |
| 4     | DML - INSERT                    | Agregar datos respetando restricciones                |
| 5     | DML - SELECT                    | Consultar, filtrar, ordenar y agregar datos           |
| 6     | DML - UPDATE y DELETE           | Modificar y eliminar datos de forma segura            |

### ¿Qué sigue después?

Con estos fundamentos, los siguientes temas a explorar serían:

| Tema                     | Descripción                                               |
| ------------------------ | --------------------------------------------------------- |
| **JOINs**                | Combinar datos de múltiples tablas en una sola consulta   |
| **Subconsultas**         | Escribir consultas dentro de otras consultas              |
| **Vistas**               | Crear "tablas virtuales" que simplifican consultas complejas |
| **Procedimientos almacenados** | Agrupar varias operaciones SQL en bloques reutilizables |
| **Índices**              | Optimizar la velocidad de las consultas                   |
| **Normalización**        | Aplicar formas normales para un diseño óptimo             |

---

<div align="center">

**Felicidades. Ahora sabes diseñar, crear, llenar, consultar, actualizar y eliminar datos en una base de datos relacional. Estos son los cimientos sobre los que se construye todo lo demás.**

</div>
