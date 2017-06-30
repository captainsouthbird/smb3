; Original address was $AEA3
; World 5 ground Fortress bonus / boss room
	.word W5F1L	; Alternate level layout
	.word W5F1O	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $6C, $01, $3C, $10, $04, $00, $E7, $11, $0C, $00, $EC, $00, $2C, $01, $D4, $33
	.byte $09, $80, $34, $08, $82, $35, $07, $80, $35, $09, $80, $35, $0B, $80, $36, $09
	.byte $80, $37, $09, $80, $38, $09, $80, $2E, $06, $0F, $2E, $0C, $0F, $2F, $09, $0F
	.byte $04, $12, $EB, $2D, $10, $12, $E8, $2D, $36, $10, $92, $E1, $42, $54, $75, $1C
	.byte $33, $14, $70, $31, $38, $0D, $16, $23, $63, $FF
