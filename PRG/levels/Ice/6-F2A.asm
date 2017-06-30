; Original address was $AC98
; World 6 second fortress boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_10 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6F, $00, $82, $71, $00, $82, $73, $00, $82, $75, $00, $82, $77, $00, $82, $79
	.byte $00, $8F, $6F, $06, $1F, $6F, $16, $19, $70, $06, $84, $72, $06, $84, $74, $06
	.byte $84, $6F, $1F, $10, $70, $1F, $10, $71, $1F, $10, $72, $1F, $10, $73, $1F, $10
	.byte $74, $1F, $10, $75, $1F, $10, $76, $1F, $10, $77, $1F, $10, $78, $1F, $10, $75
	.byte $14, $10, $73, $18, $10, $76, $1B, $13, $FF
