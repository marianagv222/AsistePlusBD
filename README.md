# 📚 ASISTE PLUS — Documentación de Base de Datos

---

## 1. Descripción Técnica

| Atributo | Detalle |
|---|---|
| **Motor de base de datos** | Microsoft SQL Server (T-SQL) |
| **Nombre de la BD** | `asiste_plus` |
| **Cantidad de tablas** | 6 tablas principales |
| **Procedimientos almacenados** | 4 stored procedures |
| **Paradigma** | Relacional normalizado |

**ASISTE PLUS** es un sistema de gestión de asistencia escolar. Permite a docentes registrar la asistencia de sus estudiantes por medio de sesiones configurables con código QR o enlace web. Los coordinadores y acudientes pueden hacer seguimiento del comportamiento académico de los estudiantes.

---

## 2. Diccionario de Datos

### 🧑‍🏫 `docente`
Almacena la información del personal docente del colegio.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_docente` | INT | PK, IDENTITY | Identificador único del docente |
| `nombre` | VARCHAR(100) | NOT NULL | Nombre completo |
| `correo` | VARCHAR(100) | NOT NULL, UNIQUE | Correo electrónico institucional |
| `telefono` | VARCHAR(20) | — | Número de contacto |
| `estado` | VARCHAR(20) | DEFAULT 'Activo' | Estado actual del docente |
| `especialidad` | VARCHAR(50) | — | Área de enseñanza (agregado con ALTER TABLE) |

---

### 🗂️ `coordinador`
Almacena la información de los coordinadores académicos.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_coordinador` | INT | PK, IDENTITY | Identificador único del coordinador |
| `nombre` | VARCHAR(100) | NOT NULL | Nombre completo |
| `correo` | VARCHAR(100) | NOT NULL, UNIQUE | Correo electrónico institucional |
| `telefono` | VARCHAR(20) | — | Número de contacto |
| `estado` | VARCHAR(20) | DEFAULT 'Activo' | Estado actual del coordinador |

> ℹ️ El coordinador actualmente no tiene llave foránea hacia otras tablas. Está pensado para una futura integración con reportes o auditoría del sistema.

---

### 👨‍👩‍👦 `acudiente`
Almacena la información del representante legal o familiar del estudiante.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_acudiente` | INT | PK, IDENTITY | Identificador único del acudiente |
| `nombre` | VARCHAR(100) | NOT NULL | Nombre completo |
| `correo` | VARCHAR(100) | UNIQUE | Correo electrónico personal |
| `telefono` | VARCHAR(20) | NOT NULL | Número de contacto obligatorio |

---

### 🏫 `curso`
Representa los grupos académicos del colegio, cada uno asignado a un docente.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_curso` | INT | PK, IDENTITY | Identificador único del curso |
| `nombre_curso` | VARCHAR(50) | NOT NULL, UNIQUE | Nombre del grupo (ej: "6A", "11A") |
| `jornada` | VARCHAR(20) | DEFAULT 'Mañana' | Jornada escolar (Mañana / Tarde) |
| `id_docente` | INT | FK → docente | Docente a cargo del curso |

---

### 🎓 `estudiante`
Almacena los datos personales y académicos de cada estudiante.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_estudiante` | INT | PK, IDENTITY | Identificador único del estudiante |
| `nombre` | VARCHAR(100) | NOT NULL | Nombre completo |
| `documento` | VARCHAR(20) | NOT NULL, UNIQUE | Número de documento de identidad |
| `correo` | VARCHAR(100) | UNIQUE | Correo electrónico |
| `fecha_nacimiento` | DATE | NOT NULL | Fecha de nacimiento |
| `id_curso` | INT | FK → curso | Curso al que pertenece |
| `id_acudiente` | INT | FK → acudiente | Acudiente responsable |
| `estado` | VARCHAR(20) | DEFAULT 'Activo' | Estado de matrícula |
| `ciudad` | VARCHAR(50) | — | Ciudad de residencia (agregado con ALTER TABLE) |

---

### 📋 `sesion_asistencia`
Registra cada sesión de toma de asistencia creada por un docente.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_sesion` | INT | PK, IDENTITY | Identificador único de la sesión |
| `fecha` | DATE | NOT NULL | Fecha de la sesión |
| `hora_inicio` | TIME | NOT NULL | Hora de inicio de la sesión |
| `metodo` | VARCHAR(20) | NOT NULL | Método de registro: 'QR' o 'LINK' |
| `codigo_qr` | VARCHAR(100) | UNIQUE | Código QR generado para la sesión |
| `link_asistencia` | VARCHAR(255) | UNIQUE | URL única de acceso para registrar asistencia |
| `id_docente` | INT | FK → docente | Docente que creó la sesión |
| `id_curso` | INT | FK → curso | Curso al que corresponde la sesión |

