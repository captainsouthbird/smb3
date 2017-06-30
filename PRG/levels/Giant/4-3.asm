; Original address was $B00F
; 4-3 entrance 
	.word W403_UnderL	; Alternate level layout
	.word W403_UnderO	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_170
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_03 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_OVERWORLD | LEVEL5_TIME_300

	.byte $19, $00, $7F, $19, $20, $77, $15, $07, $05, $11, $04, $10, $13, $12, $05, $15
	.byte $18, $20, $17, $18, $20, $15, $23, $05, $11, $20, $10, $20, $2E, $41, $01, $2E
	.byte $50, $03, $2E, $50, $05, $2E, $50, $07, $2E, $50, $09, $2E, $50, $0B, $2E, $50
	.byte $0D, $2E, $50, $0F, $2E, $50, $11, $2E, $50, $13, $2E, $50, $15, $2E, $50, $17
	.byte $2E, $50, $19, $2E, $50, $35, $2C, $93, $37, $28, $E3, $E2, $52, $20, $FF
