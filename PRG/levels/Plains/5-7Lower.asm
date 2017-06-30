; Original address was $A4F9
; 5-7 lower part (broken LoadLevel_LittleCloudSolidRun fails to load in editor)
	.word W507L	; Alternate level layout
	.word W507O	; Alternate object layout
	.byte LEVEL1_SIZE_07 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_13 | LEVEL3_VSCROLL_FREE | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $00, $00, $03, $60, $00, $19, $20, $02, $D5, $1A, $00, $C0, $2A, $19, $03, $92
	.byte $09, $05, $E2, $0F, $07, $E3, $61, $08, $16, $19, $08, $90, $14, $0A, $43, $17
	.byte $0C, $22, $0C, $0B, $E2, $62, $0D, $15, $12, $10, $02, $20, $13, $14, $20, $19
	.byte $16, $21, $13, $14, $21, $19, $16, $22, $13, $14, $22, $19, $16, $23, $15, $18
	.byte $24, $17, $14, $25, $19, $10, $23, $18, $0D, $0A, $13, $E2, $34, $15, $84, $37
	.byte $16, $09, $38, $16, $40, $39, $16, $40, $19, $1B, $92, $08, $1D, $E3, $34, $1D
	.byte $84, $36, $1F, $40, $37, $1F, $40, $38, $1F, $40, $39, $1F, $40, $12, $21, $02
	.byte $60, $20, $1E, $02, $22, $E2, $04, $26, $E3, $34, $26, $84, $57, $28, $05, $38
	.byte $28, $40, $39, $28, $40, $1A, $2D, $C0, $11, $14, $2E, $33, $20, $2F, $18, $36
	.byte $2D, $09, $21, $31, $14, $22, $33, $10, $18, $31, $13, $32, $35, $41, $36, $37
	.byte $61, $2E, $39, $41, $2A, $3B, $41, $19, $3A, $92, $56, $37, $03, $2A, $39, $09
	.byte $20, $3B, $C4, $E3, $61, $05, $40, $40, $BF, $0F, $50, $40, $BA, $0F, $58, $50
	.byte $22, $1A, $50, $BF, $1A, $60, $BF, $40, $5A, $09, $FF
