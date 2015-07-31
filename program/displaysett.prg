PROCEDURE DisplaySett
LPARAMETERS nXres
IF PCOUNT()<1
    nXres = 1280
    nYres = 800
    nColor = 32
    nFreq  = 60
   ELSE 
    IF MESSAGEBOX('Менять разрешение?',4+64,'')=6
    nXres = 800
    nYres = 600
    nColor = 32
    nFreq  = 60
    lChangeDisp = .t.
    ELSE
    RETURN 
    ENDIF 
ENDIF 
**Clear All  
  cBuffer = Replicate(Chr(0), 255)  
  DECLARE INTEGER EnumDisplaySettings   IN user32.dll INTEGER, INTEGER,string  
  DECLARE INTEGER ChangeDisplaySettings IN user32.dll STRING, INTEGER  
    
  create cursor modes (description C(50), Col_depth N(2,0),width N(4,0),height N(4,0),frequency N(3,0))  
    
  local m.rez, m.i, m.wd, m.hg, m.dp, m.fr, m.ds, m.cd  
  m.i=0  
  m.rez=1  
    
  do while m.rez=1  
      m.rez=EnumDisplaySettings(0, m.i, @cBuffer)  
      if m.rez=1  
          m.wd=asc(substr(cBuffer,109,1))+256*asc(substr(cBuffer,110,1))  
          m.hg=asc(substr(cBuffer,113,1))+256*asc(substr(cBuffer,114,1))  
          m.dp=asc(substr(cBuffer,105,1))  
          m.fr=asc(substr(cBuffer,121,1))  
          do case  
              case m.dp=1  
                  m.cd="2 Colors, "  
              case m.dp=2  
                  m.cd="4 Colors, "  
              case m.dp=4  
                  m.cd="16 Colors, "  
              case m.dp=8  
                  m.cd="256 Colors, "  
              case m.dp=16  
                  m.cd="High Color (16 bit), "  
              case m.dp=24  
                  m.cd="True Color (24 bit), "  
              case m.dp=32  
                  m.cd="True Color (32 bit), "  
              otherwise  
                  m.cd="Unknown Color depth, "  
          endcase  
          m.ds=allt(str(m.wd))+" by "+allt(str(m.hg))+", "+m.cd+ ;  
              iif(m.fr=1,"Default Refresh",allt(str(m.fr))+" Hertz")  
                
          insert into modes values (m.ds, m.dp, m.wd, m.hg, m.fr)  
      endif  
      m.i=m.i+1  
  enddo  
    
  EnumDisplaySettings(0, -1, @cBuffer)  
  m.wd=asc(substr(cBuffer,109,1))+256*asc(substr(cBuffer,110,1))  
  m.hg=asc(substr(cBuffer,113,1))+256*asc(substr(cBuffer,114,1))  
  m.dp=asc(substr(cBuffer,105,1))  
  m.fr=asc(substr(cBuffer,121,1))  
    
  select modes  
          LOCATE ALL FOR col_depth=nColor  and width=nXres and height=nYres and frequency=nFreq   
  IF !FOUND()
      locate for col_depth=m.dp and width=m.wd and height=m.hg and frequency=m.fr  

      brow  
  ENDIF 
    
  if !(col_depth=m.dp and width=m.wd and height=m.hg and frequency=m.fr)  
      local m.ot  
    
     * m.ot=messagebox("Change mode?",36,"")  
    *  if m.ot=6  
          cBuffer=left(cBuffer,104)+chr(Col_depth)+substr(cBuffer,106)  
          cBuffer=left(cBuffer,108)+chr(width%256)+chr(int(width/256))+substr(cBuffer,111)  
          cBuffer=left(cBuffer,112)+chr(height%256)+chr(int(height/256))+substr(cBuffer,115)  
          cBuffer=left(cBuffer,120)+chr(frequency)+substr(cBuffer,122)  
          ChangeDisplaySettings(@cBuffer, 0)  
     * endif  
  ENDIF
  USE IN SELECT('modes')