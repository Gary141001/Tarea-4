Subimos nuestros archivos database a SAS, en especifico el archivo attacking (estadisticas
de ofensiva)*;
%web_drop_table(attacking); /* especificamos la tabla */
FILENAME REFFILE '/home/u62036575/attacking.xlsx'; /asociamos SAS con nuestro archivo/

PROC IMPORT DATAFILE = REFFILE /* importamos el archivo a SAS*/
	DBMS=XLSX /* tipo de datos de nuesto archivo*/
	OUT=attacking; /* tipo de datos de nuesto archivo*/
	GETNAMES=YES;
RUN;

%web_open_table(attacking);

*Subimos nuestros archivos database a SAS, en especifico el archivo attemps (estadisticas
de tiros de gol)*;
%web_drop_table(attempts); /* especificamos la tabla */
FILENAME REFFILE '/home/u62036575/attempts.xlsx'; /* importamos el archivo a SAS*/

PROC IMPORT DATAFILE=REFFILE  /* importamos el archivo a SAS*/
	DBMS=XLSX /* tipo de datos de nuesto archivo*/
	OUT=attempts; /* tipo de datos de nuesto archivo*/
	GETNAMES=YES;
RUN;
%web_open_table(attempts);

*Subimos nuestros archivos database a SAS, en especifico el archivo de goals (estadisticas
de goles*;
%web_drop_table(goals); /* especificamos la tabla */

FILENAME REFFILE '/home/u62036575/goals.xlsx'; /* importamos el archivo a SAS*/

PROC IMPORT DATAFILE=REFFILE /* importamos el archivo a SAS*/
	DBMS=XLSX /* tipo de datos de nuesto archivo*/
	OUT=goals; /* tipo de datos de nuesto archivo*/
	GETNAMES=YES;
RUN;

%web_open_table(goals);

proc contents data=attacking; run; /vemos las propiedades de nuestra tabla attacking/
proc contents data=attempts; run; /vemos las propiedades de nuestra tabla attempts/
proc contents data=goals; run; /vemos las propiedades de nuestra tabla goals/

Vamos a proceder a unir las tablas;

Depuramos la tabla pues cuenta con espacios en blanco pero siguen siendo bastantes;
data players;
   merge attacking (IN=a) attempts (IN=b) goals (IN=c);
   by serial;
run;

*De otra manera tambien depuramos la tabla pues cuenta con espacios en blanco 
y tener menos datos que la anterior*;
data players_1;
   merge attacking (IN=a) attempts (IN=b) goals (IN=c);
   by serial;
   if a or b or c;
run;

Es nuestra tabla depurada y limpia con la menor cantidad de datos en blanco;
data Estadisticas;
   merge attacking (IN=a) attempts (IN=b) goals (IN=c);
   by serial;
   if a or c and b;
run;


proc contents data=estadisticas; run; /* vemos las propiedades de nuestra tabla creada */

/* restringimos los datos para tener una tabla aun mas pequena */
data players_3;
   merge attacking (IN=a) attempts (IN=b) goals (IN=c);
   by serial;
   if a and b and c;
run;

*Creamos una tabla condicional donde nos muestre los jugadores goleadores (mas de 5 goles) *;
data  Estadisticas_Goleadores;
     set Estadisticas(where=(goals>=5));
     run;
     
*Creamos una tabla condicional donde nos muestre los jugadores que más asistencias tienen (mas de 4 asistencias) *;
data  Estadisticas_Asistencias;
     set Estadisticas(where=(assists>=4));
     run;

*Creamos una tabla donde nos muestren los datos de cierto equipo (Barcelona) *;
data  Estadisticas_Barcelona;
     set Estadisticas;
     where club like '%Barcelon%';
     run;
    
*Creamos una tabla donde veamos relacionen al jugador con los goles y su posicion *;
data goals_1(keep=goals  position );
      set Estadisticas;
run;

*Creamos otra tabla donde vemos los jugadores que más juegos tienen, hasta los que menos *;
proc sort data=Estadisticas output = Mas_partidos;
     by descending match_played;
run;

*Procedemos a hacer un analisis de nuestros datos con nuestra tabla donde estan todos nuestros
datos*;
proc univariate data=players; /* indicamos que queremos cono conocer la distribución de nuestra data players */
        var goals; /* identificamos la variable goals(goles)*/
run;

proc univariate data=Estadisticas; /* indicamos que queremos cono conocer la distribución de nuestra data Estadisticas */
        var goals; /* identificamos nuestra variable goals(goles)*/
run;

proc univariate data=Estadisticas; /* indicamos que queremos cono conocer la distribución de nuestra data Estadisticas */
        var penalties; /* ahora identificamos nuestra variable penalties(penales)*/
       
run;

Creamos una tabla;
proc tabulate data=Estadisticas; /* especificamos el conjunto de datos con los que vamos a trabajar*/
       var goals; /* especificamos LA variable de analisis goals*/
       class club position; /* especificamos LAS variables de clasificación*/
       table club, position*goals; /* creamos la estructura de la tabla (concatenamos)*/
run;

Pedimos que de informacion estadisticas de nuesta data;
proc means data=Estadisticas; /* especificamos que queremos trabajar con los datos de Estadisticas*/
        class club position; /* especificamos LAS variables de clasificación club y position*/
         var goals; /* especificamos LA variable de analisis*/
         output out=mean_goals; /* nos arrojara la media de los goles*/
run;

Creamos una tabla;
proc tabulate data=Estadisticas; /* especificamos el conjunto de datos con los que vamos a trabajar*/
       var penalties; /* especificamos LA variable de analisis penalties */
       class club position;  /* especificamos LAS variables de clasificación club y position*/
       table club, position*penalties; /* creamos la estructura de la tabla (concatenamos)*/
run;

proc means data=Estadisticas; /* especificamos que queremos trabajar con los datos de Estadisticas*/
            class club position; /* especificamos LAS variables de clasificación club y position*/
            var penalties; /* especificamos LA variable de analisis penalties */
            output out=mean_penalties; /* nos arrojara la media de los goles por penal*/
run;

Repetimos lo mismo pero con la tabla goals para tener datos limpios y comparar los resultados;
proc univariate data=goals;/* indicamos que queremos cono conocer la distribución de nuestra data goals */
        var goals; /* identificamos nuestra variable goals(goles)*/
run;

proc univariate data=goals;/* indicamos que queremos cono conocer la distribución de nuestra data goals */
        var penalties; /* ahora identificamos nuestra variable penalties(penales)*/
run;

Creamos una tabla;
proc tabulate data=goals; /* especificamos el conjunto de datos con los que vamos a trabajar*/
       var goals; /* especificamos LA variable de analisis goals*/
       class club position; /* especificamos LAS variables de clasificación*/
       table club, position*goals; /* creamos la estructura de la tabla (concatenamos)*/
run;

proc means data=goals;Pedimos que de informacion estadisticas de nuesta data goals;
            class club position;/* especificamos LAS variables de clasificación club y position*/
            var goals; /* especificamos LA variable de analisis goals*/
            output out=mean_goals; /* nos arrojara la media de los goles*/
run;

Creamos una tabla;
proc tabulate data=goals; /* especificamos el conjunto de datos con los que vamos a trabajar*/
       var penalties; /* especificamos LA variable de analisis penalties */
       class club position;/* especificamos LAS variables de clasificación club y position*/
       table club, position*penalties; /* creamos la estructura de la tabla (concatenamos)*/
run;

proc means data=goals; /* especificamos que queremos trabajar con los datos de goals*/
            class club position; /* especificamos LAS variables de clasificación club y position*/
            var penalties; /* especificamos LA variable de analisis penalties */
            output out=mean_penalties; /* nos arrojara la media de los goles por penal*/
run;