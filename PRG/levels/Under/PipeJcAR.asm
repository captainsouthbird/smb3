; Original address was $ADE8
; Pipe junction A2
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_D8
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $6F, $00, $E4, $94, $00, $56, $00, $94, $01, $86, $01, $14, $02
	.byte $04, $75, $02, $E0, $16, $03, $54, $16, $0C, $64, $99, $06, $81, $03, $94, $0D
	.byte $86, $01, $14, $0D, $01, $15, $0D, $E0, $94, $0F, $56, $00, $0F, $0F, $E4, $8F
	.byte $03, $B1, $09, $0F, $03, $E0, $6F, $0C, $E0, $10, $03, $07, $10, $0C, $0A, $2F
	.byte $01, $C1, $2F, $0D, $C1, $FF
