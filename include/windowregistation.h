*Столбцы массива aWindows - свойство приложения
#DEFINE cnWINDOWS_INDEX					1
#DEFINE cnWINDOWS_TYPE					2
#DEFINE cnWINDOWS_SHOW_TYPE				3
#DEFINE cnWINDOWS_OBJ_NAME				4
#DEFINE cnWINDOWS_OBJ_REF				5
#DEFINE cnWINDOWS_CAPTION				6
#DEFINE cnWINDOWS_ALLOW_MULT				7
#DEFINE cnWINDOWS_STD_TLB_INDEX				8
#DEFINE cnWINDOWS_CST_TLB_INDEX				9
#DEFINE cnWINDOWS_ACTIVEFLAG				10
#DEFINE cnWINDOWS_ARRAY_COLS				10

*Типы окон, свойство окна хранящееся в массиве окон
*в столбце cnWINDOWS_TYPE
#DEFINE cnWND_TYPE_FORM					1
#DEFINE cnWND_TYPE_TOOLBAR				2

*Тип окна в разрезе Modal/Modeless, свойство окна
*хранящееся в массиве окон в столбце cnWINDOWS_SHOW_TYPE
#DEFINE cnWND_MODAL					1
#DEFINE cnWND_MODELESS					2
