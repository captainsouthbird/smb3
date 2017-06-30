; Original address was $B372
; World 4's Big [?] block area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $40, $20, $B1, $0F, $42, $20, $B7, $00, $4A, $20, $B5, $0F, $42
	.byte $2F, $B7, $00, $50, $20, $B8, $00, $50, $2F, $B8, $00, $59, $20, $B1, $0F, $2A
	.byte $21, $10, $2B, $21, $10, $2C, $21, $10, $2D, $21, $10, $2E, $21, $10, $2F, $21
	.byte $10, $30, $22, $D5, $30, $2D, $C5, $24, $23, $89, $26, $23, $89, $28, $23, $89
	.byte $40, $30, $BF, $0F, $50, $30, $B8, $00, $50, $3F, $B8, $00, $59, $30, $B1, $0F
	.byte $30, $32, $D5, $30, $3D, $C5, $E2, $51, $86, $E3, $61, $03, $FF
