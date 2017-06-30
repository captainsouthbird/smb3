; Original address was $B22C
; 6-1
	.word W601_BonusL	; Alternate level layout
	.word Empty_ObjLayout	; Alternate object layout
	.byte LEVEL1_SIZE_09 | LEVEL1_YSTART_180
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_12 | LEVEL3_VSCROLL_LOCKLOW | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(12) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $12, $02, $C2, $1A, $00, $10, $0B, $77, $08, $13, $77, $0D, $14, $1A, $0D, $10
	.byte $25, $34, $0E, $11, $34, $10, $00, $38, $14, $A1, $12, $18, $C2, $37, $1A, $82
	.byte $05, $1C, $C2, $14, $21, $C2, $07, $2B, $C2, $12, $2D, $C2, $37, $2A, $A2, $05
	.byte $25, $05, $27, $23, $43, $36, $2F, $03, $E2, $68, $20, $36, $32, $82, $36, $3A
	.byte $A3, $1A, $34, $10, $03, $1A, $39, $10, $34, $03, $3A, $C2, $14, $3D, $C2, $12
	.byte $42, $C2, $07, $49, $C2, $37, $4E, $A2, $36, $4B, $03, $76, $53, $13, $11, $56
	.byte $C2, $76, $58, $12, $33, $58, $82, $07, $59, $C2, $76, $5D, $11, $33, $5E, $82
	.byte $33, $54, $01, $76, $62, $12, $09, $66, $C2, $13, $68, $C2, $38, $6C, $A1, $1A
	.byte $70, $10, $1F, $12, $71, $C2, $40, $77, $09, $FF
