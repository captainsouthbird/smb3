; Original address was $BD32
; End of 3-8
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $59, $00, $81, $15, $40, $00, $BF, $01, $50, $00, $BA, $01, $54, $02, $21, $56
	.byte $02, $4F, $56, $12, $43, $10, $07, $E2, $11, $0D, $E2, $1A, $16, $C0, $19, $37
	.byte $16, $40, $38, $16, $40, $39, $16, $40, $40, $18, $09, $FF


