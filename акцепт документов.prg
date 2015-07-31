LOCAL allcnt, wk_cnt

SELECT form
CALCULATE COUNT() ALL FOR frmstatusid<3 and INLIST(frmTypeId,1,3,5,20) AND frmdateacc>{24.07.2007} AND frmdateacc<{01.08.2007} TO allcnt
GO top
wk_cnt = 0
SCAN FOR frmstatusid<3 and INLIST(frmTypeId,1,3,5,20) AND frmdateacc>{24.07.2007} AND frmdateacc<{01.08.2007}
    REPLACE NEXT 1 frmstatusid WITH 3
    wk_cnt = 1+wk_cnt
    WAIT WINDOW "Обработано "+ STR(wk_cnt ,3,0)+" из "+ STR(allcnt,3,0) NOWAIT 
ENDSCAN 