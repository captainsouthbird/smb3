; Original address was $BA02
; Airship boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BOSS | LEVEL5_TIME_300

	.byte $00, $00, $0F, $03, $01, $E4, $06, $03, $E0, $04, $04, $E1, $06, $06, $F0, $05
	.byte $07, $F1, $06, $0A, $E1, $05, $0C, $E1, $02, $0D, $E5, $63, $02, $10, $66, $04
	.byte $10, $64, $05, $10, $66, $0B, $10, $65, $0D, $10, $62, $0E, $10, $66, $0E, $10
	.byte $00, $00, $4B, $00, $0F, $4B, $0A, $01, $5D, $09, $04, $62, $09, $06, $42, $FF
