; Original address was $B442
; "Unused Level 4" entrance
	.word Unused4_InnerL	; Alternate level layout
	.word Unused4_InnerO	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $80, $00, $1F, $0C, $90, $00, $10, $0C, $91, $00, $70, $04, $92
	.byte $00, $58, $04, $97, $05, $53, $02, $9A, $08, $50, $07, $71, $05, $00, $17, $08
	.byte $52, $9A, $0B, $80, $03, $80, $0E, $5F, $11, $90, $0D, $B6, $01, $90, $0F, $5A
	.byte $10, $96, $0C, $B0, $00, $00, $0D, $DF, $10, $0D, $D0, $91, $0D, $40, $00, $17
	.byte $0F, $E2, $18, $0D, $0F, $18, $0E, $0F, $E0, $68, $20, $90, $03, $D1, $90, $0A
	.byte $D1, $FF
