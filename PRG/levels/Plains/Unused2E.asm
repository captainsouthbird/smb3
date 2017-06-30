; Original address was $BD88

	.word W307_CoinHeavL	; Alternate level layout
	.word W307_CoinHeavO	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $5F, $12, $06, $02, $17, $04, $01, $16, $0E, $00, $38, $19, $E2
	.byte $E1, $63, $20, $4A, $1C, $BF, $18, $58, $35, $22, $17, $3C, $01, $16, $40, $00
	.byte $19, $46, $95, $40, $4F, $09, $FF
