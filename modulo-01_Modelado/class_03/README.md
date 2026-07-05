# Clase 3: Creación de tablas en SQL Server (DDL)

<div align="center">
  <img src="https://img.shields.io/badge/Nivel-Intermedio-blue" alt="Nivel Intermedio">
  <img src="https://img.shields.io/badge/Enfoque-SQL Práctico-green" alt="Enfoque SQL Práctico">

  <h2>Del esquema relacional a tablas reales en SQL Server</h2>

  <p><em>Tu primer contacto con el código SQL para construir bases de datos</em></p>
</div>

---

## Objetivos de esta clase

Al finalizar esta sesión, serás capaz de:

- Crear una base de datos en SQL Server
- Escribir sentencias `CREATE TABLE` con columnas y tipos de datos
- Aplicar restricciones de integridad (PK, FK, NOT NULL, UNIQUE, CHECK)
- Entender los tipos de datos más comunes en SQL Server
- Llevar un esquema relacional (clase anterior) a tablas reales

---

## Antes de empezar

### ¿Qué es DDL?

**DDL (Data Definition Language)** es el conjunto de comandos SQL que se usan para **definir la estructura** de una base de datos. Con DDL no manipulas datos; creas, modificas o eliminas las "cajas" donde se guardarán los datos.

| Comando          | ¿Qué hace?                           | Ejemplo rápido               |
| ---------------- | ------------------------------------- | ---------------------------- |
| `CREATE TABLE`   | Crea una tabla nueva                  | `CREATE TABLE Profesor (...)` |
| `ALTER TABLE`    | Modifica una tabla existente          | Agregar o quitar columnas    |
| `DROP TABLE`     | Elimina una tabla por completo        | `DROP TABLE Profesor`        |
| `CREATE DATABASE`| Crea una base de datos nueva          | `CREATE DATABASE MiEscuela`  |

**Explicación sencilla:** DDL es como construir la estructura de un edificio. Defines cuántos pisos hay, cuántas habitaciones, de qué tamaño serán. Luego, con otro tipo de comandos (DML, que veremos después), metes los muebles y las personas.

### Herramientas que puedes usar

- **SQL Server Management Studio (SSMS):** La herramienta oficial de Microsoft
- **Azure Data Studio:** Alternativa moderna y ligera
- **VS Code + extensión SQL Server:** Si prefieres trabajar desde VS Code

---

## Paso 1: Crear la base de datos

Antes de crear tablas, necesitas una base de datos donde guardarlas:

```sql
-- Crear la base de datos
CREATE DATABASE Escuela;
GO

-- Seleccionar la base de datos para trabajar con ella
USE Escuela;
GO
```

**¿Qué es `GO`?** Es un separador de lotes en SQL Server. Le dice al servidor: "ejecuta todo lo anterior antes de continuar". No es un comando SQL estándar, sino una instrucción específica de las herramientas de SQL Server.

**¿Qué es `USE`?** Le indica al servidor en qué base de datos quieres trabajar. Si no lo pones, las tablas podrían crearse en la base de datos equivocada.

---

## Paso 2: Tipos de datos en SQL Server

Antes de crear tablas, necesitas saber qué tipos de datos existen. Un tipo de dato define **qué clase de información** puede guardar una columna.

### Tipos más comunes

| Tipo de dato     | ¿Qué guarda?                 | Ejemplo de valor          | ¿Cuándo usarlo?                     |
| ---------------- | ----------------------------- | ------------------------- | ------------------------------------ |
| `INT`            | Números enteros               | `1`, `42`, `-10`          | IDs, cantidades, edades              |
| `VARCHAR(n)`     | Texto de longitud variable    | `'Juan'`, `'Programación'`| Nombres, descripciones cortas        |
| `NVARCHAR(n)`    | Texto con soporte para tildes | `'José'`, `'Diseño'`     | Textos en español u otros idiomas    |
| `DATE`           | Solo fecha                    | `'2025-03-15'`            | Fechas de nacimiento, inscripción    |
| `DATETIME`       | Fecha y hora                  | `'2025-03-15 14:30:00'`   | Registros que necesitan hora exacta  |
| `BIT`            | Verdadero o falso             | `1` o `0`                 | Estados activo/inactivo              |
| `DECIMAL(p,s)`   | Números con decimales         | `99.99`, `3.14`           | Precios, promedios, calificaciones   |

**¿Qué significa `VARCHAR(50)`?** Significa que esa columna puede guardar texto de hasta 50 caracteres. Si alguien escribe un nombre más largo, SQL Server dará un error.

