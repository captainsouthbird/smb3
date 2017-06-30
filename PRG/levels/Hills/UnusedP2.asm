; Original address was $A98E
; "Orange" pipe junction 2
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_0F0
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_70
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(3) | LEVEL4_INITACT_PIPE_B
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $0E, $80, $00, $5E, $0F, $8E, $01, $B0, $04, $6F, $00, $E4, $0F, $06
	.byte $73, $8F, $0A, $B3, $03, $8F, $0E, $5B, $01, $13, $0E, $E4, $98, $00, $52, $0D
	.byte $98, $09, $82, $04, $14, $05, $53, $94, $01, $83, $03, $94, $00, $54, $00, $2F
	.byte $02, $C1, $36, $0B, $91, $FF
