; Original address was $B931
; 6-6 entrance
	.word W606_UnderL	; Alternate level layout
	.word W606_UnderO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $10, $3F, $60, $00, $1E, $76, $06, $80, $77, $08, $14, $78, $04, $84
	.byte $78, $0E, $10, $79, $0E, $10, $60, $0F, $88, $62, $0F, $88, $64, $0F, $88, $66
	.byte $0F, $88, $68, $0F, $88, $6A, $0F, $88, $6C, $0F, $88, $6E, $0F, $88, $70, $0F
	.byte $88, $72, $0F, $88, $74, $0D, $89, $76, $0D, $89, $78, $0F, $88, $11, $07, $C2
	.byte $14, $02, $C2, $35, $0B, $E1, $E0, $12, $20, $38, $23, $A1, $11, $28, $C2, $13
	.byte $22, $C2, $16, $27, $C2, $40, $2C, $09, $FF
