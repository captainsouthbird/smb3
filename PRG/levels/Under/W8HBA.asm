; Original address was $AC79
; Unused "Dark" hammer bro fight area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(19) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $40, $00, $0E, $52, $00, $0C, $32, $07, $16, $36, $07, $16, $57, $08, $0B, $57
	.byte $0C, $0B, $9A, $00, $80, $0F, $FF
