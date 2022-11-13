*Primero subimos a SAS datasets que encontramos en internet y para este 
caso tenemos tres archivos .csv que fueron attacking, attemps y goals*;

Data attacking;
INFILE '/home/u62036150/attacking.csv' DSD MISSOVER FIRSTOBS=2;
INPUT serial player_name$ club$ position$ assists corner_taken offsides dribbles match_played;
RUN;

Data attempts;
infile '/home/u62036150/attempts.csv' DSD MISSOVER FIRSTOBS=2;
INPUT serial player_name$ club$	position$ total_attempts on_target off_target blocked match_played;
RUN;

Data goals;
infile '/home/u62036150/goals.csv' DSD MISSOVER FIRSTOBS=2;
INPUT serial player_name$ club$ position$ goals	right_foot left_foot headers others inside_area	outside_areas penalties	match_played;
RUN;

*Juntamos las tres tablas con la llave player_name para que nos muestren las estadisticas de cad jugador*;

PROC SORT DATA=attacking; By player_name; Run;
PROC SORT DATA=attempts; By player_name; Run;
PROC SORT DATA=goals; By player_name; Run;


*llamamos a nuestra tabla grande llamada estadisticas*;
DATA Estadisticas;
MERGE attacking attempts goals;
BY player_name;
RUN;

*Procedemos a ver las propiedades de nuestras tablas*;
proc contents data=attacking; run;

proc contents data=attempts; run;

proc contents data=goals; run;

proc contents data=Estadisticas; run;

*Creamos una tabla condicional donde nos muestre los jugadores goleadores (mas de 5 goles)*;
data  Estadisticas_Goleadores;
     set Estadisticas(where=(goals>=5));
     run;
     
*Creamos una tabla condicional donde nos muestre los jugadores que más asistencias tienen (mas de 4 asistencias)*;
data  Estadisticas_Asistencias;
     set Estadisticas(where=(assists>=4));
     run;

*Creamos una tabla donde nos muestren los datos de cierto equipo (Barcelona)*;
data  Estadisticas_Barcelona;
     set Estadisticas;
     where club like '%Barcelon%';
     run;
    
*Creamos una tabla donde veamos relacionen al jugador con los goles y su posicion *;
data goals(keep=goals  position );
      set Estadisticas;
run;

*Creamos otra tabla donde vemos los jugadores que más juegos tienen, hasta los que menos*;
proc sort data=Estadisticas output=Mas_partidos;
     by descending match_played;
run;