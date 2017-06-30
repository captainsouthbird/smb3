; Original address was $BA4A
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $06, $01, $E0, $05, $02, $E2, $03, $03, $E4, $05, $04, $E3, $06
	.byte $05, $E2, $03, $06, $E2, $07, $07, $E0, $05, $09, $E2, $07, $0B, $E1, $06, $0C
	.byte $E0, $05, $0D, $E0, $06, $0E, $E1, $65, $03, $10, $63, $04, $10, $66, $04, $10
	.byte $65, $05, $10, $67, $05, $10, $66, $06, $10, $63, $07, $10, $67, $08, $10, $65
	.byte $0A, $10, $67, $0C, $10, $66, $0D, $10, $65, $0E, $10, $00, $00, $4B, $00, $0F
	.byte $4B, $0A, $01, $61, $0A, $03, $61, $0A, $05, $61, $0A, $07, $61, $0A, $09, $61
	.byte $0A, $0B, $61, $0A, $0D, $61, $FF
