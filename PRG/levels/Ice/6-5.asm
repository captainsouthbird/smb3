; Original address was $ACEA
; 6-5 outside / powerup / goal
	.word W605_UnderL	; Alternate level layout
	.word W605_UnderO	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_400

	.byte $60, $0E, $1F, $61, $0E, $8F, $63, $0E, $8F, $65, $0E, $8F, $67, $0E, $8F, $69
	.byte $0E, $8F, $6B, $0E, $8F, $6D, $0E, $8F, $6F, $0E, $8F, $71, $0E, $86, $73, $0C
	.byte $87, $75, $06, $80, $75, $0A, $88, $77, $04, $81, $77, $0E, $86, $79, $00, $8F
	.byte $20, $00, $4D, $12, $01, $C2, $13, $08, $C2, $37, $0C, $E1, $E0, $52, $20, $60
	.byte $1E, $1F, $60, $2E, $1F, $61, $2E, $84, $63, $2E, $84, $65, $2E, $84, $67, $2E
	.byte $84, $69, $2E, $84, $6B, $2E, $84, $6D, $2E, $84, $6F, $2E, $84, $71, $26, $88
	.byte $73, $26, $88, $75, $26, $88, $77, $26, $88, $79, $20, $8F, $57, $1C, $11, $35
	.byte $20, $01, $37, $24, $91, $E1, $64, $96, $E2, $52, $41, $60, $3F, $10, $61, $38
	.byte $17, $62, $38, $17, $63, $38, $17, $64, $38, $17, $65, $38, $17, $66, $38, $17
	.byte $67, $38, $17, $68, $38, $17, $69, $38, $17, $6A, $38, $17, $6B, $38, $17, $6C
	.byte $38, $17, $6D, $38, $17, $6E, $38, $17, $6F, $38, $17, $70, $38, $17, $71, $38
	.byte $17, $72, $38, $17, $73, $38, $17, $74, $38, $17, $75, $38, $17, $76, $38, $17
	.byte $77, $38, $17, $78, $38, $17, $79, $38, $17, $1A, $38, $10, $27, $37, $41, $A2
	.byte $13, $47, $C2, $14, $43, $C2, $40, $4C, $09, $FF
