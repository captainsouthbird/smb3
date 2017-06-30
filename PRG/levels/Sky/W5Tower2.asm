; Original address was $B637
; World 5 tower just before top
	.word W5T3L	; Alternate level layout
	.word W5T3O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $00, $11, $02, $0B, $00, $02, $09, $0A, $02, $09, $06, $02, $04, $03, $02, $02
	.byte $0D, $02, $70, $00, $4A, $04, $6B, $05, $4F, $18, $69, $0F, $41, $06, $60, $16
	.byte $48, $10, $6A, $14, $46, $05, $60, $20, $4F, $0F, $70, $20, $4A, $0F, $30, $0D
	.byte $82, $31, $08, $82, $31, $0C, $80, $36, $02, $13, $34, $03, $A2, $35, $0C, $10
	.byte $35, $0E, $0B, $36, $00, $10, $36, $07, $10, $36, $0C, $14, $37, $00, $17, $37
	.byte $0C, $14, $38, $00, $17, $38, $0D, $12, $39, $00, $16, $39, $0D, $12, $3A, $00
	.byte $16, $3A, $0D, $12, $20, $1A, $1C, $21, $1A, $1C, $22, $1A, $1C, $23, $1A, $1C
	.byte $24, $1A, $1C, $25, $1A, $1C, $26, $1A, $1C, $27, $1A, $1C, $28, $1A, $1C, $29
	.byte $1A, $1C, $2A, $1A, $1C, $2B, $1A, $1C, $2C, $1A, $1C, $2D, $1A, $1C, $2E, $1A
	.byte $1C, $2F, $1A, $1C, $30, $1A, $1C, $31, $10, $80, $31, $1C, $C2, $E1, $51, $20
	.byte $31, $1E, $18, $32, $1E, $18, $33, $1E, $18, $34, $14, $10, $34, $16, $10, $34
	.byte $1E, $0A, $34, $1F, $17, $35, $14, $14, $35, $1E, $0A, $35, $1F, $17, $36, $14
	.byte $14, $36, $1E, $0A, $36, $1F, $17, $37, $15, $13, $37, $1E, $0A, $37, $1F, $17
	.byte $38, $15, $18, $38, $1E, $18, $39, $15, $18, $39, $1E, $18, $3A, $15, $18, $3A
	.byte $1E, $18, $26, $2B, $0B, $2C, $29, $0B, $30, $2D, $0B, $FF
