-- =====================================================
-- CREACION BASE DE DATOS
-- =====================================================

IF DB_ID('asiste_plus') IS NULL
CREATE DATABASE asiste_plus;
GO

USE asiste_plus;
GO

DROP TABLE IF EXISTS asistencia;
DROP TABLE IF EXISTS sesion_asistencia;
DROP TABLE IF EXISTS estudiante;
DROP TABLE IF EXISTS curso;
DROP TABLE IF EXISTS acudiente;
DROP TABLE IF EXISTS coordinador;
DROP TABLE IF EXISTS docente;
GO

-- =====================================================
-- CREACION DE TABLAS (DDL)
-- =====================================================

CREATE TABLE docente(
 id_docente INT IDENTITY(1,1) PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 correo VARCHAR(100) NOT NULL UNIQUE,
 telefono VARCHAR(20),
 estado VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE coordinador(
 id_coordinador INT IDENTITY(1,1) PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 correo VARCHAR(100) NOT NULL UNIQUE,
 telefono VARCHAR(20),
 estado VARCHAR(20) DEFAULT 'Activo'
);

CREATE TABLE acudiente(
 id_acudiente INT IDENTITY(1,1) PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 correo VARCHAR(100) UNIQUE,
 telefono VARCHAR(20) NOT NULL
);

CREATE TABLE curso(
 id_curso INT IDENTITY(1,1) PRIMARY KEY,
 nombre_curso VARCHAR(50) NOT NULL UNIQUE,
 jornada VARCHAR(20) DEFAULT 'Mañana',
 id_docente INT NOT NULL,
 FOREIGN KEY(id_docente) REFERENCES docente(id_docente)
);

CREATE TABLE estudiante(
 id_estudiante INT IDENTITY(1,1) PRIMARY KEY,
 nombre VARCHAR(100) NOT NULL,
 documento VARCHAR(20) NOT NULL UNIQUE,
 correo VARCHAR(100) UNIQUE,
 fecha_nacimiento DATE NOT NULL,
 id_curso INT NOT NULL,
 id_acudiente INT NOT NULL,
 estado VARCHAR(20) DEFAULT 'Activo',
 FOREIGN KEY(id_curso) REFERENCES curso(id_curso),
 FOREIGN KEY(id_acudiente) REFERENCES acudiente(id_acudiente)
);

CREATE TABLE sesion_asistencia(
 id_sesion INT IDENTITY(1,1) PRIMARY KEY,
 fecha DATE NOT NULL,
 hora_inicio TIME NOT NULL,
 metodo VARCHAR(20) NOT NULL,
 codigo_qr VARCHAR(100) UNIQUE,
 link_asistencia VARCHAR(255) UNIQUE,
 id_docente INT NOT NULL,
 id_curso INT NOT NULL,
 FOREIGN KEY(id_docente) REFERENCES docente(id_docente),
 FOREIGN KEY(id_curso) REFERENCES curso(id_curso)
);

CREATE TABLE asistencia(
 id_asistencia INT IDENTITY(1,1) PRIMARY KEY,
 fecha_registro DATETIME DEFAULT GETDATE(),
 estado VARCHAR(20) NOT NULL,
 id_estudiante INT NOT NULL,
 id_sesion INT NOT NULL,
 FOREIGN KEY(id_estudiante) REFERENCES estudiante(id_estudiante),
 FOREIGN KEY(id_sesion) REFERENCES sesion_asistencia(id_sesion)
);
GO

-- =====================================================
-- ALTER TABLE
-- =====================================================

ALTER TABLE estudiante
ADD ciudad VARCHAR(50);

ALTER TABLE docente
ADD especialidad VARCHAR(50);
GO

-- =====================================================
-- INSERTS (DML)
-- =====================================================

INSERT INTO docente(nombre,correo,telefono) VALUES
('Carlos Ramirez','carlos@colegio.com','3001111111'),
('Ana Torres','ana@colegio.com','3001111112'),
('Luis Mejia','luis@colegio.com','3001111113'),
('Sandra Lopez','sandra@colegio.com','3001111114'),
('Miguel Rojas','miguel@colegio.com','3001111115'),
('Paola Diaz','paola@colegio.com','3001111116'),
('Jorge Perez','jorge@colegio.com','3001111117'),
('Laura Ruiz','laura@colegio.com','3001111118'),
('Camilo Gil','camilo@colegio.com','3001111119'),
('Natalia Mora','natalia@colegio.com','3001111120');

INSERT INTO coordinador(nombre,correo,telefono) VALUES
('Mario Gomez','mario@colegio.com','3101111111'),
('Andrea Luna','andrea@colegio.com','3101111112'),
('Pedro Arias','pedro@colegio.com','3101111113'),
('Diana Vega','diana@colegio.com','3101111114'),
('Julian Restrepo','julian@colegio.com','3101111115'),
('Monica Castro','monica@colegio.com','3101111116'),
('Sonia Marulanda','sonia@colegio.com','3101111117'),
('Kevin Cano','kevin@colegio.com','3101111118'),
('Daniela Ochoa','daniela@colegio.com','3101111119'),
('Ruben Jaramillo','ruben@colegio.com','3101111120');

INSERT INTO acudiente(nombre,correo,telefono) VALUES
('Marta Diaz','marta@gmail.com','3201111111'),
('Jose Perez','jose@gmail.com','3201111112'),
('Claudia Ruiz','claudia@gmail.com','3201111113'),
('David Mora','david@gmail.com','3201111114'),
('Luisa Toro','luisa@gmail.com','3201111115'),
('Rosa Gil','rosa@gmail.com','3201111116'),
('Javier Cano','javier@gmail.com','3201111117'),
('Angela Mesa','angela@gmail.com','3201111118'),
('Sofia Arango','sofia@gmail.com','3201111119'),
('Felipe Cruz','felipe@gmail.com','3201111120');

INSERT INTO curso(nombre_curso,jornada,id_docente) VALUES
('6A','Mañana',1),
('6B','Mañana',2),
('7A','Tarde',3),
('7B','Tarde',4),
('8A','Mañana',5),
('8B','Mañana',6),
('9A','Tarde',7),
('9B','Tarde',8),
('10A','Mañana',9),
('11A','Mañana',10);

INSERT INTO estudiante(nombre,documento,correo,fecha_nacimiento,id_curso,id_acudiente) VALUES
('Juan Perez','1001','juan@gmail.com','2010-01-10',1,1),
('Maria Lopez','1002','maria@gmail.com','2010-03-15',2,2),
('Pedro Diaz','1003','pedro@gmail.com','2009-05-20',3,3),
('Sara Ruiz','1004','sara@gmail.com','2009-06-10',4,4),
('Daniel Mora','1005','daniel@gmail.com','2008-02-11',5,5),
('Valentina Gil','1006','vale@gmail.com','2008-08-09',6,6),
('Andres Toro','1007','andres@gmail.com','2007-11-21',7,7),
('Camila Cano','1008','camila@gmail.com','2007-09-19',8,8),
('Santiago Mesa','1009','santiago@gmail.com','2006-04-25',9,9),
('Laura Cruz','1010','laura@gmail.com','2006-12-30',10,10);

INSERT INTO sesion_asistencia(fecha,hora_inicio,metodo,codigo_qr,link_asistencia,id_docente,id_curso) VALUES
('2026-04-01','07:00','QR','QR001','link1',1,1),
('2026-04-01','07:10','LINK','QR002','link2',2,2),
('2026-04-02','08:00','QR','QR003','link3',3,3),
('2026-04-02','08:10','LINK','QR004','link4',4,4),
('2026-04-03','09:00','QR','QR005','link5',5,5),
('2026-04-03','09:10','LINK','QR006','link6',6,6),
('2026-04-04','10:00','QR','QR007','link7',7,7),
('2026-04-04','10:10','LINK','QR008','link8',8,8),
('2026-04-05','11:00','QR','QR009','link9',9,9),
('2026-04-05','11:10','LINK','QR010','link10',10,10);

INSERT INTO asistencia(estado,id_estudiante,id_sesion) VALUES
('Asistió',1,1),
('Asistió',2,2),
('Falta',3,3),
('Asistió',4,4),
('Falta',5,5),
('Asistió',6,6),
('Asistió',7,7),
('Falta',8,8),
('Asistió',9,9),
('Asistió',10,10);
GO

-- =====================================================
-- UPDATE
-- =====================================================

UPDATE estudiante
SET ciudad='Medellín'
WHERE id_estudiante IN (1,2,3,4,5);

UPDATE docente
SET especialidad='Matemáticas'
WHERE id_docente=1;

UPDATE docente
SET especialidad='Lenguaje'
WHERE id_docente=2;
GO

-- =====================================================
-- CONSULTAS DE NEGOCIO
-- =====================================================

SELECT c.nombre_curso, COUNT(e.id_estudiante) AS total_estudiantes
FROM curso c
INNER JOIN estudiante e
ON c.id_curso=e.id_curso
GROUP BY c.nombre_curso;

SELECT e.nombre, COUNT(a.id_asistencia) AS asistencias
FROM estudiante e
INNER JOIN asistencia a
ON e.id_estudiante=a.id_estudiante
WHERE a.estado='Asistió'
GROUP BY e.nombre;

SELECT c.nombre_curso, COUNT(e.id_estudiante) cantidad
FROM curso c
INNER JOIN estudiante e
ON c.id_curso=e.id_curso
GROUP BY c.nombre_curso
HAVING COUNT(e.id_estudiante)>=1;

SELECT AVG(total_asistencias*1.0) AS promedio_asistencia
FROM(
 SELECT COUNT(id_asistencia) total_asistencias
 FROM asistencia
 GROUP BY id_estudiante
)X;

SELECT SUM(CASE WHEN estado='Falta' THEN 1 ELSE 0 END) AS total_faltas
FROM asistencia;

SELECT e.nombre, s.fecha
FROM asistencia a
INNER JOIN estudiante e
ON a.id_estudiante=e.id_estudiante
INNER JOIN sesion_asistencia s
ON a.id_sesion=s.id_sesion
WHERE a.estado='Falta'
AND MONTH(s.fecha)=4
AND YEAR(s.fecha)=2026;
GO

-- =====================================================
-- PROCEDIMIENTO 1
-- =====================================================

CREATE PROCEDURE sp_reporte_asistencia
    @id_estudiante INT,
    @total_asistencias INT OUTPUT
AS
BEGIN

    SELECT @total_asistencias = COUNT(a.id_asistencia)
    FROM asistencia a
    WHERE a.id_estudiante = @id_estudiante
    AND a.estado='Asistió';

    SELECT 
        e.nombre,
        COUNT(a.id_asistencia) AS asistencias
    FROM estudiante e
    INNER JOIN asistencia a 
    ON e.id_estudiante = a.id_estudiante
    WHERE e.id_estudiante = @id_estudiante
    AND a.estado='Asistió'
    GROUP BY e.nombre;

END;
GO

-- =====================================================
-- PROCEDIMIENTO 2
-- =====================================================

CREATE PROCEDURE sp_registrar_asistencia
    @estado VARCHAR(20),
    @id_estudiante INT,
    @id_sesion INT,
    @mensaje VARCHAR(100) OUTPUT
AS
BEGIN

    INSERT INTO asistencia(estado,id_estudiante,id_sesion)
    VALUES(@estado,@id_estudiante,@id_sesion);

    SET @mensaje='Asistencia registrada correctamente';

END;
GO

-- =====================================================
-- PROCEDIMIENTO 3
-- =====================================================

CREATE PROCEDURE sp_consultar_faltas
    @id_estudiante INT,
    @total_faltas INT OUTPUT
AS
BEGIN

    SELECT @total_faltas = COUNT(*)
    FROM asistencia
    WHERE id_estudiante = @id_estudiante
    AND estado = 'Falta';

    SELECT 
        e.nombre,
        COUNT(a.id_asistencia) AS faltas
    FROM estudiante e
    INNER JOIN asistencia a
    ON e.id_estudiante = a.id_estudiante
    WHERE e.id_estudiante = @id_estudiante
    AND a.estado='Falta'
    GROUP BY e.nombre;

END;
GO

-- =====================================================
-- PROCEDIMIENTO 4
-- =====================================================

CREATE PROCEDURE sp_crear_sesion
    @fecha DATE,
    @hora_inicio TIME,
    @metodo VARCHAR(20),
    @codigo_qr VARCHAR(100),
    @link_asistencia VARCHAR(255),
    @id_docente INT,
    @id_curso INT,
    @mensaje VARCHAR(100) OUTPUT
AS
BEGIN

    INSERT INTO sesion_asistencia
    (
        fecha,
        hora_inicio,
        metodo,
        codigo_qr,
        link_asistencia,
        id_docente,
        id_curso
    )
    VALUES
    (
        @fecha,
        @hora_inicio,
        @metodo,
        @codigo_qr,
        @link_asistencia,
        @id_docente,
        @id_curso
    );

    SET @mensaje='Sesion creada correctamente';

END;
GO