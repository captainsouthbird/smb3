; Original address was $BD8F
; Cheep Cheep hand trap
	.word W8H_PrizeL	; Alternate level layout
	.word W8H_PrizeO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_200

	.byte $79, $0E, $71, $63, $56, $00, $B4, $06, $54, $07, $B6, $06, $54, $0E, $4E, $31
	.byte $18, $21, $54, $20, $42, $54, $25, $41, $54, $2A, $43, $54, $31, $49, $54, $3D
	.byte $45, $31, $3F, $00, $32, $37, $40, $33, $37, $40, $54, $43, $49, $54, $4F, $45
	.byte $2E, $44, $40, $2F, $44, $40, $30, $44, $40, $31, $44, $40, $32, $44, $40, $33
	.byte $44, $40, $32, $48, $40, $33, $48, $40, $34, $48, $40, $35, $48, $40, $36, $48
	.byte $40, $54, $57, $44, $54, $5F, $4A, $54, $60, $49, $54, $6D, $44, $54, $72, $B6
	.byte $0D, $40, $7C, $B7, $03, $48, $7F, $BB, $00, $31, $74, $80, $30, $75, $81, $31
	.byte $77, $81, $30, $79, $81, $31, $7B, $80, $28, $7D, $C8, $E7, $51, $10, $FF
