; Original address was $BF28
; Pipe exit
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_07 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_09 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $37, $02, $A2, $16, $05, $04, $79, $08, $20, $11, $07, $0A, $13, $04, $0A, $40
	.byte $0A, $09, $FF
