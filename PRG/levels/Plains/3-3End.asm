; Original address was $BF9A
; End of 3-3
	.word W303L	; Alternate level layout
	.word W303O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $59, $00, $81, $0F, $59, $08, $B1, $03, $37, $09, $A1, $13, $03, $E2, $15, $0D
	.byte $E2, $1A, $10, $C0, $1F, $19, $11, $94, $39, $10, $40, $40, $18, $09, $FF
