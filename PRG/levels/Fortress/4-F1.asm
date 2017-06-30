; Original address was $B6A6
; World 4 first fortress
	.word W40F_BonusL	; Alternate level layout
	.word W40F_BonusO	; Alternate object layout
	.byte LEVEL1_SIZE_09 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_14 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6E, $00, $3A, $8F, $0E, $00, $E1, $8F, $10, $00, $E5, $03, $14, $0A, $E0, $11
	.byte $15, $09, $E0, $12, $16, $08, $E0, $15, $17, $07, $E0, $16, $18, $06, $E0, $17
	.byte $11, $10, $04, $11, $18, $04, $10, $20, $E6, $0C, $74, $20, $31, $03, $73, $27
	.byte $33, $01, $75, $2A, $31, $02, $14, $2F, $E4, $05, $74, $2F, $30, $00, $75, $2F
	.byte $31, $02, $15, $27, $04, $11, $32, $04, $12, $3A, $04, $36, $35, $A2, $36, $37
	.byte $A2, $36, $3B, $A2, $36, $3D, $A2, $36, $39, $92, $10, $3F, $E2, $03, $16, $3F
	.byte $E2, $0A, $12, $45, $E3, $04, $10, $49, $E0, $00, $70, $41, $31, $01, $15, $4C
	.byte $04, $10, $51, $E4, $03, $73, $52, $31, $01, $31, $5A, $01, $14, $58, $E4, $05
	.byte $17, $5E, $E1, $05, $75, $5C, $31, $01, $10, $60, $E4, $01, $34, $64, $A4, $10
	.byte $68, $E4, $17, $16, $6E, $64, $15, $86, $E0, $02, $11, $83, $62, $10, $8F, $E8
	.byte $00, $E3, $02, $20, $FF
