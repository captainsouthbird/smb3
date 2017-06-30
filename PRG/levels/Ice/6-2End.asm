; Original address was $B381
; 6-2 end
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $5A, $00, $80, $07, $14, $03, $C2, $20, $08, $D3, $22, $08, $DE, $1A, $08, $10
	.byte $30, $16, $0F, $73, $18, $0C, $73, $14, $10, $C2, $40, $19, $09, $FF
