; Original address was $B279
; World 4 2nd fortress bonus area
	.word W4F2L	; Alternate level layout
	.word W4F2O	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_02 | LEVEL3_VERTICAL | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(8) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $00, $00, $0C, $20, $00, $4F, $25, $04, $91, $27, $00, $47, $28, $00, $47, $29
	.byte $00, $47, $27, $0B, $44, $28, $0B, $44, $29, $0B, $44, $4D, $00, $24, $2D, $08
	.byte $F7, $04, $1C, $07, $46, $10, $29, $26, $1C, $F3, $00, $21, $12, $0E, $12, $26
	.byte $09, $21, $2C, $04, $15, $1F, $00, $28, $1C, $0C, $1E, $1C, $06, $21, $13, $05
	.byte $2B, $18, $21, $2C, $00, $22, $36, $F9, $42, $30, $21, $21, $39, $A3, $25, $39
	.byte $41, $06, $33, $04, $29, $33, $45, $2A, $39, $A1, $2C, $39, $41, $0D, $3C, $07
	.byte $24, $3E, $A4, $29, $3E, $D4, $21, $48, $46, $07, $45, $04, $08, $4D, $0A, $2A
	.byte $40, $F8, $4A, $49, $26, $0E, $11, $00, $0E, $18, $01, $09, $21, $02, $09, $2E
	.byte $03, $E4, $78, $85, $E0, $12, $99, $FF
