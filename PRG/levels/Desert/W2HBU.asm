; Original address was $B1D7
; World 2 Hammer Bro (not used)
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $10, $05, $0A, $10, $0D, $0A, $12, $02, $0A, $32, $07, $16, $16, $00, $04, $16
	.byte $04, $04, $36, $07, $16, $FF
