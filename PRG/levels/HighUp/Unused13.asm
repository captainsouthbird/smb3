; Original address was $B0C4
; "Unused Level 13"
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_04 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(4) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $1A, $00, $68, $19, $02, $42, $13, $0E, $25, $14, $06, $24, $18, $0A, $22, $16
	.byte $07, $04, $1A, $0B, $04, $1A, $0F, $61, $13, $08, $41, $12, $0F, $42, $15, $11
	.byte $04, $37, $15, $62, $17, $19, $24, $16, $1A, $42, $19, $1A, $04, $19, $1C, $04
	.byte $37, $20, $61, $14, $23, $10, $03, $1A, $23, $63, $13, $24, $41, $15, $24, $04
	.byte $37, $25, $10, $32, $2A, $60, $31, $2C, $82, $12, $2C, $10, $02, $36, $2C, $80
	.byte $19, $2C, $40, $1A, $2C, $62, $13, $2D, $04, $36, $2E, $80, $19, $2E, $40, $16
	.byte $30, $10, $02, $17, $31, $04, $35, $35, $23, $35, $37, $00, $38, $34, $10, $39
	.byte $34, $10, $38, $38, $10, $39, $38, $10, $1A, $34, $65, $17, $3C, $61, $FF
