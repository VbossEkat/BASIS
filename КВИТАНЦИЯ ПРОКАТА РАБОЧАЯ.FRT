   �   @                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              'ORIENTATION=0
PAPERSIZE=9
COLOR=2

erJet 1300 PCL 5e      �ParentAlias = "rptitoghd"
RelationalExpr = "exispcltid"
ChildAlias = "exispcltinfo"
ChildOrder = "cltid"
Name = "Relation7"
                                                             relation                                                      relation                                                      Arial                                                         [��������� � ]                                                Arial                                                         [������������ ����������]                                     Arial                                                         [� �/�]                                                                                                                     Arial                                                         [����� ������]                                                Arial                                                                                                                                                                                                                                                                                                                                                                               ALLTRIM(STR(nPosCount))                                                                                                     Arial                                                         rptitogdt.tvrnm                                                                                                             Arial                                                                                                                        nvl(ttoc(Rptitogdt.usestart),[])                              Arial                                                         /ROUND(rptitogdt.tvrprcsale* Rptitogdt.tvrqnt,2)               "@Z 9999999.99"                                               Arial                                                         [�����:]                                                                                                                    Arial                                                          MTOW(nfrmsum,rptitoghd.frmcurid)                              Arial                                                         	nfrmsum#0                                                     
[��������]                                                    Arial                                                         #GETWORDNUM(rptitoghd.frmnote,1,'&')                           Arial                                                         d[��������: �����-����� �������� �������� ���������� ��� ������ ����� ������� � ��������� ����������]                          Arial                                                         [�����]                                                       Arial                                                         [������]                                                      Arial                                                         DevCltInfo.CltNM                                              Arial                                                         [����� � ������]                                              Arial                                                         nvl(ttoc(Rptitogdt.useend),[])                                Arial                                                         /ROUND(rptitogdt.tvrprcsale* Rptitogdt.tvrqnt,2)               "@Z 9999999.99"                                               Arial                                                                                                                                                                                     [���� ]                                                       Arial                                                         ALLTRIM(TTOC(datetime()))                                     Arial                                                         ALLTRIM(rptitoghd.frmnum)                                     Arial                                                         [� ���������]                                                 Arial                                                         NGETWORDNUM(rptitoghd.frmnote,2,'&')+[ ,  ]+GETWORDNUM(rptitoghd.frmnote,3,'&')                                                cursor                                                        Arial                                                         [����� �����]                                                 Arial                                                         ExEmiCltInfo.CltNM                                            Arial                                                          ALLTRIM(TTOC(rptitoghd.frmdate))                              Arial                                                         [��� "������ ������"]                                         Arial                                                         [��� 6674205580]                                              Arial                                                         [�.������������, 620089,]                                     Arial                                                         [��. ������������, 44-508,506]                                Arial                                                         	nPosCount                                                     rptitogdt.tvrqnt                                              0                                                             nFrmSum                                                       .ROUND(rptitogdt.tvrprcsale*rptitogdt.tvrqnt,2)                0                                                             Arial                                                         Arial                                                         Arial                                                         Arial                                                         Arial                                                         Arial                                                         Arial                                                         dataenvironment                                               �Top = 60
Left = 6
Width = 1016
Height = 601
Visible = .F.
TabStop = .F.
InitialSelectedAlias = "rptitogdt"
DataSource = .NULL.
Name = "Dataenvironment"
                             ;PROCEDURE OpenTables
SELECT RptItogHD
LOCATE

ENDPROC
                                                                   ����    �   �                         ��   %   I       e      ]           6  U    F�  � -� U 	 RPTITOGHD
 OpenTables,     ��1 q A 2                       0       )   �                                                                          cursor                                                        �Top = 10
Left = 547
Height = 340
Width = 101
Alias = "rptitogdt"
CursorSource = rptitogdt.dbf
Name = "Cursor1"
                                                                        cursor                                                        tTop = 16
Left = 9
Height = 426
Width = 100
Alias = "rptitoghd"
CursorSource = rptitoghd.dbf
Name = "Cursor2"
          cursor                                                        sTop = 17
Left = 150
Height = 29
Width = 91
Alias = "cltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor3"
           relation                                                      wParentAlias = "rptitoghd"
RelationalExpr = "cltid"
ChildAlias = "cltinfo"
ChildOrder = "cltid"
Name = "Relation1"
       cursor                                                        vTop = 81
Left = 150
Height = 33
Width = 91
Alias = "owncltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor4"
        relation                                                      }ParentAlias = "rptitoghd"
RelationalExpr = "owncltid"
ChildAlias = "owncltinfo"
ChildOrder = "cltid"
Name = "Relation2"
                                                                 cursor                                                        wTop = 143
Left = 149
Height = 31
Width = 91
Alias = "devcltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor5"
       relation                                                      }ParentAlias = "rptitoghd"
RelationalExpr = "devcltid"
ChildAlias = "devcltinfo"
ChildOrder = "cltid"
Name = "Relation3"
                                                                 cursor                                                        yTop = 275
Left = 140
Height = 32
Width = 91
Alias = "exispcltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor6"
                                                                     cursor                                                        wTop = 337
Left = 140
Height = 34
Width = 91
Alias = "cntcltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor7"
       relation                                                      }ParentAlias = "rptitoghd"
RelationalExpr = "cntcltid"
ChildAlias = "cntcltinfo"
ChildOrder = "cltid"
Name = "Relation5"
                                                                 cursor                                                        �Top = 15
Left = 425
Height = 277
Width = 100
Alias = "ownrptsaccinfo"
Order = "cltsaccid"
CursorSource = rptsaccinfo.dbf
Name = "Cursor8"
                                            relation                                                      �ParentAlias = "rptitoghd"
RelationalExpr = "ownsaccid"
ChildAlias = "ownrptsaccinfo"
ChildOrder = "cltsaccid"
Name = "Relation6"
                                                        yTop = 210
Left = 139
Height = 32
Width = 91
Alias = "exemicltinfo"
CursorSource = rptcltinfo.dbf
Name = "Cursor9"
                                                                     �ParentAlias = "rptitoghd"
RelationalExpr = "exemicltid"
ChildAlias = "exemicltinfo"
ChildOrder = "cltid"
Name = "Relation4"
                                                             (��������� �������                                             d                                                                                                                        