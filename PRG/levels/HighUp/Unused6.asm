; Original address was $B2BF
; "Unused Level 6"
	.word W602_EndL	; Alternate level layout
	.word W602_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $59, $00, $81, $7F, $76, $00, $85, $12, $05, $C2, $73, $0C, $12, $30, $0C, $82
	.byte $11, $13, $C2, $33, $16, $82, $76, $12, $1C, $33, $1D, $82, $35, $25, $40, $12
	.byte $26, $C2, $75, $24, $10, $76, $28, $14, $33, $2A, $00, $74, $31, $11, $76, $37
	.byte $82, $34, $38, $81, $34, $3B, $80, $76, $42, $82, $10, $42, $C2, $33, $46, $81
	.byte $33, $4B, $82, $34, $4F, $30, $72, $50, $13, $73, $54, $10, $74, $55, $10, $75
	.byte $56, $10, $76, $57, $11, $17, $5F, $07, $11, $5E, $95, $10, $5F, $80, $11, $60
	.byte $A5, $16, $66, $83, $15, $6A, $E0, $14, $6B, $B0, $13, $6C, $82, $14, $6F, $D1
	.byte $14, $72, $E1, $13, $73, $83, $34, $67, $40, $12, $63, $C2, $2F, $70, $82, $32
	.byte $71, $60, $10, $75, $C2, $34, $7C, $92, $77, $7C, $80, $60, $7E, $11, $61, $7E
	.byte $80, $63, $7E, $80, $65, $7E, $80, $67, $7E, $80, $69, $7E, $80, $6B, $7E, $80
	.byte $6D, $7E, $80, $6F, $7E, $80, $71, $7E, $80, $73, $7E, $80, $75, $7E, $80, $77
	.byte $7E, $80, $76, $7B, $10, $E7, $42, $80, $FF
