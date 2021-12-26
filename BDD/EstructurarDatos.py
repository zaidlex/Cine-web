import csv

#Crear listas de los datos que están en las tablas
Clasificaciones = ['A','B','B15','C']
Idiomas = ["Español", "Inglés", "Subtitulado"]
Generos = ["Comedia", "Animación","Suspenso","Acción","Familiar","Aventura","Terror","Drama"]
Dir = "/home/zchx/Documents/BDD/BDDPeliculas/"

with open("PeliculasDatos.csv", newline='') as csvfile, open("PeliculasDatos.sql",'w') as sql:
    datos = csv.reader(csvfile, delimiter=':')
    for row in datos:
        """
        row

        """
        sql.write("BEGIN;\n")
        # tabla pelicula
        sql.write("INSERT INTO  Pelicula (Nombre_Pelicula,Sipnosis,director,Actores,Distribuidora,Duracion,Extreno,finCartelera,IDClasificacion) VALUES(")
        sql.write('"'+row[0]+'",') # Nombre pelicula
        sql.write('"'+row[1]+'",') # Sipnosis
        sql.write('"'+row[2]+'",') # Director
        sql.write('"'+row[3]+'",') # Actores
        sql.write('"'+row[4]+'",') # Distribuidora
        sql.write('"'+row[5]+'",') # Duracion
        sql.write('STR_TO_DATE("'+row[6].replace("/","-")+'", "%d-%m-%Y"),') # Extreno
        sql.write('STR_TO_DATE("'+row[7].replace("/","-")+'", "%d-%m-%Y"),') # Fin cartelera
        sql.write(str(Clasificaciones.index(row[10])+1)) # Clasificacion pelicula ***
        sql.write(");\n")
        # Guarda el id de la pelicula
        sql.write("SELECT LAST_INSERT_ID() INTO @mysql_id_ultima_pelicula;\n")

        # tabla Poster
        sql.write("INSERT INTO  Poster (IDPelicula,Poster) VALUES(@mysql_id_ultima_pelicula,")
        sql.write('"'+Dir+row[8]+'"') # Poster
        sql.write(");\n")

        #tabla Idiomas pelicula
        idiomasPelicula = row[9].split()
        for idioma in idiomasPelicula:
            sql.write("INSERT INTO  IdiomasPelicula (IDPelicula,IDIdioma) VALUES(@mysql_id_ultima_pelicula,")
            sql.write(str(Idiomas.index(idioma)+1)) # Idiomas pelicula
            sql.write(");\n")

        # tabla Generos pelicula
        generosPelicula = row[11].split()
        for genero in generosPelicula:
            sql.write("INSERT INTO  GenerosPeliculas (IDPelicula,IDGenero) VALUES(@mysql_id_ultima_pelicula,")
            #split espacio
            sql.write(str(Generos.index(genero)+1)) # Genero pelicula
            sql.write(");\n")

        #Pares, sala-Horarios hasta terminar la fila
        #desde 12 sala 13 hoario
        # tabla Sala
        for sala in range(12, len(row),2):
            sql.write("INSERT INTO  Sala (Nombre_Sala) VALUES(")
            sql.write('"'+row[sala]+'"') # Nombre sala
            sql.write(");\n")
            sql.write("SELECT LAST_INSERT_ID() INTO @mysql_id_ultima_sala;\n")

            horariosPelicula = row[sala+1].split(",")
            for horario in horariosPelicula:
                sql.write("INSERT INTO  Horario (Hora) VALUES(")
                sql.write('"'+horario+'"') # Genero pelicula
                sql.write(");\n")

                sql.write("SELECT LAST_INSERT_ID() INTO @mysql_id_ultimo_horario;\n")

                sql.write("INSERT INTO  Funcion (IDPelicula, IDSala, IDHorario) VALUES(@mysql_id_ultima_pelicula,@mysql_id_ultima_sala, @mysql_id_ultimo_horario);\n")


        sql.write("COMMIT;\n")

