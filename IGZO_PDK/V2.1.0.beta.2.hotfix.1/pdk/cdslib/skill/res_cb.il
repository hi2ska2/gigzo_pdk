printf("---> yod res_cb.il\n")

; ******************************************************************************
; pragResResCallBack()
; sets: [l w]
; ******************************************************************************

procedure( pragResResCallBack()
let( (grid width length res max_width min_width tmp nt max_length stripLen)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
;	max_width = round(cdfParseFloatString(pragVars->resMaxW)/grid)*grid
	max_width = round(75.0u/grid)*grid
	min_length = round(3.0u/grid)*grid
	min_width = round(1.4u/grid)*grid
	max_length = round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid
	nt = round(cdfParseFloatString(cdfgData->nt->value))
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid

	if( cdfgData->shape->value=="Straight"
	then
		min_length = round(3.0u/grid)*grid
	)
	if( (cdfgData->shape->value=="Oxbow") || (cdfgData->shape->value=="Meander")  
	then
		stripLen=(length-(nt+2)*1.4u)/(nt+1)
		stripLen=round(stripLen/grid)*grid
	)
	if( cdfgData->shape->value=="Serpentine"
	then
;		stripLen=(length-(nt+2)*1.7u)/(nt+2) 
		stripLen=(length-(nt+2)*1.4u+width*(nt-1))/(2*nt)
		stripLen=round(stripLen/grid)*grid
	)
;	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
;	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid

	res = cdfParseFloatString(cdfgData->r->value)
	rsh = 200000 ;Value from defines_<tech> file

	etchl = cdfParseFloatString(pragVars->resEtchL)
	etch = cdfParseFloatString(pragVars->resEtch)

	tmp = res/rsh * (width - 2*etch) + 2*etchl
	; rsh is modified for corners by rsh' = (rsh/100) * (100-98c/L) see the DM
	; Note that the following equations are only valid since etchl=0
	if( cdfgData->shape->value=="Oxbow" || cdfgData->shape->value=="Serpentine"
	then
		tmp = (res*100*(width-2*etch) + rsh*98e-6*((2*nt)+2)) / ( rsh*100 ) + 2*etchl
	)
	if( cdfgData->shape->value=="Meander"
	then
		tmp = (res*100*(width-2*etch) + rsh*98e-6*(2*nt)) / ( rsh*100 ) + 2*etchl
	)
	; Ensure length is on grid
	length = round(tmp/grid)*grid

	; Check min and max
	if( cdfgData->shape->value=="Straight"
	then
		if( (length < min_length)
		then
			warn("Minimum length is %g M\n" min_length)
			length = min_length
		); min check
		if( (length > max_length)
		then
			warn("Maximum length is %g M\n" max_length)
			length = max_length
		); max check
	else
		if( (stripLen < min_length)
		then
			warn("Minimum single strip length is %g M\n" min_length)
			stripLen = min_length
			if( cdfgData->shape->value=="Serpentine"
			then
;				length=stripLen*(nt+2)+(nt+2)*1.4u
				length=stripLen*2+(nt+2)*1.4u+((2*stripLen)-width)*(nt-1)
			else
				length=stripLen*(nt+1)+(nt+2)*1.4u
			)
		) ;min check
		if( (stripLen > max_length)
		then
			warn("Maximum single strip length is %g M\n" max_length)
			stripLen = max_length
			if( cdfgData->shape->value=="Serpentine"
			then
;				length=stripLen*(nt+2)+(nt+2)*1.4u
				length=stripLen*2+(nt+2)*1.4u+((2*stripLen)-width)*(nt-1)
			else
				length=stripLen*(nt+1)+(nt+2)*1.4u
			)
		) ;max check		
	) ;if
	; Set length & nt
;	cdfgData->nt->value = sprintf(s "%d" nt)
	cdfgData->l->value = sprintf(s "%g" length)

	; Recalculate the resistance
	pragResResCalc()
); let
)

; ******************************************************************************
; pragResShapeCallBack()
; sets: [Shape]
; ******************************************************************************

