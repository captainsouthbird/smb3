	.word W7F1L	; Alternate level layout
	.word W7F1O	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $62, $00, $2F, $4F, $72, $00, $26, $4F, $02, $00, $5F, $02, $10, $5F, $02, $20
	.byte $5F, $02, $30, $5F, $02, $40, $5F, $00, $00, $E1, $4F, $02, $00, $F0, $16, $09
	.byte $04, $72, $14, $0B, $E2, $00, $15, $0B, $02, $14, $06, $04, $02, $0F, $10, $22
	.byte $12, $C2, $05, $17, $62, $0B, $15, $73, $14, $11, $04, $13, $14, $E0, $02, $12
	.byte $15, $E2, $00, $13, $15, $02, $16, $1A, $B5, $02, $23, $10, $09, $27, $72, $14
	.byte $25, $04, $14, $2B, $04, $17, $28, $00, $15, $2F, $E0, $02, $13, $30, $E1, $00
	.byte $15, $30, $02, $02, $33, $10, $14, $35, $04, $14, $3E, $04, $16, $37, $B5, $06
	.byte $3B, $63, $13, $45, $E2, $00, $14, $45, $02, $14, $4A, $04, $17, $4D, $00, $00
	.byte $4F, $EF, $30, $10, $4F, $E8, $30, $71, $5D, $37, $15, $37, $6C, $B1, $37, $71
	.byte $E2, $E1, $61, $95, $E2, $38, $E1, $E4, $68, $53, $E6, $02, $16, $E7, $34, $64
	.byte $FF
