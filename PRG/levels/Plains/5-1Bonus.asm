; Original address was $B64D
; 5-1's bonus area
	.word W501L	; Alternate level layout
	.word W501O	; Alternate object layout
	.byte LEVEL1_SIZE_07 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $40, $00, $B9, $01, $40, $00, $B3, $07, $40, $08, $B7, $09, $4A, $00, $BF, $05
	.byte $5A, $00, $B0, $05, $4F, $06, $BB, $07, $55, $0E, $B5, $07, $27, $02, $A2, $31
	.byte $0E, $0E, $40, $12, $BA, $23, $4C, $10, $B5, $02, $4C, $14, $B5, $02, $4C, $18
	.byte $B9, $03, $4C, $1C, $B7, $03, $59, $16, $B1, $09, $34, $1E, $C1, $4C, $20, $BE
	.byte $10, $51, $31, $B8, $04, $40, $36, $BF, $09, $50, $36, $BA, $09, $1A, $40, $C0
	.byte $30, $58, $40, $23, $19, $46, $92, $16, $4A, $00, $19, $50, $94, $40, $56, $09
	.byte $E1, $61, $A3, $FF
