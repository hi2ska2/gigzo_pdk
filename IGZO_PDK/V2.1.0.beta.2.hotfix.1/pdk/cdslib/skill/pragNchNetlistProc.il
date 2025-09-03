printf("---> yod pragNchNetlistProc.il\n")

;------------------------------------------------------------------------
; Mostly this is the standard netlist procedure, except add a 0 at the end
; for the bulk node
;------------------------------------------------------------------------
procedure(pragNchNetlistProc(inst)
    let((formatter netlister sigs)
        formatter=nlGetFormatter(inst)
        netlister=nlGetNetlister(formatter)
        nlPrintInstComments(formatter inst)
        nlPrintIndentString(netlister)
        nlPrintInstName(formatter inst)
        ; nlPrintInstSignals( formatter inst)
        when(sigs=nlGetSignalList(inst)
            nlPrintString(netlister "( ")
            foreach(sig sigs
                nlPrintString(netlister sig " ")
            )
            nlPrintString(netlister "0 )")
        )
        nlPrintModelName(formatter inst)
        nlPrintInstParameters(formatter inst)
        t
    )
)

