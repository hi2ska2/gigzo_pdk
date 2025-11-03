printf(strcat( "---> yod libInit.il [" getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "]\n"))

; Load display.drf
if( isFile( strcat( getShellEnvVar("HOME") "/display.drf")) then
  drLoadDrf( strcat( getShellEnvVar("HOME") "/display.drf") nil)
  printf("---> ~/display.drf\n")
else
  drLoadDrf( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/display.drf") nil)
  printf("---> display.drf\n")
)

; ******************************************************************************
; Global values
; ******************************************************************************

; Note that the min max are not DRC values but intended to provide boundaries for pcell creation

pragVars=makeTable('pdkVars "")

pragVars->GridRes = 0.1u

pragVars->nchMinW    = "0.1u"
pragVars->nchMinL    = "0.1u"
pragVars->nchMaxW    = "100u"
pragVars->nchMaxL    = "100u"

;pragVars->resSheetRes = "190k"
pragVars->resEtchL    = "0u"
pragVars->resEtch     = "0u"
;pragVars->resMinW     = "0.1u"
pragVars->resMinL     = "0.1u"
pragVars->resMaxW     = "125u"
pragVars->resMaxL     = "120u"

;pragVars->capUnitArea = "0.0027"
pragVars->capEtch     = "0u"
pragVars->capMinW     = "0.1u"
pragVars->capMinL     = "0.1u"
pragVars->capMaxW     = "1000u"
pragVars->capMaxL     = "1000u"

; ******************************************************************************
; Load Callbacks
; ******************************************************************************

loadi( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/nch_cb.il"))
loadi( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/res_cb.il"))
loadi( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/cap_cb.il"))
loadi( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/resmt2_cb.il"))

; ******************************************************************************
; Load Netlisting Procedure
; ******************************************************************************

loadi( strcat( getShellEnvVar("/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk") "/cdslib/skill/pragNchNetlistProc.il"))

; ******************************************************************************
; Model location
; ******************************************************************************

; Default model locations
envSetVal("spectre.envOpts" "modelFiles" 'string "$/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk/models/nch.scs;typ $/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk/models/resmod.scs;nom $/home/jsw2277/gigzo_pdk/IGZO_PDK/V2.1.0.beta.2.hotfix.1/pdk/models/capmod.scs;nom") 

