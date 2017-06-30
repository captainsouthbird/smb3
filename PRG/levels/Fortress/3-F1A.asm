; Original address was $AC48
; World 3 1st Fortress water part
	.word W3F1L	; Alternate level layout
	.word W3F1O	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $10, $10, $48, $0D, $19, $44, $08, $1C, $45, $12, $1E, $45, $0D, $22, $4D, $0D
	.byte $30, $4F, $0D, $40, $4F, $0D, $50, $45, $12, $51, $42, $00, $00, $FD, $18, $00
	.byte $0E, $EC, $01, $15, $0E, $E3, $01, $2D, $0E, $C4, $E0, $61, $32, $00, $10, $EF
	.byte $08, $00, $19, $EC, $02, $00, $1C, $E7, $05, $0C, $1C, $E0, $02, $0D, $1E, $E1
	.byte $00, $0F, $1E, $E0, $01, $10, $1E, $E0, $02, $11, $1E, $E0, $05, $0A, $1D, $00
	.byte $0F, $1B, $00, $E1, $68, $29, $32, $12, $01, $55, $10, $83, $49, $00, $22, $EC
	.byte $33, $0F, $22, $00, $0F, $29, $00, $E2, $68, $16, $0F, $30, $00, $0F, $37, $00
	.byte $0F, $3E, $00, $2D, $33, $C6, $33, $3A, $01, $E3, $61, $32, $0F, $45, $00, $0F
	.byte $4C, $00, $2D, $41, $C6, $E4, $61, $32, $00, $56, $FF, $18, $11, $51, $E0, $02
	.byte $0F, $53, $00, $2E, $51, $0B, $E5, $68, $85, $70, $66, $38, $0D, $00, $66, $EF
	.byte $19, $17, $67, $00, $32, $6A, $86, $34, $6A, $86, $12, $69, $E4, $00, $16, $69
	.byte $E0, $01, $16, $6C, $E0, $01, $16, $6F, $E0, $00, $12, $71, $E4, $00, $32, $68
	.byte $0E, $35, $67, $0E, $36, $6B, $0E, $36, $6E, $0E, $36, $70, $0E, $10, $74, $E8
	.byte $0B, $E6, $68, $18, $FF
