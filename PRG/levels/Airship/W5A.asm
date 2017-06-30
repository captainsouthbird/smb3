; Original address was $AC97
; World 5 airship
	.word W5Airship_BossL	; Alternate level layout
	.word W5Airship_BossO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_0B0
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_80
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_AIRSHIPB
	.byte LEVEL5_BGM_AIRSHIP | LEVEL5_TIME_300

	.byte $0C, $03, $1B, $0D, $04, $1A, $0E, $05, $1D, $0F, $06, $1D, $10, $07, $20, $11
	.byte $11, $09, $20, $10, $0C, $03, $03, $0D, $04, $03, $0E, $05, $03, $0F, $06, $03
	.byte $50, $07, $0A, $51, $09, $0A, $0D, $09, $04, $0E, $1A, $63, $12, $15, $16, $13
	.byte $17, $14, $14, $19, $20, $15, $15, $1B, $20, $10, $16, $1D, $1D, $17, $1F, $30
	.byte $0B, $52, $15, $0A, $53, $17, $0A, $54, $19, $0A, $55, $1B, $0A, $56, $1D, $0A
	.byte $57, $1F, $0B, $0D, $1B, $01, $0F, $17, $06, $70, $1D, $52, $0D, $2D, $42, $10
	.byte $2C, $20, $1B, $11, $2C, $20, $1B, $12, $2C, $15, $13, $2C, $15, $0C, $2D, $01
	.byte $30, $22, $00, $70, $28, $53, $15, $24, $0D, $15, $27, $0D, $17, $2B, $70, $0B
	.byte $36, $18, $0C, $36, $18, $0D, $35, $19, $0E, $34, $1A, $0F, $33, $20, $14, $65
	.byte $37, $45, $06, $06, $38, $0C, $07, $3B, $0D, $6D, $38, $62, $13, $32, $70, $08
	.byte $49, $13, $0E, $4E, $11, $0F, $4C, $16, $10, $4C, $20, $2F, $11, $4C, $20, $2E
	.byte $12, $41, $30, $39, $52, $41, $0B, $07, $4C, $05, $09, $49, $0A, $09, $4C, $B3
	.byte $09, $4F, $D1, $0C, $4E, $0C, $0F, $44, $0D, $09, $50, $45, $0F, $5A, $20, $22
	.byte $68, $5C, $46, $0F, $08, $50, $05, $09, $5D, $0C, $0E, $5A, $01, $10, $5E, $0C
	.byte $13, $50, $A0, $09, $61, $0C, $09, $65, $0D, $09, $69, $0D, $10, $61, $0C, $10
	.byte $65, $0D, $10, $68, $0D, $0B, $74, $1A, $0C, $74, $1A, $0D, $73, $1B, $0E, $72
	.byte $1B, $6A, $74, $2A, $29, $78, $91, $E7, $02, $60, $6E, $74, $63, $12, $7B, $71
	.byte $0C, $70, $01, $0D, $70, $41, $FF
