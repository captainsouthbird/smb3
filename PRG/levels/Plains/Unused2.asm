; Original address was $A9AC
; "Unused Level 2"
	.word Unused2_ExitL	; Alternate level layout
	.word Unused2_ExitO	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_070
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_01 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(1) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $0A, $00, $C1, $4D, $51, $00, $89, $3F, $19, $00, $D1, $4F, $02, $05, $E2, $04
	.byte $0B, $E2, $06, $0B, $00, $09, $07, $92, $4C, $00, $BC, $01, $34, $02, $94, $E0
	.byte $51, $10, $35, $06, $43, $19, $03, $F5, $01, $16, $E2, $03, $1D, $E2, $26, $14
	.byte $A3, $27, $11, $A2, $26, $1A, $12, $27, $1E, $11, $27, $1F, $30, $29, $19, $70
	.byte $09, $1B, $92, $2C, $14, $D5, $30, $16, $81, $34, $12, $A1, $34, $14, $45, $34
	.byte $1E, $A4, $36, $12, $41, $37, $1A, $A1, $19, $1B, $F3, $01, $21, $E2, $03, $2C
	.byte $E2, $25, $22, $A4, $26, $29, $A3, $26, $27, $0E, $26, $28, $0E, $07, $2C, $01
	.byte $09, $20, $90, $2C, $29, $D8, $34, $2E, $A4, $19, $21, $F6, $01, $34, $E2, $04
	.byte $3A, $E2, $26, $36, $22, $27, $32, $13, $47, $3C, $FC, $09, $31, $91, $09, $38
	.byte $92, $29, $35, $40, $30, $32, $81, $33, $35, $41, $34, $35, $40, $35, $33, $42
	.byte $19, $30, $F4, $40, $3E, $B9, $0F, $4C, $40, $BC, $0F, $FF
