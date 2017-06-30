; Original address was $B422
; World 5 Hammer Bro ground battle B
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(19) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $40, $00, $0E, $53, $00, $0C, $57, $0C, $0B, $32, $07, $16, $36, $07, $16, $36
	.byte $0A, $07, $9A, $00, $80, $0F, $FF
