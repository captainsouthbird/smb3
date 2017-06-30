; Original address was $B1F6
; World 2 Boomerang/Fire Bro
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_09 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $11, $04, $0A, $11, $0C, $0A, $14, $0A, $0A, $16, $00, $04, $16, $05, $04, $16
	.byte $0D, $04, $79, $00, $20, $79, $02, $23, $79, $07, $20, $18, $09, $62, $19, $09
	.byte $62, $FF
