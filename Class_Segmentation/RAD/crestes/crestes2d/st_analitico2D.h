/*/-----------------------------------------------------------------------------------
//	st_analitico2D.h
//-----------------------------------------------------------------------------------
//
//	Descripci�: Prototipus funcions de detecci� de crestes i valls
//	Versi�: 1.0
//	Autor/a: Antomio Lopez
//	Data creaci�: 1-06-2004
//
//	Modificacions:
//
//		Data	Tipus_de_modificaci�.
//
//	COPYRIGHT (c) Centre de Visi� per Computador 2004
//	Tots els drets reservats	
/////////////////////////////////////////////////////////////////////////////////////*/


Image st_analitico2D(	Image Lx, 
						Image Ly,
						Image A11, 
						Image A22, 
						Image A12, 
						double contraste, 
						int fils, 
						int cols);
