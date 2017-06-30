; Original address was $B332
; Beginning of 7-6
	.word W706_MazeL	; Alternate level layout
	.word W706_MazeO	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_08 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $35, $0A, $F3, $55, $0B, $23, $57, $00, $28, $57, $09, $2B, $39, $00, $FE, $39
	.byte $0F, $F4, $56, $01, $B0, $02, $11, $03, $E2, $12, $08, $E2, $10, $0E, $E2, $40
	.byte $14, $BF, $0D, $50, $14, $BA, $0D, $15, $14, $04, $58, $22, $27, $58, $2A, $2C
	.byte $56, $22, $2C, $54, $22, $21, $1A, $22, $C0, $30, $14, $29, $E2, $16, $32, $E2
	.byte $40, $39, $09, $E1, $F8, $27, $FF
