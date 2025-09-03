printf("---> yod nch_cb.il\n")

; ******************************************************************************
; pragNchWidthCallBack()
; ******************************************************************************

procedure( pragNchWidthCallBack()
let( (grid width max_width min_width notchmultiplier subwidth finger notchmult fing)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
	max_width = round(cdfParseFloatString(pragVars->nchMaxW)/grid)*grid
	min_width = round(cdfParseFloatString(pragVars->nchMinW)/grid)*grid
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid

	notchmultiplier=cdfParseFloatString(cdfgData->nm->value)
	notchmult=round(notchmultiplier)

	fingers=cdfParseFloatString(cdfgData->f->value)
	fing=round(fingers)
	
	; Experimental?
    	when( (!cdfgData->experimental->value)
       		; If width is not minimum, set to minimum
        	when( ( width/(notchmult*fing) < 2.0u || width/(notchmult*fing) > 20.0u)
            		width = 2.0u * notchmult * fing
			cdfgData->w->value = sprintf(s "%g" width)
           		warn("Subwidth can only be within 2.0-20.0u when not in experimental mode")
        	); when
    	); Experimental
	
	; Set subwidth
	subwidth=width/notchmult/fing
	subwidth = round(subwidth/grid)*grid
	width = subwidth * notchmult * fing
	
	
	;run calc
	;pragNchWidthCalc()
	
	cdfgData->ns->value = sprintf(s "%g" subwidth)
	cdfgData->w->value = sprintf(s "%g" width)

); let
)

; ******************************************************************************
; pragNchLengthCallBack()
; ******************************************************************************

procedure( pragNchLengthCallBack()
let( (grid length max_length min_length)

	; Set Grid, Min & Max L values
	grid = pragVars->GridRes
	max_length = round(cdfParseFloatString(pragVars->nchMaxL)/grid)*grid
	min_length = round(cdfParseFloatString(pragVars->nchMinL)/grid)*grid

	; Ensure length is on grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

	; Experimental?
    	when( (!cdfgData->experimental->value)
        	; If length is not minimum, set to minimum
        	when( (length < 0.6u || length > 5.0u)
            		length = 0.6u
			;length_value = 800n
            		warn("Length can only be within 0.6-5.0u when not in experimental mode")
        	); when
    	); Experimental

	; Set Length
	cdfgData->l->value = sprintf(s "%g" length) 

); let
)

; ******************************************************************************
; pragNchNotchMultiplierCallBack()
; ******************************************************************************

procedure( pragNchNotchMultiplierCallBack()
let( (grid width notchmultiplier subwidth finger notchmult fing)

	grid = pragVars->GridRes
	subwidth = round(cdfParseFloatString(cdfgData->ns->value)/grid)*grid

	notchmultiplier=cdfParseFloatString(cdfgData->nm->value)
	notchmult=round(notchmultiplier)

	if( notchmult<1
	then
		notchmult=1
	)

	fingers=cdfParseFloatString(cdfgData->f->value)
	fing=round(fingers)

	width=subwidth*notchmult*fing

	; Set width
	cdfgData->w->value = sprintf(s "%g" width)
	cdfgData->nm->value = sprintf(s "%d" notchmult)

); let
)

; ******************************************************************************
; pragNchNotchSubwidthCallBack()
; ******************************************************************************

procedure( pragNchNotchSubwidthCallBack()
let( (grid width notchmultiplier subwidth finger notchmult fing)

	grid = pragVars->GridRes
	subwidth = round(cdfParseFloatString(cdfgData->ns->value)/grid)*grid

	notchmultiplier=cdfParseFloatString(cdfgData->nm->value)
	notchmult=round(notchmultiplier)
	
	; Experimental?
    	when( (!cdfgData->experimental->value)
        	; If subwidth is not minimum, set to minimum
        	when( (subwidth < 2.0u || subwidth > 20.0u)
            		subwidth = 2.0u
			cdfgData->ns->value = sprintf(s "%g" subwidth)
            		warn("Subwidth can only be within 2.0-20.0u when not in experimental mode")
        	); when
    	); Experimental

	fingers=cdfParseFloatString(cdfgData->f->value)
	fing=round(fingers)

	width=subwidth*notchmult*fing

	; Set width
	cdfgData->w->value = sprintf(s "%g" width)

); let
)

