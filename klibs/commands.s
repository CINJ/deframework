

.pseudocommand mov src:tar {
	lda src
	sta tar
}

.pseudocommand mox src:tar {
	ldx src
	stx tar
}

.pseudocommand moy src:tar {
	ldy src
	sty tar
}

.function _16bit_nextArgument(arg) {
	.if (arg.getType()==AT_IMMEDIATE)
		.return CmdArgument(arg.getType(),>arg.getValue())
	.return CmdArgument(arg.getType(),arg.getValue()+1)
}

.pseudocommand inc16 arg {
	inc arg
	bne over
	inc _16bit_nextArgument(arg)
over:
}
.pseudocommand mov16 src:tar {
	lda src
	sta tar
	lda _16bit_nextArgument(src)
	sta _16bit_nextArgument(tar)
}
.pseudocommand add16 arg1 : arg2 : tar {
	.if (tar.getType()==AT_NONE) .eval tar=arg1
	lda arg1
	adc arg2
	sta tar
	lda _16bit_nextArgument(arg1)
	adc _16bit_nextArgument(arg2)
	sta _16bit_nextArgument(tar)
}

.macro waitX(count) {
	ldx #count
!loop:
	dex
	bne !loop-
}


//Make accumulator negative value
.pseudocommand neg {
	clc
	eor #%11111111
	adc #$00
}

//absolute value of the accumulator
.pseudocommand abs {
	cmp #$80
	bmi !skip+
	clc
	eor #%11111111
	adc #$00
!skip:
}

.pseudocommand sadc value {
	clc
	adc value
}

.pseudocommand ssbc value {
	sec
	sbc value
}

