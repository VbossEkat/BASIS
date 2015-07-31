*-------------------------------------------------------
* Project.........: BASIS.PJX
* File............: MTOC.PRG
* Module/Procedure: MTOC()
* Called by.......: <N/A>
* Parameters......: <tnMonth>
* Returns.........: <lcMonth>
* Notes...........: Преобразование цифрового значения месяца в символьное с учетом падежа скота
*-------------------------------------------------------
LPARAMETERS	tnMonth,tnPadezh

LOCAL lcMonth
***

lcMonth = []

DO CASE
	&&Именительный падеж
	CASE tnPadezh = 1
		DO CASE
			CASE tnMonth = 1
				lcMonth = [Январь]
			CASE tnMonth = 2
				lcMonth = [Февраль]
			CASE tnMonth = 3
				lcMonth = [Март]
			CASE tnMonth = 4
				lcMonth = [Апрель]
			CASE tnMonth = 5
				lcMonth = [Май]
			CASE tnMonth = 6
				lcMonth = [Июнь]
			CASE tnMonth = 7
				lcMonth = [Июль]
			CASE tnMonth = 8
				lcMonth = [Август]
			CASE tnMonth = 9
				lcMonth = [Сентябрь]
			CASE tnMonth = 10
				lcMonth = [Октябрь]
			CASE tnMonth = 11
				lcMonth = [Ноябрь]
			CASE tnMonth = 12
				lcMonth = [Декабрь]
		ENDCASE
	&&Родительный падеж
	CASE tnPadezh = 2
		DO CASE
			CASE tnMonth = 1
				lcMonth = [января]
			CASE tnMonth = 2
				lcMonth = [февраля]
			CASE tnMonth = 3
				lcMonth = [марта]
			CASE tnMonth = 4
				lcMonth = [апреля]
			CASE tnMonth = 5
				lcMonth = [мая]
			CASE tnMonth = 6
				lcMonth = [июня]
			CASE tnMonth = 7
				lcMonth = [июля]
			CASE tnMonth = 8
				lcMonth = [августа]
			CASE tnMonth = 9
				lcMonth = [сентября]
			CASE tnMonth = 10
				lcMonth = [октября]
			CASE tnMonth = 11
				lcMonth = [ноября]
			CASE tnMonth = 12
				lcMonth = [декабря]
		ENDCASE
ENDCASE

RETURN lcMonth
************************************************************************************
**********************************  END PROCEDURE **********************************
************************************************************************************