procedure( pragResShapeCallBack()
let( (grid width length shape nt nc)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	nt = round(cdfParseFloatString(cdfgData->nt->value))
	nc = round(cdfParseFloatString(cdfgData->nc->value))
	shape = cdfgData->shape->value
	sp = 1.4u
	if( (shape=="Oxbow" && ((length-(nt+2)*sp)/width)<(2*nt+2)) || (shape=="Serpentine" && ((length-(nt+2)*sp)/width)<(3*nt+1)) || (shape=="Meander" && ((length-(nt+2)*sp)/width)<(2*nt+2))
		then
			warn("Resistor too short for selected shape -- Resetting to \"Straight\" shape")
			if(shape=="Oxbow" then
				nc = 4
				nt = (nc-2)/2
			)
			if(shape=="Serpentine" then
				nc = 6
				nt = (nc-2)/2
			)
			if(shape=="Meander" then
				nc = 4
				nt = nc/2
			)
			shape = "Straight"
			
	)
	cdfgData->shape->value = sprintf(s "%s" shape)
	cdfgData->nc->value = sprintf(s "%d" nc)
	cdfgData->nt->value = sprintf(s "%d" nt)

	pragResResCalc()

); let
)
; ******************************************************************************
; pragResNcCallBack()
; sets: [l res]
; ******************************************************************************
procedure( pragResNcCallBack()
let( (nc nt)

	nc = round(cdfParseFloatString(cdfgData->nc->value))
	nt = round(cdfParseFloatString(cdfgData->nt->value))
	minNc = 4
	minNt = 1
	maxNc = 16
	;check for min no.of corners
	if(cdfgData->shape->value=="Oxbow" 
	then
		if(nc<minNc
		then
			nc = minNc
			nt = minNt
			warn("Minimum 90-degree-Corners is %L\n" minNc)
		)
		if(nc>maxNc
		then
			warn("90-degree-Corners is not characterised above %L\n" maxNc)
		)
		rem = remainder(nc 4)
		if(!zerop(rem)
		then
			warn("Only Multiples of %L allowed for 90-degree-Corners" minNc)
;			warn("Reverting 90-degree-Corners to minimum 90-degree-Corners %L\n" minNc)
;		 	nc = minNc	
			case( rem
				( 1 	nc = nc+3)
				( 2 	nc = nc+2)
				( 3     nc = nc+1)
				) ;case	
;			nc = nc+4	
			warn("Reverting 90-degree-Corners to next valid value: %L\n" nc)
		)
		nt = (nc-2)/2
	)

	if(cdfgData->shape->value=="Serpentine"
	then
		minNc  = 6
		minNt  = 2
		if(nc<minNc
		then
			nc = minNc
			nt = minNt
			warn("Minimum 90-degree-Corners is %L\n" minNc)
		)
		if(nc>maxNc
		then
			warn("90-degree-Corners is not characterised above %L\n" maxNc)
		)
		rem = remainder(nc 2)
		if(!zerop(rem)
		then
			warn("Only Multiples of %L allowed for 90-degree-Corners" minNt)
;			warn("Reverting 90-degree-Corners to minimum 90-degree-Corners %L\n" minNc)
		 	nc = nc+1	
			warn("Reverting 90-degree-Corners to next valid value: %L\n" nc)
		)
		nt = (nc-2)/2
	)
	
	if(cdfgData->shape->value=="Meander"
	then
		minNt  = 2
		if(nc<minNc
		then
			nc = minNc
			nt = minNt
			warn("Minimum 90-degree-Corners is %L\n" minNc)
		)
		if(nc>maxNc
		then
			warn("90-degree-Corners is not characterised above %L\n" maxNc)
		)
		rem = remainder(nc 4)
		if(!zerop(rem)
		then
			warn("Only Multiples of %L allowed for 90-degree-Corners" minNc)
;			warn("Reverting 90-degree-Corners to minimum 90-degree-Corners %L\n" minNc)
			case( rem
				( 1 	nc = nc+3)
				( 2 	nc = nc+2)
				( 3     nc = nc+1)
			) ;case	
			warn("Reverting 90-degree-Corners to next valid value: %L\n" nc)	
;		 	nc = minNc	
;			nt = minNt
		)
		nt = nc/2
	)

	cdfgData->nc->value = sprintf(s "%d" nc)
	cdfgData->nt->value = sprintf(s "%d" nt)

	; Adjust res
	pragResLengthCallBack()

); let
)


