; Original address was $BF5E
; World 4 Hammer Bro battle
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $10, $02, $10, $11, $0D, $10, $16, $03, $05, $14, $0B, $05, $19, $00, $77, $FF
