/*
* Author: Prof. Ing. Laura C. Duarte
* Purpose: Creation, alteration and elimination of tables.
* Version: PostgreSQL 11v2
* pgAdmin Versión: 4.4
*/


-- DROP TABLE
-- Elimination from weak to strong tables
----IF EXIST: Prevents the return of an error in case the table does not exist within the database.


DROP TABLE IF EXISTS tipo_pregunta CASCADE;
DROP TABLE IF EXISTS aplicacion_examen CASCADE;
DROP TABLE IF EXISTS pregunta CASCADE;
DROP TABLE IF EXISTS examen CASCADE;
DROP TABLE IF EXISTS asignatura CASCADE;
DROP TABLE IF EXISTS estudiante CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS profesor CASCADE;
DROP TABLE IF EXISTS curso CASCADE;

-- DROP ROLE
DROP ROLE IF EXISTS dba_user;

--
-- TABLE CREATION


-- Creation from strong to weak tables

--
-- Name: curso; Type: TABLE; Schema: public; Owner: postgres
--
CREATE TABLE curso (
cod_cur VARCHAR(5),
nom_cur VARCHAR(50) NOT NULL,
des_cur TEXT, 
CONSTRAINT pk_curso PRIMARY KEY (cod_cur));

--
-- Name: profesor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE profesor (
ide_pro VARCHAR(15),
nom_pro VARCHAR(50) NOT NULL,
ape_pro VARCHAR(50) NOT NULL,
tit_pro VARCHAR(100),
dir_pro VARCHAR(100),
tel_pro VARCHAR(15),
ema_pro VARCHAR(70));

--
-- Name: profesor pk_profesor; Type: PK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Primary Key in Profesor
--

ALTER TABLE profesor
ADD CONSTRAINT pk_profesor PRIMARY KEY (ide_pro);

--
-- Name: alumno; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE alumno (
ide_alu VARCHAR(15),
nom_alu VARCHAR(50) NOT NULL,
ape_alu VARCHAR(50) NOT NULL,
tel_alu VARCHAR(15),
ema_alu VARCHAR(70),
dir_alu VARCHAR(100),
fk_cod_cur VARCHAR(5), --Llave foránea de curso
CONSTRAINT pk_alumno PRIMARY KEY (ide_alu));

--
-- Name: alumno fk_cur_alu; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Course <- Student
--

ALTER TABLE alumno
ADD CONSTRAINT fk_cur_alu FOREIGN KEY (fk_cod_cur) -- Como se llama el campo foráneo en la tabla alumno.
REFERENCES curso(cod_cur) -- Tabla y campo que envian la llave primaria como foránea a alumnp..
ON DELETE RESTRICT ON UPDATE CASCADE; -- Restringir el borrado permitir la actualización en cascada.

--
-- Name: asignatura; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE asignatura (
cod_asi VARCHAR(10),
nom_asi VARCHAR(100) NOT NULL,
dur_asi INT2,
fk_cod_cur VARCHAR(5),
fk_ide_pro VARCHAR(15),
CONSTRAINT pk_asignatura PRIMARY KEY (cod_asi));

--
-- Name: asignatura fk_cur_asi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Course <- Subject
--

ALTER TABLE asignatura
ADD CONSTRAINT fk_cur_asi FOREIGN KEY (fk_cod_cur)
REFERENCES curso(cod_cur)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: asignatura fk_pro_asi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Professor <- Subject
--

ALTER TABLE asignatura
ADD CONSTRAINT fk_pro_asi FOREIGN KEY (fk_ide_pro)
REFERENCES profesor(ide_pro)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: examen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE examen (
cod_exa SERIAL,
fec_exa DATE,
fk_cod_asi VARCHAR(10),
fk_ide_pro VARCHAR(15),
CONSTRAINT pk_examen PRIMARY KEY (cod_exa, fec_exa));

--
-- Name: examen fk_asi_exa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Subject <- Exam
--

ALTER TABLE examen
ADD CONSTRAINT fk_asi_exa FOREIGN KEY (fk_cod_asi)
REFERENCES asignatura(cod_asi)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: examen fk_pro_exa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Professor <- Exam
--

