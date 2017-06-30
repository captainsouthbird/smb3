; Original address was $AA61
; 7-1 outside
	.word W701_MazeL	; Alternate level layout
	.word W701_MazeO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_08 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $1A, $00, $C0, $3F, $40, $00, $B0, $0F, $13, $01, $E2, $13, $0A, $E3, $12, $03
	.byte $02, $37, $0A, $A2, $36, $0C, $A3, $36, $0E, $A3, $E0, $F8, $27, $40, $10, $BF
	.byte $0F, $50, $10, $BA, $0F, $14, $10, $04, $E1, $F8, $27, $13, $22, $E2, $11, $26
	.byte $E2, $58, $20, $21, $37, $25, $A2, $35, $27, $A4, $40, $2A, $09, $FF
