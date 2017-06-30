; Original address was $BA4B
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $06, $01, $E1, $04, $02, $E1, $03, $04, $E3, $05, $05, $F2, $06
	.byte $06, $F0, $04, $07, $E1, $05, $08, $E1, $04, $0B, $E1, $03, $0D, $E1, $66, $02
	.byte $10, $64, $03, $10, $63, $05, $10, $64, $08, $10, $65, $09, $10, $64, $0C, $10
	.byte $63, $0E, $10, $00, $00, $4B, $00, $0F, $4B, $0A, $01, $59, $09, $08, $42, $09
	.byte $04, $62, $09, $06, $62, $08, $0B, $63, $08, $0D, $63, $FF
