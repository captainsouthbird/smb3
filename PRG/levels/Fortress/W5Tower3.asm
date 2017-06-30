; Original address was $B51E
; World 5 "Sand castle" second part
	.word W5T4L	; Alternate level layout
	.word W5T4O	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $12, $02, $42, $10, $05, $4F, $10, $15, $46, $02, $10, $5D, $11, $0A, $41, $79
	.byte $06, $18, $79, $0F, $1A, $00, $00, $01, $00, $00, $EF, $0F, $10, $00, $EA, $01
	.byte $10, $02, $E1, $02, $18, $02, $E2, $09, $19, $0F, $E1, $06, $14, $0F, $E0, $00
	.byte $10, $09, $E2, $00, $10, $0A, $E0, $01, $10, $0C, $E2, $00, $1A, $0C, $C2, $34
	.byte $02, $A3, $60, $10, $29, $0F, $00, $10, $E0, $0F, $07, $10, $E8, $07, $08, $18
	.byte $E7, $01, $09, $1A, $E6, $01, $10, $10, $E3, $00, $14, $11, $E0, $00, $18, $15
	.byte $E0, $00, $16, $1C, $E4, $01, $17, $1B, $E3, $00, $18, $1A, $E2, $00, $00, $1E
	.byte $F1, $1A, $1A, $16, $C3, $14, $10, $02, $20, $13, $C2, $4A, $1C, $F8, $01, $11
	.byte $10, $01, $16, $11, $E1, $51, $71, $01, $10, $50, $01, $15, $50, $01, $18, $51
	.byte $01, $1C, $51, $04, $18, $91, $FF