ALTER TABLE examen
ADD CONSTRAINT fk_pro_exa FOREIGN KEY (fk_ide_pro)
REFERENCES profesor(ide_pro)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: pregunta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE pregunta (
cod_pre SERIAL,
enu_pre TEXT,
rta_pre TEXT,
tip_pre VARCHAR(100),
fk_cod_exa INT4,
fk_fec_exa DATE,
CONSTRAINT pk_pregunta PRIMARY KEY (cod_pre));

--
-- Name: pregunta fk_exa_pre; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Exam <- Question
--

ALTER TABLE pregunta
ADD CONSTRAINT fk_exa_pre FOREIGN KEY (fk_cod_exa, fk_fec_exa)
REFERENCES examen(cod_exa, fec_exa)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: aplicacion_examen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE aplicacion_examen (
fk_cod_exa INT4,
fk_ide_alu VARCHAR(15),
fk_fec_exa DATE,
fecha DATE,
asistencia BOOLEAN,
nota DECIMAL(2,1),
CONSTRAINT pk_aplicacion_examen PRIMARY KEY (fk_cod_exa, fk_ide_alu, fecha));

--
-- Name: aplicacion_examen fk_exa_aexn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Exam <- Exam_application
--

ALTER TABLE aplicacion_examen
ADD CONSTRAINT fk_exa_aex FOREIGN KEY (fk_cod_exa, fk_fec_exa)
REFERENCES examen(cod_exa, fec_exa)
ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Name: aplicacion_examen fk_exa_aex; Type: FK CONSTRAINT; Schema: public; Owner: postgres
-- Alteration of the tables - Referential Integrity between Student <- Exam_application
--

ALTER TABLE aplicacion_examen
ADD CONSTRAINT fk_alu_aex FOREIGN KEY (fk_ide_alu)
REFERENCES alumno(ide_alu)
ON DELETE RESTRICT ON UPDATE CASCADE;


--
-- Data for Name: profesor; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO profesor (ide_pro, nom_pro, ape_pro, tit_pro, dir_pro, tel_pro, ema_pro)
VALUES ('1098741236', 'Diego', 'Quintero', 'Ing de Sistemas', 'Cabecera', '63514789', 'correo1@gmail.com');

INSERT INTO profesor (ide_pro, nom_pro, ape_pro, tit_pro, dir_pro, tel_pro, ema_pro)
VALUES ('63147895', 'Sarah', 'Salazar', 'Biólogo', 'Lagos', '6741258', 'correo2@gmail.com');

INSERT INTO profesor (ide_pro, nom_pro, ape_pro, tit_pro, dir_pro, tel_pro, ema_pro)
VALUES ('37852963', 'Sergio', 'Beltrán', 'Licenciado', 'Aurora', '6748596', 'correo3@gmail.com');

INSERT INTO profesor (ide_pro, nom_pro, ape_pro, tit_pro, dir_pro, tel_pro, ema_pro)
VALUES ('98741357', 'Julian', 'Ortiz', 'Quimico', 'Florida', '6857412', 'correo4@gmail.com');

INSERT INTO profesor (ide_pro, nom_pro, ape_pro, tit_pro, dir_pro, tel_pro, ema_pro)
VALUES ('147896321', 'Monica', 'Zambrano', 'Industrial', 'Cañaveral', '6987435', 'correo5@gmail.com');
--
-- Data for Name: curso; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO curso(cod_cur, nom_cur, des_cur)
VALUES ('T001', 'Ofimática', E'Familiarizar al participante con el mundo de la ofimática,\n aportando de una manera rápida y sencilla conocimientos básicos\n sobre el computador y sus componentes. Además,\n empezar a conocer generalidades sobre el sistema\n operativo Windows y el paquete Microsoft office para\n la creación de textos (Word),\n Hojas de cálculo (Excel) y presentaciones con diapositivas (Power Point).');

INSERT INTO curso(cod_cur, nom_cur, des_cur)
VALUES ('T002', 'Fauna & Flora', E'Inventarios de flora y fauna es una práctica muy habitual\n dentro del medio ambiente y la conservación, sin embargo está\n escasamente desarrollada dentro de las formaciones\n regladas y las aplicaciones en campo');

INSERT INTO curso(cod_cur, nom_cur, des_cur)
VALUES ('T003', 'Programáción', 'Conceptos básicos de la programación');
  
INSERT INTO curso(cod_cur, nom_cur, des_cur)
VALUES ('T004', 'Ingles', E'Curso de inglés multimedia gratis nivel iniciación\n con ejercicios de ingles resueltos, gramatica inglesa,\n listening, pronunciacion y fonetica inglesa.');

