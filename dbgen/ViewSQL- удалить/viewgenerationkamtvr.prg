#DEFINE	pcvCONNECTIONNAME	SQLBASISCONNECTION

*13.02.2006 17:09 -> Генерация представлений
WAIT WINDOW [Генерация Remote View для справочника изделий] NOWAIT NOCLEAR
SET MESSAGE TO [Генерация Remote View для справочника изделий]
***
lvTvrPrefView()
lvTvrPrefViewRepl()
lvTvrPrefEdit()
***
lvTvrMatView()
lvTvrMatViewRepl()
lvTvrMatEdit()
***
WAIT CLEAR
SET MESSAGE TO []
*------------------------------------------------------------------------------

*/RV KamTvr: список изделий/*
PROCEDURE lvTvrPrefView
***
CREATE SQL VIEW lvTvrPrefView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrPref.TvrPrefId, ;
	TvrPref.TvrPrefNM ;
FROM TvrPref
***
DBSETPROP([lvTvrPrefView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPrefView],[VIEW],[COMMENT],[RV KamTvr: список изделий.])
***
ENDPROC
*------------------------------------------------------------------------------

*/RV KamTvr: редактирование изделий/*
PROCEDURE lvTvrPrefEdit
***
CREATE SQL VIEW lvTvrPrefEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrPref.TvrPrefId, ;
	TvrPref.TvrPrefNM ;
FROM TvrPref ;
WHERE TvrPref.TvrPrefId = ?_PARAM
***
DBSETPROP([lvTvrPrefEdit.TvrPrefId],[FIELD],[KeyField],.T.)
DBSETPROP([lvTvrPrefEdit.TvrPrefId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvTvrPrefEdit.TvrPrefNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrPrefEdit.TvrPrefNM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvTvrPrefEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrPrefEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrPrefEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPrefEdit],[VIEW],[COMMENT],[RV KamTvr: редактирование изделий.])
***
ENDPROC
*------------------------------------------------------------------------------

*/RV KamTvr: список материалов/*
PROCEDURE lvTvrMatView
***
CREATE SQL VIEW lvTvrMatView REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrMat.TvrMatId, ;
	TvrMat.TvrMatNM ;
FROM TvrMat
***
DBSETPROP([lvTvrPrefView],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrPrefView],[VIEW],[COMMENT],[RV KamTvr: список материалов.])
***
ENDPROC
*------------------------------------------------------------------------------

*/RV KamTvr: редактирование материалов/*
PROCEDURE lvTvrMatEdit
***
CREATE SQL VIEW lvTvrMatEdit REMOTE CONNECTION pcvCONNECTIONNAME SHARE AS ;
SELECT ;
	TvrMat.TvrMatId, ;
	TvrMat.TvrMatNM ;
FROM TvrMat ;
WHERE TvrMat.TvrMatId = ?_PARAM
***
DBSETPROP([lvTvrMatEdit.TvrMatId],[FIELD],[KeyField],.T.)
DBSETPROP([lvTvrMatEdit.TvrMatId],[FIELD],[Updatable],.F.)
***
DBSETPROP([lvTvrMatEdit.TvrMatNM],[FIELD],[Updatable],.T.)
***
DBSETPROP([lvTvrMatEdit.TvrMatNM],[FIELD],[DefaultValue],[""])
***
DBSETPROP([lvTvrMatEdit],[VIEW],[SendUpdates],.T.)
DBSETPROP([lvTvrMatEdit],[VIEW],[WhereType],1) &&DB_KEY
DBSETPROP([lvTvrMatEdit],[VIEW],[FetchSize],-1)
***
DBSETPROP([lvTvrMatEdit],[VIEW],[COMMENT],[RV KamTvr: редактирование материалов.])
***
ENDPROC
*------------------------------------------------------------------------------