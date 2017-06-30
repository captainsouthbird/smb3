; Original address was $AFD8
; Apparently unused fortress boss room with two rotodisc pillars to duck under
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6E, $00, $3A, $3F, $00, $00, $EF, $19, $30, $01, $D5, $00, $1A, $EE, $01, $00
	.byte $1C, $EF, $23, $10, $10, $E7, $00, $10, $19, $E7, $00, $10, $1C, $E5, $00, $15
	.byte $10, $02, $15, $19, $02, $13, $25, $E0, $08, $14, $24, $E0, $09, $15, $23, $E0
	.byte $0A, $16, $22, $E0, $0B, $17, $21, $E0, $0C, $18, $20, $E0, $0D, $11, $35, $71
	.byte $16, $33, $E0, $00, $16, $37, $E0, $00, $16, $3B, $E0, $00, $10, $3F, $E8, $00
	.byte $FF
