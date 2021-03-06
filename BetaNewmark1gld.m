disp ( ' ' )
disp ( ' ' )
disp ( '........................................................UNIVERSIDAD AUTÓNOMA DE NUEVO LEÓN........................................................' )
disp ( ' ' )
disp ( ' ' )
disp ( ' ----------------------------------------------------------FACULTAD DE INGENIERÍA CIVIL-----------------------------------------------------------' )
disp ( ' ' )
disp ( ' ----------------------------------------------------------INSTITUTO DE INGENIERÍA CIVIL----------------------------------------------------------' )
disp ( ' ' )
disp ( ' ' )
disp ( 'INICIO DEL PROGRAMA ----------------------------------------------------------------------------------------------------------------------------- ' )
disp ( '---------------------------------------------BETA DE NEWMARK EN UN GRADO DE LIBERTAD DINÁMICO-----------------------------------------------------' )
disp ( ' ' )
disp ( 'Se Borrará la Ventana de Trabajo y las Variables' )
disp ( 'Precione Cualquier Tecla Para Continuar' )
disp ( ' ' )
disp ( ' ' )

pause
clc 
clear

% PROGRAMA BETA DE NEWMARK 1.
%
% Nombre del Programa: BETA DE NEWMARK UN GRADO DE LIBERTADA DINÁMICA.
% Descripcion: Calcula a través del algorítmo de Beta de Newmark los
% vectores de comportamiento en desplazamientos, velocidad y aceleración
% para un sistema de un grado de libertad dinámica.
% Realizado por: ING. EDWIN M. R. MARTÍNEZ.
% Fecha: 7 de octubre del 2012.

%%

% NOTAS DEL PROCEDIMIENTO PARA EL USO DEL PROGRAMA:
%
% 1) Verificar que los datos en el archivo de Excel se encuentran en el
% siguiente formato por columnas y que el resto de las casillas se encuentren libres 
%(unicamente los valores de los datos deberán estar en la hoja, sin identificadores):
%
%PRIMERA FILA: MASA/RIGIDEZ/FRACCIÓN DE AMORTIGUAMIENTO CRÍTICO/BETA PROPUESTA/DELTA t/Xo/X´o/X´´o
%
%SEGUNDA FILA: VECTOR DEL NÚMERO DE DATOS DE FUERZA EXCITADORA//TIEMPO (ti+DELTA t)/FUERZA EXCITADORA
%
% 2) Verificar que el vector de datos este determinado de 1 a N por números enteros.
%
% 3) Cambiar el nombre del archivo 'datos1gld.xls'por el nombre del archivo con igual extensión.
%
% 4) Cambiar el nombre de la hoja 'Hoja' por el nombre de la estación de origen de los datos 'estacion1' (por ejemplo).
%
% AMBOS CAMBIOS PUEDEN REALIZARSE PRESIONANDO SELECCIONANDO EL
% ESCRITO DEL RENGLÓN SUPERIOR Y PRECIONANDO CONTROL+F PARA
% REMPLAZAR EL NOMBRE POR EL NECESARIO EN TODO EL PROGRAMA.
%
% 5) Iniciar el programa y verificar resultados.
%%

