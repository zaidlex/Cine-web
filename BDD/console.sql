/*para reconocer ñ y acentos*/
ALTER DATABASE Cine DEFAULT CHARACTER SET latin1 COLLATE latin1_spanish_ci;

/*
    Tablas De la base de datos
*/

/*Clasificación de la pellícula*/
CREATE TABLE IF NOT EXISTS ClasificacionPelicula (
    IDClasificacion TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Clasificacion ENUM('A', 'B', 'B15', 'C') NOT NULL,
	Descripcion varchar(255) NOT NULL
);

/* Tabla de la pelicula*/
CREATE TABLE IF NOT EXISTS Pelicula (
	IDPelicula INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	IDClasificacion TINYINT UNSIGNED NOT NULL,
	Nombre_Pelicula varchar(255) NOT NULL,
	Sipnosis TEXT NOT NULL,
	Director varchar(100) NOT NULL,
	Actores TEXT NOT NULL,
	Distribuidora varchar(50) NOT NULL,
	Duracion varchar(15) NOT NULL,
	Extreno DATE NOT NULL, /*dia/mes/año*/
	FinCartelera DATE NOT NULL, /*dia/mes/año*/
    FOREIGN KEY (IDClasificacion)
	    REFERENCES ClasificacionPelicula(IDClasificacion)
);

/*Horario de cada dunción*/
CREATE TABLE IF NOT EXISTS Horario (
    IDHorario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    Hora TIME NOT NULL /*hora:minutos*/
);

/*sala de cada función*/
CREATE TABLE IF NOT EXISTS Sala (
    IDSala INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	Nombre_Sala ENUM('s1', 's2', 's3', 's4', 's5') NOT NULL
);

/*Tabla de las funciones de todas las peliculas*/
CREATE TABLE IF NOT EXISTS Funcion (
    IDFuncion INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    IDPelicula INT UNSIGNED,
    IDSala INT UNSIGNED,
    IDHorario INT UNSIGNED,
    FOREIGN KEY (IDPelicula)
        REFERENCES Pelicula(IDPelicula),
    FOREIGN KEY (IDSala)
	    REFERENCES Sala(IDSala),
    FOREIGN KEY (IDHorario)
	    REFERENCES Horario(IDHorario)
);

/*poster de la película*/
CREATE TABLE IF NOT EXISTS Poster (
	IDPelicula INT UNSIGNED,
	Poster_pel varchar(255) NOT NULL,
	FOREIGN KEY (IDPelicula)
	    REFERENCES Pelicula (IDPelicula)
);

/*sillas de cada sala*/
CREATE TABLE IF NOT EXISTS Silla (
	IDSala INT UNSIGNED,
	Letra ENUM('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K') NOT NULL,
	Numero ENUM('1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11') NOT NULL,
	FOREIGN KEY (IDSala)
	    REFERENCES Sala (IDSala)
);

/*genero de la película*/
CREATE TABLE IF NOT EXISTS Genero (
	IDGenero TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Genero_pel varchar(20) NOT NULL,
	Descripcion varchar(255) NOT NULL
);

/*Relación de los generos con la pelicula*/
CREATE TABLE IF NOT EXISTS GenerosPeliculas(
	IDPelicula INT UNSIGNED,
	IDGenero TINYINT UNSIGNED,
    FOREIGN KEY (IDPelicula)
	    REFERENCES Pelicula (IDPelicula),
    FOREIGN KEY (IDGenero)
	    REFERENCES Genero(IDGenero)
);

/*Idiomas disponibles*/
CREATE TABLE IF NOT EXISTS Idioma (
	IDIdioma TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	Idioma_pel VARCHAR(50) NOT NULL UNIQUE
);

/*Idiomas de la pelicula*/
CREATE TABLE IF NOT EXISTS IdiomasPelicula (
	IDPelicula INT UNSIGNED,
    IDIdioma TINYINT UNSIGNED,
    FOREIGN KEY (IDPelicula)
	    REFERENCES Pelicula (IDPelicula),
    FOREIGN KEY (IDIdioma)
	    REFERENCES Idioma (IDIdioma)
);

/* usuario para conexión de la página y la base de datos*/
DROP USER 'UsrCine'@'localhost';
FLUSH PRIVILEGES;
CREATE USER 'UsrCine'@'localhost' IDENTIFIED BY 'c!n3#8732';
GRANT SELECT ON Cine . * TO 'UsrCine'@'localhost';
/*Sólo se podrá modificar para comprar boleto*/
GRANT INSERT ON Cine . Silla TO 'UsrCine'@'localhost';
FLUSH PRIVILEGES;

SHOW TABLES;
/*
 Datos base.
 Datos que se utilizan al ingresar las películas
 */

