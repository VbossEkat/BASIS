PROCEDURE NtoTSTR
PARAMETERS nTimeCount
**** ����������� ����� �� �����
**** nTimeCount - ���������� ������� � ������
** ����������� � ������
LOCAL nDD,nHH,nMM, nSS, lStr
lStr = []
STORE 0 TO nDD,nHH,nMM, nSS
nDD = int(nTimeCount)
nTimeCount = nTimeCount * 24 * 60

nHH = int(nTimeCount-(nDD *24*60))/60
nMM = nTimeCount-(nDD *24*60)- nHH  * 60
lStr = nvl(allt(str(nDD,13,0))+[ ��� ] ,[])
lStr = lStr +NVL(allt(str(nHH ))+[��� ],[])
lStr = lStr +NVL(allt(str(nMM ))+[��� ],[])



RETURN lStr 