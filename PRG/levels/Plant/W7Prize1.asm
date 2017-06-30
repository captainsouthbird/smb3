; Original address was $BED3
; World 7 giant piranha prize room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_05 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(5) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $FD, $4E, $00, $F7, $40, $04, $FC, $4D, $0E, $F8, $2D, $04, $F9, $4D
	.byte $09, $24, $34, $09, $F2, $54, $0B, $22, $36, $00, $F8, $56, $08, $27, $20, $02
	.byte $D1, $19, $00, $B1, $19, $01, $A1, $19, $02, $B1, $19, $03, $A1, $19, $04, $B1
	.byte $19, $05, $A1, $19, $06, $B1, $19, $07, $A1, $19, $08, $B1, $19, $09, $A1, $19
	.byte $0A, $B1, $19, $0B, $A1, $19, $0C, $B1, $19, $0D, $A1, $19, $0E, $B1, $19, $0F
	.byte $A1, $18, $00, $01, $18, $01, $00, $18, $02, $01, $18, $03, $00, $18, $04, $01
	.byte $18, $05, $00, $18, $06, $01, $18, $07, $00, $18, $08, $01, $18, $09, $00, $18
	.byte $0A, $01, $18, $0B, $00, $18, $0C, $01, $18, $0D, $00, $18, $0E, $01, $18, $0F
	.byte $00, $FF
