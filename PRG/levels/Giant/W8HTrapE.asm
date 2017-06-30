; Original address was $BE17
; Hand trap prize room
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $4F, $00, $B0, $0F, $50, $00, $B8, $00, $59, $00, $B1, $0F, $4F, $0F, $BB, $0A
	.byte $57, $03, $B0, $00, $58, $03, $B0, $01, $56, $0B, $B2, $03, $57, $0A, $B1, $00
	.byte $58, $09, $B0, $00, $34, $01, $A4, $FF
