* GRDSearch.h  - ��������� ��� ������ � txtGrid

* ���� ������/����������
#DEFINE	cnMODE_NO_SEARCH			0	&& ��� ������
#DEFINE cnMODE_LOCATE_CONTEXT			1	&& ���������� �����
#DEFINE	cnMODE_LOCATE_SEQUENTIAL		2	&& ���������������� �����
#DEFINE cnMODE_FILTER_CONTEXT			3	&& ����������� ������
#DEFINE cnMODE_FILTER_SEQUENTIAL		4	&& ���������������� ������
#DEFINE cnMODE_FILTER_EXTERNAL			5	&& ������� ������

*������� ������� aSearchedColumns ������� GRD - �������� �������� ������
#DEFINE cnFILTER_MODE				1	&& ����� �������/�����
#DEFINE cnFILTER_ACTIVE				2	&& ������� ����������
#DEFINE cnFILTER_STRING				3	&& ��������� �������/������ ������
#DEFINE cnFILTER_COLUMN				4	&& ����� �������
#DEFINE cnFILTER_FIELD				5	&& ��� ����
#DEFINE cnFILTER_HEADERCAPTION			6	&& ��������� �������
#DEFINE cnFILTER_ARRAY_COLS			6	&& ����� ��������

*��������� ������ ������ �������
#DEFINE cnRESET_USER_ACTIVECOLUMN		1	&& ���������������� ������ ������������� ����������/������ � ������� �������
#DEFINE cnRESET_USER_ALLCOLUMNS			2	&& ���������������� ������ �������/������ �� ���� ��������
#DEFINE cnRESET_LOCATE_UNACTIVE_COLUMN		3	&& ������ ������, ���� ������� ������ �� ������� (AfterRowColChange)
#DEFINE cnRESET_LOCATE				4	&& ������ ������ (Valid)
#DEFINE cnRESET_ALLCOLUMNS			5	&& ������ ������������� ����������/������ �� ���� ��������