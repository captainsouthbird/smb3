; Original address was $B0B5
; Pipe junction F1
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_04 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $9A, $00, $50, $0F, $95, $00, $54, $00, $6F, $00, $E5, $95, $01
	.byte $84, $04, $15, $06, $54, $9A, $0B, $80, $03, $8F, $0F, $5B, $00, $14, $0F, $E5
	.byte $8F, $0B, $B4, $03, $0F, $06, $74, $8F, $03, $B0, $03, $0F, $03, $07, $2F, $01
	.byte $C1, $38, $0D, $91, $9A, $0D, $50, $01, $FF
