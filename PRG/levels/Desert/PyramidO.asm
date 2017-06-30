; Original address was $AF26
; Pyramid entrance / bonus / exit
	.word W2PY_InsideL	; Alternate level layout
	.word W2PY_InsideO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $00, $00, $67, $00, $10, $67, $00, $20, $67, $00, $30, $67, $00, $40, $67, $00
	.byte $50, $67, $00, $60, $67, $00, $70, $67, $14, $05, $0C, $10, $0E, $73, $12, $0C
	.byte $73, $14, $0A, $20, $14, $0F, $72, $16, $08, $74, $18, $06, $75, $14, $0E, $0B
	.byte $E0, $68, $20, $00, $10, $90, $04, $10, $90, $08, $10, $90, $0C, $10, $90, $00
	.byte $28, $71, $02, $28, $90, $06, $28, $90, $0A, $28, $90, $0E, $28, $90, $12, $28
	.byte $90, $16, $28, $90, $38, $38, $91, $E3, $71, $25, $31, $30, $89, $34, $30, $89
	.byte $32, $30, $19, $35, $30, $19, $2D, $35, $0B, $38, $32, $0D, $08, $34, $60, $09
	.byte $34, $60, $08, $30, $70, $08, $36, $70, $00, $30, $90, $04, $30, $90, $02, $3A
	.byte $90, $06, $3A, $90, $0A, $3A, $90, $0E, $3A, $90, $12, $3A, $90, $16, $3A, $90
	.byte $00, $3A, $70, $00, $58, $71, $02, $58, $90, $06, $58, $90, $0A, $58, $90, $0E
	.byte $58, $90, $12, $58, $90, $16, $58, $90, $38, $63, $A1, $40, $6A, $09, $FF
