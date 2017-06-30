; Original address was $AB0B
; World 3 2nd Fortress parts 1 and 3
	.word W3F2L	; Alternate level layout
	.word W3F2O	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $19, $00, $E1, $5F, $4F, $00, $89, $0F, $0F, $00, $E1, $0F, $11, $00, $E2, $04
	.byte $13, $07, $E5, $02, $34, $01, $D1, $16, $0A, $E0, $00, $17, $0A, $E0, $01, $18
	.byte $0A, $E0, $02, $4F, $10, $89, $0F, $0F, $10, $E1, $0F, $14, $11, $02, $35, $1C
	.byte $00, $4F, $20, $89, $0F, $0F, $20, $E1, $0F, $14, $25, $02, $34, $2E, $92, $17
	.byte $28, $E0, $07, $18, $27, $E0, $08, $E2, $51, $02, $0F, $30, $E9, $0F, $6F, $40
	.byte $3A, $1F, $0F, $40, $E0, $1F, $0F, $44, $E5, $0C, $16, $45, $62, $2F, $41, $D1
	.byte $0F, $5F, $EB, $00, $14, $54, $E0, $00, $15, $5B, $E0, $00, $FF
