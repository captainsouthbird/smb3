; Original address was $ADB7
; World 1 Airship 
	.word W1Airship_BossL	; Alternate level layout
	.word W1Airship_BossO	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_0B0
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_80
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_AIRSHIPB
	.byte LEVEL5_BGM_AIRSHIP | LEVEL5_TIME_300

	.byte $0C, $04, $18, $0D, $05, $17, $0E, $06, $20, $1A, $0F, $07, $20, $19, $10, $08
	.byte $20, $18, $11, $0A, $20, $3B, $12, $0C, $20, $07, $13, $0E, $30, $05, $0C, $04
	.byte $03, $0D, $05, $03, $0E, $06, $03, $0F, $07, $03, $50, $08, $0A, $51, $0A, $0A
	.byte $52, $0C, $0A, $53, $0D, $0B, $0D, $09, $04, $0C, $1E, $41, $12, $1D, $1C, $13
	.byte $1E, $18, $14, $1F, $30, $07, $12, $1D, $03, $13, $1E, $03, $54, $1F, $0B, $0D
	.byte $18, $06, $0D, $13, $06, $0C, $1E, $01, $13, $14, $71, $08, $28, $20, $22, $0E
	.byte $25, $62, $0E, $2C, $42, $14, $27, $71, $0D, $2C, $01, $09, $28, $08, $09, $2D
	.byte $08, $10, $24, $06, $2D, $35, $00, $09, $3D, $1D, $0A, $3D, $1D, $0B, $3D, $1D
	.byte $12, $31, $1C, $13, $32, $18, $14, $33, $30, $07, $12, $31, $03, $13, $32, $03
	.byte $54, $33, $0B, $14, $3B, $71, $0C, $3D, $B6, $0C, $3D, $C4, $0C, $43, $D4, $09
	.byte $38, $0A, $0E, $3B, $42, $12, $41, $14, $13, $42, $20, $19, $14, $43, $20, $17
	.byte $15, $45, $30, $15, $12, $41, $03, $13, $42, $03, $54, $43, $0A, $55, $45, $0B
	.byte $11, $4D, $41, $10, $4D, $01, $12, $47, $07, $12, $4F, $07, $0E, $54, $1A, $0F
	.byte $54, $1A, $10, $53, $1B, $11, $52, $1B, $12, $50, $1C, $6D, $54, $2A, $71, $54
	.byte $63, $15, $5B, $71, $2C, $58, $91, $E5, $02, $60, $FF
