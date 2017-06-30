W5_InitIndex:	.byte $00, (W5_ByRowType_S2 - W5_ByRowType), (W5_ByRowType_S3 - W5_ByRowType), (W5_ByRowType_S4 - W5_ByRowType)
W5_ByRowType:	.byte $23, $2E, $27, $21, $23, $41, $4E, $4E, $43, $43, $42, $63, $62, $63, $63, $63, $83, $83, $8F, $83
W5_ByRowType_S2:	.byte $27, $4D, $4D, $44, $6D, $6D, $6D, $6D, $6F, $8F, $8D, $82, $8D, $8D, $8D, $A2, $AD, $AD, $AD, $AD, $A7, $AD
W5_ByRowType_S3:
W5_ByRowType_S4:
W5_ByScrCol:	.byte $02, $04, $06, $08, $0A, $02, $04, $06, $08, $0A, $0C, $02, $04, $06, $08, $0A, $02, $04, $06, $08
W5_ByScrCol_S2:	.byte $1E, $18, $1C, $1E, $16, $18, $1A, $1C, $1E, $14, $16, $18, $1A, $1C, $1E, $12, $14, $16, $18, $1A, $1C, $1E
W5_ByScrCol_S3:
W5_ByScrCol_S4:
W5_ObjSets:	.word W3HBO, W502O, $0400, W503O, W3HBO, W501O, W5P1O, W5P1O, W3HBO, W3HBO, W5T1O, W3HBO, W5F1O, W3HBO, W3HBO, W3HBO, W3HBO, W3HBO, $0001, W3HBO
W5_ObjSets_S2:	.word $0900, W5TDO, W3HBO, W505O, W3HBO, W3HBO, W504O, W3HBO, $0001, $0001, W3HBO, $D2B4, W3HBO, W507O, W3HBO, KINGO, W3HBO, W509O, W508O, W3HBO, $0700, W506O
W5_ObjSets_S3:
W5_ObjSets_S4:
W5_LevelLayout:	.word W5HBA, W502L, TOADL, W503L, W5HBA, W501L, PJCLL, PJCRL, W5HBA, W5HBA, W5T1L, W5HBA, W5F1L, W5HBA, W5HBA, W5HBA, W5HBA, W5HBA, $0000, W5HBB
W5_LevelLayout_S2:	.word TOADL, W5TDL, W5HBD, W505L, W5HBC, W5HBC, W504L, W5HBC, $0000, $0000, W5HBC, $A857, W5HBC, W507L, W5HBC, KNG5L, W5HBC, W509L, W508L, W5HBC, TOADL, W506L
W5_LevelLayout_S3:
W5_LevelLayout_S4:
