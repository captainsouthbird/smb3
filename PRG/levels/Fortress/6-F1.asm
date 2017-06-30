; Original address was $B151
; World 6 first fortress
	.word W6F1_AltL	; Alternate level layout
	.word W6F1_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $60, $00, $3F, $4F, $70, $00, $3A, $4F, $00, $00, $ED, $06, $0E, $05, $E7, $01
	.byte $11, $00, $E7, $02, $18, $03, $E0, $04, $00, $07, $E1, $78, $34, $08, $83, $76
	.byte $0A, $74, $76, $0F, $AE, $7A, $00, $40, $1F, $15, $03, $E2, $00, $02, $1F, $E3
	.byte $1B, $67, $1E, $7F, $2F, $12, $81, $31, $10, $81, $2B, $17, $01, $67, $2E, $7D
	.byte $0B, $20, $EF, $1D, $0A, $20, $CF, $0A, $30, $CD, $05, $3E, $F4, $15, $64, $3C
	.byte $82, $63, $3D, $77, $67, $3C, $A0, $64, $44, $8F, $74, $44, $86, $16, $46, $E4
	.byte $08, $12, $4F, $E8, $10, $02, $47, $F7, $10, $02, $4F, $EF, $18, $08, $48, $02
	.byte $0D, $41, $02, $12, $48, $02, $1A, $43, $C2, $14, $4D, $00, $03, $46, $04, $70
	.byte $60, $38, $1F, $02, $68, $ED, $17, $10, $60, $E4, $07, $16, $66, $62, $10, $68
	.byte $E4, $07, $10, $7F, $E8, $00, $11, $77, $60, $16, $74, $E0, $00, $16, $7A, $E0
	.byte $00, $E4, $68, $20, $FF
