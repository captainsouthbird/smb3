; Original address was $BDB8

	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $1F, $10, $08, $E2, $12, $04, $E2, $38, $02, $A1, $19, $04, $96
	.byte $12, $06, $02, $40, $0C, $09, $FF
