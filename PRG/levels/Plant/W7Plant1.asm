; Original address was $BC23
; World 7 giant piranha 1
	.word W7I1_PrizeL	; Alternate level layout
	.word W7I1_PrizeO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_05 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(5) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_200

	.byte $39, $00, $F7, $39, $08, $F7, $34, $0A, $A3, $37, $0A, $D1, $34, $12, $A3, $59
	.byte $10, $23, $39, $18, $F7, $14, $18, $01, $37, $12, $D1, $15, $18, $B3, $15, $19
	.byte $B3, $16, $1A, $A2, $16, $1B, $A2, $14, $1C, $B4, $14, $1D, $B4, $15, $1E, $A3
	.byte $15, $1F, $A3, $14, $19, $01, $15, $1A, $00, $15, $1B, $00, $13, $1C, $01, $13
	.byte $1D, $01, $14, $1E, $00, $14, $1F, $00, $59, $20, $21, $59, $22, $28, $13, $20
	.byte $B5, $13, $21, $B5, $14, $22, $A4, $14, $23, $A4, $15, $24, $B3, $15, $25, $B3
	.byte $12, $26, $A6, $12, $27, $A6, $2B, $2C, $A3, $2F, $2C, $D3, $39, $2F, $F8, $12
	.byte $20, $01, $12, $21, $01, $13, $22, $00, $13, $23, $00, $14, $24, $01, $14, $25
	.byte $01, $11, $26, $00, $11, $27, $00, $59, $38, $27, $35, $31, $A2, $33, $33, $A4
	.byte $34, $3A, $A3, $32, $3C, $A5, $2B, $3E, $AC, $36, $37, $92, $37, $31, $D1, $37
	.byte $33, $D1, $37, $37, $D1, $37, $3A, $D1, $37, $3C, $D1, $37, $3E, $D1, $E3, $02
	.byte $20, $FF
