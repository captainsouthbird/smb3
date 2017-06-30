; Original address was $B60D
; Sand trap
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_14 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(19) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_200

	.byte $40, $00, $0E, $9A, $00, $80, $05, $9A, $06, $50, $03, $98, $0A, $82, $03, $78
	.byte $08, $61, $18, $0E, $50, $79, $0E, $E1, $5A, $0F, $D0, $0C, $99, $02, $D2, $98
	.byte $14, $82, $02, $18, $13, $60, $19, $13, $E1, $18, $17, $50, $79, $17, $E1, $98
	.byte $1D, $82, $0A, $18, $1C, $60, $19, $1C, $E1, $18, $27, $04, $79, $27, $E1, $59
	.byte $28, $D1, $07, $97, $20, $D2, $98, $31, $82, $01, $18, $30, $01, $19, $30, $E1
	.byte $9A, $33, $50, $03, $78, $33, $51, $9A, $37, $80, $68, $99, $3B, $D2, $99, $40
	.byte $D2, $99, $4A, $D1, $39, $58, $17, $39, $68, $17, $39, $78, $17, $39, $88, $17
	.byte $39, $98, $16, $9A, $A0, $50, $08, $79, $A0, $60, $19, $A2, $04, $7A, $A2, $E0
	.byte $5A, $A3, $D0, $02, $19, $A6, $01, $1A, $A6, $E0, $79, $A7, $50, $9A, $A9, $80
	.byte $04, $9A, $AE, $50, $01, $97, $B0, $83, $03, $17, $B0, $62, $17, $B3, $04, $78
	.byte $B3, $E2, $58, $B4, $D2, $06, $97, $BB, $83, $01, $9A, $BD, $50, $02, $17, $BB
	.byte $01, $18, $BB, $E2, $17, $BD, $52, $9A, $C0, $80, $1F, $40, $C0, $09, $FF