**¿Cuál es la diferencia entre `VARCHAR` y `NVARCHAR`?** `NVARCHAR` soporta caracteres especiales como tildes (á, é, í), eñes (ñ) y otros caracteres internacionales. Si tu base de datos es en español, es recomendable usar `NVARCHAR`.

---

## Paso 3: Crear tablas con restricciones

### Sintaxis básica de CREATE TABLE

```sql
CREATE TABLE NombreTabla (
    NombreColumna TipoDeDato [RESTRICCIONES],
    NombreColumna TipoDeDato [RESTRICCIONES],
    ...
);
```

### Restricciones disponibles

| Restricción      | ¿Qué hace?                                         | Ejemplo                                |
| ---------------- | --------------------------------------------------- | -------------------------------------- |
| `PRIMARY KEY`    | Identifica cada fila de forma única                 | `ID_Profesor INT PRIMARY KEY`          |
| `NOT NULL`       | Obliga a que el campo tenga un valor                | `Nombre NVARCHAR(50) NOT NULL`         |
| `UNIQUE`         | No permite valores repetidos                        | `Email NVARCHAR(100) UNIQUE`           |
| `DEFAULT`        | Asigna un valor si no se proporciona uno            | `Estado BIT DEFAULT 1`                 |
| `CHECK`          | Valida que el valor cumpla una condición            | `CHECK (Cantidad_Maxima > 0)`          |
| `FOREIGN KEY`    | Establece relación con otra tabla                   | `ID_Profesor INT FOREIGN KEY REFERENCES Profesor(ID_Profesor)` |
| `IDENTITY(1,1)`  | Genera números automáticos (1, 2, 3...)             | `ID INT IDENTITY(1,1) PRIMARY KEY`     |

**¿Qué es `IDENTITY(1,1)`?** Le dice a SQL Server que genere los valores de esa columna automáticamente. El primer número es `1` y cada registro nuevo suma `1`. Así no tienes que escribir el ID manualmente.

---

## Ejemplo completo: Sistema de Inscripción

Vamos a tomar el esquema relacional de la clase anterior y convertirlo en tablas reales. Recuerda el orden: tablas independientes primero, tablas con dependencias después.

### Tabla 1: Profesor (independiente)

```sql
CREATE TABLE Profesor (
    ID_Profesor     INT           IDENTITY(1,1) PRIMARY KEY,
    Nombre          NVARCHAR(50)  NOT NULL,
    Apellido        NVARCHAR(50)  NOT NULL,
    Departamento    NVARCHAR(80)  NOT NULL,
    Email           NVARCHAR(100) UNIQUE,
    Telefono        NVARCHAR(20)
);
```

**Explicación línea por línea:**

| Línea                    | ¿Qué hace?                                              |
| ------------------------ | -------------------------------------------------------- |
| `ID_Profesor INT`        | Columna de tipo número entero                            |
| `IDENTITY(1,1)`          | SQL Server genera el ID automáticamente (1, 2, 3...)     |
| `PRIMARY KEY`            | Esta columna identifica cada profesor de forma única     |
| `NVARCHAR(50) NOT NULL`  | Texto de hasta 50 caracteres, obligatorio                |
| `UNIQUE`                 | No puede haber dos profesores con el mismo email         |
| Sin NOT NULL en Teléfono | El teléfono es opcional (puede quedar vacío)             |

### Tabla 2: Estudiante (independiente)

```sql
CREATE TABLE Estudiante (
    Matricula   NVARCHAR(20)  PRIMARY KEY,
    Nombre      NVARCHAR(50)  NOT NULL,
    Apellido    NVARCHAR(50)  NOT NULL,
    Telefono    NVARCHAR(20),
    Email       NVARCHAR(100) UNIQUE
);
```

**Nota:** Aquí usamos una clave primaria natural (`Matricula`) en lugar de un IDENTITY. Esto es válido cuando el identificador ya existe en el dominio del problema (cada estudiante ya tiene su matrícula asignada por la universidad).

### Tabla 3: Curso (depende de Profesor)

```sql
CREATE TABLE Curso (
    Codigo_Curso     NVARCHAR(10)  PRIMARY KEY,
    Nombre           NVARCHAR(100) NOT NULL,
    Descripcion      NVARCHAR(500),
    Cantidad_Maxima  INT           NOT NULL CHECK (Cantidad_Maxima > 0),
    ID_Profesor      INT           FOREIGN KEY REFERENCES Profesor(ID_Profesor) NOT NULL
);
```

**Explicación de las partes nuevas:**

| Parte                          | ¿Qué hace?                                                  |
| ------------------------------ | ------------------------------------------------------------ |
| `CHECK (Cantidad_Maxima > 0)`  | No permite crear cursos con capacidad 0 o negativa           |
| `FOREIGN KEY REFERENCES...`    | En SQL Server puedes definir la clave foránea en la misma línea del campo, vinculándola a la tabla de origen |

