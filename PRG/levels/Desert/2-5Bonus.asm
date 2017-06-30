; Original address was $B8A7
; 2-5 bonus
	.word W205L	; Alternate level layout
	.word W205O	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_10 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_09 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(9) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_300

	.byte $4F, $00, $B0, $0F, $4F, $00, $BB, $00, $5A, $00, $B0, $0F, $4F, $0F, $BB, $00
	.byte $31, $03, $10, $31, $05, $10, $31, $07, $10, $31, $09, $10, $31, $0B, $10, $32
	.byte $04, $10, $32, $06, $10, $32, $08, $10, $32, $0A, $10, $33, $03, $10, $33, $05
	.byte $10, $33, $09, $10, $33, $0B, $10, $34, $04, $10, $34, $06, $10, $34, $08, $10
	.byte $34, $0A, $10, $35, $03, $10, $35, $05, $10, $35, $07, $0D, $35, $09, $10, $35
	.byte $0B, $07, $38, $07, $10, $37, $03, $83, $37, $08, $83, $2F, $01, $D1, $38, $0C
	.byte $92, $E0, $12, $E6, $FF