; ******************************************************************************
; pragResNtCallBack()
; sets: [l res]
; ******************************************************************************
procedure( pragResNtCallback()
let( (nt minNt)
	nt = round(cdfParseFloatString(cdfgData->nt->value))
	;check for min no.of turns
	if(cdfgData->shape->value=="Meander" || cdfgData->shape->value=="Serpentine"
	then
		minNt = 2
		if(nt<minNt
		then
		 nt = minNt
		)
	else
		minNt = 1
		if(nt<minNt 
		then
		 nt = minNt
		)	
	)
	if(cdfgData->shape->value=="Meander" && oddp(nt)
	then
			nt = nt+1
			warn("Only Even turns allowed resetting to next even value %L\n" nt)
	)		
	if(cdfgData->shape->value=="Oxbow" && evenp(nt)
	then
			nt = nt+1
			warn("Only Odd turns allowed resetting to next odd value %L\n" nt)
	)
	if(cdfgData->shape->value=="Serpentine" 
	then
			if(onep(nt)
			then
				nt = nt+1
				warn("Min no. of turns for the shape is  %L\n" nt)
			)
	)
	cdfgData->nt->value = sprintf(s "%d" nt)

	; Adjust res
;	pragResLengthCallBack()
	pragResNcCallBack()

); let
)

; ******************************************************************************
; pragResWidthCallBack()
; sets: [w res]
; ******************************************************************************

procedure( pragResWidthCallBack()
let( (grid width max_width min_width)

	; Set Grid, Min & Max W values
	grid = pragVars->GridRes
;	max_width = round(cdfParseFloatString(pragVars->resMaxW)/grid)*grid
	max_width = round(75.0u/grid)*grid
	min_width = round(1.4u/grid)*grid

	; Ensure width is on grid
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid

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
;	pragResResCalc()
	pragResShapeCallBack()

); let
)

; ******************************************************************************
; pragResLengthCallBack()
; sets: [l res]
; ******************************************************************************

procedure( pragResLengthCallBack()
let( (grid length max_length min_width min_length tmp)

	; Set Grid, Min & Max L values
	grid = pragVars->GridRes
	min_width = round(1.4u/grid)*grid
	max_length = round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid
	min_length = round(3.0u/grid)*grid
	nt = round(cdfParseFloatString(cdfgData->nt->value))

	; Ensure length is on grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	nt = round(cdfParseFloatString(cdfgData->nt->value))
	; Check min and max
;	if( cdfgData->shape->value=="Straight"
;	then
;		min_length = round(3.0u/grid)*grid
;	)
;	if( cdfgData->shape->value=="Oxbow"  
;	then
;		min_length = 4*min_width+(nt+2)*1.4u
;	)
;	if( cdfgData->shape->value=="Serpentine"
;	then
;		min_length = 7*min_width+(nt+2)*1.4u
;	)
;	if( cdfgData->shape->value=="Meander"
;	then
;		min_length = 6*min_width+(nt+2)*1.4u
;	)
	; Set length
;	cdfgData->l->value = sprintf(s "%g" length)
	pragResShapeCallBack()

); let
)

; ******************************************************************************
; SUBFUNCTIONS
; ******************************************************************************

