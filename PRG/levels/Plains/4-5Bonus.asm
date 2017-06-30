; Original address was $AF30
; 4-5 bonus room and unused exit
	.word W405L	; Alternate level layout
	.word W405O	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $BF, $21, $50, $00, $BA, $00, $5A, $00, $B0, $10, $50, $0E, $BA, $13
	.byte $37, $05, $92, $37, $09, $13, $59, $0D, $08, $1A, $20, $D0, $2F, $58, $22, $22
	.byte $19, $27, $93, $16, $2B, $00, $12, $27, $E2, $13, $30, $E2, $19, $30, $93, $40
	.byte $39, $09, $E0, $12, $75, $FF
