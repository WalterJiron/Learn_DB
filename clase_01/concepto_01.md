<div align="center">
  <h1>🗂️ Diseño de bases de datos mediante modelado entidad-relación</h1>

## 📊 **Diagramas Entidad-Relación con draw.io**

_Fundamentos del modelado conceptual de bases de datos_

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbG2zjX2d6MG-YM0J0zkb8vILdu3ZGjD7Ywg&s" width="50"/>

</div>

---

## 🎯 **Objetivo del Módulo**

Al finalizar este módulo, serás capaz de:

- Comprender los conceptos fundamentales del modelo Entidad-Relación
- Identificar y modelar entidades, atributos y relaciones
- Representar correctamente la cardinalidad entre entidades
- Crear diagramas ER profesionales usando draw.io
- Convertir modelos conceptuales en esquemas relacionales

---

## 🧱 **Elementos Fundamentales del Modelo ER**

### 1. **🏛️ Entidades**

Representan "cosas" u "objetos" del mundo real sobre los cuales queremos almacenar información.

| Elemento           | Símbolo en draw.io                                                           | Descripción               | Ejemplo                    |
| ------------------ | ---------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| **Entidad Fuerte** | ![Rectángulo](https://via.placeholder.com/50x30/4CAF50/FFFFFF?text=E)        | Existe independientemente | `Estudiante`, `Producto`   |
| **Entidad Débil**  | ![Rectángulo doble](https://via.placeholder.com/50x30/FF9800/FFFFFF?text=ED) | Depende de otra entidad   | `Teléfono` (de `Empleado`) |

**🔧 En draw.io:** Busca "Entity" en la librería de formas o usa un rectángulo simple.

### 2. **🏷️ Atributos**

Características o propiedades de las entidades.

| Tipo de Atributo | Símbolo            | Descripción           | Ejemplo en `Estudiante`         |
| ---------------- | ------------------ | --------------------- | ------------------------------- |
| **Simple**       | ○                  | Atómico, no divisible | `Edad`                          |
| **Compuesto**    | ○ con subatributos | Divisible en partes   | `Dirección` (calle, ciudad, CP) |
| **Derivado**     | ○ punteado         | Se calcula de otros   | `Edad` (de `FechaNacimiento`)   |
| **Clave**        | ○ subrayado        | Identifica la entidad | `Matrícula`                     |
| **Multivaluado** | ○ doble            | Múltiples valores     | `Teléfonos`                     |

**🔧 En draw.io:** Usa elipses o círculos conectados a la entidad.

### 3. **🔗 Relaciones**

Asociaciones entre dos o más entidades.

| Tipo          | Símbolo | Descripción           | Ejemplo                         |
| ------------- | ------- | --------------------- | ------------------------------- |
| **Binaria**   | ────    | Entre dos entidades   | `Estudiante` - `Curso`          |
| **Recursiva** | ────◄─  | Entidad consigo misma | `Empleado` supervisa `Empleado` |
| **Ternaria**  | ──►◄─   | Entre tres entidades  | `Estudiante`-`Profesor`-`Curso` |

**🔧 En draw.io:** Usa líneas con rombos (opcional) para las relaciones.

---

## 📐 **Cardinalidad y Modalidad**

### **¿Cuántos? - Cardinalidad**

Define el número máximo de ocurrencias en una relación.

| Notación | Símbolo | Significado     |
| -------- | ------- | --------------- |
| **1:1**  | `┼───┼` | Uno a Uno       |
| **1:N**  | `┼───<` | Uno a Muchos    |
| **N:1**  | `>───┼` | Muchos a Uno    |
| **M:N**  | `>───<` | Muchos a Muchos |

### **¿Obligatorio? - Modalidad**

Define el mínimo de ocurrencias.

| Notación  | Símbolo | Significado         |
| --------- | ------- | ------------------- | ---------------------- |
| **(0,1)** | `○───`  | Opcional (mínimo 0) |
| **(1,1)** | `       | ───`                | Obligatorio (mínimo 1) |

**🎯 Ejemplo completo:** `(0,N)` significa: mínimo 0, máximo muchos.

---

## 🛠️ **Tutorial: Creando un Diagrama ER en draw.io**

### **Paso 1: Configuración inicial**

1. Accede a [app.diagrams.net](https://app.diagrams.net/) o descarga la aplicación
2. Selecciona "Crear nuevo diagrama"
3. Elige "Blank Diagram" o "Entity Relationship"

### **Paso 2: Usando las formas ER**

```mermaid
graph TD
    A[Panel de formas] --> B[Buscar "ER" o "Entity"]
    B --> C[Arrastrar formas al lienzo]
    C --> D[Conectar con líneas]
    D --> E[Configurar cardinalidad]
```

### **Paso 3: Librerías recomendadas**

1. **Formas básicas:** Para rectángulos (entidades)
2. **General:** Para elipses (atributos)
3. **Arrow:** Para relaciones y cardinalidades
4. **Entity Relationship:** (Si está disponible)

### **Paso 4: Mejores prácticas de diseño**

- ✅ **Alinea** los elementos usando las guías
- ✅ **Agrupa** entidades relacionadas
- ✅ **Usa colores** consistentes (ej: azul para entidades, verde para atributos)
- ✅ **Añade texto descriptivo** en las relaciones
- ✅ **Exporta** como PNG o PDF para compartir

---

## 📚 **Ejemplo Práctico: Sistema Universitario**

### **Requerimientos:**

1. Un **estudiante** puede inscribirse en muchos **cursos**
2. Un **curso** tiene muchos **estudiantes**
3. Cada **curso** es impartido por un **profesor**
4. Un **profesor** puede impartir varios cursos
5. Cada **estudiante** tiene una **matrícula única**
6. Cada **curso** tiene un **código único**

### **📝 Paso a paso en draw.io:**

1. **Crear las entidades:**

   ```
   [Estudiante]    [Curso]    [Profesor]
   ```

2. **Añadir atributos clave:**

   ```
   Estudiante: Matrícula(PK), Nombre, Email
   Curso: Código(PK), Nombre, Créditos
   Profesor: ID(PK), Nombre, Departamento
   ```

3. **Establecer relaciones:**

   ```
   Estudiante >───< Curso        (M:N, "Inscribe")
   Profesor ┼───< Curso          (1:N, "Imparte")
   ```

4. **Especificar cardinalidad:**
   ```
   Estudiante (0,N) ─── (0,N) Curso
   Profesor (1,1) ─── (0,N) Curso
   ```

### **🖼️ Diagrama Resultante:**

```plaintext
┌─────────────────┐       ┌─────────────────┐
│   ESTUDIANTE    │       │     CURSO       │
├─────────────────┤       ├─────────────────┤
│ Matrícula (PK)  │       │ Código (PK)     │
│ Nombre          │       │ Nombre          │
│ Email           │       │ Créditos        │
└────────┬────────┘       └────────┬────────┘
         │                         │
         │       INSCRIBE          │
         │   (Estudiante en Curso) │
         │                         │
         │    (0,N)     │     (0,N)│
         └──────────────┼──────────┘
                        │
                        │ IMPARTE
                        │ (Profesor del Curso)
                        │
                        │ (1,1)     │    (0,N)
                ┌───────┴───────────┘
                │
        ┌───────▼───────┐
        │   PROFESOR    │
        ├───────────────┤
        │ ID (PK)       │
        │ Nombre        │
        │ Departamento  │
        └───────────────┘
```

---

## 🔄 **De Diagrama ER a Esquema Relacional**

### **Reglas de transformación:**

1. **Entidad → Tabla**
2. **Atributo → Columna**
3. **Atributo clave → PRIMARY KEY**
4. **Relación 1:N → FOREIGN KEY en tabla "N"**
5. **Relación M:N → Nueva tabla intermedia**

### **📋 Resultado para nuestro ejemplo:**

```sql
-- Tablas principales
CREATE TABLE Estudiante (
    Matricula VARCHAR(20) PRIMARY KEY,
    Nombre VARCHAR(100),
    Email VARCHAR(100)
);

CREATE TABLE Curso (
    Codigo VARCHAR(10) PRIMARY KEY,
    Nombre VARCHAR(100),
    Creditos INT,
    ID_Profesor INT,
    FOREIGN KEY (ID_Profesor) REFERENCES Profesor(ID)
);

CREATE TABLE Profesor (
    ID INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Departamento VARCHAR(50)
);

-- Tabla intermedia para relación M:N
CREATE TABLE Inscripcion (
    Matricula_Estudiante VARCHAR(20),
    Codigo_Curso VARCHAR(10),
    Fecha_Inscripcion DATE,
    PRIMARY KEY (Matricula_Estudiante, Codigo_Curso),
    FOREIGN KEY (Matricula_Estudiante) REFERENCES Estudiante(Matricula),
    FOREIGN KEY (Codigo_Curso) REFERENCES Curso(Codigo)
);
```

---

## 🧪 **Ejercicio Práctico**

### **Caso: Sistema de Biblioteca**

**Requerimientos:**

1. Los **libros** tienen ISBN, título y autor
2. Los **miembros** tienen ID, nombre y fecha de inscripción
3. Un **miembro** puede pedir prestados muchos **libros**
4. Un **libro** puede ser prestado a muchos **miembros** (en diferentes momentos)
5. Cada **préstamo** registra fecha de préstamo y devolución

### **📝 Tu tarea:**

1. Identifica las entidades y sus atributos
2. Determina las relaciones y cardinalidades
3. Crea el diagrama ER en draw.io
4. Exporta tu diagrama como imagen
5. Convierte el diagrama a esquema SQL

---

## 📖 **Recursos Adicionales**

### **Documentación oficial:**

- [Draw.io Tutorial - Entity Relationship](https://www.drawio.com/doc/blog/entity-relationship-diagrams)
- [Simbología ER estándar](https://en.wikipedia.org/wiki/Entity–relationship_model)

### **Plantillas útiles en draw.io:**

1. File → New from Template → Software → Entity Relationship
2. Format panel → Style → Presets

### **Extensiones recomendadas:**

- **draw.io Integration** para VS Code
- **draw.io Diagrams** para Confluence

---

## ✅ **Checklist de Evaluación**

| Competencia                                    | Sí  | No  | Comentarios |
| ---------------------------------------------- | --- | --- | ----------- |
| Identifica correctamente entidades y atributos | ☐   | ☐   |             |
| Establece relaciones apropiadas                | ☐   | ☐   |             |
| Define correctamente cardinalidades            | ☐   | ☐   |             |
| Usa draw.io eficientemente                     | ☐   | ☐   |             |
| Exporta diagramas en formatos adecuados        | ☐   | ☐   |             |
| Convierte diagrama ER a esquema SQL            | ☐   | ☐   |             |

---

<div align="center">

## 🚀 **Próximo Paso: Normalización de Bases de Datos**

_¡Has completado el módulo de modelado ER! En el siguiente módulo aprenderás a optimizar tus diseños mediante las **formas normales** para eliminar redundancias y anomalías._

📅 **Duración estimada:** 1.5 semanas  
🎯 **Habilidad clave:** Transformar esquemas ER en estructuras normalizadas

**[Continuar con el Módulo 2 →]**

</div>

---

<div align="center">
  
  ### 📞 **¿Necesitas ayuda?**
  - Consulta la [documentación de draw.io](https://www.drawio.com/doc/)
  - Revisa ejemplos en [GitHub de draw.io](https://github.com/jgraph/drawio)
  - Practica con casos reales de tu interés
  
  **💡 Recuerda:** Un buen diseño ER ahorra horas de desarrollo futuro.
</div>
