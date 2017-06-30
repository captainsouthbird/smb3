; Original address was $ADAB
; "Unused Level 14"
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $00, $00, $04, $14, $0D, $02, $13, $04, $02, $13, $0A, $02, $11, $0E, $02, $10
	.byte $09, $02, $0D, $0F, $02, $0C, $09, $02, $0A, $07, $02, $09, $0A, $02, $08, $0D
	.byte $02, $14, $45, $02, $13, $4A, $02, $0F, $48, $02, $14, $34, $02, $14, $3D, $02
	.byte $13, $3A, $02, $12, $33, $02, $14, $2F, $02, $13, $2A, $02, $11, $28, $02, $0E
	.byte $27, $02, $0C, $25, $02, $0C, $29, $02, $08, $25, $02, $08, $29, $02, $06, $2B
	.byte $02, $06, $00, $FF, $79, $00, $21, $4F, $0C, $0A, $DB, $11, $08, $F2, $16, $01
	.byte $F2, $36, $06, $22, $16, $0B, $F2, $06, $10, $FF, $0C, $1C, $C4, $12, $1D, $C3
	.byte $14, $1A, $C3, $36, $10, $22, $16, $15, $F3, $06, $20, $FF, $2B, $28, $88, $0C
	.byte $27, $DA, $10, $20, $C3, $34, $2C, $01, $06, $30, $FF, $10, $37, $F3, $10, $3D
	.byte $F4, $33, $34, $40, $13, $3A, $F3, $34, $34, $40, $34, $37, $21, $35, $34, $40
	.byte $36, $34, $40, $37, $34, $40, $38, $34, $40, $39, $34, $40, $FF
