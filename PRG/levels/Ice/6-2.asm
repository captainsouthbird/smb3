; Original address was $B14C
; 6-2
	.word W602_EndL	; Alternate level layout
	.word W602_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_09 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $36, $00, $43, $36, $07, $43, $72, $14, $13, $78, $1F, $13, $31, $15, $82, $57
	.byte $1F, $E0, $37, $22, $01, $36, $28, $43, $77, $2D, $13, $30, $29, $10, $31, $29
	.byte $10, $32, $29, $10, $33, $29, $10, $34, $29, $10, $35, $29, $10, $33, $2E, $82
	.byte $76, $32, $13, $36, $37, $43, $36, $3E, $43, $30, $33, $82, $33, $3B, $82, $38
	.byte $35, $82, $33, $34, $10, $34, $34, $10, $35, $34, $10, $33, $39, $10, $34, $39
	.byte $10, $35, $39, $10, $38, $42, $43, $39, $49, $43, $2B, $4A, $40, $2C, $4A, $40
	.byte $2D, $4A, $40, $2E, $4A, $40, $2F, $4A, $40, $30, $4A, $40, $31, $4A, $40, $32
	.byte $4A, $40, $33, $4A, $40, $34, $4A, $40, $35, $4A, $40, $36, $4A, $40, $37, $4A
	.byte $40, $38, $4A, $40, $6B, $51, $13, $28, $56, $43, $28, $5C, $43, $25, $58, $0A
	.byte $46, $58, $E0, $47, $58, $E0, $6D, $68, $13, $34, $6F, $43, $30, $6E, $82, $38
	.byte $78, $43, $2D, $74, $0B, $27, $72, $40, $28, $72, $40, $29, $72, $40, $2A, $72
	.byte $40, $2B, $72, $40, $2C, $72, $40, $2D, $72, $40, $2E, $72, $40, $2F, $72, $40
	.byte $30, $72, $43, $39, $80, $43, $37, $8A, $93, $E8, $42, $80, $FF
