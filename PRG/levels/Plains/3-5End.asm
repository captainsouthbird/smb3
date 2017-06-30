; Original address was $AEFA
; 3-5 end
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $58, $00, $82, $0F, $40, $00, $BF, $01, $50, $00, $BA, $01, $5A, $00, $B0, $05
	.byte $54, $00, $21, $12, $05, $E2, $13, $0B, $E2, $1A, $10, $C0, $20, $17, $11, $01
	.byte $19, $16, $91, $38, $10, $40, $39, $10, $40, $40, $19, $09, $FF