; Calculates Res
procedure( pragResResCalc()
let( (grid width length rsh etchl etch tmp nt max_length stripLen)

	grid = pragVars->GridRes
	width = round(cdfParseFloatString(cdfgData->w->value)/grid)*grid
	length = round(cdfParseFloatString(cdfgData->l->value)/grid)*grid
	max_length = round(cdfParseFloatString(pragVars->resMaxL)/grid)*grid
	min_length = round(3.0u/grid)*grid
	nt = round(cdfParseFloatString(cdfgData->nt->value))

	if( cdfgData->shape->value=="Straight"
	then
		min_length = round(3.0u/grid)*grid
	)
	if( (cdfgData->shape->value=="Oxbow") || (cdfgData->shape->value=="Meander")  
	then
		stripLen=(length-(nt+2)*1.4u)/(nt+1) 
		stripLen=round(stripLen/grid)*grid
	)
	if( cdfgData->shape->value=="Serpentine"
	then
;		stripLen=(length-(nt+2)*1.4u)/(nt+2) 
		stripLen=(length-(nt+2)*1.4u+width*(nt-1))/(2*nt)
		stripLen=round(stripLen/grid)*grid
	)
	; Length rounding
	if( cdfgData->shape->value=="Oxbow"
	then
		tmp=(length-(nt+2)*1.4u)/(nt+1) 
		tmp=round(tmp/grid)*grid
		length=tmp*(nt+1)+(nt+2)*1.4u
;		cdfgData->l->value = sprintf(s "%g" length)
	)
	if( cdfgData->shape->value=="Serpentine"
	then
;		tmp=(length-(nt+2)*1.4u)/(nt+2)
;		tmp=round(tmp/grid)*grid
;		length=tmp*(nt+2)+(nt+2)*1.4u
;		cdfgData->l->value = sprintf(s "%g" length)
		tmp=(length-(nt+2)*1.4u+width*(nt-1))/(2*nt)
		tmp=round(tmp/grid)*grid
		length=tmp*2+(nt+2)*1.4u+((2*tmp)-width)*(nt-1)
	)
	if( cdfgData->shape->value=="Meander"
	then
		tmp=(length-(nt+2)*1.4u)/(nt+1)
		tmp=round(tmp/grid)*grid
		length=tmp*(nt+1)+(nt+2)*1.4u
;		cdfgData->l->value = sprintf(s "%g" length)
	)
	; Check min and max
	if( cdfgData->shape->value=="Straight"
	then
		if( (length < min_length)
		then
			warn("Minimum length is %g M\n" min_length)
			length = min_length
		); min check
		if( (length > max_length)
		then
			warn("Maximum length is %g M\n" max_length)
			length = max_length
		); max check
	else
		if( (stripLen < min_length)
		then
			warn("Minimum single strip length is %g M\n" min_length)
			stripLen = min_length
			if( cdfgData->shape->value=="Serpentine"
			then
;				length=stripLen*(nt+2)+(nt+2)*1.4u
				length=stripLen*2+(nt+2)*1.4u+((2*stripLen)-width)*(nt-1)
			else
				length=stripLen*(nt+1)+(nt+2)*1.4u
			)
		) ;min check
		if( (stripLen > max_length)
		then
			warn("Maximum single strip length is %g M\n" max_length)
			stripLen = max_length
			; revert the no.of turns to nearest lower value
			if( cdfgData->shape->value=="Serpentine"
			then
;				if(((nt>1) && (nt!=2)) then
;					nt = nt-1
;				else
;					nt = nt
;				)
;				length=stripLen*(nt+2)+(nt+2)*1.7u
				length=stripLen*2+(nt+2)*1.4u+((2*stripLen)-width)*(nt-1)
			else
;				if(nt>1 then
;					nt = nt-2
;				else
;					nt = nt
;				)
				length=stripLen*(nt+1)+(nt+2)*1.4u
			)
;			; check for nt=0 
;			if(zerop(nt)
;			then
;				when(cdfgData->shape->value=="Oxbow" 
;					nt = nt+1
;				)
;				nt = nt+2
;			) ;if
;			warn("Resetting the No. of turns to lower value %L\n" nt)
		) ;max check
	)

	; Set length & nt
	cdfgData->nt->value = sprintf(s "%d" nt)	
	cdfgData->l->value = sprintf(s "%g" length)

	rsh = 200000 ;Value from defines_<tech> file

	if( cdfgData->shape->value=="Oxbow" || cdfgData->shape->value=="Serpentine"
		rsh = rsh * (100-98e-6*((2*nt)+2)/length)/100
	)
	if( cdfgData->shape->value=="Meander"
		rsh = rsh * (100-98e-6*(2*nt)/length)/100
	)
	etchl = cdfParseFloatString(pragVars->resEtchL)
	etch = cdfParseFloatString(pragVars->resEtch)

	tmp = ( (length - 2*etchl) / (width - 2*etch) ) * rsh

	cdfgData->r->value = sprintf(s "%g" tmp )
)
)
