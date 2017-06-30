; Original address was $A8B2
; World 5 Sky fortress main
	.word W5F2L	; Alternate level layout
	.word W5F2O	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $79, $00, $1F, $79, $10, $1F, $79, $20, $1F, $79, $30, $1F, $79, $40, $1F, $79
	.byte $50, $1F, $79, $60, $1F, $79, $70, $1F, $0C, $00, $E1, $7F, $6E, $00, $41, $7F
	.byte $7A, $00, $40, $7F, $0E, $02, $E4, $01, $57, $01, $44, $57, $08, $42, $56, $0F
	.byte $41, $33, $02, $D2, $55, $14, $42, $57, $1B, $44, $57, $20, $4B, $35, $20, $24
	.byte $35, $25, $02, $55, $30, $41, $55, $34, $41, $57, $3B, $44, $56, $42, $41, $58
	.byte $49, $41, $58, $4D, $40, $58, $50, $40, $58, $53, $41, $57, $59, $46, $35, $5B
	.byte $01, $35, $5C, $20, $57, $66, $4F, $57, $76, $49, $0E, $7D, $E4, $01, $33, $7D
	.byte $C1, $E7, $61, $72, $FF
