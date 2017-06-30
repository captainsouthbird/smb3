; Original address was $B139
; World 4 fortress bonus area
	.word W4F1L	; Alternate level layout
	.word W4F1O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_10 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $8B, $00, $8F, $09, $80, $00, $5B, $01, $60, $01, $EA, $6B, $09
	.byte $E4, $0B, $09, $04, $90, $0A, $8A, $25, $80, $04, $B7, $08, $80, $0D, $B9, $14
	.byte $89, $0D, $B3, $03, $00, $04, $E7, $08, $0D, $E4, $07, $04, $07, $0C, $0D, $07
	.byte $20, $02, $D1, $6A, $10, $E2, $0C, $10, $0A, $2C, $16, $25, $2C, $1A, $00, $80
	.byte $22, $B3, $0A, $87, $25, $8A, $0A, $00, $2F, $E6, $64, $21, $E5, $60, $2C, $E3
	.byte $07, $25, $E8, $09, $21, $0A, $03, $2C, $0A, $07, $25, $01, $20, $2D, $C4, $28
	.byte $23, $0E, $2C, $22, $0E, $87, $2F, $50, $00, $E2, $51, $46, $FF
