; Original address was $B03C
; "Unused Level 12"
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_04 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(4) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $19, $00, $68, $18, $02, $42, $12, $0E, $25, $13, $06, $24, $17, $0A, $22, $15
	.byte $07, $04, $19, $0B, $04, $19, $0F, $61, $12, $08, $41, $11, $0F, $42, $14, $11
	.byte $04, $36, $15, $62, $16, $19, $24, $15, $1A, $42, $18, $1A, $04, $18, $1C, $04
	.byte $36, $20, $61, $13, $23, $10, $03, $19, $23, $63, $12, $24, $41, $14, $24, $04
	.byte $36, $25, $10, $31, $2A, $60, $30, $2C, $82, $11, $2C, $10, $02, $35, $2C, $80
	.byte $18, $2C, $40, $19, $2C, $62, $12, $2D, $04, $35, $2E, $80, $18, $2E, $40, $15
	.byte $30, $10, $02, $16, $31, $04, $34, $35, $23, $34, $37, $00, $37, $34, $10, $38
	.byte $34, $10, $37, $38, $10, $38, $38, $10, $19, $34, $65, $16, $3C, $61, $FF
