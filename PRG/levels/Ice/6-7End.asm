; Original address was $BCB0
; 6-7 End
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $74, $03, $36, $75, $03, $36, $76, $03, $31, $77, $03, $31, $78, $03, $31, $79
	.byte $03, $36, $76, $08, $31, $77, $08, $31, $78, $08, $31, $1A, $00, $10, $30, $09
	.byte $03, $C2, $20, $08, $D5, $0D, $0B, $C2, $15, $0C, $73, $18, $0B, $72, $36, $02
	.byte $0E, $40, $18, $09, $FF
