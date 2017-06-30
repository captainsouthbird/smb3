; Original address was $B382
; Beginning of 7-4
	.word W704_WaterL	; Alternate level layout
	.word W704_WaterO	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_06 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $4F, $13, $07, $E2, $14, $02, $E2, $14, $0B, $E2, $19, $01, $92
	.byte $16, $04, $00, $38, $0B, $E2, $37, $0D, $92, $40, $00, $B0, $23, $4C, $0F, $BD
	.byte $08, $E0, $53, $20, $4B, $13, $B0, $01, $50, $18, $B0, $00, $51, $18, $B8, $01
	.byte $53, $1A, $B6, $01, $55, $1C, $B4, $01, $40, $24, $BF, $0B, $50, $24, $B9, $0B
	.byte $32, $21, $0B, $36, $21, $0B, $11, $31, $E2, $13, $37, $E3, $15, $34, $E2, $58
	.byte $30, $22, $19, $34, $91, $16, $36, $00, $40, $3C, $09, $FF
