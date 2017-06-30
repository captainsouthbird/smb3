; Original address was $AD60
; Toad House
	.word $0000	; Alternate level layout
	.word $0000	; Alternate object layout
	.byte LEVEL1_SIZE_01 | LEVEL1_YSTART_140
	.byte LEVEL2_BGPAL_00 | LEVEL2_OBJPAL_08 | LEVEL2_XSTART_18 | LEVEL2_UNUSEDFLAG
	.byte LEVEL3_TILESET_07 | LEVEL3_VSCROLL_LOCKED
	.byte LEVEL4_BGBANK_INDEX(7) | LEVEL4_INITACT_NOTHING
	.byte LEVEL5_BGM_TOADHOUSE | LEVEL5_TIME_UNLIMITED

	.byte $6F, $00, $6F, $70, $00, $6F, $0F, $04, $B7, $10, $02, $B2, $10, $0B, $B2, $71
	.byte $00, $60, $11, $01, $B1, $11, $0D, $B1, $71, $0F, $60, $12, $00, $B1, $12, $0E
	.byte $B1, $13, $00, $A2, $13, $0F, $A3, $16, $00, $B2, $16, $0C, $B2, $77, $00, $73
	.byte $77, $01, $73, $17, $02, $A2, $17, $0D, $A2, $77, $0E, $73, $77, $0F, $73, $1A
	.byte $02, $BB, $10, $0A, $C0, $11, $0C, $C0, $12, $0D, $C0, $13, $0E, $C2, $16, $0C
	.byte $C3, $18, $04, $08, $18, $07, $08, $18, $0A, $08, $FF
