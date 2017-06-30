; Original address was $B9AB
; "Unused Level 10"
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_SKY | LEVEL5_TIME_300

	.byte $0B, $0B, $02, $10, $0A, $02, $14, $04, $02, $14, $0A, $02, $30, $0F, $80, $32
	.byte $0E, $80, $34, $0D, $80, $34, $0F, $80, $36, $0C, $80, $36, $0E, $80, $0E, $10
	.byte $02, $0C, $14, $02, $14, $1C, $02, $10, $16, $02, $14, $16, $02, $0C, $1C, $02
	.byte $0F, $1D, $02, $14, $10, $02, $15, $13, $07, $11, $1B, $07, $32, $10, $80, $34
	.byte $11, $80, $36, $10, $80, $36, $12, $80, $30, $15, $80, $30, $17, $80, $30, $19
	.byte $80, $30, $1B, $80, $32, $16, $80, $32, $18, $80, $32, $1A, $80, $34, $17, $80
	.byte $34, $19, $80, $36, $18, $80, $34, $1F, $80, $14, $20, $02, $14, $26, $02, $30
	.byte $21, $80, $32, $20, $80, $32, $22, $80, $34, $21, $80, $34, $23, $80, $36, $20
	.byte $80, $36, $22, $80, $36, $24, $80, $79, $00, $11, $2F, $15, $13, $07, $11, $1B
	.byte $07, $37, $07, $A3, $37, $27, $93, $FF