**¿Qué pasa si intento asignar un profesor que no existe?** SQL Server rechazará la operación con un error. Eso es justamente el trabajo de la clave foránea: proteger la integridad de los datos.

### Tabla 4: Inscripcion (relación M:N, depende de Estudiante y Curso)

```sql
CREATE TABLE Inscripcion (
    ID                      INT           IDENTITY(1,1) PRIMARY KEY,
    Matricula_Estudiante    NVARCHAR(20)  FOREIGN KEY REFERENCES Estudiante(Matricula) NOT NULL,
    Codigo_Curso            NVARCHAR(10)  FOREIGN KEY REFERENCES Curso(Codigo_Curso) NOT NULL,
    Fecha_Inscripcion       DATE          NOT NULL DEFAULT GETDATE(),
    Estado                  NVARCHAR(20)  NOT NULL DEFAULT 'Activa'
                            CHECK (Estado IN ('Activa', 'Completada', 'Cancelada')),

    -- Evitar que un estudiante se inscriba dos veces en el mismo curso
    UNIQUE (Matricula_Estudiante, Codigo_Curso)
);
```

**Explicación de las partes nuevas:**

| Parte                                  | ¿Qué hace?                                                     |
| -------------------------------------- | --------------------------------------------------------------- |
| `DEFAULT GETDATE()`                    | Si no se da una fecha, usa la fecha actual del servidor          |
| `DEFAULT 'Activa'`                     | Si no se da un estado, pone "Activa" automáticamente            |
| `CHECK (Estado IN (...))`              | Solo permite los tres valores válidos para estado               |
| `UNIQUE (Matricula_Estudiante, ...)`   | Un estudiante no puede inscribirse dos veces al mismo curso     |
| `FOREIGN KEY REFERENCES...`            | Al igual que en Curso, vinculamos la matrícula y el código del curso directamente en la definición de la columna |

---

## Script completo

Aquí está todo junto, listo para copiar y ejecutar en SQL Server:

```sql
-- ============================================
-- Sistema de Inscripción de Materias
-- Base de datos: Escuela
-- ============================================

CREATE DATABASE Escuela;
GO

USE Escuela;
GO

-- 1. Tabla Profesor (independiente)
CREATE TABLE Profesor (
    ID_Profesor     INT           IDENTITY(1,1) PRIMARY KEY,
    Nombre          NVARCHAR(50)  NOT NULL,
    Apellido        NVARCHAR(50)  NOT NULL,
    Departamento    NVARCHAR(80)  NOT NULL,
    Email           NVARCHAR(100) UNIQUE,
    Telefono        NVARCHAR(20)
);
GO

-- 2. Tabla Estudiante (independiente)
CREATE TABLE Estudiante (
    Matricula   NVARCHAR(20)  PRIMARY KEY,
    Nombre      NVARCHAR(50)  NOT NULL,
    Apellido    NVARCHAR(50)  NOT NULL,
    Telefono    NVARCHAR(20),
    Email       NVARCHAR(100) UNIQUE
);
GO

-- 3. Tabla Curso (depende de Profesor)
CREATE TABLE Curso (
    Codigo_Curso     NVARCHAR(10)  PRIMARY KEY,
    Nombre           NVARCHAR(100) NOT NULL,
    Descripcion      NVARCHAR(500),
    Cantidad_Maxima  INT           NOT NULL CHECK (Cantidad_Maxima > 0),
    ID_Profesor      INT           FOREIGN KEY REFERENCES Profesor(ID_Profesor) NOT NULL
);
GO

-- 4. Tabla Inscripcion (relación M:N entre Estudiante y Curso)
CREATE TABLE Inscripcion (
    ID                      INT           IDENTITY(1,1) PRIMARY KEY,
    Matricula_Estudiante    NVARCHAR(20)  FOREIGN KEY REFERENCES Estudiante(Matricula) NOT NULL,
    Codigo_Curso            NVARCHAR(10)  FOREIGN KEY REFERENCES Curso(Codigo_Curso) NOT NULL,
    Fecha_Inscripcion       DATE          NOT NULL DEFAULT GETDATE(),
    Estado                  NVARCHAR(20)  NOT NULL DEFAULT 'Activa'
                            CHECK (Estado IN ('Activa', 'Completada', 'Cancelada')),
    UNIQUE (Matricula_Estudiante, Codigo_Curso)
);
GO
```

---

## Comandos adicionales útiles

### Ver las tablas que existen en la base de datos

```sql
-- Listar todas las tablas
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
```

### Ver la estructura de una tabla

