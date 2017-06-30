; Original address was $B3E7
; Hammer Bro battle area (World 3 out of water)
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $12, $03, $E2, $32, $07, $16, $13, $0D, $E2, $16, $01, $00, $36, $07, $16, $19
	.byte $06, $99, $1A, $00, $C0, $0F, $FF
