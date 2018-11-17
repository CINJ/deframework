
.macro setBank(bank) {
	lda $dd00
	and #%11111100
	ora #[3-bank] 
	sta $dd00
}

.macro setD018bmp(screen, bmp) {
	lda #[[screen*16]+[bmp*8]]
	sta $d018
}

.macro setD018char(screen, char) {
	lda #[[screen*16]+[char*2]]
	sta $d018
}

.macro setD011(bmp, rsel, yscroll) {
	lda $d011
	and #%11010000
	ora #[bmp*32] + [[rsel^1]*8] + yscroll
	sta $d011
}

.macro setD016(mcol, csel, xscroll) {
	lda $d016
	and #%11100000
	ora #[mcol*16] + [[csel^1]*8] + xscroll
	sta $d016	
}

//new ones added from Kick src
.function screenToD018(addr) {
	.return ((addr&$3fff)/$400)<<4
}
.function charsetToD018(addr) {
	.return ((addr&$3fff)/$800)<<1
}
.function toD018(screen, charset) {
	.return screenToD018(screen) | charsetToD018(charset)
}

.function toSpritePtr(addr) {
	.return (addr&$3fff)/$40
}