```sql
-- Ver columnas y tipos de dato de una tabla
EXEC sp_columns 'Profesor';
```

### Eliminar una tabla

```sql
-- Eliminar una tabla (cuidado: borra todo su contenido)
DROP TABLE Inscripcion;
```

**Importante:** Para eliminar una tabla que tiene relaciones (FKs), primero debes eliminar las tablas que dependen de ella. Por ejemplo, no puedes eliminar `Profesor` si `Curso` tiene una FK que apunta a ella.

### Modificar una tabla existente

```sql
-- Agregar una columna nueva
ALTER TABLE Estudiante
ADD Fecha_Nacimiento DATE;

-- Eliminar una columna
ALTER TABLE Estudiante
DROP COLUMN Fecha_Nacimiento;
```

---

## Errores comunes y cómo solucionarlos

### Error: "There is already an object named..."

**Causa:** Intentas crear una tabla que ya existe.
**Solución:** Elimina la tabla primero con `DROP TABLE` o verifica que no exista.

### Error: "The INSERT statement conflicted with the FOREIGN KEY constraint..."

**Causa:** Intentas insertar un valor en una FK que no existe en la tabla referenciada.
**Solución:** Asegúrate de que el valor de la FK exista en la tabla padre.

### Error: "Cannot insert the value NULL into column..."

**Causa:** Intentas dejar vacía una columna que tiene restricción NOT NULL.
**Solución:** Proporciona un valor para esa columna.

### Error: "Violation of UNIQUE KEY constraint..."

**Causa:** Intentas insertar un valor que ya existe en una columna UNIQUE.
**Solución:** Usa un valor diferente que no se repita.

---

## Ejercicio práctico

### Caso: Sistema de Biblioteca

Usando el esquema relacional del ejercicio de la clase 2 (Biblioteca), escribe el script SQL completo para crear las tablas en SQL Server.

**Recordatorio del esquema:**

- **Libro:** ISBN (PK), Título, Autor, Año_Publicación
- **Miembro:** ID_Miembro (PK), Nombre, Email (UNIQUE), Fecha_Inscripción
- **Prestamo:** ID (PK), ID_Miembro (FK), ISBN (FK), Fecha_Prestamo, Fecha_Devolucion, Estado

**Tu tarea:**

1. Crea la base de datos `Biblioteca`
2. Crea las tres tablas respetando el orden correcto
3. Aplica las restricciones de integridad apropiadas
4. Usa tipos de datos adecuados para cada columna
5. Agrega al menos un `CHECK` y un `DEFAULT`

---

## Recursos útiles para seguir investigando

Para aquellas personas que desean profundizar o investigar más allá de los fundamentos, aquí compartimos enlaces directos a la documentación oficial de Microsoft Learn:

- **Tipos de datos en SQL Server:** Consulta la lista técnica completa y detallada de todos los tipos de datos admitidos por el motor de base de datos en [Tipos de datos de Transact-SQL](https://learn.microsoft.com/es-es/sql/t-sql/data-types/data-types-transact-sql).
- **Funciones de ventana (Window Functions):** Aprende a realizar cálculos analíticos y de agregación sobre un conjunto de registros (ventana) asociados a la fila actual usando la cláusula `OVER` en [Cláusula OVER (Transact-SQL)](https://learn.microsoft.com/es-es/sql/t-sql/queries/select-over-clause-transact-sql).

---

## Resumen de lo aprendido


| Concepto             | Lo que aprendiste                                           |
| -------------------- | ----------------------------------------------------------- |
| **DDL**              | Comandos para definir la estructura de bases de datos       |
| **CREATE DATABASE**  | Cómo crear una base de datos nueva                          |
| **CREATE TABLE**     | Cómo crear tablas con columnas y restricciones              |
| **Tipos de datos**   | INT, NVARCHAR, DATE, BIT, DECIMAL y cuándo usar cada uno   |
| **Restricciones**    | PK, FK, NOT NULL, UNIQUE, CHECK, DEFAULT, IDENTITY         |
| **Orden de creación**| Tablas independientes primero, dependientes después         |
| **ALTER/DROP TABLE** | Cómo modificar o eliminar tablas existentes                 |

---

## Preparación para la próxima clase

En la siguiente clase aprenderemos a **insertar datos** en las tablas que acabamos de crear usando el comando `INSERT INTO`.

### Tarea para la próxima sesión

1. Completar el ejercicio de la Biblioteca
2. Ejecutar el script del sistema de inscripción en SQL Server
3. Experimentar creando tus propias tablas

---

<div align="center">

**Has dado el salto de la teoría al código real. Desde aquí, todo lo que diseñaste en las clases anteriores cobra vida en SQL Server.**

</div>
