; Original address was $B568
; World 5 drop-down
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_040
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_80
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_FREE
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $14, $06, $02, $14, $00, $02, $10, $00, $02, $0E, $04, $02, $0C, $06, $02, $09
	.byte $05, $02, $05, $05, $02, $03, $03, $02, $00, $04, $02, $00, $02, $02, $20, $07
	.byte $D5, $14, $01, $F2, $36, $06, $13, $34, $07, $92, $36, $04, $0B, $36, $0B, $10
	.byte $37, $04, $17, $38, $04, $17, $39, $04, $17, $3A, $05, $15, $FF
