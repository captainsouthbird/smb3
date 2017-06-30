; Original address was $A6F9
; ?
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_11 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0D, $8F, $2A, $2F, $07, $8F, $3A, $29, $07, $97, $31, $3D, $02, $9A
	.byte $00, $7F, $00, $0A, $1F, $2F, $9A, $10, $4F, $00, $8A, $20, $72, $04, $0A, $23
	.byte $11, $8C, $23, $41, $02, $6C, $25, $11, $8E, $25, $41, $01, $8D, $27, $71, $01
	.byte $0D, $29, $10, $8E, $29, $40, $00, $8D, $2E, $7F, $01, $8F, $20, $59, $0B, $6E
	.byte $29, $D0, $6F, $29, $E0, $10, $2A, $59, $0F, $2D, $76, $0D, $2D, $00, $0E, $2D
	.byte $D0, $9A, $2A, $55, $00, $8D, $3E, $71, $01, $0D, $3F, $03, $6E, $3F, $D0, $8F
	.byte $34, $B4, $06, $9A, $30, $5F, $00, $0F, $39, $86, $97, $3F, $52, $03, $17, $31
	.byte $92, $77, $3E, $A2, $9A, $30, $5F, $00, $9A, $34, $95, $00, $75, $42, $61, $97
	.byte $41, $52, $03, $94, $50, $7F, $07, $94, $60, $7F, $07, $FF
