printf("---> yod cap_cb.il\n")

; ******************************************************************************
; pragCapCapCallBack()
; sets: [l cap]
; ******************************************************************************

procedure( pragCapCapCallBack()
  let( (grid width length cap max_length min_length)

    ; Set Grid, Min & Max L values
    grid = pragVars->GridRes
    max_length = round(cdfParseFloatString(pragVars->capMaxL)/grid)*grid
    min_length = round(cdfParseFloatString(pragVars->capMinL)/grid)*grid
    capUnitArea = 0.0027 ;Value from defines_<tech> file
	

    ; Ensure length is on grid
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    length = round(cdfParseFloatString(cdfgData->c->value)/width/capUnitArea/grid)*grid
    cap = length*width*capUnitArea

    ; Experimental?
    if( (!cdfgData->experimental->value)
    then

        ; If length is less than minimum, set to Min
        if( (length < min_length)
        then
            length = min_length
            warn("WARNING: Minimum Length is %g M\n" min_length)
            width = round(cdfParseFloatString(cdfgData->c->value)/length/cdfParseFloatString(pragVars->capUnitArea)/grid)*grid
            cdfgData->w->value = sprintf(s "%g" width)
            pragCapWidthCallBack()
        ); if

        ; If length is greater than maximum, set to Max
        if( (length > max_length)
        then
            length = max_length
            warn("WARNING: Maximum Length is %g M\n" max_length)
            width = round(cdfParseFloatString(cdfgData->c->value)/length/cdfParseFloatString(pragVars->capUnitArea)/grid)*grid
            cdfgData->w->value = sprintf(s "%g" width)
            pragCapWidthCallBack()
        ); if

    ); Experimental

    ; Set Length
    cdfgData->l->value = sprintf(s "%g" length)
    cdfgData->c->value = sprintf(s "%g" cap)

    ; Adjust Cap
    pragCapCapCalc()

  ); let
)

; ******************************************************************************
; pragCapWidthCallBack()
; sets: [w cap]
; ******************************************************************************

procedure( pragCapWidthCallBack()
  let( (grid width max_width min_width)

    ; Set Grid, Min & Max W values
    grid = pragVars->GridRes
    max_width = round(cdfParseFloatString(pragVars->capMaxW)/grid)*grid
    min_width = round(cdfParseFloatString(pragVars->capMinW)/grid)*grid

    ; Ensure width is on grid
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid

    ; Experimental?
    if( (!cdfgData->experimental->value)
    then

        ; If width is less than minimum, set to Min
        if( (width < min_width)
        then
            width = min_width
            warn("WARNING: Minimum Width is %g M\n" min_width)
        ); if

        ; If width is greater than maximum, set to Max
        if( (width > max_width)
        then
            width = max_width
            warn("WARNING: Maximum Width is %g M\n" max_width)
        ); if

    ); Experimental

    ; Set Width
    cdfgData->w->value = sprintf(s "%g" width)

    ; Adjust Cap
    pragCapCapCalc()

  ); let
)

; ******************************************************************************
; pragCapLengthCallBack()
; sets: [l cap]
; ******************************************************************************

procedure( pragCapLengthCallBack()
  let( (grid length max_length min_length)

    ; Set Grid, Min & Max L values
    grid = pragVars->GridRes
    max_length = round(cdfParseFloatString(pragVars->capMaxL)/grid)*grid
    min_length = round(cdfParseFloatString(pragVars->capMinL)/grid)*grid

    ; Ensure length is on grid
    length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

    ; Experimental?
    if( (!cdfgData->experimental->value)
    then

        ; If length is less than minimum, set to Min
        if( (length < min_length)
        then
            length = min_length
            warn("WARNING: Minimum Length is %g M\n" min_length)
        ); if

        ; If length is greater than maximum, set to Max
        if( (length > max_length)
        then
            length = max_length
            warn("WARNING: Maximum Length is %g M\n" max_length)
        ); if

    ); Experimental

    ; Set Length
    cdfgData->l->value = sprintf(s "%g" length)

    ; Adjust Cap
    pragCapCapCalc()

  ); let
)

; ******************************************************************************
; SUBFUNCTIONS
; ******************************************************************************

; Calculates Cap, Area and Perimeter
procedure( pragCapCapCalc()
  let( (grid width length cap etch )

    grid = pragVars->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

    cap = 0.0027 ;Value from defines_<tech> file
    ;capsw = cdfParseFloatString(pragVars->capUnitSideWall)
    etch = cdfParseFloatString(pragVars->capEtch)

    cdfgData->c->value = sprintf(s "%g" ( (length - 2*etch) * (width - 2*etch) * cap ) )
    cdfgData->area->value = sprintf(s "%g" ( length * width ))
    cdfgData->perim->value = sprintf(s "%g" ( 2 * (length + width) ))
  ) ; let
)

; Calculates Area
procedure( pragCapAreaCalc()
  let( (grid width length)

    grid = pragVars->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

    cdfgData->area->value = sprintf(s "%g" ( length * width ) )
  ) ; let
)

; Calculates Perimeter
procedure( pragCapPerimCalc()
  let( (grid width length)

    grid = pragVars->GridRes
    width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
    length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

    cdfgData->perim->value = sprintf(s "%g" ( 2 * (length + width) ))
  ) ; let
)
