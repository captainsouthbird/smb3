; Original address was $AEF1
; Pipe junction C1
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $99, $00, $51, $0F, $6F, $00, $E9, $99, $01, $81, $0D, $0F, $0F
	.byte $E9, $8F, $03, $B4, $09, $8F, $06, $54, $04, $0F, $03, $E3, $13, $03, $07, $6F
	.byte $0C, $E3, $13, $0C, $0A, $14, $06, $71, $14, $0A, $80, $94, $08, $B2, $01, $16
	.byte $08, $07, $75, $09, $E0, $16, $09, $0A, $2F, $01, $C6, $2F, $0D, $C6, $FF
