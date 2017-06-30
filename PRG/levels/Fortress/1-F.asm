; Original address was $A95D
; World 1 Fortress
	.word W10F_AltL	; Alternate level layout
	.word W10F_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_10 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6E, $00, $3C, $9F, $00, $00, $EF, $9F, $10, $00, $E5, $09, $10, $0A, $E4, $00
	.byte $10, $0B, $E3, $00, $10, $0C, $E2, $00, $16, $0E, $E0, $02, $17, $0D, $E0, $03
	.byte $18, $0C, $E0, $04, $19, $00, $E1, $10, $79, $11, $31, $18, $7A, $11, $40, $18
	.byte $15, $14, $E5, $03, $19, $1A, $E1, $03, $18, $1C, $E0, $00, $16, $1D, $E2, $00
	.byte $18, $21, $E0, $04, $16, $2A, $E2, $02, $17, $2D, $E1, $00, $18, $2E, $E0, $00
	.byte $19, $2A, $E1, $26, $34, $24, $00, $10, $2F, $E5, $0F, $15, $38, $02, $16, $43
	.byte $E0, $0A, $17, $42, $E0, $0C, $18, $41, $E0, $0F, $16, $47, $02, $12, $4A, $61
	.byte $7A, $51, $40, $0E, $18, $55, $E2, $01, $17, $5A, $E3, $02, $17, $5B, $02, $64
	.byte $51, $3B, $11, $18, $60, $E0, $00, $19, $60, $E1, $3F, $10, $63, $E0, $2C, $36
	.byte $62, $01, $11, $64, $E0, $2B, $12, $66, $E0, $29, $13, $68, $E0, $27, $14, $6B
	.byte $E0, $24, $15, $6F, $E3, $0A, $15, $61, $62, $17, $6D, $00, $64, $63, $32, $0F
	.byte $16, $7E, $64, $05, $72, $00, $E7, $48, $54, $12, $93, $62, $10, $9F, $E8, $00
	.byte $E6, $68, $10, $FF
