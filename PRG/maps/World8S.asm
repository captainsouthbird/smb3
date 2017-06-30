W8_InitIndex:	.byte $00, (W8_ByRowType_S2 - W8_ByRowType), (W8_ByRowType_S3 - W8_ByRowType), (W8_ByRowType_S4 - W8_ByRowType)
W8_ByRowType:	.byte $3E, $51, $5E, $51, $71, $7A, $71, $7A
W8_ByRowType_S2:	.byte $3E, $5E, $5A, $5E, $51, $71, $7B, $7B, $7B, $7E
W8_ByRowType_S3:	.byte $5E, $51, $5E, $51, $51, $51, $71, $71, $72, $71, $7E, $9E, $9E, $91, $91, $91, $9E
W8_ByRowType_S4:	.byte $7E, $7A, $71, $71, $71, $72
W8_ByScrCol:	.byte $08, $02, $06, $08, $02, $04, $06, $08
W8_ByScrCol_S2:	.byte $1A, $12, $14, $18, $1A, $14, $16, $18, $1A, $1C
W8_ByScrCol_S3:	.byte $22, $24, $26, $28, $2A, $2C, $22, $24, $28, $2A, $2C, $22, $24, $26, $28, $2A, $2C
W8_ByScrCol_S4:	.byte $32, $34, $36, $38, $3A, $3C
W8_ObjSets:	.word W8P1O, W8HBO, W8P4O, W8HBO, W8HBO, W8T1O, W8HBO, W8BSO
W8_ObjSets_S2:	.word W8P4O, W8P2O, W8AirshipO, W8P5O, W8HBO, W8HBO, W8H3O, W8H2O, W8H1O, W8P1O
W8_ObjSets_S3:	.word W8P2O, W8HBO, W8P3O, W8HBO, W8HBO, W8HBO, W8HBO, W801O, W80FO, W8HBO, W8P5O, W802O, W8P6O, W8HBO, W8HBO, W8HBO, W8P6O
W8_ObjSets_S4:	.word W8P3O, W8T2O, W8HBO, W8HBO, W8HBO, W8BCO
W8_LevelLayout:	.word PJFLL, W707L, PJFLL, W707L, W707L, W8T1L, W707L, W8BSL
W8_LevelLayout_S2:	.word PJFRL, PJFLL, W8AirshipL, PJFLL, W707L, W707L, W8H3L, W8H2L, W8H1L, PJFRL
W8_LevelLayout_S3:	.word PJFRL, W707L, PJFLL, W707L, W707L, W707L, W707L, W801L, W80FL, W707L, PJFRL, W802L, PJALL, W707L, W707L, W707L, PJARL
W8_LevelLayout_S4:	.word PJFRL, W8T2L, W707L, W707L, W707L, W8BCL
