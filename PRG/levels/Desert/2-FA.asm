; Original address was $BBFC
; World 2 fortress spike room
	.word W20FL	; Alternate level layout
	.word W20FO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_11 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_09 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $05, $00, $95, $19, $00, $8F, $35, $06, $41, $74, $06, $31, $76, $06, $41, $35
	.byte $0A, $44, $74, $0A, $34, $76, $0A, $44, $35, $11, $49, $74, $11, $39, $76, $11
	.byte $49, $33, $11, $40, $34, $11, $40, $33, $16, $40, $34, $16, $40, $33, $1A, $40
	.byte $34, $1A, $40, $35, $1E, $46, $74, $1E, $36, $76, $1E, $46, $35, $2A, $43, $74
	.byte $2A, $33, $76, $2A, $43, $09, $2F, $90, $0D, $2F, $90, $11, $2F, $90, $15, $2F
	.byte $90, $17, $26, $0B, $E2, $78, $C9, $33, $1E, $40, $34, $1E, $40, $33, $21, $40
	.byte $34, $21, $40, $33, $24, $40, $34, $24, $40, $69, $00, $4F, $69, $10, $4F, $69
	.byte $20, $4E, $FF
