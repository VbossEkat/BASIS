*------------------------------------------------------------------------------
* Project.........: Basis.pjx
* File............: ViewGeneration.prg
* Module/Procedure: ViewGeneration()
* Called by.......: <NA>
* Parameters......: <tcSourceScriptPath>
* Returns.........: <none>
* Notes...........: 
*------------------------------------------------------------------------------
LPARAMETERS	tcSourceScriptPath

*14.06.2005 17:05 ->Запишем LV для каждой ПО
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationAcc.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationAdmin.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationBank.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationCard.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationClt.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationCoupon.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationDevice.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationDiscount.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationFrm.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationFrmType.prg]))
*EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationKamtvr.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationMeasureUnit.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationOrgUnit.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationPBook.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationPOS.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationPrice.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationQryPar.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationRpt.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationRst.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationScrFrm.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationStorage.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationTlu.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationTvr.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationUser.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewQueuePayDoc.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationUser.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationPOS.prg]))
EXECSCRIPT(FILETOSTR(tcSourceScriptPath + [ViewGenerationAcc.prg]))
*------------------------------------------------------------------------------

*******************************************************************************
******************************** END PROCEDURE ********************************
*******************************************************************************