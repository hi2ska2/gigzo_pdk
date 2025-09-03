printf("---> yod resmt2_cb.il\n")

; ******************************************************************************
; pragMetalResResCallBack()
; sets: [l w]
; ******************************************************************************

procedure( pragMetalResResCallBack()
let( (grid width length res max_width min_width max_length tmp modelName rsh)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
	max_width = round(cdfParseFloatString(pragVars->resMaxW)/grid)*grid
	max_length = round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid
	min_length = round(cdfParseFloatString(pragVars->resMinL)/grid)*grid
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	res = cdfParseFloatString(cdfgData->r->value)
	modelName = cdfgData->model->value

	case( modelName
		( "resmt1" 	rsh = 0.325)
		( "resmt2" 	rsh = 0.325)
		( "ressd"  	rsh = 0.325)
		( "resgate"  	rsh = 0.325)
		( "resrdl"  	rsh = 0.10)
	)
	case( modelName
		("resmt1" 	min_width = round(3.0u/grid)*grid )
		("resmt2" 	min_width = round(3.0u/grid)*grid )
		("ressd"  	min_width = round(2.0u/grid)*grid )
		("resgate"  	min_width = round(2.0u/grid)*grid )
		("resrdl"  	min_width = round(30.0u/grid)*grid )
	)
	case( modelName
		("resmt1" 	max_length = 2*round(100.0u/grid)*grid )
		("resmt2" 	max_length = 2*round(100.0u/grid)*grid )
		("ressd"  	max_length = round(200.0u/grid)*grid )
		("resgate"  	max_length = round(200.0u/grid)*grid )
		("resrdl"  	max_length = 2*round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid )
	)
	etchl = cdfParseFloatString(pragVars->resEtchL)
	etch = cdfParseFloatString(pragVars->resEtch)

	tmp = res/rsh * (width - 2*etch) + 2*etchl
	; rsh is modified for corners by rsh' = (rsh/100) * (100-110c/L) see the DM
	; Note that the following equations are only valid since etchl=0
	; Ensure length is on grid
	length = round(tmp/grid)*grid

	; Check min and max
	if( (length < min_length)
	then
		warn("Minimum length is %g M\n" min_length)
		length = min_length
	); if
	if( (length > max_length)
	then
		warn("Maximum length is %g M\n" max_length)
		length = max_length
	); if

	; Set length
	cdfgData->l->value = sprintf(s "%g" length)

	; Recalculate the resistance
	pragMetalResResCalc()
); let
)

; ******************************************************************************
; pragMetalResWidthCallBack()
; sets: [w res]
; ******************************************************************************

procedure( pragMetalResWidthCallBack()
let( (grid width max_width min_width modelName)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
	max_width = round(cdfParseFloatString(pragVars->resMaxW)/grid)*grid
	modelName = cdfgData->model->value

	; Ensure width is on grid
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
	
	case( modelName
		("resmt1" 	min_width = round(3.0u/grid)*grid )
		("resmt2" 	min_width = round(3.0u/grid)*grid )
		("ressd"  	min_width = round(2.0u/grid)*grid )
		("resgate"  	min_width = round(2.0u/grid)*grid )
		("resrdl"  	min_width = round(30.0u/grid)*grid )
	)

	; Check min and max
	if( (width < min_width)
	then
		warn("Minimum width is %g M\n" min_width)
		width = min_width
	); if
	if( (width > max_width)
	then
		warn("Maximum width is %g M\n" max_width)
		width = max_width
	); if

	; Set Width
	cdfgData->w->value = sprintf(s "%g" width)

	; Adjust Res
	pragMetalResResCalc()

); let
)

; ******************************************************************************
; pragMetalResLengthCallBack()
; sets: [l res]
; ******************************************************************************

procedure( pragMetalResLengthCallBack()
let( (grid length max_length min_length tmp modelName)

	; Set Grid, Min & Max L values
	grid = pragVars->GridRes
	min_length = round(cdfParseFloatString(pragVars->resMinL)/grid)*grid
	max_length = round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid
	modelName = cdfgData->model->value

	case( modelName
		("resmt1" 	max_length = 2*round(100.0u/grid)*grid )
		("resmt2" 	max_length = 2*round(100.0u/grid)*grid )
		("ressd"  	max_length = round(200.0u/grid)*grid )
		("resgate"  	max_length = round(200.0u/grid)*grid )
		("resrdl"  	max_length = 2*round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid )
	)

	; Ensure length is on grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

	; Check min and max
	min_length = round(cdfParseFloatString(pragVars->resMinL)/grid)*grid
	
	; Ensure length is on grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

	; Check min and max
	if( (length < min_length)
	then
		warn("Minimum length is %g M\n" min_length)
		length = min_length
	); if
	if( (length > max_length)
	then
		warn("Maximum length is %g M\n" max_length)
		length = max_length
	); if
	; Set length
	cdfgData->l->value = sprintf(s "%g" length)

	; Adjust res
	pragMetalResResCalc()

); let
)

; ******************************************************************************
; SUBFUNCTIONS
; ******************************************************************************

; Calculates Res
procedure( pragMetalResResCalc()
let( (grid width length rsh etchl etch tmp modelName)

	grid = pragVars->GridRes
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	modelName = cdfgData->model->value

	case( modelName
		("resmt1" 	rsh = 0.325)
		("resmt2" 	rsh = 0.325)
		("ressd"  	rsh = 0.325)
		("resgate"  	rsh = 0.325)
		("resrdl"  	rsh = 0.10)
	)
	etchl = cdfParseFloatString(pragVars->resEtchL)
	etch = cdfParseFloatString(pragVars->resEtch)

	tmp = ( (length - 2*etchl) / (width - 2*etch) ) * rsh

	cdfgData->r->value = sprintf(s "%g" tmp )
)
)

