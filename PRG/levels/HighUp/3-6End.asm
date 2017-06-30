; Original address was $AA3D
; 3-6 end
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(4) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $2F, $09, $D1, $17, $07, $10, $04, $16, $08, $42, $18, $08, $04, $18, $0A, $04
	.byte $18, $0E, $10, $05, $17, $0F, $43, $19, $0F, $04, $19, $12, $04, $1A, $16, $10
	.byte $20, $40, $19, $09, $FF