INSERT INTO curso(cod_cur, nom_cur, des_cur)
VALUES ('T005', 'Quimica', E'1	Etimología\n 2	Definición\n 3	Introducción\n 4	Historia\n 4.1	Química como ciencia\n 4.2	Estructura química\n 5	Principios de la química moderna\n 5.1	Materia\n 5.2	Átomos\n 5.3	Elemento químico\n 5.4	Compuesto químico\n 6	Subdisciplinas de la química\n 7	Los aportes de célebres autores\n 8	Campo de trabajo: el átomo\n9 Conceptos fundamentales\n 9.1	Partículas\n 9.2	De los átomos a las moléculas\n 9.3	Orbitales\n 9.4	De los orbitales a las sustancias\n 9.5	Disoluciones\n 9.6	Medida de la concentración\n 9.7	Acidez\n 9.8	Formulación y nomenclatura\n 10	Véase también\n 11	Referencias\n 11.1	Bibliografía\n 12	Enlaces externos');
--
-- Data for Name: asignatura; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A001', 'WORD 2019', '10', 'T001', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A002', 'POWER POINT 2019', '10', 'T001', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A003', 'EXCEL 2019', '10', 'T001', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A004', 'Quimica Organica', '20', 'T005', '98741357');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A005', 'Quimica Inorganica', '20', 'T005', '98741357');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A006', 'Fauna', '15', 'T002', '63147895');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A007', 'Flora', '15', 'T002', '63147895');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A008', 'Inventarios', '15', 'T002', '63147895');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A009', 'Conceptos Básicos', '10', 'T003', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A010', 'Representación de Algoritmos', '10', 'T003', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A011', 'Estructuras Secuenciales', '10', 'T003', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A012', 'Estructuras Repetitivas', '10', 'T003', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A013', 'Estructuras de Datos', '10', 'T003', '1098741236');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A014', 'Ingles A.1', '10', 'T004', '37852963');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A015', 'Ingles A.2', '10', 'T004', '37852963');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A016', 'Ingles B.1', '10', 'T004', '37852963');

