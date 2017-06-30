; Original address was $B141
; 5-6
	.word W504_EndL	; Alternate level layout
	.word W504_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_07 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $00, $00, $03, $79, $00, $11, $0B, $37, $0C, $40, $38, $0C, $40, $39, $0C, $40
	.byte $3A, $0C, $40, $18, $1A, $E2, $03, $19, $12, $E2, $04, $31, $18, $80, $31, $1A
	.byte $80, $31, $1C, $80, $19, $2A, $E2, $01, $32, $22, $80, $32, $24, $80, $32, $26
	.byte $80, $31, $3D, $80, $33, $3F, $80, $38, $3D, $60, $19, $32, $E2, $01, $19, $3A
	.byte $E2, $01, $37, $32, $01, $30, $41, $80, $30, $49, $80, $31, $45, $80, $33, $43
	.byte $80, $33, $47, $80, $33, $4B, $80, $36, $4C, $16, $36, $41, $41, $38, $45, $60
	.byte $36, $49, $41, $36, $51, $0D, $32, $5E, $10, $33, $5E, $10, $34, $5B, $10, $35
	.byte $5B, $10, $36, $57, $10, $37, $57, $10, $3A, $51, $12, $34, $5D, $82, $36, $5A
	.byte $82, $38, $56, $82, $33, $68, $16, $37, $61, $13, $36, $61, $83, $2F, $6F, $40
	.byte $30, $6F, $40, $31, $6F, $40, $32, $6F, $40, $33, $6F, $40, $34, $6F, $40, $35
	.byte $6F, $40, $36, $6F, $40, $37, $6F, $40, $38, $67, $48, $39, $6F, $40, $3A, $6F
	.byte $40, $36, $6C, $E2, $E6, $63, $20, $FF
