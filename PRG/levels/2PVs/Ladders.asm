; Original address was $0001

	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_040 | LEVEL1_2PVS
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(18) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_300

	.byte $00, $03, $03, $01, $07, $5B, $01, $08, $5B, $02, $01, $02, $02, $03, $02, $02
	.byte $05, $02, $02, $0A, $02, $02, $0C, $02, $02, $0E, $02, $03, $00, $16, $03, $09
	.byte $16, $07, $01, $02, $07, $03, $02, $07, $05, $02, $07, $0A, $02, $07, $0C, $02
	.byte $07, $0E, $02, $08, $00, $16, $08, $09, $16, $0C, $02, $02, $0C, $0D, $02, $FF
