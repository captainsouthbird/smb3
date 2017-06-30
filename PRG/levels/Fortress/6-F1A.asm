; Original address was $B1FF
; World 6 first fortress second part
	.word W6F1L	; Alternate level layout
	.word W6F1O	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $10, $00, $4F, $10, $10, $42, $02, $13, $4C, $02, $20, $47, $10, $18, $49, $10
	.byte $28, $4F, $10, $38, $46, $00, $00, $EF, $12, $17, $08, $E1, $00, $13, $07, $62
	.byte $16, $08, $02, $17, $02, $00, $10, $04, $20, $36, $0A, $01, $00, $13, $E1, $14
	.byte $10, $11, $20, $04, $15, $74, $0A, $17, $E5, $0A, $10, $17, $E3, $00, $18, $17
	.byte $E0, $00, $10, $1E, $E7, $00, $14, $17, $02, $15, $1E, $02, $34, $19, $21, $35
	.byte $1C, $21, $34, $18, $02, $00, $28, $EF, $17, $17, $26, $E1, $05, $18, $25, $E0
	.byte $00, $16, $2F, $E0, $02, $18, $2C, $CA, $10, $29, $20, $29, $21, $0B, $10, $3F
	.byte $E4, $00, $15, $37, $E3, $08, $32, $30, $01, $13, $3D, $00, $10, $38, $20, $E3
	.byte $68, $16, $E0, $58, $D4, $FF
