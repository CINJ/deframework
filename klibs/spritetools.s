/*
Sprite Font (stores each imported letter as a sprite)
You need to use the template stored in the /fonts dir 
Export as a PNG or GIF file and away you go...

*/

.macro _spriteFontReaderSinglecolor(filename, startAdr, charCount) {
    .var spriteData = List()
    .var pic = LoadPicture(filename)
	.for (var char=0; char<charCount; char++) {
	    .for (var row=0; row<21; row++) {
            .eval spriteData.add(pic.getSinglecolorByte((char * 3), row) ^ $ff)
            .eval spriteData.add(pic.getSinglecolorByte((char * 3)+1, row) ^ $ff)
            .eval spriteData.add(pic.getSinglecolorByte((char * 3)+2, row) ^ $ff)
        }
        .eval spriteData.add(0)
    }
	.pc = startAdr "sprite font"
	.fill spriteData.size(), spriteData.get(i)
}

.macro _spriteFontReaderMulticolor(filename, startAdr, charCount) {
    .var spriteData = List()
    .var pic = LoadPicture(filename)
	.for (var char=0; char<charCount; char++) {
	    .for (var row=0; row<21; row++) {
            .eval spriteData.add(pic.getMulticolorByte((char * 3), row) ^ $ff)
            .eval spriteData.add(pic.getMulticolorByte((char * 3)+1, row) ^ $ff)
            .eval spriteData.add(pic.getMulticolorByte((char * 3)+2, row) ^ $ff)
        }
        .eval spriteData.add(0)
    }
	.pc = startAdr "sprite font"
	.fill spriteData.size(), spriteData.get(i)
}
