#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 14:29 -> Генерация представлений
WAIT WINDOW [Генерация представлений для ПО: Банки] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация представлений для ПО: Банки]
***
lvCltBankList()
lvCltBankAttr()
lvCltBankInfoByBik()
lvCltBankView()
lvCltBankViewRepl()
lvCltBankEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/LV CLT: список банков/*
PROCEDURE lvCltBankList
***
CREATE SQL VIEW lvCltBankList REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankID, ;
	CltBank.CltBankBIK + ' "' + CltBank.CltBankNM + '"' AS CltBankNM ;
FROM CltBank
***
DBSETPROP([lvCltBankList],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankList],[VIEW],[COMMENT],[LV CLT: список банков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: атрибуты банка/*
PROCEDURE lvCltBankAttr
***
CREATE SQL VIEW lvCltBankAttr REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankKS, ;
	CltBank.CltBankAddr ;
FROM CltBank ;
WHERE CltBank.CltBankID = ?_PARAM
***
DBSETPROP([lvCltBankAttr],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankAttr],[VIEW],[COMMENT],[LV CLT: атрибуты банка])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: Информации о банке по БИКу/*
PROCEDURE lvCltBankInfoByBik
***
CREATE SQL VIEW lvCltBankInfoByBik REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankID, ;
	CltBank.CltBankKS, ;
	CltBank.CltBankNM, ;
	CltBank.CltBankAddr, ;
	CltBank.CltBankIsSys ;
FROM CltBank ;
WHERE UPPER(CltBank.CltBankBIK) = ?_PARAM
***
DBSETPROP([lvCltBankInfoByBik],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankInfoByBik],[VIEW],[COMMENT],[LV CLT: Информации о банке по БИКу])
***
ENDPROC
*------------------------------------------------------------------------------
	
*/LV CLT: справочник банков/*
PROCEDURE lvCltBankView
***
CREATE SQL VIEW lvCltBankView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankID, ;
	CltBank.CltBankBIK, ;
	CltBank.CltBankKS, ;
	CltBank.CltBankNM, ;
	CltBank.CltBankAddr, ;
	CltBank.CltBankIsSys ;
FROM CltBank
***
DBSETPROP([lvCltBankView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankView],[VIEW],[COMMENT],[LV CLT: справочник банков])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: обновления для lvCltBankView/*
PROCEDURE lvCltBankViewRepl
***
CREATE SQL VIEW lvCltBankViewRepl REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankID, ;
	CltBank.CltBankBIK, ;
	CltBank.CltBankKS, ;
	CltBank.CltBankNM, ;
	CltBank.CltBankAddr, ;
	CltBank.CltBankIsSys ;
FROM CltBank ;
WHERE CltBank.CltBankID = ?_PARAM
***
DBSETPROP([lvCltBankViewRepl],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankViewRepl],[VIEW],[COMMENT],[LV CLT: обновления для lvCltBankViewRepl])
***
ENDPROC
*------------------------------------------------------------------------------

*/LV CLT: редактирование таблицы CltBank*/
PROCEDURE lvCltBankEdit
***
CREATE SQL VIEW lvCltBankEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	CltBank.CltBankID, ;
	CltBank.CltBankBIK, ;
	CltBank.CltBankKS, ;
	CltBank.CltBankNM, ;
	CltBank.CltBankAddr, ;
	CltBank.CltBankIsSys, ;
	CltBank.Stamp_, ;
	CltBank.User_ ;
FROM CltBank ;
WHERE CltBank.CltBankID = ?_PARAM
***
DBSETPROP([lvCltBankEdit.CltBankID],[FIELD],[KeyField],.T.)
***
DBSETPROP([lvCltBankEdit.CltBankID],[FIELD],[Updatable],.F.)
DBSETPROP([lvCltBankEdit.CltBankBIK],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.CltBankKS],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.CltBankNM],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.CltBankAddr],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.CltBankIsSys],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.Stamp_],[FIELD],[Updatable],.T.)
DBSETPROP([lvCltBankEdit.User_],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvCltBankEdit.CltBankBIK],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltBankEdit.CltBankKS],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltBankEdit.CltBankNM],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltBankEdit.CltBankAddr],[FIELD],[DefaultValue],[""])
DBSETPROP([lvCltBankEdit.CltBankIsSys],[FIELD],[DefaultValue],[.F.])
***
DBSETPROP([lvCltBankEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvCltBankEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvCltBankEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvCltBankEdit],[VIEW],[COMMENT],[LV CLT: редактирование таблицы CltBank])
***
ENDPROC
*------------------------------------------------------------------------------