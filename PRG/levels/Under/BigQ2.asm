; Original address was $B1BC
; World 2's Big [?] block area
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $80, $10, $5F, $00, $90, $10, $5A, $00, $99, $13, $81, $0C, $80
	.byte $11, $58, $03, $63, $14, $E5, $69, $11, $81, $6B, $10, $E4, $70, $11, $55, $96
	.byte $11, $B0, $0B, $16, $1C, $0A, $80, $15, $B2, $07, $02, $1C, $0A, $60, $1C, $E0
	.byte $80, $1F, $5F, $00, $90, $1F, $5A, $00, $00, $1F, $E6, $67, $1D, $65, $8D, $13
	.byte $50, $0B, $0D, $13, $E0, $6E, $13, $75, $14, $1F, $E4, $20, $1D, $D1, $39, $11
	.byte $91, $77, $10, $E3, $19, $13, $E1, $19, $13, $01, $99, $40, $51, $0F, $99, $41
	.byte $81, $05, $60, $40, $EF, $70, $40, $E8, $97, $47, $81, $01, $95, $49, $83, $01
	.byte $92, $4B, $86, $04, $17, $47, $01, $15, $49, $01, $12, $4B, $01, $18, $47, $E0
	.byte $16, $49, $E0, $13, $4B, $E1, $80, $43, $B7, $0C, $87, $4F, $5B, $00, $08, $4F
	.byte $E9, $87, $43, $5A, $02, $00, $43, $EF, $10, $43, $E3, $14, $43, $07, $14, $44
	.byte $0A, $72, $44, $E1, $91, $45, $B0, $03, $11, $48, $0A, $90, $46, $B0, $01, $10
	.byte $48, $04, $68, $45, $E7, $90, $45, $80, $02, $20, $41, $D1, $28, $4D, $C5, $E1
	.byte $12, $95, $E4, $71, $25, $FF
