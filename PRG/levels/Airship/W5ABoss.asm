; Original address was $BAF5
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $03, $01, $F2, $05, $02, $E2, $04, $04, $E2, $03, $05, $E0, $06
	.byte $05, $E1, $06, $07, $E0, $03, $08, $E2, $05, $0A, $E1, $04, $0C, $E2, $03, $0E
	.byte $E4, $65, $03, $10, $64, $05, $10, $63, $06, $10, $66, $06, $10, $66, $08, $10
	.byte $63, $09, $10, $65, $0B, $10, $64, $0D, $10, $00, $00, $4B, $00, $0F, $4B, $0A
	.byte $01, $5D, $09, $03, $62, $09, $07, $62, $09, $09, $62, $FF
