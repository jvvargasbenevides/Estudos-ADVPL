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

	oModel:SetOperation(3)               //------> Operação de inclusão

	oModel:Activate()

// CRIAR O CABEÇALHO DA TELA

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

				//Se não deu certo, altera a variável para false aa
			Else
				lOk := .F.
				RollBackSX8()
				aErro := oModel:GetErrorMessage()
			EndIf

     Endif

    if lOk
		FWAlertSuccess("O usuario Fez uma inclusão automatica na tabela de preço " ,"Inclusão automatica com sucesso")
	else
		FWAlertError(aErro[6],"NãoA foi possivel realizar a inclusão na tabela de preço")
	endif

	If (!IsBlind())
		RESET ENVIRONMENT
	EndIf

return(lRet)

