; Original address was $BFB3
; World 5 Hammer Bro battle Sky B
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_BATTLE | LEVEL5_TIME_200

	.byte $13, $04, $02, $11, $06, $02, $0F, $04, $02, $0D, $06, $02, $32, $07, $15, $36
	.byte $08, $15, $79, $00, $21, $0F, $32, $0D, $0B, $36, $07, $0A, $36, $0A, $07, $FF
