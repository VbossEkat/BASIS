SELECT  CheckPaymentType.CheckPaymentTypeID,  CheckPaymentType.TypePayFscID AS ID_, ;
 CASE WHEN CheckPaymentType.CheckPaymentTypeID=1 ;
 THEN '��������'  ;
 WHEN CheckPaymentType.CheckPaymentTypeID=2 ;
 THEN '���������� �����'  ;
 WHEN CheckPaymentType.CheckPaymentTypeID=3 ;
 THEN '����� '  ELSE '������ ������ �����' END AS NM  ;
 FROM CheckPaymentType  JOIN iter_intlist_to_table(?_PARAM) i ON CheckPaymentType.CheckPaymentTypeID = i.number