/*/-----------------------------------------------------------------------------------
//	diffinit2D.h
//-----------------------------------------------------------------------------------
//
//	Descripci�: Prototipus funcions de diferencies finites
//	Versi�: 1.0
//	Autor/a: Antonio L�pez
//	Data creaci�: 1-06-2004
//
//	Modificacions:
//
//		Data	Tipus_de_modificaci�.
//
//	COPYRIGHT (c) Centre de Visi� per Computador 2004
//	Tots els drets reservats	
/////////////////////////////////////////////////////////////////////////////////////*/


/* diferencias centradas de L en la direccion X */
Image dfc2D_x(Image L);

/* diferencias centradas de L en la direccion Y */
Image dfc2D_y(Image L);

/* diferencias hacia delante de L en la direccion X */
Image dff2D_x(Image L);

/* diferencias hacia delante de L en la direccion Y */
Image dff2D_y(Image L);

/* diferencias hacia atras de L en la direccion X */
Image dfb2D_x(Image L);

/* diferencias hacia atras de L en la direccion Y */
Image dfb2D_y(Image L);

/* segundas diferencias centradas de L en la direccion X */
Image dfc2D_xx(Image L);

/* segundas diferencias centradas de L en la direccion Y */
Image dfc2D_yy(Image L);

/* segundas diferencias centradas de L en la direccion cruzada XY */
Image dfc2D_xy(Image L);
