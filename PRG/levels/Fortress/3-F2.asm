; Original address was $AA79
; World 3 2nd Fortress entrance and second part
	.word W3F2_AltL	; Alternate level layout
	.word W3F2_AltO	; Alternate object layout
	.byte LEVEL1_SIZE_05 | LEVEL1_YSTART_040
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_02 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(2) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_FORTRESS | LEVEL5_TIME_300

	.byte $00, $00, $E1, $0F, $47, $04, $83, $0B, $06, $00, $E1, $03, $08, $00, $E2, $05
	.byte $0B, $00, $E0, $0F, $03, $07, $72, $29, $0A, $91, $02, $00, $4F, $E0, $52, $10
	.byte $00, $10, $EE, $0F, $0F, $10, $EB, $0F, $19, $20, $E1, $2F, $58, $28, $82, $07
	.byte $4F, $20, $89, $11, $0F, $20, $E0, $0F, $10, $20, $E0, $05, $12, $2C, $B5, $34
	.byte $20, $A2, $16, $29, $B5, $17, $20, $E0, $02, $18, $20, $E0, $04, $58, $33, $82
	.byte $03, $4F, $32, $89, $0D, $0F, $30, $E0, $0F, $10, $35, $E5, $01, $10, $37, $E0
	.byte $08, $14, $39, $B5, $17, $3A, $E1, $03, $4F, $40, $89, $0F, $0F, $40, $E1, $0F
	.byte $10, $4F, $E6, $00, $12, $42, $B5, $34, $4D, $92, $17, $41, $B5, $17, $4C, $E0
	.byte $03, $18, $4B, $E0, $04, $E4, $42, $14, $FF
