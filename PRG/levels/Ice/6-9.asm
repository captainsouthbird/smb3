; Original address was $BCEE
; 6-9
	.word W609_UnderL	; Alternate level layout
	.word W609_UnderO	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $10, $5F, $74, $0C, $80, $76, $0A, $83, $78, $08, $85, $36, $0E, $94
	.byte $E0, $02, $40, $6E, $18, $8C, $70, $18, $8C, $72, $18, $8C, $74, $18, $8C, $76
	.byte $18, $8C, $78, $18, $8F, $2B, $25, $0B, $4D, $23, $E0, $4D, $27, $E0, $78, $3E
	.byte $80, $37, $34, $A3, $40, $48, $09, $FF
