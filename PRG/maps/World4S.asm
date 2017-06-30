W4_InitIndex:	.byte $00, (W4_ByRowType_S2 - W4_ByRowType), (W4_ByRowType_S3 - W4_ByRowType), (W4_ByRowType_S4 - W4_ByRowType)
W4_ByRowType:	.byte $4B, $4E, $47, $41, $4B, $6B, $62, $6B, $6B, $62, $8E, $8F, $8B, $8B
W4_ByRowType_S2:	.byte $4B, $4E, $42, $4B, $4B, $4B, $4B, $6B, $6B, $6B, $6F, $67, $6B, $8B, $8B, $8B, $87, $8E, $8B, $A7
W4_ByRowType_S3:
W4_ByRowType_S4:
W4_ByScrCol:	.byte $02, $04, $0A, $0C, $0E, $02, $08, $0A, $0C, $0E, $02, $0A, $0C, $0E
W4_ByScrCol_S2:	.byte $10, $12, $14, $16, $18, $1A, $1C, $10, $12, $14, $16, $1A, $1C, $10, $12, $14, $18, $1A, $1C, $14
W4_ByScrCol_S3:
W4_ByScrCol_S4:
W4_ObjSets:	.word W4HBO, W4P1O, $0900, W46AO, W4HBO, W4HBO, KINGO, W4HBO, W4HBO, W4F2O, W4P2O, $0001, W405O, W4HBO
W4_ObjSets_S2:	.word W4HBO, W4P2O, W4F1O, W4HBO, W403O, W4HBO, W402O, W4HBO, W4HBO, W4HBO, $0001, $0700, W4HBO, W4HBO, W4HBO, W404O, $0400, W4P1O, W401O, $0700
W4_ObjSets_S3:
W4_ObjSets_S4:
W4_LevelLayout:	.word W4HBA, PJALL, TOADL, W46AL, W4HBA, W4HBA, KNG4L, W4HBA, W4HBA, W4F2L, PJDLL, $0000, W405L, W4HBA
W4_LevelLayout_S2:	.word W4HBA, PJDRL, W4F1L, W4HBA, W403L, W4HBA, W402L, W4HBA, W4HBA, W4HBA, $0000, TOADL, W4HBA, W4HBA, W4HBA, W404L, TOADL, PJARL, W401L, TOADL
W4_LevelLayout_S3:
W4_LevelLayout_S4:
