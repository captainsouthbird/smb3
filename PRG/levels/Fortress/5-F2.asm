; Original address was $A857
; World 5 Sky fortress entrance / boss room
	.word W5F2_AltL	; Alternate level layout
	.word W5F2_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $70, $20, $39, $1F, $79, $00, $41, $0E, $7A, $1E, $40, $31, $0E, $00, $E1, $4F
	.byte $10, $0F, $EA, $0E, $16, $02, $E0, $01, $16, $08, $E0, $00, $18, $0B, $E2, $01
	.byte $12, $02, $62, $10, $00, $4E, $36, $0B, $91, $E0, $52, $20, $10, $1E, $E9, $31
	.byte $72, $26, $30, $06, $73, $26, $30, $07, $74, $26, $30, $08, $75, $26, $33, $28
	.byte $79, $2A, $30, $01, $37, $27, $A1, $16, $31, $63, $70, $41, $34, $0D, $11, $4D
	.byte $60, $FF
