/*
Fills, and macros to manipulate data
*/


.macro fill_1K(val, mem) {
	ldx #$00
	lda #val
loop:
	sta mem,x
	sta mem+$100,x
	sta mem+$200,x
	sta mem+$300,x
	dex
	bne loop
}

.macro fill_2K(val, mem) {
	ldx #$00
	lda #val
loop:
	sta mem,x
	sta mem+$100,x
	sta mem+$200,x
	sta mem+$300,x
	sta mem+$400,x
	sta mem+$500,x
	sta mem+$600,x
	sta mem+$700,x
	dex
	bne loop
}

.macro fill_4K(val, mem) {
	ldx #$00
	lda #val
loop:
	sta mem,x
	sta mem+$100,x
	sta mem+$200,x
	sta mem+$300,x
	sta mem+$400,x
	sta mem+$500,x
	sta mem+$600,x
	sta mem+$700,x
	sta mem+$800,x
	sta mem+$900,x
	sta mem+$a00,x
	sta mem+$b00,x
	sta mem+$c00,x
	sta mem+$d00,x
	sta mem+$e00,x
	sta mem+$f00,x
	dex
	bne loop
}

.macro fill_8K(val, mem) {
	ldx #$00
	lda #val
loop:
	sta mem,x
	sta mem+$100,x
	sta mem+$200,x
	sta mem+$300,x
	sta mem+$400,x
	sta mem+$500,x
	sta mem+$600,x
	sta mem+$700,x
	sta mem+$800,x
	sta mem+$900,x
	sta mem+$a00,x
	sta mem+$b00,x
	sta mem+$c00,x
	sta mem+$d00,x
	sta mem+$e00,x
	sta mem+$f00,x
	sta mem+$1000,x
	sta mem+$1100,x
	sta mem+$1200,x
	sta mem+$1300,x
	sta mem+$1400,x
	sta mem+$1500,x
	sta mem+$1600,x
	sta mem+$1700,x
	sta mem+$1800,x
	sta mem+$1900,x
	sta mem+$1a00,x
	sta mem+$1b00,x
	sta mem+$1c00,x
	sta mem+$1d00,x
	sta mem+$1e00,x
	sta mem+$1f00,x
	dex
	bne loop
}


//sinus libs
.function sinus(i, amplitude, center, noOfSteps) {
	.return round(center+amplitude*sin(toRadians(i*360/noOfSteps)))	
}

.function cosinus(i, amplitude, center, noOfSteps) {
	.return round(center+amplitude*cos(toRadians(i*360/noOfSteps)))	
}

.macro getRandom(delay) {
	lda #$ff  //; maximum frequency value
	sta $d40e //; voice 3 frequency low byte
	sta $d40f //; voice 3 frequency high byte
	lda #$80  //; noise waveform, gate bit off
	sta $d412 //; voice 3 control register
	ldx #delay
!delay:
	dex
	bne !delay-
	lda $d41b //; get the actual random number
}




