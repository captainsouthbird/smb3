; Original address was $BA49
; 1-2 bonus area
	.word W102L	; Alternate level layout
	.word W102O	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_05 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $40, $00, $B3, $0F, $44, $00, $B7, $03, $44, $0C, $B7, $03, $4C, $00, $BB, $00
	.byte $4C, $0F, $BD, $00, $5A, $00, $B0, $0F, $24, $07, $D1, $58, $00, $11, $E0, $51
	.byte $C3, $35, $06, $83, $36, $06, $83, $37, $06, $83, $38, $06, $83, $39, $06, $83
	.byte $FF
