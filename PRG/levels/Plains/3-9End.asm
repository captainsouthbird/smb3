; Original address was $B312
; Generic pipe exit sandy sky
	.word W309L	; Alternate level layout
	.word W309O	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $20, $13, $01, $E2, $12, $07, $E3, $19, $00, $96, $37, $03, $A2
	.byte $17, $07, $01, $40, $0C, $09, $FF
