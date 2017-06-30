; Original address was $AC16
; 5-3 beginning
	.word W503_InsideL	; Alternate level layout
	.word W503_InsideO	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $0B, $00, $C5, $0F, $49, $00, $B1, $02, $0A, $05, $93, $04, $02, $E2, $03, $0A
	.byte $E2, $05, $07, $07, $28, $09, $92, $40, $0E, $BA, $01, $E0, $02, $67, $FF