INSERT INTO asignatura( cod_asi, nom_asi, dur_asi, fk_cod_cur, fk_ide_pro)
VALUES ('A017', 'Ingles B.2', '10', 'T004', '37852963');
--
-- Data for Name: alumno; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('78963214', 'Leidy', 'Arciniegas', '6321478', 'correo1@gmail.com', 'Valencia', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('47896321', 'Angela', 'Vecino', '6524178', 'correo2@gmail.com', 'Girón', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('14789632', 'Carolina', 'Villamizar', NULL, 'correo3@gmail.com', 'Mutis', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('21478963', 'Krisma', 'Montero', '6985214', 'corre4o@gmail.com', 'Real de Minas', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('32147896', 'Sally', 'Castillo', '6741258', 'correo@gmail.com', NULL, 'T005');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('17896321', 'Arturo', 'Parada', '6421478', 'correo51@gmail.com', 'Flora', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('24789632', 'Blanca', 'Parra', '6424178', 'correo26@gmail.com', 'Cumbre', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('31478963', 'Rocio', 'Perez', NULL, 'correo37@gmail.com', 'Valencia', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('42147896', 'Carlos', 'Ardila', '6485214', 'correo48@gmail.com', 'Lagos', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('53214789', 'Diego', 'Rincon', '6441258', 'correo95@gmail.com', NULL, 'T005');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('67896321', 'Alejandro', 'Alvarez', '6421478', 'correo106@gmail.com', 'Rincon de los Caballeros', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('74789632', 'Fernando', 'Lopez', '6624178', 'correo117@gmail.com', 'Piedecuesta', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('81478963', 'Edilma', 'Hurtado', NULL, 'correo812@gmail.com', 'Mutis', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('92147896', 'Hector', 'Gomez', '6385214', 'correo913@gmail.com', 'Real de Minas', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('13214789', 'Ivan', 'Meza', '6441258', 'correo140@gmail.com', NULL, 'T005');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('71963214', 'Maria de Jesus', 'Neira', '6311478', 'correo15@gmail.com', 'Provenza', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('42896321', 'Nancy', 'Ocampo', '6524178', 'correo162@gmail.com', 'Altos del Cacique', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('13789632', 'Oscar', 'Aguirre', NULL, 'correo17@gmail.com', 'La floresta', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('24478963', 'Ramon', 'Hurtado', '6945214', 'correo184@gmail.com', 'El prado', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('35147896', 'Rocio', 'Marin', '6761258', 'correo195@gmail.com', NULL, 'T005');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('16896321', 'Olga', 'Reyes', '6441478', 'correo2016@gmail.com', 'Cabecera del Llano', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('27789632', 'Francisco', 'Bermudez', '6464178', 'correo2127@gmail.com', 'Santa Ana', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('38478963', 'Guillermo', 'Rios', NULL, 'correo3228@gmail.com', 'Villabel', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('49147896', 'Cesar', 'Bonilla', '6475214', 'correo4239@gmail.com', 'Bucarica', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('51214789', 'Salome', 'Guerrero', '6481258', 'correo2451@gmail.com', NULL, 'T005');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur)
VALUES ('62896321', 'William', 'Espinoza', '6491478', 'correo6252@gmail.com', 'Caldas', 'T001');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('73789632', 'Ronaldo', 'Alzate', '6614178', 'correo7263@gmail.com', 'Reposo', 'T002');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('84478963', 'Joan', 'Quintero', NULL, 'correo2784@gmail.com', 'Florida', 'T003');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('95147896', 'Isabela', 'Palacios', '6325214', 'correo2895@gmail.com', 'Valencia', 'T004');

INSERT INTO alumno(ide_alu, nom_alu, ape_alu, tel_alu, ema_alu, dir_alu, fk_cod_cur) 
VALUES ('16214789', 'Jesus', 'Shachez', '6431258', 'correo2916@gmail.com', NULL, 'T005');
--
-- Data for Name: examen; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-23', 'A001', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-24', 'A002', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-25', 'A003', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-26', 'A004', '98741357');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-27', 'A005', '98741357');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-28', 'A006', '63147895');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-29', 'A007', '63147895');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-30', 'A008', '63147895');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-08-31', 'A009', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-01', 'A010', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-02', 'A011', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-03', 'A012', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-04', 'A013', '1098741236');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-05', 'A014', '37852963');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-06', 'A015', '37852963');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-07', 'A016', '37852963');

INSERT INTO examen(fec_exa, fk_cod_asi, fk_ide_pro)
VALUES ( '2019-09-08', 'A017', '37852963');
--
-- Data for Name: aplicacion_examen; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '53214789', '2019-08-27', '2019-09-25', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '13214789', '2019-08-26', '2019-09-24', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '13214789', '2019-08-27', '2019-09-25', true, 4.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '35147896', '2019-08-26', '2019-09-24', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '35147896', '2019-08-27', '2019-09-25', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '51214789', '2019-08-26', '2019-09-24', true, 2.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '51214789', '2019-08-27', '2019-09-25', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '16214789', '2019-08-26', '2019-09-24', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '16214789', '2019-08-27', '2019-09-25', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '16896321', '2019-08-23', '2019-09-09', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '16896321', '2019-08-24', '2019-09-10', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '16896321', '2019-08-25', '2019-09-11', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '62896321', '2019-08-23', '2019-09-09', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '62896321', '2019-08-24', '2019-09-10', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '62896321', '2019-08-25', '2019-09-11', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '47896321', '2019-08-28', '2019-09-12', true, 4.6);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '47896321', '2019-08-29', '2019-09-13', true, 3.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '47896321', '2019-08-30', '2019-09-14', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '24789632', '2019-08-28', '2019-09-12', true, 2.1);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '24789632', '2019-08-29', '2019-09-13', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '24789632', '2019-08-30', '2019-09-14', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '74789632', '2019-08-28', '2019-09-12', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '74789632', '2019-08-29', '2019-09-13', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '74789632', '2019-08-30', '2019-09-14', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '42896321', '2019-08-28', '2019-09-12', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '42896321', '2019-08-29', '2019-09-13', true, 4.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '42896321', '2019-08-30', '2019-09-14', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '78963214', '2019-08-23', '2019-09-09', true, 3.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '78963214', '2019-08-24', '2019-09-10', true, 3.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '78963214', '2019-08-25', '2019-09-11', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '17896321', '2019-08-23', '2019-09-09', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '17896321', '2019-08-24', '2019-09-10', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '17896321', '2019-08-25', '2019-09-11', true, 4.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '67896321', '2019-08-23', '2019-09-09', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '67896321', '2019-08-24', '2019-09-10', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '67896321', '2019-08-25', '2019-09-11', true, 2.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (1, '71963214', '2019-08-23', '2019-09-09', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (2, '71963214', '2019-08-24', '2019-09-10', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (3, '71963214', '2019-08-25', '2019-09-11', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '27789632', '2019-08-28', '2019-09-12', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '27789632', '2019-08-29', '2019-09-13', true, 3.9);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '27789632', '2019-08-30', '2019-09-14', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (6, '73789632', '2019-08-28', '2019-09-12', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (7, '73789632', '2019-08-29', '2019-09-13', true, 4.3);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (8, '73789632', '2019-08-30', '2019-09-14', true, 4.4);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '14789632', '2019-08-31', '2019-09-15', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '14789632', '2019-09-01', '2019-09-16', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '14789632', '2019-09-02', '2019-09-17', true, 2.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '14789632', '2019-09-03', '2019-09-18', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '14789632', '2019-09-04', '2019-09-19', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '31478963', '2019-08-31', '2019-09-15', true, 4.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '31478963', '2019-09-01', '2019-09-16', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '31478963', '2019-09-02', '2019-09-17', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '31478963', '2019-09-03', '2019-09-18', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '31478963', '2019-09-04', '2019-09-19', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '81478963', '2019-08-31', '2019-09-15', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '81478963', '2019-09-01', '2019-09-16', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '81478963', '2019-09-02', '2019-09-17', true, 4.6);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '81478963', '2019-09-03', '2019-09-18', true, 3.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '81478963', '2019-09-04', '2019-09-19', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '13789632', '2019-08-31', '2019-09-15', true, 2.1);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '13789632', '2019-09-01', '2019-09-16', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '13789632', '2019-09-02', '2019-09-17', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '13789632', '2019-09-03', '2019-09-18', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '13789632', '2019-09-04', '2019-09-19', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '38478963', '2019-08-31', '2019-09-15', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '38478963', '2019-09-01', '2019-09-16', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '38478963', '2019-09-02', '2019-09-17', true, 4.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '38478963', '2019-09-03', '2019-09-18', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '38478963', '2019-09-04', '2019-09-19', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (9, '84478963', '2019-08-31', '2019-09-15', true, 3.9);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (10, '84478963', '2019-09-01', '2019-09-16', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (11, '84478963', '2019-09-02', '2019-09-17', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (12, '84478963', '2019-09-03', '2019-09-18', true, 4.3);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (13, '84478963', '2019-09-04', '2019-09-19', true, 4.4);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '21478963', '2019-09-05', '2019-09-20', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '21478963', '2019-09-06', '2019-09-21', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '21478963', '2019-09-07', '2019-09-22', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '21478963', '2019-09-08', '2019-09-23', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '42147896', '2019-09-05', '2019-09-20', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '42147896', '2019-09-06', '2019-09-21', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '42147896', '2019-09-07', '2019-09-22', true, 4.6);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '42147896', '2019-09-08', '2019-09-23', true, 3.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '92147896', '2019-09-05', '2019-09-20', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '92147896', '2019-09-06', '2019-09-21', true, 2.1);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '92147896', '2019-09-07', '2019-09-22', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '92147896', '2019-09-08', '2019-09-23', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '24478963', '2019-09-05', '2019-09-20', true, 3.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '24478963', '2019-09-06', '2019-09-21', true, 4.7);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '24478963', '2019-09-07', '2019-09-22', true, 5.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '24478963', '2019-09-08', '2019-09-23', true, 3.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '49147896', '2019-09-05', '2019-09-20', true, 4.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '49147896', '2019-09-06', '2019-09-21', true, 3.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '49147896', '2019-09-07', '2019-09-22', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '49147896', '2019-09-08', '2019-09-23', true, 3.9);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (14, '95147896', '2019-09-05', '2019-09-20', true, 4.8);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (15, '95147896', '2019-09-06', '2019-09-21', false, 0.0);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (16, '95147896', '2019-09-07', '2019-09-22', true, 4.3);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (17, '95147896', '2019-09-08', '2019-09-23', true, 4.4);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '32147896', '2019-08-26', '2019-09-24', true, 3.2);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (5, '32147896', '2019-08-27', '2019-09-25', true, 3.5);

INSERT INTO aplicacion_examen (fk_cod_exa, fk_ide_alu, fk_fec_exa, fecha, asistencia, nota) 
VALUES (4, '53214789', '2019-08-26', '2019-09-24', false, 0.0);
--
-- Data for Name: pregunta; Type: TABLE DATA; Schema: public; Owner: postgres
--
INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ('¿Qué es Microsoft Word?' , 'Procesador de Texto' , 'A' , 1 , '23/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es Microsoft Power Point?' , 'Presentación de diapositivas' , 'A' , 2 , '24/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es Microsoft Excel?' , 'Hoja de calculo' , 'A' , 3 , '25/08/2019' );
		
INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Quimica Organica?' , E'Rama de la química que estudia una numerosa clase de\n moléculas que contienen carbono, formando enlaces\n covalentes carbono-carbono y carbono-hidrógeno,\n también conocidos como compuestos orgánicos' , 'A' , 4 , '26/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Quimica Inorganica?' , E'Ciencia que estudia la composición y las propiedades\n de la materia y de las transformaciones que\n esta experimenta sin que se alteren\n los elementos que la forman.' , 'A' , 5 , '27/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Fauna?' , E'Conjunto de todas las especies animales,\n generalmente con referencia a un lugar, clima,\n tipo, medio o período geológico concretos.' , 'A' , 6 , '28/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué son las Estructuras Secuenciales?' , E'Es aquella en la que una acción (instrucción) sigue a\n otra en secuencia. Las tareas se suceden de tal\n modo que la salida de una es la entrada de la\n siguiente y así sucesivamente hasta\n el fin del proceso.' , 'A' , 11 , '2/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué son las Estructuras Repetitivas?' , E'Se utilizan cuando se quiere que un conjunto\n de instrucciones  se ejecuten un cierto número\n finito de veces, por ejemplo, escribir algo en\n pantalla cierta cantidad de veces, mover un objeto\n de un punto a otro cierta cantidad de pasos, o\n hacer una operación matemática cierta cantidad de veces.' , 'A' , 12 , '3/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué son las Estructuras De Datos?' , E'Las estructuras de datos es una rama de las ciencias\n de la computación que estudia y aplica diferentes\n formas de organizar información dentro de una\n aplicación, para manipular, buscar e insertar\n  estos datos de manera eficiente.' , 'A' , 13 , '4/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( E'Write the correct answer.\nThere aren’t ______ for everybody?' , 'enough chairs' , 'B' , 14 , '5/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Flora?' , E'Conjunto de plantas de una zona o de un\n período geológico determinado.' , 'A' , 7 , '29/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Inventarios?' , E'Lista ordenada de fauna y flora además cosas\n valorables que pertenecen a un ecosistema.' , 'A' , 8 , '30/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  programación' , E'Es el arte de hacer que una computadora haga\n lo que nosotros querramos. En el nivel más simple\n consiste en ingresar en la computadora una secuencia\n de órdenes para lograr un cierto objetivo.' , 'A' , 9 , '31/08/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( '¿Qué es  Representación De Algoritmos?' , E'Una vez que se ha elegido la mejor alternativa para\n solucionar el problema o reto para el que se crea\n el algoritmo es el momento de representarlo\n siguiendo alguno de estos métodos: \n2Lenguaje natural (español, inglés, etc.) Diagramas de flujo' , 'A' , 10 , '1/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( E'Choose the correct option.\n1) It will been very nice this evening.\n 2) It has been very nice this evening.\n 3) It was been very nice this evening.' , 'It has been very nice this evening' , 'A' , 15 , '6/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( E'Choose the correct option. \n 1) I am usually having some coffee and toast for my breakfast. \n 2) I am used to have some coffee and toast for my breakfast. \n23) I usually have some coffee and toast for my breakfast' , 'I usually have some coffee and toast for my breakfast' , 'A' , 16 , '7/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( E'Choose the correct option.\n 1) What do you think we’ll be doing in five years’ time?.\n 2) What do you think you’re doing in five years’ time?. \n 3) What do you think we do in five year’s time?.' , 'What do you think we’ll be doing in five years’ time?' , 'A' , 17 , '8/09/2019' );

INSERT INTO pregunta (enu_pre, rta_pre, tip_pre, fk_cod_exa, fk_fec_exa)
VALUES ( E'Choose the correct option.\n 1) \n 2) \n 3)' , ' ' , 'A' , NULL , NULL );



CREATE ROLE dba_user
WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'posuts';

ALTER TABLE aplicacion_examen OWNER TO dba_user;
ALTER TABLE pregunta OWNER TO dba_user;
ALTER TABLE examen OWNER TO dba_user;
ALTER TABLE asignatura OWNER TO dba_user;
ALTER TABLE alumno OWNER TO dba_user;
ALTER TABLE profesor OWNER TO dba_user;
ALTER TABLE curso OWNER TO dba_user;

ALTER TABLE aplicacion_examen ADD COLUMN com_apl TEXT;
ALTER TABLE aplicacion_examen ADD COLUMN des_asistencia CHAR;
ALTER TABLE aplicacion_examen ADD COLUMN num_apl SERIAL8;
ALTER TABLE examen ADD COLUMN nom_exa VARCHAR(50);
ALTER TABLE examen ADD COLUMN des_exa TEXT;
ALTER TABLE examen ADD COLUMN est_exa VARCHAR(8);
ALTER TABLE examen ADD COLUMN ver_exa NUMERIC(2,1);
ALTER TABLE examen ADD COLUMN fac_exa DATE;

ALTER TABLE aplicacion_examen RENAME COLUMN fecha TO fec_apl;
ALTER TABLE aplicacion_examen RENAME COLUMN asistencia TO asi_apl;
ALTER TABLE aplicacion_examen RENAME COLUMN nota TO nta_apl;
ALTER TABLE alumno RENAME TO estudiante;

ALTER TABLE examen 
ADD CONSTRAINT ckest_exa CHECK (est_exa IN ('Borrador', 'Activo', 'Inactivo'));

ALTER TABLE examen ALTER COLUMN fec_exa SET DEFAULT CURRENT_DATE;
ALTER TABLE aplicacion_examen ALTER COLUMN fec_apl SET DEFAULT CURRENT_DATE;

CREATE TABLE tipo_pregunta (
cod_tpr VARCHAR(4),
nom_tpr VARCHAR(100),
des_tpr TEXT,
car_tpr TEXT,
ejm_tpr TEXT,
CONSTRAINT pktipo_pregunta PRIMARY KEY (cod_tpr));

INSERT INTO tipo_pregunta
VALUES ('A', 'Respuesta larga', 
		'El tipo de pregunta de "Respuesta Larga" sólo debe usarse para ejercicios cuya respuesta sea larga (más tres palabras) y subjetiva.',
		NULL,
		'¿Qué es la sabiduría?.');

INSERT INTO tipo_pregunta
VALUES ('B', 'Preguntas de rellenar el espacio en blanco', 
		'Una pregunta para rellenar el espacio en blanco es una frase, una oración o un párrafo con un espacio en blanco en el cual el estudiante debe escribir la palabra o las palabras que faltan. También puede crear una pregunta con varios espacios en blanco.',
		NULL, 
		NULL);

INSERT INTO tipo_pregunta
VALUES ('C', 'Respuesta corta', 
		'El tipo de pregunta de "Respuesta corta" sólo debe usarse para ejercicios cuya respuesta sea corta (no más de dos o tres palabras) e inequívoca.',
		NULL,
		' ¿Quién descubrió América?, el alumno/a podría dar las siguientes respuestas, todas correctas: Colón. Cristóbal Colón. Fue Cristóbal Colón. La descubrió Cristóbal Colón.');

INSERT INTO tipo_pregunta
VALUES ('D', 'Selección multiple con única respuesta', 
		'La pregunta de opción múltiple, de selección múltiple o multiopción es una forma de evaluación por la cual se solicita a los encuestados o examinados seleccionar una o varias de las opciones de una lista de respuestas, este tipo de pregunta es usado en evaluaciones educativas (en lo que popularmente se llaman exámenes tipo test1), en elecciones (para escoger entre múltiples candidatos o partidos políticos diferentes), en los cuestionarios para estudios de mercado, encuestas, estadística y muchas otras áreas.', 
		'Cada opción debe poderse leer directamente a continuación del enunciado. Proponer opciones mutuamente exclusivas u obvias. Incluir opciones que engloben otras opciones. Debe evitarse formular opciones globalizadoras porque supone dar pistas al examinando.',
		'En el texto, con la expresión “...no es preciso demostrar que la novela policial es popular...” se quiere decir que A. es inútil prestarle atención a un género menor. B. por ser un producto de la “cultura de masas” es muy difundida. C. su popularidad es tan evidente que no requiere demostración. D. su popularidad se debe a la “manipulación del gusto”.');

INSERT INTO tipo_pregunta
VALUES ('E', 'Selección multiple con única respuesta', 
		'La pregunta de opción múltiple, de selección múltiple o multiopción es una forma de evaluación por la cual se solicita a los encuestados o examinados seleccionar una o varias de las opciones de una lista de respuestas, este tipo de pregunta es usado en evaluaciones educativas (en lo que popularmente se llaman exámenes tipo test1), en elecciones (para escoger entre múltiples candidatos o partidos políticos diferentes), en los cuestionarios para estudios de mercado, encuestas, estadística y muchas otras áreas.', 
		'Cada opción debe poderse leer directamente a continuación del enunciado. Proponer opciones mutuamente exclusivas u obvias. Incluir opciones que engloben otras opciones. Debe evitarse formular opciones globalizadoras porque supone dar pistas al examinando.',
		'En el texto, con la expresión “...no es preciso demostrar que la novela policial es popular...” se quiere decir que A. es inútil prestarle atención a un género menor. B. por ser un producto de la “cultura de masas” es muy difundida. C. su popularidad es tan evidente que no requiere demostración. D. su popularidad se debe a la “manipulación del gusto”.');

INSERT INTO tipo_pregunta
VALUES ('F', 'Selección multiple con multiple respuesta', 
		'Este tipo de preguntas consta de un enunciado y cuatro opciones de respuesta (1,2,3,4). Sólo dos de esas opciones responden correctamente a la pregunta.', 
		'El estudiante debe responder este tipo de preguntas en su hoja de respuestas de acuerdo con el siguiente cuadro: Si 1 y 2 son correctas, rellene el óvalo (A) Si 2 y 3 son correctas, rellene el óvalo (B) Si 3 y 4 son correctas, rellene el óvalo (C) Si 2 y 4 son correctas, rellene el óvalo (D) Si 1 y 3 son correctas, rellene el óvalo (E)',
		'Para que un grupo de estudiantes de un colegio elabore un estudio ambiental, con el fin de mejorar las condiciones del establecimiento y su entorno, es recomendable promover actividades científicas y eventos culturales con otras ciudades. recuperar las áreas recreativas y la infraestructura del establecimiento. apropiarse de los espacios públicos dentro y fuera del establecimiento. elaborar estudios técnicos sobre la valorización del suelo en la zona.');


ALTER TABLE pregunta ALTER COLUMN tip_pre TYPE VARCHAR(4);

ALTER TABLE aplicacion_examen ALTER COLUMN des_asistencia TYPE VARCHAR(10);

ALTER TABLE pregunta RENAME COLUMN tip_pre TO cod_tpr;

ALTER TABLE pregunta 
ADD CONSTRAINT fktippre_pre FOREIGN KEY (cod_tpr)
REFERENCES tipo_pregunta(cod_tpr)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE examen 
DROP COLUMN nom_exa;

ALTER TABLE estudiante
ADD CONSTRAINT uqema_alu UNIQUE (ema_alu);

ALTER TABLE profesor
ADD CONSTRAINT uqema_pro UNIQUE (ema_pro);

ALTER TABLE aplicacion_examen ALTER COLUMN asi_apl SET NOT NULL;

ALTER TABLE aplicacion_examen ALTER COLUMN nta_apl DROP NOT NULL;

ALTER TABLE examen ALTER COLUMN fec_exa DROP DEFAULT;

ALTER TABLE aplicacion_examen DROP CONSTRAINT pk_aplicacion_examen;

ALTER TABLE aplicacion_examen ADD CONSTRAINT pkaplicacion_examen PRIMARY KEY (num_apl);

ALTER TABLE aplicacion_examen 
ADD CONSTRAINT cknta_apl CHECK (nta_apl BETWEEN 0.0 AND 5.0);

ALTER TABLE aplicacion_examen
ADD CONSTRAINT ckasi_apl CHECK (des_asistencia IN ('Si', 'No', 'Tarde', 'Excusa'));

