; Original address was $AA2A
; World 1 Fortress spike room / Warp Whistle location
	.word W10FL	; Alternate level layout
	.word W10FO	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6E, $00, $3C, $1F, $00, $00, $EF, $1F, $19, $00, $E1, $1F, $10, $00, $DF, $6E
	.byte $09, $32, $02, $79, $0D, $31, $02, $10, $10, $DF, $17, $1D, $00, $6F, $1D, $31
	.byte $00, $79, $12, $31, $03, $0F, $1D, $D0, $00, $1E, $EF, $11, $10, $1E, $EA, $11
	.byte $00, $30, $EF, $2F, $10, $30, $EA, $2F, $6F, $44, $39, $08, $12, $46, $61, $0E
	.byte $09, $D2, $E1, $68, $B7, $FF
