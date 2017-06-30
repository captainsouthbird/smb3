; Original address was $B6BA

	.word W802L	; Alternate level layout
	.word W802O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_14 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $BF, $01, $50, $00, $B9, $01, $1A, $00, $D0, $2F, $40, $04, $BF, $01
	.byte $4A, $06, $B0, $00, $4B, $06, $B4, $01, $4C, $08, $B0, $00, $4D, $08, $B2, $01
	.byte $4E, $0A, $B0, $00, $4F, $0A, $B0, $01, $40, $06, $B0, $29, $41, $0F, $BF, $01
	.byte $45, $0C, $B3, $03, $46, $0B, $B2, $00, $47, $0A, $B1, $00, $28, $09, $07, $51
	.byte $0E, $B8, $02, $52, $0D, $B7, $00, $53, $0C, $B6, $00, $54, $0B, $B5, $00, $55
	.byte $0A, $B4, $00, $56, $09, $B3, $00, $57, $08, $B2, $00, $58, $07, $B1, $00, $59
	.byte $06, $B0, $00, $20, $02, $D1, $20, $0D, $C2, $E0, $41, $39, $40, $10, $BF, $0F
	.byte $50, $10, $B9, $0F, $40, $20, $BF, $00, $50, $20, $B9, $00, $40, $2E, $BF, $01
	.byte $50, $2E, $B9, $01, $45, $21, $B0, $02, $28, $23, $89, $29, $23, $89, $2A, $23
	.byte $89, $2B, $23, $89, $2C, $23, $89, $2D, $23, $89, $2E, $23, $89, $2F, $23, $89
	.byte $30, $23, $89, $31, $23, $89, $20, $21, $D1, $38, $2D, $E1, $E2, $41, $39, $FF
