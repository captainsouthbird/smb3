; Original address was $BCB8
; Tank boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_300

	.byte $00, $00, $0F, $0F, $00, $4B, $0F, $0F, $4B, $19, $01, $61, $19, $03, $61, $19
	.byte $05, $61, $19, $07, $61, $19, $09, $61, $19, $0B, $61, $19, $0D, $61, $14, $01
	.byte $F1, $16, $0A, $F2, $17, $0C, $F1, $15, $0D, $F3, $76, $02, $10, $75, $04, $10
	.byte $77, $05, $10, $77, $08, $10, $76, $0B, $10, $75, $0E, $10, $16, $01, $E2, $15
	.byte $03, $E3, $17, $04, $E1, $17, $07, $E1, $2F, $07, $D1, $FF
