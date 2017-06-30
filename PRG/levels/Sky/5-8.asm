; Original address was $AA5F
; 5-8
	.word W504_EndL	; Alternate level layout
	.word W504_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $15, $23, $02, $13, $21, $02, $12, $24, $02, $0E, $22, $02, $15, $1B, $02, $14
	.byte $18, $02, $14, $16, $02, $14, $10, $02, $13, $1D, $02, $13, $15, $02, $0A, $10
	.byte $02, $14, $0C, $02, $12, $0C, $02, $0F, $0D, $02, $0E, $0E, $02, $0C, $0E, $02
	.byte $0C, $0C, $02, $0A, $0A, $02, $14, $5B, $02, $14, $59, $02, $14, $53, $02, $12
	.byte $5D, $02, $11, $54, $02, $11, $50, $02, $0E, $5D, $02, $0E, $5B, $02, $15, $4C
	.byte $02, $15, $40, $02, $14, $45, $02, $13, $4A, $02, $10, $41, $02, $0E, $4D, $02
	.byte $15, $3A, $02, $14, $33, $02, $11, $3C, $02, $11, $38, $02, $11, $32, $02, $0E
	.byte $31, $02, $0D, $34, $02, $14, $79, $02, $14, $71, $02, $11, $78, $02, $11, $76
	.byte $02, $11, $70, $02, $0E, $77, $02, $0C, $79, $02, $0F, $6E, $02, $18, $00, $C9
	.byte $15, $0F, $D6, $19, $0F, $D6, $32, $11, $23, $32, $13, $01, $19, $1C, $D5, $19
	.byte $26, $D3, $18, $2E, $C3, $19, $36, $D3, $19, $3E, $D4, $14, $44, $D1, $19, $48
	.byte $D5, $15, $5A, $D1, $19, $52, $D5, $19, $5D, $D5, $32, $63, $01, $14, $62, $D2
	.byte $16, $6B, $C2, $19, $66, $C4, $13, $70, $DF, $32, $7D, $E2, $E7, $63, $20, $FF
