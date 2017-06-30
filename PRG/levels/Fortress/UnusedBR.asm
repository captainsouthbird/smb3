; Original address was $A930
; Bowser's room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $60, $00, $3F, $0F, $70, $00, $38, $0F, $14, $0E, $E0, $01, $15, $0E, $07, $17
	.byte $00, $E0, $01, $17, $0D, $E0, $02, $18, $00, $E2, $0F, $78, $02, $D0, $0A, $79
	.byte $04, $D1, $06, $FF
