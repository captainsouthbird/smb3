; Original address was $AE37
; Pipe junction B1
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $6F, $00, $E4, $94, $00, $56, $00, $94, $01, $86, $01, $14, $02
	.byte $04, $75, $02, $E0, $96, $03, $84, $01, $16, $04, $04, $77, $04, $E0, $98, $05
	.byte $82, $05, $96, $0B, $84, $01, $16, $0B, $01, $17, $0B, $E0, $94, $0D, $86, $01
	.byte $14, $0D, $01, $15, $0D, $E0, $94, $0F, $56, $00, $0F, $0F, $E4, $8F, $03, $B1
	.byte $09, $0F, $03, $E0, $10, $03, $07, $6F, $0C, $E0, $10, $0C, $0A, $2F, $01, $C1
	.byte $2F, $0D, $C1, $FF
