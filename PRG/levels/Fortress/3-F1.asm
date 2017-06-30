; Original address was $AB81
; World 3 1st Fortress non-water part
	.word W3F1_AltL	; Alternate level layout
	.word W3F1_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_11 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $0F, $00, $4F, $0F, $10, $4F, $0F, $20, $45, $13, $26, $44, $10, $2B, $41, $13
	.byte $2D, $4F, $13, $3C, $4B, $10, $48, $41, $13, $4A, $45, $13, $50, $4F, $13, $60
	.byte $4A, $10, $6B, $41, $13, $6D, $4F, $13, $7D, $45, $70, $90, $38, $1F, $08, $00
	.byte $E6, $AF, $0F, $03, $24, $13, $01, $74, $15, $15, $E3, $00, $16, $1F, $E0, $00
	.byte $17, $1E, $E0, $01, $18, $1D, $E0, $02, $14, $10, $02, $15, $19, $02, $15, $20
	.byte $E3, $02, $18, $2A, $E0, $02, $0F, $26, $E0, $79, $10, $26, $E2, $04, $10, $2D
	.byte $E2, $1A, $37, $23, $A1, $13, $30, $25, $17, $32, $00, $17, $3A, $00, $E3, $48
	.byte $03, $10, $4A, $E2, $20, $17, $48, $E1, $01, $17, $42, $00, $17, $4E, $00, $E4
	.byte $48, $B1, $13, $52, $23, $17, $58, $00, $E5, $48, $35, $10, $6D, $E2, $15, $17
	.byte $61, $00, $E6, $48, $22, $13, $76, $21, $17, $71, $00, $17, $78, $00, $E7, $48
	.byte $54, $10, $83, $E8, $0C, $17, $81, $00, $E8, $68, $76, $10, $90, $E4, $0F, $08
	.byte $A0, $E7, $0F, $10, $AF, $E8, $00, $11, $A1, $60, $11, $AD, $60, $FF
