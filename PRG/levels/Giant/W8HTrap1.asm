; Original address was $BD40
; Hammer Bro hand trap
	.word W8H_PrizeL	; Alternate level layout
	.word W8H_PrizeO	; Alternate object layout
	.byte LEVEL1_SIZE_04 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_03 | LEVEL2_OBJPAL_09 | LEVEL2_XSTART_18
	.byte LEVEL3_TILESET_11 | LEVEL3_VSCROLL_LOCKED | LEVEL3_PIPENOTEXIT
	.byte LEVEL4_BGBANK_INDEX(11) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_UNDERGROUND | LEVEL5_TIME_200

	.byte $79, $00, $71, $0D, $79, $26, $71, $19, $55, $00, $4D, $56, $0E, $B4, $01, $55
	.byte $0F, $B0, $00, $59, $10, $4F, $32, $19, $16, $36, $19, $16, $32, $1F, $30, $36
	.byte $1E, $31, $36, $1D, $07, $52, $20, $B8, $02, $55, $23, $B5, $02, $54, $26, $4F
	.byte $54, $36, $48, $40, $3D, $B9, $02, $4A, $3F, $BF, $00, $5A, $3F, $B0, $00, $2A
	.byte $3D, $C7, $E3, $51, $10, $FF
