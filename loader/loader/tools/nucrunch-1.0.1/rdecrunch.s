;
; NuCrunch 0.1
; Christopher Jam
; February 2016
;

; next byte is fetched from mem[ mem[zps+1]*256+(mem[zps]-1)%256 ]
; ie, init pointer to start byte then increment low byte of pointer.
; Low byte is decremented before each fetch, then if it hits zero the high byte is predecremented for the next fetch
; note that getByte requires y to be zero
; also note that this mangled pointer is a tad inimical to the literal fetches -/

.export decrunch_next_group
.export decrunch
.export decrunch_end

.macro getByte0
	dec zps+0
	bne *+7
	jsr nextPage
	bvc *+4
	lda (zps),y
.endmacro

.macro _getByte0
	bit zps+0
	bne *+4
	dec zps+1
	dec zps+0
	lda (zps),y
.endmacro

.if 0
.define getByte1 jsr get_byte
.else
.define getByte1 getByte0
.endif


.macro getBit1
.local nomore
	asl zbs1
	bne nomore
	getByte1
	sec
	rol
	sta zbs1
nomore:
.endmacro

; get head of a pair of bits from the bitpair stream
; (must getBit2t precisely once before invoking again)

.macro getBit2h
.local nomore
	asl zbs2
	bne nomore
	getByte1
	sec
	rol
	sta zbs2
nomore:
.endmacro

; same, but preserving A/ trashing X.
.macro getBit2hpa
.local nomore
	asl zbs2
	bne nomore
	tax
	getByte1
	sec
	rol
	sta zbs2
	txa
nomore:
.endmacro

.macro getBit2t
	asl zbs2
.endmacro

; get head of a quad of bits from the quad stream
; (must getBit4t precisely three times before invoking again)

.macro getBit4h
.local nomore
	asl zbs4
	bne nomore
	getByte1
	sec
	rol
	sta zbs4
nomore:
.endmacro


; get tail of a quad of bits from the quad stream
.macro getBit4t
	asl zbs4
.endmacro

; note, trashes X.  Also, carry is clear when done
.macro getExpGoulombTail
.local ndone
ndone:
	getBit2hpa
	rol
	getBit2t
	bcs ndone
.endmacro

.macro getExpGoulombTail_odd_aligned
.local ndone
ndone:
	getBit2t
	rol
	getBit2hpa
	bcs ndone
.endmacro


decrunch_zpa =$e0   ;7 bytes required


zps      = decrunch_zpa+$00
zbs1     = decrunch_zpa+$02
zbs2     = decrunch_zpa+$03
zbs4     = decrunch_zpa+$04
offsetm1 = decrunch_zpa+$05



decrunch:

	stx zps+0
	sta zps+1
	ldy #0
	sty zbs1
	sty zbs2
	sty zbs4


decrunch_next_group:
	ldy #0
next_segment:
	jsr get_byte
	sta copy_dst+1
	jsr get_byte
	sta copy_dst+2

decode_literal:

getEG0p1:   ;get count [eg0+1] in x
	ldx#1
	getBit1
	lda#1
	bcc ret1
	lda#1
	getExpGoulombTail
	tax
ret1:
	txa
	sec
	eor#255
	adc copy_dst+1
	sta copy_dst+1
	sta literal_dst+1
	bcs *+5
	dec copy_dst+2
	lda copy_dst+2
	sta literal_dst+2



literal_loop:
literal_src:
	getByte1
literal_dst:
	sta $f000,x
	dex
	bne literal_loop


	; literal is always followed by copy

decode_copy:
	getBit2h
	bcc short_offset
	lda#1
	getExpGoulombTail_odd_aligned
	adc#255
	sta offsetm1+1
	getByte1
	jmp got_high

short_offset:
	lda#0
	sta offsetm1+1

	;ExpGoulomb k=3
	getBit4h
	lda#1
	bcc no_tail
	getExpGoulombTail_odd_aligned
no_tail:
	adc#255

	getBit4t
	rol
	getBit4t
	rol
	getBit4t
	rol
got_high:
	sta offsetm1

	ldx#2
	getBit2t
	bcc length_two
	lda#1
	getExpGoulombTail
	tax
	inx
	beq end_of_segment  ; copy length of 256 marks end of segment
length_two:

	txa
	eor#255
	sec
	adc copy_dst+1
	sta copy_dst+1
	bcs *+6
	dec copy_dst+2
	sec

	; note carry is set at this point; good as we want to add (offsetm1+1)
	lda copy_dst+1
	adc offsetm1
	sta copy_src+1

	lda copy_dst+2
	adc offsetm1+1
	sta copy_src+2

copy_loop:
copy_src:
	lda $f000,x
copy_dst:
	sta $f000,x
	dex
	bne copy_loop


	ldy#0
	getBit1
	bcs jmp_decode_copy
	jmp decode_literal
jmp_decode_copy:
	jmp decode_copy

get_byte:
	getByte0
end_of_file:
	rts
end_of_segment:
	lda offsetm1
	cmp#0
	beq end_of_file
	jmp next_segment
nextPage:
	lda (zps),y
	dec zps+1
	clv
	rts

