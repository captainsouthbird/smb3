; Original address was $BCDE
; Podoboo hand trap
	.word W8H_PrizeL	; Alternate level layout
	.word W8H_PrizeO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_200

	.byte $79, $00, $71, $3F, $59, $00, $B1, $09, $57, $04, $B1, $05, $55, $06, $B1, $03
	.byte $54, $0A, $42, $31, $0D, $81, $32, $0F, $80, $56, $10, $41, $54, $14, $42, $56
	.byte $1B, $42, $33, $10, $81, $31, $14, $82, $31, $18, $81, $32, $1A, $80, $56, $20
	.byte $41, $54, $27, $42, $53, $2E, $42, $33, $20, $80, $31, $27, $82, $30, $2D, $84
	.byte $40, $3C, $B9, $03, $4A, $3F, $BC, $00, $57, $36, $B3, $09, $32, $33, $80, $33
	.byte $34, $80, $2A, $3D, $C8, $E3, $51, $10, $FF
