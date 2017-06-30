; Original address was $BF10
; World 6 Hammer Bro battle A
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $11, $03, $C2, $32, $07, $16, $14, $01, $C2, $36, $07, $16, $7A, $00, $1F, $FF
