; Original address was $BF29
; 6-1 bonus
	.word W601L	; Alternate level layout
	.word W601O	; Alternate object layout
	.byte LEVEL1_SIZE_02 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $6F, $00, $8F, $71, $00, $80, $73, $00, $80, $75, $00, $80, $77, $00, $80, $79
	.byte $00, $8F, $77, $04, $80, $71, $0C, $80, $74, $06, $1F, $35, $09, $1A, $36, $09
	.byte $1A, $37, $09, $1A, $38, $09, $1A, $71, $10, $80, $71, $18, $80, $74, $16, $17
	.byte $77, $16, $80, $77, $1A, $81, $71, $1E, $80, $73, $1E, $80, $75, $1E, $80, $77
	.byte $1E, $80, $53, $1C, $08, $17, $19, $05, $E1, $18, $C3, $FF