Masa1 = xlsread ( 'Datos.xls' , 'GLD1' , 'A1' ) ; % Lectura de la masa del sitema.
Rigidez1 = xlsread ( 'Datos.xls' , 'GLD1' , 'B1' ) ; % Lectura de la rigidez del sistema.
Xi1 = xlsread ( 'Datos.xls' , 'GLD1' , 'C1' ) ; % Lectura de la fracción de amortiguamiento crítico.
Beta1 = xlsread ( 'Datos.xls' , 'GLD1' , 'D1' ) ; % Lectura de la beta propuesta.
Deltat1 = xlsread ( 'Datos.xls' , 'GLD1' , 'E1' ) ; % Lectura del valor de delta t.
Desplazamientoi1 = xlsread ( 'Datos.xls' , 'GLD1' , 'F1' ) ; % Lectura del desplazamiento inicial.
Velocidadi1 = xlsread ( 'Datos.xls' , 'GLD1' , 'G1' ) ; % Lectura de la velocidad inicial.
Aceleracioni1 = xlsread ( 'Datos.xls' , 'GLD1' , 'H1' ) ; % Lectura de la aceleración inicial.
Datos = xlsread ( 'Datos.xls' , 'GLD1' , 'A5:A10005' ) ; % Lectura del vector de número de datos. ¡CONSIDERE MODIFICAR EN ALGÚN CASO NECESARIO YA QUE SÓLO SE CUENTAN 10000 VALORES!
Tiempo = xlsread ( 'Datos.xls' , 'GLD1' , 'B5:B10005' ) ; % Lectura del comportamiento de la fuerza externa.
Fexterna = xlsread ( 'Datos.xls' , 'GLD1' , 'C5:C10005' ) ; % Lectura del comportamiento de la fuerza externa.

 % Determinación de los valores de las variables respecto a los vectores
 % leidos en la etapa anterior.
Masa = Masa1 ( 1 ) ;
Rigidez = Rigidez1 ( 1 ) ;
Xi = Xi1 ( 1 ) ;
Beta = Beta1 ( 1 ) ; 
Deltat = Deltat1 ( 1 ) ;
Desplazamientoi = Desplazamientoi1 ( 1 ) ;
Velocidadi = Velocidadi1 ( 1 ) ; 
Aceleracioni = Aceleracioni1 ( 1 ) ;


%%

%Comienzo del proceso de calculos del programa.

disp ( 'Iniciando los Cálculos' )
disp ( ' ' )
disp ( 'Espere un Momento' )
disp ( ' ' )

%Calculo de las constantes del algoritmo.

Alfa = 0.25 * ( 0.50 + Beta ) ^ 2 ;

a0 = Alfa ^ ( - 1 ) * Deltat ^ ( - 2 ) ; 
a1 = Beta / ( Alfa * Deltat ) ; 
a2 = 1 / ( Alfa * Deltat ) ;
a3 = 1 / ( 2 * Alfa )-1 ;
a4 = Beta / Alfa - 1 ;
a5 = ( Deltat / 2 ) * (Beta / Alfa - 2 ) ;
a6 = Deltat * ( 1 - Beta ) ;
a7 = Beta * Deltat ;

w = ( Rigidez / Masa ) ^ ( 1 / 2 ) ; 
c = 2 * Masa * w * Xi ; 

Kt = Rigidez + a0 * Masa + a1 * c ; 


n = length ( Datos ) - 1 ; % Lectura del número de datos.

format long  % Arreglo del formato numérico.

B ( 1 ) = Desplazamientoi ;
C ( 1 ) = Velocidadi ;
D ( 1 ) = Aceleracioni ;

% Procedimiento iterativo del algoritmo:
for i = 1 : n
    
    A ( i ) = Fexterna ( i + 1 ) + Masa * ( a0 * B ( i ) + a2 * C ( i ) + a3 * D ( i ) ) + c * ( a1 * B ( i ) + a4 * C ( i ) + a5 * D ( i ) ) ;
    
    E ( i ) = A ( i ) / Kt ;
    F ( i ) = a0 * ( E ( i ) - B ( i ) ) - a2 * C ( i ) - a3 * D ( i ) ;
    G ( i ) = C ( i ) + a6 * D ( i ) + a7 * F ( i ) ;
    
    B ( i + 1 ) = E ( i ) ;
    D ( i + 1 ) = F ( i ) ;
    C ( i + 1 ) = G ( i ) ;
    
end

%%
% Impresión de información final y proceso de guardado en el archivo
% original respectivo.


Excel_1 = xlswrite ( 'Datos.xls' , 'RESULTADOS' , 'GLD1', 'A3') ;

