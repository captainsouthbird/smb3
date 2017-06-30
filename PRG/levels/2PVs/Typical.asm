	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_2PVS | LEVEL1_YSTART_040
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(18) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_300

	.byte $00, $03, $03, $01, $00, $00, $01, $0E, $01, $03, $00, $25, $03, $0A, $25, $06
	.byte $04, $27, $07, $00, $21, $07, $0E, $21, $0A, $00, $25, $0A, $0A, $25, $0B, $00
	.byte $00, $0B, $0E, $01, $FF

