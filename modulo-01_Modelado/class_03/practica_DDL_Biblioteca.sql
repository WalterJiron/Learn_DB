CREATE DATABASE Biblioteca; -- Crea la base de datos

GO

USE Biblioteca; -- Selecciona la base de datos

GO

CREATE TABLE Libro(
    ISBN NVARCHAR(20) PRIMARY KEY NOT NULL,
    Titulo NVARCHAR(200) NOT NULL,
    Autor NVARCHAR(100) NOT NULL,
    Anio_Publicacion INT CHECK (Anio_Publicacion > 0) NOT NULL,
    DateCreate DATETIME DEFAULT GETDATE(),
    DateUpdate DATETIME,
    DateDelete DATETIME,
    EstadoLibro BIT DEFAULT 1
);

GO

CREATE TABLE Miembro(
    ID_Miembro INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Fecha_Inscripcion DATE NOT NULL DEFAULT GETDATE(),
    DateCreate DATETIME DEFAULT GETDATE(),
    DateUpdate DATETIME,
    DateDelete DATETIME,
    EstadoMiembro BIT DEFAULT 1
);

GO

CREATE TABLE Prestamo(
    ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ID_Miembro INT FOREIGN KEY REFERENCES Miembro(ID_Miembro) NOT NULL,
    ISBN NVARCHAR(20) FOREIGN KEY REFERENCES Libro(ISBN) NOT NULL,
    Fecha_Prestamo DATE NOT NULL DEFAULT GETDATE(),
    Fecha_Devolucion DATE,   -- Se llena cuando el miembro devuelve el libro
    Estado NVARCHAR(20) DEFAULT 'Activo'
           CHECK (Estado IN ('Activo', 'Devuelto', 'Vencido')) NOT NULL,
    DateCreate DATETIME DEFAULT GETDATE(),
    DateUpdate DATETIME,
    DateDelete DATETIME,
    EstadoPrestamo BIT DEFAULT 1
);