#INCLUDE 'TOTVS.CH'
#INCLUDE "TBICONN.CH"

User function ROTAUTO01()

local aErro    := {}
Local lRet     := .f.
local oSZ1Mod  
local lOk      := .f.

If (!IsBlind())
		PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	EndIf

	oModel := FWLoadModel("AL01BRW")     //------>Carregando a rotina

	oModel:SetOperation(3)               //------> Opera��o de inclus�o

	oModel:Activate()

// CRIAR O CABE�ALHO DA TELA

oSZ1Mod := oModel:GetModel("SZ1MASTER")
oSZ1Mod:SetValue("Z1_IDUSR"   , GETSXENUM("SZ1","Z1_IDUSR"))
oSZ1Mod:SetValue("Z1_NOME"    , "Miguel" )
oSZ1Mod:SetValue("Z1_SBRNOME" , "Vargas"     )
oSZ1Mod:SetValue("Z1_PAIS"    , "Brasil"     )
oSZ1Mod:SetValue("Z1_NUMTEL"  , "98138-8583" )

	If oModel:VldData()

			//Tenta realizar o Commit
			If oModel:CommitData()
				lOk := .T.
				ConfirmSX8()

				//Se n�o deu certo, altera a vari�vel para false aa
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf

     Endif

    if lOk
		FWAlertSuccess("O usuario Fez uma inclus�o automatica na tabela de pre�o " ,"Inclus�o automatica com sucesso")
	else
		FWAlertError(aErro[6],"N�oA foi possivel realizar a inclus�o na tabela de pre�o")
	endif

	If (!IsBlind())
		RESET ENVIRONMENT
	EndIf

return(lRet)

