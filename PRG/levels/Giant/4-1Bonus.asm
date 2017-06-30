; Original address was $B952
; 4-1 bonus
	.word W401L	; Alternate level layout
	.word W401O	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERWATER | LEVEL5_TIME_300

	.byte $52, $01, $87, $1D, $4F, $00, $B1, $20, $51, $00, $BA, $00, $5A, $00, $B0, $20
	.byte $4F, $1F, $BB, $0F, $2F, $07, $D1, $2F, $1D, $C7, $16, $0A, $83, $37, $0D, $32
	.byte $36, $12, $33, $39, $1B, $30, $36, $14, $0B, $37, $0E, $0B, $E1, $21, $A3, $FF