---

### ✅ `asistencia`
Registra el estado de asistencia de cada estudiante en cada sesión.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| `id_asistencia` | INT | PK, IDENTITY | Identificador único del registro |
| `fecha_registro` | DATETIME | DEFAULT GETDATE() | Fecha y hora exacta del registro |
| `estado` | VARCHAR(20) | NOT NULL | Estado: 'Asistió' o 'Falta' |
| `id_estudiante` | INT | FK → estudiante | Estudiante evaluado |
| `id_sesion` | INT | FK → sesion_asistencia | Sesión a la que corresponde |

---

## 3. Relaciones entre Submódulos

### Diagrama de relaciones (texto)

```
docente ──────────────┬──── curso ──────── estudiante ──── acudiente
                      │         │
               sesion_asistencia│
                      │         │
                      └─────────┴──── asistencia ──── estudiante
```

---

### Explicación de relaciones

**Docente → Curso:**
Cada curso tiene exactamente un docente asignado como responsable (relación 1 a N). Un docente puede tener a su cargo uno o varios cursos. Esta relación determina quién puede crear sesiones de asistencia para dicho curso.

**Docente → Sesión de Asistencia:**
Cuando un docente inicia una toma de asistencia, se crea un registro en `sesion_asistencia` vinculado tanto al docente que la genera como al curso objetivo. Esto permite auditar quién tomó la asistencia y cuándo, incluso si el docente no es el titular del curso.

**Curso → Estudiante:**
Cada estudiante pertenece a un único curso (relación N a 1). El curso agrupa a los estudiantes por grado y jornada, y es el vínculo central que conecta al docente con su grupo de alumnos.

**Estudiante → Acudiente:**
Cada estudiante tiene un acudiente registrado (relación N a 1). El acudiente es el contacto de emergencia y receptor de notificaciones en caso de inasistencias o novedades académicas.

**Sesión de Asistencia → Asistencia:**
Cada sesión genera múltiples registros individuales en la tabla `asistencia`, uno por estudiante del curso. La sesión define el contexto (fecha, hora, método, curso) y cada registro de asistencia captura si el estudiante asistió o faltó en esa sesión específica.

**Estudiante → Asistencia:**
La tabla `asistencia` cruza al estudiante con la sesión, formando la relación central del sistema. Gracias a esta tabla es posible obtener reportes históricos, calcular porcentajes de asistencia y detectar estudiantes con alta inasistencia.

**Coordinador (independiente):**
La tabla `coordinador` almacena la información del personal directivo, pero actualmente no tiene llaves foráneas hacia otras tablas del esquema. Su rol está pensado para un módulo de consulta de reportes globales o supervisión de múltiples cursos, funcionalidad que puede implementarse en futuras versiones del sistema.

---

### Procedimientos almacenados y su lógica

| Procedimiento | Función |
|---|---|
| `sp_reporte_asistencia` | Consulta el total de asistencias de un estudiante específico y retorna el detalle como resultado |
| `sp_registrar_asistencia` | Inserta un nuevo registro de asistencia para un estudiante en una sesión dada |
| `sp_consultar_faltas` | Calcula el total de faltas de un estudiante y retorna el detalle |


Estos procedimientos encapsulan la lógica de negocio principal del sistema. Las vistas del frontend (si existen) deberían consumirlos en lugar de ejecutar consultas directas, lo que garantiza seguridad, reutilización y consistencia de los datos.

---

### Relación con vistas del frontend



- **Vista de asistencia por curso:** alimentada por la consulta que agrupa estudiantes y cuenta sus asistencias por nombre de curso.
- **Panel de faltas:** usa la consulta de `SUM(CASE WHEN estado='Falta')` para mostrar resúmenes al docente o coordinador.
- **Reporte mensual de faltas:** la consulta filtrada por `MONTH` y `YEAR` sobre `sesion_asistencia` sustenta una vista de historial mensual por estudiante.
- **Formulario de registro de asistencia:** se conecta directamente con `sp_registrar_asistencia` al momento en que el estudiante escanea el QR o accede al link.
- **Módulo de creación de sesión:** invoca `sp_crear_sesion` y genera dinámicamente el código QR y el enlace único para cada clase.

---