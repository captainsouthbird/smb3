; Original address was $AE61
; "Unused Level 15"
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_06 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_02 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(13) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $00, $00, $03, $79, $00, $10, $5F, $31, $16, $80, $31, $18, $80, $31, $1A, $80
	.byte $31, $1C, $80, $31, $1E, $80, $13, $14, $E5, $0D, $11, $24, $E4, $06, $33, $2F
	.byte $20, $16, $27, $E2, $0C, $55, $2C, $31, $10, $36, $E3, $01, $10, $3D, $E3, $01
	.byte $31, $39, $82, $33, $31, $00, $14, $36, $E3, $01, $14, $3D, $E3, $01, $34, $39
	.byte $82, $10, $41, $E4, $04, $11, $48, $E4, $04, $12, $4F, $E4, $04, $FF
