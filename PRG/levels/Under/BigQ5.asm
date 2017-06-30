; Original address was $B3D8
; World 5's Big [?] block area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $40, $30, $B9, $06, $40, $39, $B9, $06, $4A, $30, $BE, $00, $4A
	.byte $3F, $BE, $00, $59, $30, $B1, $0F, $20, $37, $D1, $39, $3D, $91, $2D, $33, $19
	.byte $2E, $33, $10, $2E, $3C, $10, $2F, $33, $10, $2F, $3C, $10, $30, $33, $10, $30
	.byte $3C, $10, $31, $33, $10, $31, $3C, $10, $32, $33, $10, $32, $3C, $10, $33, $33
	.byte $10, $33, $3C, $10, $34, $33, $10, $34, $3C, $10, $35, $33, $19, $35, $32, $06
	.byte $40, $70, $BF, $00, $50, $70, $B8, $00, $59, $70, $B1, $0F, $40, $73, $BF, $0C
	.byte $50, $7F, $B8, $00, $20, $71, $D1, $30, $7D, $C4, $24, $72, $80, $25, $71, $80
	.byte $26, $72, $80, $27, $71, $80, $28, $72, $80, $29, $71, $80, $2A, $72, $80, $2B
	.byte $71, $80, $2C, $72, $80, $2D, $71, $80, $E3, $61, $65, $E7, $42, $E5, $FF
