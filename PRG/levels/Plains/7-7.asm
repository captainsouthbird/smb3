; Original address was $AAA8
; AADF
	.word W707_MainL	; Alternate level layout
	.word W707_MainO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_04 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_200

	.byte $40, $00, $B0, $15, $41, $00, $BF, $00, $51, $00, $B8, $00, $41, $0F, $BF, $06
	.byte $51, $0F, $B8, $06, $1A, $00, $C0, $3F, $0E, $08, $E2, $0F, $03, $E2, $19, $06
	.byte $92, $38, $0C, $E2, $58, $16, $22, $40, $28, $09, $E0, $73, $20, $FF
