; Original address was $B079
; Pipe junction E2
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_D8
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $99, $00, $51, $0F, $93, $00, $55, $00, $6F, $00, $E3, $93, $01
	.byte $85, $01, $73, $03, $55, $0F, $0F, $E9, $8F, $03, $50, $09, $0F, $03, $E0, $8F
	.byte $0B, $B4, $01, $6F, $0C, $E3, $13, $0C, $0A, $70, $03, $73, $2F, $01, $C1, $2F
	.byte $0D, $C6, $FF
