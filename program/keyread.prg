PROCEDURE Keyread
LOCAL lcRead,lcReadChar
lcRead = []
lcReadChar = 0
DO WHILE lcReadChar<>13
    lcReadChar = INKEY()
    IF lcReadChar  <> 0 
        lcRead = lcRead + CHR(lcReadChar)
    ENDIF
    
ENDDO 
WAIT WINDOW lcRead+ CHR(13)+STR(LEN(lcRead),10,0)

285008500850085008500
