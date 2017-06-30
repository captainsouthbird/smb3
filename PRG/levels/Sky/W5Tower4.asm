; Original address was $B5AE
; World 5 top of tower
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $0C, $37, $02, $11, $36, $02, $13, $30, $02, $14, $2D, $02, $14, $20, $02, $0F
	.byte $21, $02, $07, $21, $02, $03, $21, $02, $00, $22, $02, $14, $14, $02, $11, $1F
	.byte $02, $10, $12, $02, $0F, $1D, $02, $0B, $1D, $02, $09, $1F, $02, $07, $1D, $02
	.byte $05, $1B, $02, $03, $19, $02, $00, $1A, $02, $14, $0A, $02, $11, $0F, $02, $14
	.byte $18, $02, $34, $17, $A1, $36, $17, $31, $37, $17, $31, $38, $15, $19, $39, $15
	.byte $19, $3A, $15, $19, $78, $12, $42, $02, $60, $1F, $46, $07, $20, $22, $C5, $09
	.byte $21, $F5, $0D, $24, $F2, $31, $21, $81, $31, $24, $81, $34, $22, $23, $34, $23
	.byte $0C, $18, $21, $F2, $18, $24, $F2, $71, $39, $49, $06, $79, $35, $41, $03, $FF