# Contenido de los generos
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Comedia','Diseñadas específicamente para provocar la risa o la alegría entre los espectadores.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Animación','Películas que se componen de fotogramas hechos a mano y que, pasados rápidamente uno detrás de otro, producen la ilusión de movimiento o vídeo. Pueden ser hechas a mano (tradicionalmente) o mediante ordenador.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Suspenso','Conocido también como intriga, estas películas se desarrollan rápidamente, y todos sus elementos giran entorno un mismo elemento intrigante.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Acción','En este género prevalecen altas dosis de adrenalina con una buena carga de movimiento, fugas, acrobacias, peleas, guerras, persecuciones y una lucha contra el mal.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Familiar','Películas para toda la familia, en general de contenido "amable" y para todos los públicos.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Aventura','Similares a las de acción, predominan las nuevas experiencias y situaciones.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Terror','Su principal objetivo es causar miedo, horror, incomodidad o preocupación.');
INSERT INTO Genero (Genero_pel,Descripcion) VALUES ('Drama','Los dramas se centran en desarrollar el problema o problemas entre los diferentes protagonistas.');

SELECT *FROM Genero;

# Idiomas
INSERT INTO Idioma (Idioma_pel)VALUES ('Español');
INSERT INTO Idioma (Idioma_pel)VALUES ('Inglés');
INSERT INTO Idioma (Idioma_pel) VALUES ('Subtitulado');

SELECT * FROM Idioma;

# Clasificación
INSERT INTO ClasificacionPelicula (Clasificacion,Descripcion) VALUES('A','Para todo público.');
INSERT INTO ClasificacionPelicula (Clasificacion,Descripcion) VALUES('B','Adolescentes y adultos.');
INSERT INTO ClasificacionPelicula (Clasificacion,Descripcion) VALUES('B15','Adolescentes mayores de 15 años y adultos.');
INSERT INTO ClasificacionPelicula (Clasificacion,Descripcion) VALUES('C','Adultos.');

SELECT * FROM ClasificacionPelicula;

/**** Views ****/

/* view de la cartelera respecto a la fecha actual */
DROP VIEW Cartelera;
CREATE VIEW Cartelera AS
    SELECT pl.IDPelicula, pl.Nombre_Pelicula, p.Poster_pel, pl.Extreno, pl.FinCartelera
        FROM Pelicula AS pl, Poster as p
        WHERE pl.IDPelicula = p.IDPelicula;

SELECT * FROM Cartelera WHERE '2021-12-16' BETWEEN Extreno AND FinCartelera;

/* View para ver la infirmación de la película */
CREATE VIEW PeliculaINFO AS
    SELECT p.Nombre_Pelicula, p.Sipnosis, p.Director, p.Actores, p.Distribuidora, p.Duracion, c.Clasificacion, c.Descripcion, p.IDPelicula
        FROM Pelicula as p, ClasificacionPelicula as c
        WHERE p.IDClasificacion =  c.IDClasificacion;

SELECT * FROM PeliculaINFO WHERE IDPelicula = 3;


/* View para ver el género de la película */
CREATE VIEW PeliculaGENERO AS
    SELECT g.genero_pel, g.Descripcion, gp.IDPelicula
        FROM GenerosPeliculas AS gp, Genero AS g
        WHERE gp.IDGenero = g.IDGenero;

SELECT * FROM PeliculaGENERO WHERE IDPelicula = 3;



/* View para ver sala y horario */
CREATE VIEW PeliculaSH AS
    SELECT S.Nombre_Sala, H.Hora, IDPelicula FROM Funcion F
        INNER JOIN Sala S ON F.IDSala = S.IDSala
        INNER Join Horario H ON F.IDHorario = H.IDHorario;

SELECT * FROM PeliculaSH WHERE IDPelicula = 3;

/* view para obtener la id de la sala*/
CREATE VIEW getIdSala AS
    SELECT s.IDSala, IDPelicula, Nombre_Sala, Hora
        FROM Funcion AS f, Sala AS s, Horario AS h
        #WHERE IDPelicula = 6 AND f.IDSala = s.IDSala AND f.IDHorario=h.IDHorario AND s.Nombre_Sala = 's5' AND h.Hora = TIME('17:00:00')
        WHERE f.IDSala = s.IDSala AND f.IDHorario=h.IDHorario;

/*Obtiene el id de la sala respecto id de la pelicula, nombre de la sala y la hora*/
SELECT * FROM getIdSala WHERE IDPelicula = 6 AND Nombre_Sala = 's5' AND Hora = TIME('17:00:00') LIMIT 1;

/* view para ver las sillas ocupadas */
CREATE VIEW SillasOcupadas AS
    SELECT Letra, Numero, s.IDSala
        FROM Silla AS s, Sala AS sala
        WHERE s.IDSala=sala.IDSala;

/*Consultar sillas de una sala*/
SELECT * FROM SillasOcupadas WHERE IDSala = 12;
/*Consultar todas las sillas*/
SELECT * FROM SillasOcupadas;

/*Eliminar silla deuna sala*/
DELETE FROM Silla WHERE Letra='h' AND Numero='5' AND IDSala=12;

/* insertando siento en la base de datos*/
INSERT INTO Silla (IDSala, Letra, Numero)
    VALUES (12, 'g','5');
