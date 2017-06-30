; Original address was $B407
; Hammer Bro battle area (World 3 in water)
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $0F, $04, $E2, $0F, $0D, $E2, $11, $01, $E2, $32, $07, $16, $36, $07, $16, $59
	.byte $00, $80, $0F, $1A, $00, $D0, $0F, $FF
