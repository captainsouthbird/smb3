	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_2PVS | LEVEL1_YSTART_040
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(18) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_300

	.byte $00, $03, $03, $00, $03, $49, $01, $01, $4D, $02, $00, $4F, $03, $00, $4F, $04
	.byte $00, $45, $04, $0A, $45, $05, $00, $42, $05, $0D, $42, $06, $00, $40, $06, $0F
	.byte $40, $07, $04, $37, $0A, $00, $35, $0A, $0A, $35, $FF
