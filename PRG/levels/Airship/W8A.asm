; Original address was $B617
; World 8 Airship
	.word W8Airship_BossL	; Alternate level layout
	.word W8Airship_BossO	; Alternate object layout
	.byte LEVEL1_SIZE_12 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_06 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_70
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_AIRSHIPB
	.byte LEVEL5_BGM_AIRSHIP | LEVEL5_TIME_300

	.byte $75, $06, $01, $76, $0C, $01, $19, $12, $15, $19, $12, $03, $18, $17, $01, $78
	.byte $14, $00, $17, $16, $41, $78, $1E, $70, $07, $17, $20, $15, $57, $20, $0F, $14
	.byte $24, $42, $16, $25, $01, $76, $2C, $01, $76, $22, $00, $14, $34, $15, $14, $34
	.byte $03, $73, $35, $00, $12, $37, $41, $13, $39, $01, $74, $40, $02, $75, $47, $02
	.byte $76, $4E, $02, $18, $56, $12, $18, $56, $03, $79, $57, $70, $0C, $75, $5C, $53
	.byte $18, $61, $12, $16, $63, $01, $17, $63, $01, $71, $65, $02, $78, $6F, $01, $76
	.byte $7A, $01, $71, $82, $01, $78, $8D, $01, $73, $94, $01, $75, $A1, $01, $17, $AD
	.byte $13, $17, $AD, $03, $78, $AE, $70, $0E, $17, $BC, $72, $17, $BA, $12, $14, $B3
	.byte $14, $15, $B3, $14, $16, $B3, $14, $17, $B3, $14, $32, $B4, $91, $EB, $42, $10
	.byte $FF
