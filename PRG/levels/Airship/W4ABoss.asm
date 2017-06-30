; Original address was $AC42
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $00, $00, $4B, $06, $04, $F2, $06, $0B, $E3, $66, $05, $11, $66
	.byte $0C, $11, $07, $02, $E0, $67, $03, $10, $07, $09, $F1, $08, $01, $43, $08, $02
	.byte $43, $08, $06, $43, $08, $07, $63, $08, $0E, $E1, $68, $0F, $10, $09, $03, $62
	.byte $09, $05, $42, $09, $09, $42, $09, $0D, $F0, $0A, $0A, $61, $0A, $0B, $61, $0A
	.byte $0E, $61, $0A, $0F, $61, $0A, $0C, $61, $00, $0F, $4B, $FF
