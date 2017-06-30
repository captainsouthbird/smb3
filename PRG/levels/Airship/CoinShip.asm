; Original address was $BC15
; Coin ship
	.word CoinShip_BossL	; Alternate level layout
	.word CoinShip_BossO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_000
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_AIRSHIPB
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_200

	.byte $08, $02, $19, $09, $03, $18, $48, $02, $0A, $49, $03, $0A, $6A, $05, $70, $37
	.byte $0B, $3B, $72, $0B, $06, $30, $35, $4B, $06, $0B, $04, $0E, $1D, $07, $0D, $1F
	.byte $04, $20, $15, $07, $20, $16, $04, $29, $14, $07, $29, $14, $06, $34, $19, $07
	.byte $34, $19, $08, $34, $19, $67, $36, $63, $69, $33, $70, $0A, $24, $3A, $91, $09
	.byte $06, $04, $22, $0E, $8D, $23, $0E, $8D, $25, $0D, $8F, $26, $0D, $8F, $28, $0C
	.byte $8F, $29, $0C, $8F, $28, $1C, $8B, $29, $1C, $8B, $22, $20, $84, $23, $20, $85
	.byte $25, $20, $85, $26, $20, $86, $22, $29, $84, $23, $29, $84, $25, $29, $84, $26
	.byte $29, $84, $28, $29, $84, $29, $29, $84, $26, $33, $80, $27, $32, $81, $28, $31
	.byte $82, $29, $30, $83, $05, $11, $C1, $08, $11, $C1, $05, $17, $D1, $08, $17, $D1
	.byte $02, $1E, $67, $23, $37, $0F, $E3, $42, $70, $FF
