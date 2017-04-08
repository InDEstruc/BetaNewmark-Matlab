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
% Nombre del Programa: BETA DE NEWMARK ENFOCADO A MÚLTIPLES GRADOS DE LIBERTADA DINÁMICA.
% Descripcion: Calcula a través del algorítmo de Beta de Newmark los
% vectores de comportamiento en desplazamientos, velocidad y aceleración para un sistema de un grado de libertad dinámica.
% Realizado por: ING. EDWIN M. R. MARTÍNEZ.
% Fecha: 7 de octubre del 2012.
% Nota: En la aplicación de dicho método se espera un error menor al 2%
% del valor real.

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

Masa1 = xlsread ( 'multiplesgld' , 'GLD6' , 'A1' ) ; % Lectura de la masa del sitema.
Rigidez1 = xlsread ( 'multiplesgld' , 'GLD6' , 'B1' ) ; % Lectura de la rigidez del sistema.
Xi1 = xlsread ( 'multiplesgld' , 'GLD6' , 'C1' ) ; % Lectura de la fracción de amortiguamiento crítico.
Beta1 = xlsread ( 'multiplesgld' , 'GLD6' , 'D1' ) ; % Lectura de la beta propuesta.
Deltat1 = xlsread ( 'multiplesgld' , 'GLD6' , 'E1' ) ; % Lectura del valor de delta t.
Desplazamientoi1 = xlsread ( 'multiplesgld' , 'GLD6' , 'F1' ) ; % Lectura del desplazamiento inicial.
Velocidadi1 = xlsread ( 'multiplesgld' , 'GLD6' , 'G1' ) ; % Lectura de la velocidad inicial.
Aceleracioni1 = xlsread ( 'multiplesgld' , 'GLD6' , 'H1' ) ; % Lectura de la aceleración inicial.

Datos = xlsread ( 'multiplesgld' , 'GLD6' , 'A5:A10005' ) ; % Lectura del vector de número de datos. ¡CONSIDERE MODIFICAR EN ALGÚN CASO NECESARIO YA QUE SÓLO SE CUENTAN 10000 VALORES!
Tiempo = xlsread ( 'multiplesgld' , 'GLD6' , 'B5:B10005' ) ; % Lectura del comportamiento de la fuerza externa.
Fexterna = xlsread ( 'multiplesgld' , 'GLD6' , 'C5:C10005' ) ; % Lectura del comportamiento de la fuerza externa.  

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


Excel_1 = xlswrite ( 'multiplesgld' , 'RESULTADOS' , 'GLD6', 'A3') ;

Excel_2 = xlswrite ( 'multiplesgld' , 'D' , 'GLD6' , 'A4' ) ; % Imprime los nombres de los vectores.
Excel_3 = xlswrite ( 'multiplesgld' , 'T' , 'GLD6' , 'B4' ) ;
Excel_4 = xlswrite ( 'multiplesgld' , 'F' , 'GLD6' , 'C4' ) ;
Excel_5 = xlswrite ( 'multiplesgld' , 'f' , 'GLD6' , 'D4' ) ;

Excel_6 = xlswrite ( 'multiplesgld' , 'U' , 'GLD6' , 'E4' ) ;
Excel_7 = xlswrite ( 'multiplesgld' , 'V' , 'GLD6' , 'F4' ) ;
Excel_8 = xlswrite ( 'multiplesgld' , 'A' , 'GLD6' , 'G4' ) ;

Excel_9 = xlswrite ( 'multiplesgld' , 'u' , 'GLD6' , 'H4' ) ;
Excel_10 = xlswrite ( 'multiplesgld' , 'a' , 'GLD6' , 'I4' ) ;
Excel_11 = xlswrite ( 'multiplesgld' , 'v' , 'GLD6' , 'J4' ) ;

Excel_12 = xlswrite ( 'multiplesgld' , A' , 'GLD6' , 'D5' ) ; % Imprime los valores del vector CARGA EFECTIVA.
Excel_13 = xlswrite ( 'multiplesgld' , B' , 'GLD6' , 'E5' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T.
Excel_14 = xlswrite ( 'multiplesgld' , C' , 'GLD6' , 'F5' ) ; % Imprime los valores del vector VELOCIDAD T.
Excel_15 = xlswrite ( 'multiplesgld' , D' , 'GLD6' , 'G5' ) ; % Imprime los valores del vector ACELERACION T.
Excel_16 = xlswrite ( 'multiplesgld' , E' , 'GLD6' , 'H5' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T+dt.
Excel_17 = xlswrite ( 'multiplesgld' , F' , 'GLD6' , 'I5' ) ; % Imprime los valores del vector VELOCIDAD T+dt.
Excel_18 = xlswrite ( 'multiplesgld' , G' , 'GLD6' , 'J5' ) ; % Imprime los valores del vector ACELERACION T+dt.

Excel_19 = xlswrite ( 'multiplesgld' , a0 , 'GLD6' , 'I1' ) ; % Imprime los valores del vector CARGA EFECTIVA.
Excel_20 = xlswrite ( 'multiplesgld' , a1 , 'GLD6' , 'J1' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T.
Excel_21 = xlswrite ( 'multiplesgld' , a2 , 'GLD6' , 'K1' ) ; % Imprime los valores del vector VELOCIDAD T.
Excel_22 = xlswrite ( 'multiplesgld' , a3 , 'GLD6' , 'L1' ) ; % Imprime los valores del vector ACELERACION T.
Excel_23 = xlswrite ( 'multiplesgld' , a4 , 'GLD6' , 'M1' ) ; % Imprime los valores del vector DESPLAZAMIENTOS T+dt.
Excel_24 = xlswrite ( 'multiplesgld' , a5 , 'GLD6' , 'N1' ) ; % Imprime los valores del vector VELOCIDAD T+dt.
Excel_25 = xlswrite ( 'multiplesgld' , a6 , 'GLD6' , 'O1' ) ; % Imprime los valores del vector ACELERACION T+dt.
Excel_26 = xlswrite ( 'multiplesgld' , a7 , 'GLD6' , 'P1' ) ; % Imprime los valores del vector ACELERACION T+dt.

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
disp ( '................................................. E. M. C. EDWIN R. MARTÍNEZ..................................................................... ' )
disp ( ' ' )
disp ( ' ' )
disp ( 'Precione Cualquier Tecla Para Borrar y Continuar' )

pause
clc 
clear

format short  % Arreglo del formato numérico.
