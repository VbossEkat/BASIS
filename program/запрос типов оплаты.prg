SELECT  CheckPaymentType.CheckPaymentTypeID,  CheckPaymentType.TypePayFscID AS ID_, ;
 CASE WHEN CheckPaymentType.CheckPaymentTypeID=1 ;
 THEN 'наличные'  ;
 WHEN CheckPaymentType.CheckPaymentTypeID=2 ;
 THEN 'банковская карта'  ;
 WHEN CheckPaymentType.CheckPaymentTypeID=3 ;
 THEN 'Купон '  ELSE 'оплата картой Гостя' END AS NM  ;
 FROM CheckPaymentType  JOIN iter_intlist_to_table(?_PARAM) i ON CheckPaymentType.CheckPaymentTypeID = i.number