Excel_2 = xlswrite ( 'Datos.xls' , 'D' , 'GLD1' , 'A4' ) ; % Imprime los nombres de los vectores.
Excel_3 = xlswrite ( 'Datos.xls' , 'T' , 'GLD1' , 'B4' ) ;
Excel_4 = xlswrite ( 'Datos.xls' , 'F' , 'GLD1' , 'C4' ) ;
Excel_5 = xlswrite ( 'Datos.xls' , 'f' , 'GLD1' , 'D4' ) ;
Excel_6 = xlswrite ( 'Datos.xls' , 'U' , 'GLD1' , 'E4' ) ;
Excel_7 = xlswrite ( 'Datos.xls' , 'V' , 'GLD1' , 'F4' ) ;
Excel_8 = xlswrite ( 'Datos.xls' , 'A' , 'GLD1' , 'G4' ) ;
Excel_9 = xlswrite ( 'Datos.xls' , 'u' , 'GLD1' , 'H4' ) ;
Excel_10 = xlswrite ( 'Datos.xls' , 'a' , 'GLD1' , 'I4' ) ;
Excel_11 = xlswrite ( 'Datos.xls' , 'v' , 'GLD1' , 'J4' ) ;

Excel_12 = xlswrite ( 'Datos.xls' , A' , 'GLD1' , 'D5' ) ; % Imprime los valores del vector CARGA EFECTIVA.
Excel_13 = xlswrite ( 'Datos.xls' , B' , 'GLD1' , 'E5' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T.
Excel_14 = xlswrite ( 'Datos.xls' , C' , 'GLD1' , 'F5' ) ; % Imprime los valores del vector VELOCIDAD T.
Excel_15 = xlswrite ( 'Datos.xls' , D' , 'GLD1' , 'G5' ) ; % Imprime los valores del vector ACELERACION T.
Excel_16 = xlswrite ( 'Datos.xls' , E' , 'GLD1' , 'H5' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T+dt.
Excel_17 = xlswrite ( 'Datos.xls' , F' , 'GLD1' , 'I5' ) ; % Imprime los valores del vector VELOCIDAD T+dt.
Excel_18 = xlswrite ( 'Datos.xls' , G' , 'GLD1' , 'J5' ) ; % Imprime los valores del vector ACELERACION T+dt.

Excel_19 = xlswrite ( 'Datos.xls' , a0 , 'GLD1' , 'I1' ) ; % Imprime los valores del vector CARGA EFECTIVA.
Excel_20 = xlswrite ( 'Datos.xls' , a1 , 'GLD1' , 'J1' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T.
Excel_21 = xlswrite ( 'Datos.xls' , a2 , 'GLD1' , 'K1' ) ; % Imprime los valores del vector VELOCIDAD T.
Excel_22 = xlswrite ( 'Datos.xls' , a3 , 'GLD1' , 'L1' ) ; % Imprime los valores del vector ACELERACION T.
Excel_23 = xlswrite ( 'Datos.xls' , a4 , 'GLD1' , 'M1' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T+dt.
Excel_24 = xlswrite ( 'Datos.xls' , a5 , 'GLD1' , 'N1' ) ; % Imprime los valores del vector VELOCIDAD T+dt.
Excel_25 = xlswrite ( 'Datos.xls' , a6 , 'GLD1' , 'O1' ) ; % Imprime los valores del vector ACELERACION T+dt.
Excel_26 = xlswrite ( 'Datos.xls' , a7 , 'GLD1' , 'P1' ) ; % Imprime los valores del vector ACELERACION T+dt.

disp ( ' ' )
disp ( 'Proceso Terminado' )
disp ( ' ' )
disp ( 'La Matriz se ha Guardado en el Archivo de Excel Correspondiente' )
disp ( ' ' )
disp ( ' ' )
disp ( ' ' )
disp ( 'Se Presentarán las Gráficas a Continuación ' )

plot( Tiempo , B' , Tiempo , C' , Tiempo , D' ) 

disp ( ' ' )
disp ( ' ' )
disp ( 'FIN DEL PROGRAMA -------------------------------------------------------------------------------------------------------------------------------- ' )
disp ( ' ' )
disp ( '................................................. Ing. EDWIN R. MARTÍNEZ..................................................................... ' )
disp ( ' ' )
disp ( ' ' )
disp ( 'Precione Cualquier Tecla Para Borrar y Continuar' )

pause
clc 
clear

format short  % Arreglo del formato numérico.
