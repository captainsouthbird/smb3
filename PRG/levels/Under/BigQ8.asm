; Original address was $B65B
; World 8's Big [?] block area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_07 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $80, $10, $5F, $00, $90, $10, $5A, $00, $99, $13, $81, $0C, $80
	.byte $11, $58, $03, $63, $14, $E5, $69, $11, $81, $6B, $10, $E4, $70, $11, $55, $96
	.byte $11, $B0, $0B, $16, $1C, $0A, $80, $15, $B2, $07, $02, $1C, $0A, $60, $1C, $E0
	.byte $80, $1F, $5F, $00, $90, $1F, $5A, $00, $00, $1F, $E6, $67, $1D, $65, $8D, $13
	.byte $50, $0B, $0D, $13, $E0, $6E, $13, $75, $14, $1F, $E4, $20, $1D, $D1, $39, $11
	.byte $91, $77, $10, $E3, $19, $13, $E1, $19, $13, $01, $80, $40, $5F, $00, $90, $40
	.byte $5A, $00, $99, $43, $81, $0C, $80, $41, $58, $03, $63, $44, $E5, $69, $41, $81
	.byte $6B, $40, $E4, $70, $41, $55, $96, $41, $B0, $0B, $16, $4C, $0A, $80, $45, $B2
	.byte $07, $02, $4C, $0A, $60, $4C, $E0, $80, $4F, $5F, $00, $90, $4F, $5A, $00, $00
	.byte $4F, $E6, $67, $4D, $65, $8D, $43, $50, $0B, $0D, $43, $E0, $6E, $43, $75, $14
	.byte $4F, $E4, $20, $4D, $D1, $39, $41, $91, $77, $40, $E3, $19, $43, $E1, $19, $43
	.byte $01, $E4, $51, $F5, $FF
