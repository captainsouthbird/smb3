; Original address was $BAA0
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $03, $01, $E4, $05, $02, $F2, $06, $03, $F1, $05, $04, $E3, $06
	.byte $06, $F1, $07, $07, $F0, $07, $08, $F1, $07, $09, $E0, $04, $0A, $E2, $05, $0C
	.byte $E2, $03, $0E, $E5, $63, $02, $10, $65, $05, $10, $67, $0A, $10, $64, $0B, $10
	.byte $65, $0D, $10, $00, $00, $4B, $00, $0F, $4B, $0A, $03, $59, $0A, $01, $61, $0A
	.byte $04, $61, $0A, $07, $61, $0A, $0A, $61, $0A, $0D, $61, $FF
