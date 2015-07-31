* GRDSearch.h  - константы для поиска в txtGrid

* Типы поиска/фильтрации
#DEFINE	cnMODE_NO_SEARCH			0	&& нет поиска
#DEFINE cnMODE_LOCATE_CONTEXT			1	&& контекстый поиск
#DEFINE	cnMODE_LOCATE_SEQUENTIAL		2	&& последовательный поиск
#DEFINE cnMODE_FILTER_CONTEXT			3	&& контекстный фильтр
#DEFINE cnMODE_FILTER_SEQUENTIAL		4	&& последовательный фильтр
#DEFINE cnMODE_FILTER_EXTERNAL			5	&& внешний фильтр

*Столбцы массива aSearchedColumns объекта GRD - свойства столбцов поиска
#DEFINE cnFILTER_MODE				1	&& режим фильтра/поиск
#DEFINE cnFILTER_ACTIVE				2	&& признак активности
#DEFINE cnFILTER_STRING				3	&& выражение фильтра/строка поиска
#DEFINE cnFILTER_COLUMN				4	&& номер колонки
#DEFINE cnFILTER_FIELD				5	&& имя поля
#DEFINE cnFILTER_HEADERCAPTION			6	&& заголовок колонки
#DEFINE cnFILTER_ARRAY_COLS			6	&& всего столбцов

*Константы режимы отмены фильтра
#DEFINE cnRESET_USER_ACTIVECOLUMN		1	&& пользовательская отмена интерактивной фильтрации/поиска в текущей колонке
#DEFINE cnRESET_USER_ALLCOLUMNS			2	&& пользовательская отмена фильтра/поиска во всех колонках
#DEFINE cnRESET_LOCATE_UNACTIVE_COLUMN		3	&& отмена поиска, если колонка поиска не активна (AfterRowColChange)
#DEFINE cnRESET_LOCATE				4	&& отмена поиска (Valid)
#DEFINE cnRESET_ALLCOLUMNS			5	&& отмена интерактивной фильтрации/поиска во всех колонках