; Original address was $B475
; World 5 "Sand castle" first part
	.word W5T2L	; Alternate level layout
	.word W5T2O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $17, $00, $44, $15, $05, $41, $10, $07, $4F, $10, $17, $4F, $10, $27, $44, $04
	.byte $24, $41, $04, $0C, $41, $00, $00, $F1, $16, $08, $02, $F1, $0E, $09, $04, $F0
	.byte $0D, $0A, $05, $F0, $0A, $0B, $06, $F0, $09, $00, $02, $E0, $2D, $0B, $07, $E4
	.byte $24, $0A, $0C, $E0, $01, $17, $07, $E0, $09, $18, $06, $E0, $0A, $01, $0A, $E4
	.byte $01, $01, $0C, $E2, $01, $01, $0E, $E4, $01, $21, $02, $C3, $04, $06, $70, $01
	.byte $08, $20, $10, $0A, $21, $E0, $51, $30, $0A, $18, $E0, $01, $16, $1C, $E2, $00
	.byte $01, $12, $23, $06, $10, $61, $06, $1C, $61, $15, $14, $02, $15, $1C, $02, $0A
	.byte $24, $E0, $01, $10, $28, $E4, $00, $00, $2E, $F1, $18, $16, $2C, $E0, $01, $17
	.byte $2B, $E0, $02, $18, $2A, $E0, $03, $01, $22, $E4, $01, $01, $24, $E2, $01, $01
	.byte $26, $E4, $01, $15, $23, $02, $15, $28, $02, $35, $23, $01, $48, $2C, $FA, $FF
