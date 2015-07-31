*SET DATABASE TO BASIS 
CLOSE DATABASES ALL
OPEN DATABASE D:\Develop\Work\DEMO\Kolcovo\basis.dbc EXCLUSIVE 
PACK DATABASE 
CLOSE DATABASES ALL

    IF MESSAGEBOX('База упакована. Компилировать файлы?',4+32,'Продолжение компиляции')<>6
    RETURN 
    ENDIF 
WAIT WINDOW "d:\develop\work\basis\BASIS.PJX" NOWAIT 
BUILD exe "d:\develop\work\basis\BASIS" FROM "d:\develop\work\basis\BASIS.PJX" 

WAIT WINDOW "d:\develop\work\basis\basis_RST.PJX" NOWAIT 
BUILD exe "d:\develop\work\basis\RST" FROM "d:\develop\work\basis\basis_RST.PJX" 


WAIT WINDOW "d:\develop\work\basis\POS.PJX" NOWAIT 
BUILD exe "d:\develop\work\basis\POS" FROM "d:\develop\work\basis\POS.PJX" 


WAIT WINDOW "d:\develop\work\basis\admin.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\admin" FROM "d:\develop\work\basis\admin.PJX" 


WAIT WINDOW "d:\develop\work\basis\auth.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\auth" FROM "d:\develop\work\basis\auth.PJX" 


WAIT WINDOW "d:\develop\work\basis\card.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\card" FROM "d:\develop\work\basis\card.PJX" 


WAIT WINDOW "d:\develop\work\basis\cash.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\cash" FROM "d:\develop\work\basis\cash.PJX" 


WAIT WINDOW "d:\develop\work\basis\client.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\client" FROM "d:\develop\work\basis\client.PJX" 


WAIT WINDOW "d:\develop\work\basis\convert.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\convert" FROM "d:\develop\work\basis\convert.PJX" 


WAIT WINDOW "d:\develop\work\basis\coupon.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\coupon" FROM "d:\develop\work\basis\coupon.PJX" 


WAIT WINDOW "d:\develop\work\basis\device.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\device" FROM "d:\develop\work\basis\device.PJX" 


WAIT WINDOW "d:\develop\work\basis\discount.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\discount" FROM "d:\develop\work\basis\discount.PJX" 


WAIT WINDOW "d:\develop\work\basis\formtype.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\formtype" FROM "d:\develop\work\basis\formtype.PJX" 


WAIT WINDOW "d:\develop\work\basis\orgunit.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\orgunit" FROM "d:\develop\work\basis\orgunit.PJX" 


WAIT WINDOW "d:\develop\work\basis\pbook.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\pbook" FROM "d:\develop\work\basis\pbook.PJX" 

WAIT WINDOW "d:\develop\work\basis\poscfg.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\poscfg" FROM "d:\develop\work\basis\poscfg.PJX" 


**WAIT WINDOW "d:\develop\work\basis\PRICE.PJX" NOWAIT 
**BUILD APP "d:\develop\work\basis\PRICE" FROM "d:\develop\work\basis\PRICE.PJX" 


WAIT WINDOW "d:\develop\work\basis\primarydoc.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\primarydoc" FROM "d:\develop\work\basis\primarydoc.PJX" 


WAIT WINDOW "d:\develop\work\basis\queryparam.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\queryparam" FROM "d:\develop\work\basis\queryparam.PJX" 


WAIT WINDOW "d:\develop\work\basis\report.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\report" FROM "d:\develop\work\basis\report.PJX" 


WAIT WINDOW "d:\develop\work\basis\screenform.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\screenform" FROM "d:\develop\work\basis\screenform.PJX" 


WAIT WINDOW "d:\develop\work\basis\tovar.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\tovar" FROM "d:\develop\work\basis\tovar.PJX" 


WAIT WINDOW "d:\develop\work\basis\user.PJX" NOWAIT 
BUILD APP "d:\develop\work\basis\user" FROM "d:\develop\work\basis\user.PJX" 

WAIT WINDOW "d:\develop\work\basis\SPLASH.PJX" NOWAIT 
BUILD exe "d:\develop\work\basis\SPLASH" FROM "d:\develop\work\basis\SPLASH.PJX" 

WAIT CLEAR 
