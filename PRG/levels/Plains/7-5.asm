; Original address was $BCE9
; Beginning of 7-5
	.word W705_UnderL	; Alternate level layout
	.word W705_UnderO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $3F, $40, $00, $B0, $0F, $36, $08, $93, $38, $05, $E2, $58, $0A
	.byte $12, $19, $02, $91, $19, $0E, $91, $12, $08, $E2, $13, $02, $E2, $15, $0B, $E2
	.byte $40, $10, $BF, $0F, $50, $10, $B9, $0F, $19, $21, $95, $37, $24, $A2, $17, $27
	.byte $01, $11, $21, $E2, $12, $28, $E2, $14, $25, $E2, $40, $2C, $09, $E0, $52, $20
	.byte $FF
