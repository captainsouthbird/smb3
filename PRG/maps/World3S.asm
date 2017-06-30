W3_InitIndex:	.byte $00, (W3_ByRowType_S2 - W3_ByRowType), (W3_ByRowType_S3 - W3_ByRowType), (W3_ByRowType_S4 - W3_ByRowType)
W3_ByRowType:	.byte $27, $21, $21, $21, $27, $21, $21, $44, $41, $4E, $41, $61, $6F, $62, $61, $61, $61, $86, $81, $8E, $86, $81, $A1, $AE, $AF, $A1, $AE
W3_ByRowType_S2:	.byte $24, $21, $21, $21, $4E, $41, $4F, $42, $5F, $57, $61, $61, $6E, $6E, $73, $77, $7F, $81, $81, $81
W3_ByRowType_S3:	.byte $21, $27, $82, $81, $8E
W3_ByRowType_S4:
W3_ByScrCol:	.byte $02, $04, $06, $08, $0A, $0C, $0E, $04, $08, $0C, $0E, $04, $06, $08, $0A, $0C, $0E, $04, $08, $0A, $0C, $0E, $02, $04, $06, $08, $0A
W3_ByScrCol_S2:	.byte $10, $12, $14, $16, $10, $12, $14, $16, $1A, $1C, $10, $12, $14, $16, $18, $1A, $1C, $10, $12, $14
W3_ByScrCol_S3:	.byte $20, $22, $29, $2B, $2D
W3_ByScrCol_S4:
W3_ObjSets:	.word $0300, W3HBO, W3HBO, W303O, $0800, W3HBO, W3HBO, W302O, W3HBO, W304O, W3HBO, W3HBO, $0001, W3F1O, W3HBO, W3HBO, W3HBO, W301O, $C640, W3P1O, W305O, $C640, W3HBO, W3P1O, $0001, W3HBO, W3P2O
W3_ObjSets_S2:	.word W306O, W3HBO, W307O, W3HBO, W308O, W3HBO, $0001, $D362, $0001, $0800, W3HBO, W309O, W3P3O, W3P2O, $C640, $0800, $0001, W3HBO, W3HBO, W3HBO
W3_ObjSets_S3:	.word W3HBO, $0700, KINGO, W3HBO, W3P3O
W3_ObjSets_S4:
W3_LevelLayout:	.word TOADL, W3HBA, W3HBC, W303L, TOADL, W3HBA, W3HBA, W302L, W3HBC, W304L, W3HBA, W3HBB, $0000, W3F1L, W3HBA, W3HBB, W3HBA, W301L, $BDD8, PJDRL, W305L, $BDD8, W3HBA, PJDLL, $0000, W3HBA, PJBLL
W3_LevelLayout_S2:	.word W306L, W3HBA, W307L, W3HBA, W308L, W3HBA, $0000, $AA79, $0000, TOADL, W3HBA, W309L, PJCLL, PJBRL, $B3E7, TOADL, $0000, W3HBA, W3HBA, W3HBA
W3_LevelLayout_S3:	.word W3HBA, TOADL, KNG3L, W3HBA, PJCRL
W3_LevelLayout_S4:
