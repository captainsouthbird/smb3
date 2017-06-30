; Original address was $A8CA
; 3-2 end
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_03 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_01 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_00 | LEVEL3_VSCROLL_LOCKLOW
	.byte LEVEL4_BGBANK_INDEX(4) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_ATHLETIC | LEVEL5_TIME_300

	.byte $17, $07, $02, $18, $07, $10, $06, $31, $09, $41, $32, $09, $D3, $17, $0D, $10
	.byte $06, $16, $0F, $42, $16, $13, $03, $18, $13, $10, $03, $17, $16, $03, $40, $17
	.byte $09, $1A, $17, $10, $30, $2A, $0B, $84, $26, $0B, $80, $26, $0F, $80, $21, $09
	.byte $0F, $03, $0A, $B0, $02, $0B, $80, $03, $0C, $A0, $03, $0D, $80, $03, $0E, $B0
	.byte $02, $0F, $80, $04, $0B, $80, $04, $0A, $A0, $05, $0C, $A0, $06, $0C, $92, $08
	.byte $0D, $B0, $06, $0D, $91, $05, $0E, $B0, $04, $0F, $80, $03, $10, $A0, $04, $10
	.byte $B0, $5A, $00, $80, $16, $FF
