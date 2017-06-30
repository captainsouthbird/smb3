; Original address was $B202
; 5-9
	.word W504_EndL	; Alternate level layout
	.word W504_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_10 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $0C, $97, $02, $07, $98, $02, $05, $96, $02, $03, $94, $02, $00, $93, $02, $0E
	.byte $75, $02, $0D, $72, $02, $0C, $63, $02, $0B, $6A, $02, $0A, $63, $02, $07, $62
	.byte $02, $07, $57, $02, $10, $4E, $02, $0E, $4C, $02, $0A, $4C, $02, $09, $4B, $02
	.byte $07, $4D, $02, $06, $4A, $02, $05, $49, $02, $02, $48, $02, $00, $46, $02, $13
	.byte $2C, $02, $0D, $2A, $02, $0A, $23, $02, $03, $20, $02, $0E, $15, $02, $0B, $14
	.byte $02, $09, $12, $02, $12, $0B, $02, $0D, $00, $02, $0C, $07, $02, $09, $08, $02
	.byte $02, $0B, $02, $00, $09, $02, $72, $00, $48, $0F, $60, $0D, $4D, $19, $79, $10
	.byte $41, $01, $6E, $17, $4C, $14, $6A, $27, $40, $00, $70, $2C, $4A, $04, $60, $4B
	.byte $4B, $1D, $6C, $59, $4E, $11, $6F, $6B, $4B, $07, $71, $73, $49, $09, $60, $98
	.byte $4B, $06, $15, $01, $D6, $06, $9A, $D3, $11, $0C, $D2, $20, $9B, $C2, $E9, $63
	.byte $20, $FF