; ******************************************************************************
; pragNchNotchGapwidthCallBack()
; ******************************************************************************

procedure( pragNchNotchGapwidthCallBack()
let( (grid gapwidth)

	grid = pragVars->GridRes
	gapwidth = round(cdfParseFloatString(cdfgData->ng->value)/grid)*grid
	
	; Experimental?
    	when( (!cdfgData->experimental->value)
        	; If gapwidth is not minimum, set to minimum
        	when( (gapwidth < 2.0u)
            		gapwidth = 2.0u
			cdfgData->ng->value = sprintf(s "%g" gapwidth)
            		warn("gapwidth cannot be less than 2.0u when not in experimental mode")
        	); when
    	); Experimental


	; Set width
	cdfgData->ng->value = sprintf(s "%g" gapwidth)

); let
)

; ******************************************************************************
; pragNchFingerPitchCallBack()
; ******************************************************************************

procedure( pragNchFingerPitchCallBack()
let( (grid fingerpitch)

	grid = pragVars->GridRes
	fingerpitch = round(cdfParseFloatString(cdfgData->fp->value)/grid)*grid
	
	; Experimental?
    	when( (!cdfgData->experimental->value)
        	; If fingerpitch is not minimum, set to minimum
        	when( (fingerpitch < 9.8u)
            		fingerpitch = 9.8u
			cdfgData->fp->value = sprintf(s "%g" fingerpitch)
            		warn("fingerpitch cannot be smaller than 9.8u when not in experimental mode")
        	); when
    	); Experimental


	; Set width
	cdfgData->fp->value = sprintf(s "%g" fingerpitch)

); let
)

; ******************************************************************************
; pragNchFingersrCallBack()
; ******************************************************************************

procedure( pragNchFingersCallBack()
let( (grid width notchmultiplier subwidth finger notchmult fing)

	grid = pragVars->GridRes
	subwidth = round(cdfParseFloatString(cdfgData->ns->value)/grid)*grid

	notchmultiplier=cdfParseFloatString(cdfgData->nm->value)
	notchmult=round(notchmultiplier)

	fingers=cdfParseFloatString(cdfgData->f->value)
	fing=round(fingers)

	if( fing<1
	then
		fing=1
	)

	width=subwidth*notchmult*fing

	; Set width
	cdfgData->w->value = sprintf(s "%g" width)
	cdfgData->f->value = sprintf(s "%d" fing)

); let
)

; ******************************************************************************
; pragNchExperimentalCallBack()
; ******************************************************************************

procedure( pragExperimentalCallBack()
	;when( (!cdfgData->experimental->value)
	;	pragNchWidthCallBack()
	;	pragNchLengthCallBack()
	;	pragNchNotchSubwidthCallBack()
	;	pragNchNotchGapwidthCallBack()
	;	pragNchFingerPitchCallBack()
	;) ;when
	
	when( (cdfgData->experimental->value)
		cdfgData->experimental->value = nil
	) ;when
)

; ******************************************************************************
; pragNchWidthCalc()
; ******************************************************************************
;
;procedure( pragNchWidthCalc()
;let( (grid width notchmultiplier subwidth finger notchmult fing)
;	
;	grid = pragVars->GridRes
;	
;	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
;	; Set subwidth
;	subwidth=width/notchmult/fing
;	
;	subwidth = round(subwidth/grid)*grid
;	width = subwidth * notchmult * fing
;	
;	cdfgData->ns->value = sprintf(s "%g" subwidth)
;	cdfgData->w->value = sprintf(s "%g" width)
;
;); let
;)
