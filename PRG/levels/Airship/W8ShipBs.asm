; Original address was $BD3E
; Tank boss room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_000
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_10 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(10) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_AIRSHIP | LEVEL5_TIME_300

	.byte $00, $00, $0F, $0F, $00, $1F, $10, $00, $4A, $10, $0F, $4A, $19, $01, $61, $19
	.byte $03, $61, $19, $05, $61, $19, $07, $61, $19, $09, $61, $19, $0B, $61, $19, $0D
	.byte $61, $0F, $01, $41, $0F, $02, $41, $FF
