; Original address was $AF00
; World 7 second fortress
	.word W7F2_AltL	; Alternate level layout
	.word W7F2_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_09 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $67, $00, $3F, $8F, $77, $00, $33, $8F, $00, $00, $E6, $8F, $7A, $08, $40, $84
	.byte $16, $00, $E4, $04, $17, $05, $E3, $00, $18, $06, $E2, $00, $19, $07, $E1, $00
	.byte $19, $0C, $E1, $01, $34, $0C, $A4, $19, $13, $E1, $01, $16, $18, $E4, $00, $19
	.byte $1D, $E1, $02, $15, $18, $02, $37, $13, $A1, $35, $1D, $A3, $19, $25, $E1, $01
	.byte $19, $28, $E1, $03, $36, $25, $A2, $33, $2A, $A5, $36, $20, $08, $36, $22, $10
	.byte $07, $34, $E7, $02, $0F, $34, $E2, $00, $1A, $31, $E0, $01, $19, $35, $E1, $01
	.byte $19, $39, $E1, $08, $38, $31, $A1, $37, $35, $A1, $34, $39, $A4, $36, $40, $A2
	.byte $38, $48, $A2, $38, $4A, $A2, $38, $4C, $A2, $38, $4E, $A2, $19, $58, $E1, $01
	.byte $38, $50, $A2, $35, $58, $A3, $37, $55, $A3, $36, $5B, $A4, $27, $58, $DA, $34
	.byte $60, $A6, $19, $66, $E1, $01, $1A, $6E, $E0, $01, $36, $66, $A2, $38, $6E, $A1
	.byte $32, $67, $01, $07, $71, $E7, $02, $0F, $71, $E2, $00, $19, $72, $E1, $06, $19
	.byte $7E, $E1, $01, $37, $72, $A1, $33, $77, $A5, $35, $7E, $A3, $07, $8D, $F2, $13
	.byte $14, $85, $E6, $01, $14, $87, $E0, $01, $39, $87, $91, $E8, $52, $10, $FF
