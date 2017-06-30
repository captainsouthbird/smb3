; Original address was $B126
; World 6 third fortress "Boo room"
	.word W6F3L	; Alternate level layout
	.word W6F3O	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $61, $00, $2F, $0F, $71, $00, $27, $0F, $01, $00, $5F, $00, $00, $E0, $0F, $07
	.byte $01, $93, $0D, $06, $61, $11, $04, $62, $14, $02, $73, $09, $0E, $00, $E0, $68
	.byte $99, $FF
