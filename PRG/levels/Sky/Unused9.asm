; Original address was $ACA9
; Unused space with a bunch of mostly inaccessible [?] blocks
	.word W504_EndL	; Alternate level layout
	.word W504_EndO	; Alternate object layout
	.byte LEVEL1_SIZE_08 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $10, $00, $02, $13, $07, $02, $0A, $0A, $02, $0E, $0A, $02, $75, $00, $44, $0E
	.byte $6A, $0F, $4F, $0A, $79, $00, $21, $0F, $0A, $15, $02, $0C, $19, $02, $06, $1D
	.byte $02, $6D, $1A, $4C, $03, $6A, $1E, $4F, $09, $79, $10, $21, $0F, $32, $10, $20
	.byte $32, $18, $20, $05, $20, $02, $0B, $22, $02, $10, $23, $02, $0E, $2B, $02, $08
	.byte $2D, $02, $73, $28, $46, $07, $79, $20, $21, $0F, $32, $20, $20, $32, $28, $20
	.byte $04, $33, $02, $09, $34, $02, $10, $3B, $02, $09, $3C, $02, $0D, $3C, $02, $08
	.byte $3D, $02, $05, $3E, $02, $6A, $30, $4F, $0A, $6D, $3B, $4C, $08, $79, $30, $21
	.byte $0F, $32, $30, $20, $32, $38, $20, $06, $4B, $02, $08, $47, $02, $09, $4A, $02
	.byte $0B, $46, $02, $10, $45, $02, $6A, $44, $42, $0E, $6D, $48, $4C, $0A, $75, $44
	.byte $44, $03, $79, $40, $21, $0F, $31, $4A, $23, $32, $40, $20, $32, $48, $20, $05
	.byte $56, $02, $05, $5A, $02, $08, $59, $02, $09, $54, $02, $0D, $5A, $02, $6E, $53
	.byte $4B, $0D, $79, $50, $21, $0F, $31, $5A, $23, $32, $50, $20, $32, $58, $20, $07
	.byte $6C, $02, $08, $65, $02, $0B, $6C, $02, $0D, $64, $02, $72, $61, $47, $09, $6F
	.byte $6B, $4A, $09, $79, $60, $21, $0F, $32, $60, $20, $32, $68, $20, $05, $7A, $02
	.byte $0B, $76, $02, $70, $75, $49, $05, $6A, $7B, $4F, $04, $79, $70, $21, $0F, $32
	.byte $70, $20, $38, $7D, $E2, $E7, $73, $10, $FF
