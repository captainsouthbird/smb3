; Original address was $B5E2
; World 7's Big [?] block area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $40, $40, $B4, $0F, $45, $40, $B8, $00, $4E, $40, $B1, $08, $50
	.byte $40, $B9, $00, $5A, $40, $B0, $05, $57, $46, $B3, $09, $55, $48, $B1, $07, $53
	.byte $4A, $B1, $05, $51, $4C, $B1, $03, $45, $4F, $BB, $00, $25, $4D, $C7, $30, $41
	.byte $D5, $40, $60, $BF, $00, $50, $60, $B8, $00, $59, $60, $B1, $0F, $40, $63, $BF
	.byte $0C, $50, $6F, $B8, $00, $20, $61, $D1, $30, $6D, $C4, $24, $62, $80, $25, $61
	.byte $80, $26, $62, $80, $27, $61, $80, $28, $62, $80, $29, $61, $80, $2A, $62, $80
	.byte $2B, $61, $80, $2C, $62, $80, $2D, $61, $80, $E4, $61, $29, $E6, $61, $C6, $FF
