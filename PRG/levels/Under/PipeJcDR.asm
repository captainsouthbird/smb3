; Original address was $AFDF
; Pipe junction D2
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_D8
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $99, $00, $51, $0F, $6F, $00, $E9, $99, $01, $80, $04, $96, $06
	.byte $82, $02, $16, $06, $01, $17, $06, $E1, $95, $09, $83, $02, $15, $09, $01, $93
	.byte $0C, $85, $02, $13, $0C, $01, $14, $0C, $E0, $93, $0F, $57, $00, $0F, $0F, $E3
	.byte $8F, $03, $B3, $01, $0F, $03, $E2, $12, $03, $07, $71, $04, $E0, $12, $04, $0A
	.byte $8F, $05, $B1, $01, $10, $06, $0A, $8F, $07, $B0, $05, $0F, $0C, $0A, $2F, $01
	.byte $C6, $2F, $0D, $C1, $FF
