	.inesprg 16  ; 16x 16KB PRG code (32 banks of 8KB)
	.ineschr 16  ; 16x  8KB CHR data (128 banks of 1KB)
	.inesmap 4   ; mapper 4 = MMC3, 8KB PRG, 1/2KB CHR bank swapping
	.inesmir 0   ; background mirroring

; Verifies:
; \$[0-9A-F][0-9A-F][0-9A-F][0-9A-F]

; Translators:
;
; Standard S&R on any address found via:
; [BJ].. \$[0-9A-F][0-9A-F][0-9A-F][0-9A-F]
;
; Then do the following for address label fixing:
; (^\s*.*\s*); (PRG005_[0-9A-F][0-9A-F][0-9A-F][0-9A-F])	-->	\n\2:\n\1	(Labels from comment to beginning of line)
; ^(\s*[BJ].. PRG005_[0-9A-F][0-9A-F][0-9A-F][0-9A-F]).*	-->	\1\n		(Formatting linebreak after B.. J..)
; \s*;.*							-->	(nothing)	(Cleans off remaining address constants)


; Handy pseudo instructions... only make sense in the context of CMPing a number...
BLT 	.macro
	BCC \1	; A < CMP (unsigned)
	.endm

BGE 	.macro
	BCS \1	; A >= CMP (unsigned)
	.endm

BLS 	.macro
	BMI \1	; A < CMP (signed)
	.endm

BGS 	.macro
	BPL \1	; A >= CMP (signed)
	.endm

; Clarifying pseudo instructions
ADD	.macro	; RegEx S&R "CLC.*\n.*?ADC" -> "ADD"
	CLC
	ADC \1
	.endm

SUB	.macro	; RegEx S&R "SEC.*\n.*?SBC" -> "SUB"
	SEC
	SBC \1
	.endm

NEG	.macro	; RegEx S&R "EOR #\$ff.*\n.*ADD #\$01" -> "NEG"
	EOR #$ff
	ADD #$01
	.endm


; This is used in video update streams; since the video address register
; takes the address high-then-low (contrary to 6502's normal low-then-high),
; this allows a 16-bit value but "corrects" it to the proper endianness.
vaddr	.macro
	.byte (\1 & $FF00) >> 8
	.byte (\1 & $00FF)
	.endm

; These are flags related to a video update stream value
VU_VERT		= $80	; Update in vertical (+32B) mode instead of horizontal (+1B) mode
VU_REPEAT	= $40	; Repeat following value several times instead of several raw values

; Provides a compilation-failing boundary check
BoundCheck:	.macro
			if \1 > \2
			fail \3 boundary exceeded (> \2)
			endif
		.endm

; Pads bytes to align to nearest 64 byte boundary for DMC samples
; SB: This would be useful for your own works, but I can't use
; it in the natively disassembly since the assembler pads zeroes
; instead of $FF values... just FYI!
;
; Usage example:
;
; .LabelPriorToDMC: DMCAlign .LabelPriorToDMC
DMCAlign:	.macro
			.ds ((\1 + $3F) & $FFC0) - \1
		.endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PPU I/O regs (CPU side)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;	PPU_CTL1:
;	0-1: Name table address, changes between the four name tables at $2000 (0), $2400 (1), $2800 (2) and $2C00 (3).
;	2: Clear, PPU incs by 1 ("horizontal"); Set, PPU incs by 32 ("vertical")
;	3: Which pattern table holds for sprites; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;	4: Which pattern table holds for BG; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;	5: Set to use 8x16 sprites instead of 8x8
;	7: Set to generate VBlank NMIs
PPU_CTL1	= $2000		; Write only

;	PPU_CTL2:
;	0: Clear for color, set for mono
;	1: Clear to clip 8 left pixels of BG
;	2: Clear to clip 8 left pixels of sprites
;	3: If clear, BG hidden
;	4: If clear, sprites hidden
;	5-7: BG color in mono mode, "color intensity" in color mode (??)
PPU_CTL2	= $2001		; Write only

;	PPU_STAT:
;	4: if set, can write to VRAM, else writes ignored
;	5: if set, sprite overflow occurred on scanline
;	6: Set if any non-transparent pixel of sprite 0 is overlapping a non-transparent pixel of BG
;	7: VBlank is occurring (cleared after read)
PPU_STAT	= $2002

; Sprites: 256 bytes, each sprite takes 4, so 64 sprites total
; Only 8 sprites per scanline, sprite 0 is drawn on top (thus highest priority)
; PPU_SPR_ADDR / PPU_SPR_DATA
; * Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
; * Byte 1 - Index number of the sprite in the pattern tables.
; * Byte 2 - Stores the attributes of the sprite.
;   * Bits 0-1 - Most significant two bits of the colour.  (Or "palette" 0-3)
;   * Bit 5 - Indicates whether this sprite has priority over the background.
;   * Bit 6 - Indicates whether to flip the sprite horizontally.
;   * Bit 7 - Indicates whether to flip the sprite vertically.
; * Byte 3 - X coordinate
PPU_SPR_ADDR	= $2003		; Set address sprite data
PPU_SPR_DATA	= $2004		; Read or write this sprite byte

PPU_SCROLL	= $2005		; Scroll register; read PPU_STAT, then write horiz/vert scroll
PPU_VRAM_ADDR	= $2006		; VRAM address (first write is high, next write is low)
PPU_VRAM_DATA	= $2007		; Data to read/write at this address

; Note that all transparent colors ($3F04, $3F08, $3F0C, $3F10, $3F14, $3F18 and $3F1C) are mirrored from 3F00
PPU_BG_PAL	= $3F00 	; 3F00-3F0F
PPU_SPR_PAL	= $3F10		; 3F10-3F1F


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOUND I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; $4000(rct1)/$4004(rct2)/$400C(noise) bits
; ---------------------------------------
; 0-3	volume / envelope decay rate
; 4	envelope decay disable
; 5	length counter clock disable / envelope decay looping enable
; 6-7	duty cycle type (unused on noise channel)

; Duty cycles:
; 00 = a weak, grainy tone.  (12.5% Duty), 01 = a solid mid-strength tone. (25% Duty), 
; 10 = a strong, full tone (50% Duty), 11 = sounds a lot like 01 (25% Duty negated)

PAPU_CTL1	= $4000	; pAPU Pulse 1 Control Register.
PAPU_CTL2	= $4004	; pAPU Pulse 2 Control Register.
PAPU_NCTL1 	= $400C ; pAPU Noise Control Register 1.


; $4008(tri) bits
; ---------------
; 0-6	linear counter load register
; 7	length counter clock disable / linear counter start
PAPU_TCR1	= $4008	; pAPU Triangle Control Register 1.


; $4001(rct1)/$4005(rct2) bits
; --------------------------
; 0-2	right shift amount
; 3	decrease / increase (1/0) wavelength
; 4-6	sweep update rate
; 7	sweep enable
PAPU_RAMP1	= $4001	; pAPU Pulse 1 Ramp Control Register.
PAPU_RAMP2	= $4005	; pAPU Pulse 2 Ramp Control Register.


; $4002(rct1)/$4006(rct2)/$400A(Tri) bits
; -------------------------------------
; 0-7	8 LSB of wavelength
PAPU_FT1	= $4002	; pAPU Pulse 1 Fine Tune (FT) Register.
PAPU_FT2	= $4006	; pAPU Pulse 2 Fine Tune (FT) Register.
PAPU_TFREQ1	= $400A ; pAPU Triangle Frequency Register 1.


; $400E(noise) bits
; -----------------
; 0-3	playback sample rate
; 4-6	unused
; 7	random number type generation
PAPU_NFREQ1	= $400E ; pAPU Noise Frequency Register 1.

; $4003(rct1)/$4007(rct2)/$400B(tri)/$400F(noise) bits
; --------------------------------------------------
; 0-2	3 MS bits of wavelength (unused on noise channel) (the "high" frequency)
; 3-7	length of tone
PAPU_CT1	= $4003 ; pAPU Pulse 1 Coarse Tune (CT) Register.
PAPU_CT2	= $4007 ; pAPU Pulse 2 Coarse Tune (CT) Register.
PAPU_TFREQ2	= $400B ; pAPU Triangle Frequency Register 2.
PAPU_NFREQ2	= $400F ; pAPU Noise Frequency Register 2.


; $4010 - DMC Play mode and DMA frequency

; Bits 0-3:
;    f   period
;    ----------
;    0   $1AC
;    1   $17C
;    2   $154
;    3   $140
;    4   $11E
;    5   $0FE
;    6   $0E2
;    7   $0D6
;    8   $0BE
;    9   $0A0
;    A   $08E
;    B   $080
;    C   $06A
;    D   $054
;    E   $048
;    F   $036
; Bits 6-7: this is the playback mode.
;	00 - play DMC sample until length counter reaches 0 (see $4013)
;	x1 - loop the DMC sample (x = immaterial)
;	10 - play DMC sample until length counter reaches 0, then generate a CPU 
PAPU_MODCTL	= $4010 ; pAPU Delta Modulation Control Register.

PAPU_MODDA	= $4011 ; pAPU Delta Modulation D/A Register.
PAPU_MODADDR	= $4012 ; pAPU Delta Modulation Address Register.
PAPU_MODLEN	= $4013 ; pAPU Delta Modulation Data Length Register.

; read
; ----
; 0	rectangle wave channel 1 length counter status
; 1	rectangle wave channel 2 length counter status
; 2	triangle wave channel length counter status
; 3	noise channel length counter status
; 4	DMC is currently enabled (playing a stream of samples)
; 5	unknown
; 6	frame IRQ status (active when set)
; 7	DMC's IRQ status (active when set)
; 
; write
; -----
; 0	rectangle wave channel 1 enable
; 1	rectangle wave channel 2 enable
; 2	triangle wave channel enable
; 3	noise channel enable
; 4	enable/disable DMC (1=start/continue playing a sample;0=stop playing)
; 5-7	unknown
PAPU_EN		= $4015	; R/W pAPU Sound Enable


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OTHER I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SPR_DMA		= $4014 ; Sprite DMA Register -- DMA from CPU memory at $100 x n to SPR-RAM (256 bytes)


; Read / Write Joypad 1/2:
;                   *  Bit 0 - Reads data from joypad or causes joypad strobe
;                      when writing.
;                   *  Bit 3 - Indicates whether Zapper is pointing at a sprite.
;                   *  Bit 4 - Cleared when Zapper trigger is released.
;                   Only bit 0 is involved in writing.
JOYPAD		= $4016		

; Frame counter control
; Changes the frame counter that changes updates on sound; any write resets
; the frame counter, good for synchronizing sound with VBlank etc.
; 0        4, 0,1,2,3, 0,1,2,3,..., etc.
; 1        0,1,2,3,4, 0,1,2,3,4,..., etc. 
; bit 6 - enable frame IRQs (when zero)
; bit 7 - 0 = 60 IRQs a frame / 1 = 48 IRQs a frame (obviously need bit 6 clear to use)
; Interestingly, both of the above are clear on bootup, meaning IRQs are being generated,
; but the 6502 ignores NMIs on startup; also, need to read from $4015 (PAPU_EN) to acknowledge
; the interrupt, otherwise it holds the status on!
FRAMECTR_CTL	= $4017


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MMC3 regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; MMC3_COMMAND:
;  Bits 0-2 - Command number:
;  * 0 - Swap two 1 KB VROM banks at PPU $0000.
;  * 1 - Swap two 1 KB VROM banks at PPU $0800.
;  * 2 - Swap one 1 KB VROM bank at PPU $1000.
;  * 3 - Swap one 1 KB VROM bank at PPU $1400.
;  * 4 - Swap one 1 KB VROM bank at PPU $1800.
;  * 5 - Swap one 1 KB VROM bank at PPU $1C00.
;  * 6 - Swap PRG-ROM bank at either $8000 or $C000 based on bit 6.
;  * 7 - Swap PRG-ROM bank at either $A000 
;
;  Bit 6 - If 0, enables swapping at $8000 and $A000, otherwise enables
;  swapping at $C000 and $A000.  (NOTE: This is what SMB3 uses, so we only
;  have defs for this mode!)
;
;  Bit 7 - If 1, causes addresses for commands 0-5 to be the exclusive-or
;  of the address stated and $1000.

; Note that bit 6 is set on all of these consistently since SMB3 uses the PRG switch this way
MMC3_2K_TO_PPU_0000	= %01000000	; 0
MMC3_2K_TO_PPU_0800	= %01000001	; 1
MMC3_1K_TO_PPU_1000	= %01000010	; 2
MMC3_1K_TO_PPU_1400	= %01000011	; 3
MMC3_1K_TO_PPU_1800	= %01000100	; 4
MMC3_1K_TO_PPU_1C00	= %01000101	; 5
MMC3_8K_TO_PRG_C000	= %01000110	; 6
MMC3_8K_TO_PRG_A000	= %01000111	; 7
MMC3_PPU_XOR_1000	= %10000000


MMC3_COMMAND	= $8000	; consult ref
MMC3_PAGE  	= $8001	; page number to MMC3_COMMAND
MMC3_MIRROR	= $A000	; bit 0 clear is horizontal mirroring, bit 0 set is vertical mirroring
MMC3_SRAM_EN	= $A001	; bit 7 set to enable SRAM at $6000-$7FFF
MMC3_IRQCNT	= $C000 ; Countdown to an IRQ
MMC3_IRQLATCH	= $C001 ; Store a temp val to be copied to MMC3_IRQCNT later
MMC3_IRQDISABLE	= $E000 ; Disables IRQ generation and copies MMC3_IRQLATCH to MMC3_IRQCNT
MMC3_IRQENABLE	= $E001 ; Enables IRQ generation


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SMB3 RAM DEFS 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; (.*?)\s*=.*?;
; \t\1:\t\t.ds 1\t;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM COMMON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Common use zero page RAM.  Bytes in $75-$F3 are context-dependent
	.data		; SB: Using .data instead of .zp to export labels
	.org $00

; For clarification, none of the other "Temp" vars are damaged by NMI,
; the NMI does employ Temp_Var1-3, and restores them when it's done.

	Temp_Var1:		.ds 1	; Temporary storage variable (protected from damage by NMI)
	Temp_Var2:		.ds 1	; Temporary storage variable (protected from damage by NMI)
	Temp_Var3:		.ds 1	; Temporary storage variable (protected from damage by NMI)
	Temp_Var4:		.ds 1	; Temporary storage variable
	Temp_Var5:		.ds 1	; Temporary storage variable
	Temp_Var6:		.ds 1	; Temporary storage variable
	Temp_Var7:		.ds 1	; Temporary storage variable
	Temp_Var8:		.ds 1	; Temporary storage variable
	Temp_Var9:		.ds 1	; Temporary storage variable
	Temp_Var10:		.ds 1	; Temporary storage variable
	Temp_Var11:		.ds 1	; Temporary storage variable
	Temp_Var12:		.ds 1	; Temporary storage variable
	Temp_Var13:		.ds 1	; Temporary storage variable
	Temp_Var14:		.ds 1	; Temporary storage variable
	Temp_Var15:		.ds 1	; Temporary storage variable
	Temp_Var16:		.ds 1	; Temporary storage variable

	VBlank_Tick:		.ds 1	; can be used for timing, or knowing when an NMI just fired off

				.ds 1	; $11 unused

	Horz_Scroll_Hi:		.ds 1	; Provides a "High" byte for horizontally scrolling, or could be phrased as "current screen"
	PPU_CTL1_Mod:		; NOT DURING GAMEPLAY, this is used as an additional modifier to PPU_CTL1
	Vert_Scroll_Hi:		.ds 1	; Provides a "High" byte for vertically scrolling (only used during vertical levels!)

	Level_ExitToMap:	.ds 1	; When non-zero, kicks back to map (OR to event when Player_FallToKing or Player_RescuePrincess is nonzero!)

	Counter_1:		.ds 1	; This value simply increments every frame, used for timing various things

	PPU_CTL2_Copy:		.ds 1	; Essentially a copy of PPU_CTL2, which updates it as well, though the sprite/BG visibility setting is usually (always?) forced on

PAD_A		= $80
PAD_B		= $40
PAD_SELECT	= $20
PAD_START	= $10
PAD_UP		= $08
PAD_DOWN	= $04
PAD_LEFT	= $02
PAD_RIGHT	= $01

	Pad_Holding:		.ds 1	; Active player's inputs (i.e. 1P or 2P, whoever's playing) buttons being held in (continuous)
	Pad_Input:		.ds 1	; Active player's inputs (i.e. 1P or 2P, whoever's playing) buttons newly pressed only (one shot)

	Roulette_RowIdx:	.ds 1	; Roulette Bonus Game only obviously

; Pal_Force_Set12:
; This overrides the normal palette routine of selecting by Level_Tileset and 
; loading the color sets PalSel_Tile_Colors/PalSel_Obj_Colors.  Setting 
; Pal_Force_Set12 to a non-zero value will select as the index instead of
; Level_Tileset, and then it will copy the first two sets of 16 colors from
; the palette data as bg / sprite colors.  FIXME is this used though??
	Pal_Force_Set12:	.ds 1

	PlantInfest_ACnt:	.ds 1	; Plant infestation level animation counter

	VBlank_TickEn:		.ds 1	; Enables the VBlank_Tick decrement and typically other things like joypad reading

	Map_Enter2PFlag:	.ds 1	; If $00, entering level, otherwise set if entering 2P VS mode


	Map_EnterViaID:		.ds 1	; Overrides whatever spot on the map you entered with something special (see Map_DoEnterViaID)

				.ds 1	; $1F unused

	; $20 has a lot of different uses on the World Map...
	Map_EnterLevelFX:		; When entering a level on the map, dictates the status of the entry (0=None, 1=Boxing in, 2=Boxing out [J only]) NOTE: Overlap/reuse
	Map_IntBoxErase:		; Used for determining where in erasing the "World X" intro box we are NOTE: Overlap/reuse
	Map_ClearLevelFXCnt:		; Counter for "clear level" FX occurring (1-6: Poof, 7-9: Flip) ("poof"/"panel flip") NOTE: Overlap/reuse
	Map_ScrollOddEven:	.ds 1	; Toggles odd/even column as it scrolls

				.ds 1	; $21 unused

	Level_Width:		.ds 1	; Width of current level, in screens (0 = don't move at all, max is 15H/16V)

	; In horizontal "typical" levels, Scroll_ColumnR/L are a column and
	; levels are rendered in vertical stripes by these start points
	Scroll_ColumnR:		.ds 1	; ($23) Current tile column (every 16px) of right side of screen (non-vertical level style ONLY)
	Scroll_ColumnL:		.ds 1	; ($24) Current tile column (every 16px) of left side of screen (non-vertical level style ONLY)

	.org $23	; NOTE, the following two are also $23/$24
	; In vertical style levels, Scroll_VOffsetT/B are an offset into the
	; visible tile grid, and levels are rendered in horizontal strips
	Scroll_VOffsetT:	.ds 1	; ($23) Current tile offset (every 16px) of top of screen (vertical level style ONLY)
	Scroll_VOffsetB:	.ds 1	; ($24) Current tile offset (every 16px) of bottom of screen (vertical level style ONLY)

	Scroll_ColorStrip: 	.ds 54	; $25-$5A This stores a strip of just the upper 2 bits of a tile ($00, $40, $80, $C0) to produce attribute info

	Scroll_LastDir:		.ds 1	; 0=screen last moved right (or up, if vertical), 1=screen last moved left (or down, if vertical)

	Scroll_RightUpd:		; Indicates every 8 pixels update going to the right, or $FF if screen moves left
	Scroll_VertUpd:		.ds 1	; Indicates every 8 pixels update up or down, in vertical levels

	Scroll_LeftUpd:		.ds 1	; Indicates every 8 pixels update going to the left, or $FF if screen moves right

	; Prepares to perform a Video_Update when possible, indexes the "Video_Upd_Table" 
	; in PRG030 OR Video_Upd_Table2 in PRG025 (whichever is currently in context)
	; Also resets the graphics buffer afterward, since the RAM buffer is
	; constantly being called to possibly perform its own updates after this value
	; resets to zero.
	Graphics_Queue:		.ds 1

				.ds 1	; $5F unused
				.ds 1	; $60 unused

	Level_LayPtr_AddrL:	.ds 1	; Low byte of address to tile layout (ORIGINAL stored in Level_LayPtrOrig_AddrL)
	Level_LayPtr_AddrH:	.ds 1	; High byte of address to tile layout (ORIGINAL stored in Level_LayPtrOrig_AddrH)

			; Typical use pair at $63/$64
	Map_Tile_AddrL:		.ds 1	; Low byte of tile address
	Map_Tile_AddrH:		.ds 1	; High byte of tile address


	.org $63	; NOTE, the following two are also $63/$64, bonus game context
	BonusText_BaseL:	.ds 1	; Instruction text base address low
	BonusText_BaseH:	.ds 1	; Instruction text base address high


	Level_ObjPtr_AddrL:	.ds 1	; Low byte of address to object set (ORIGINAL stored in Level_ObjPtrOrig_AddrL)
	Level_ObjPtr_AddrH:	.ds 1	; High byte of address to object set (ORIGINAL stored in Level_ObjPtrOrig_AddrH)

				.ds 1	; $67 unused
				.ds 1	; $68 unused

	Video_Upd_AddrL:	.ds 1	; Video_Misc_Updates routine uses this as an address, low byte
	Video_Upd_AddrH:	.ds 1	; Video_Misc_Updates routine uses this as an address, hi byte
	Music_Base_L:		.ds 1	; Current music segment base address low byte
	Music_Base_H:		.ds 1	; Current music segment base address high byte

	Sound_Sqr_FreqL:	.ds 1	; Calculated square wave frequency for Note On (low byte)
	Sound_Sqr_FreqH:	.ds 1	; Calculated square wave frequency for Note On (high byte)
	Sound_Map_EntrV:	.ds 1	; Current index into the volume ramp-down table used exclusively for the "level enter" sound
	Sound_Map_EntV2:	.ds 1	; Same as Sound_Map_EntrV, only for the second track

	Music_PatchAdrL:	.ds 1	; Music current patch address low byte
	Music_PatchAdrH:	.ds 1	; Music current patch address high byte
	Sound_Map_Off:		.ds 1	; Current "offset" within a map sound effect

	; ASSEMBLER BOUNDARY CHECK, END OF ZERO PAGE PRE CONTEXT @ $74
.BoundZP_PreCtx:	BoundCheck .BoundZP_PreCtx, $74, Zero Page

	; NOTE: $75 - $F3 are context specific; see contexts below

	.org $F4
	Scroll_OddEven:		.ds 1	; 0 or 1, depending on what part of 8 pixels has crossed (need better description)

	Controller1Press:	.ds 1	; Player 1's controller "pressed this frame only" (see Controller1 for values)
	Controller2Press:	.ds 1	; Player 2's controller "pressed this frame only" (see Controller2 for values)
	Controller1:		.ds 1	; Player 1's controller inputs -- R01 L02 D04 U08 S10 E20 B40 A80
	Controller2:		.ds 1	; Player 2's controller inputs -- R01 L02 D04 U08 S10 E20 B40 A80

				.ds 1	; $F9 unused
				.ds 1	; $FA unused
				.ds 1	; $FB unused

	Vert_Scroll:		.ds 1	; Vertical scroll of name table; typically at $EF (239, basically showing the bottom half)
	Horz_Scroll:		.ds 1	; Horizontal scroll of name table

				.ds 1	; $FE unused

	PPU_CTL1_Copy:		.ds 1	; Holds PPU_CTL1 register data 

	; ASSEMBLER BOUNDARY CHECK, END OF ZERO PAGE @ $100
.BoundZP:	BoundCheck .BoundZP, $100, Zero Page

; NOTE: CONTEXT -- Page 0 RAM changes meaning depending on the "context", i.e. what state
; of the game we're currently in!  This means that variables are defined with overlapping
; addresses, and care must be taken to use the correct labels depending on the code!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM: TITLE SCREEN / ENDING CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $75	; $75-$F3 is available for this context-dependent situation

; Title screen "objects", which includes Mario, Luigi, and the assortment of other things
; The following are the offsets from any of the object arrays:
; 0 = Mario, 1 = Luigi, 2 = Starman, 3 = Mushroom, 4 = Super Leaf, 5 = Goomba, 6 = Buzzy Beatle, 7 = Koopa shell

; Note that some of this is used for the engine (especially in the Princess's chamber) but some of it is
; different (especially during the montage) so consider the overlapped variables in the next section

	Title_XPosHi:		.ds 8	; $75-$7C "High" part of the extended precision X position for all objects
	Title_YPosHi:		.ds 8	; $7D-$84 "High" part of the extended precision X position for all objects
	Title_ObjX:		.ds 8	; $85-$8C Title screen object X positions
	Title_ObjY:		.ds 8	; $8D-$94 Title screen object Y positions
	Title_ObjXVel:		.ds 8	; $95-$9C X velocities of title screen objects (4.4FP)
	Title_ObjYVel:		.ds 8	; $9D-$A3 Y velocities of title screen objects 
	Title_XPosFrac:		.ds 8	; $A5-$AC X position extended precision of objects (provides 4-bit fixed point)
	Title_YPosFrac:		.ds 8	; $AD-$B4 Y position extended precision of objects (provides 4-bit fixed point)
	Title_ObjYVelChng:	.ds 2	; $B5-$B6 Mario / Luigi change in Y velocity flag
	Title_ObjMLFlags:	.ds 2	; $B7-$B8 Mario / Luigi Sprite flags
	Title_ObjMLMoveDir:	.ds 1	; 0 = No move, 1 = Left, 2 = Right
				.ds 1	; $BA unused
	Title_ObjMLAnimFrame:	.ds 2	; $BB-$BC Mario / Luigi animation frame
	Title_ObjMLDirTicks:	.ds 2	; $BD-$BE Mario / Luigi animation ticks
	Title_ObjMLSprite:	.ds 2	; $BF-$C0 Mario / Luigi next sprite to display
	Title_ObjMLPower:	.ds 2	; $C1-$C2 Mario / Luigi current powerup (0 = Small, 1 = Big, 2 = Leaf)
	Title_ObjMLSprRAMOff:	.ds 2	; $C3-$C4 Mario / Luigi Defines a Sprite_RAM offset for Mario / Luigi
	Title_ObjMLSprVis:	.ds 2	; $C5-$C6 Mario / Luigi sprite sliver visibility bits (generated by Title_MLDetermineSpriteVis)
	Title_ObjMLTailTick:	.ds 2	; $C7-$C8 Mario / Luigi tail wagging tick
	Title_ObjMLHold:	.ds 2	; $C9-$CA Mario / Luigi holding something flag (when non-zero)
	Title_ObjMLBonkTick:	.ds 2	; $CB-$CC Mario / Luigi use "bonked" frame while > 0
	Title_ObjMLKickTick:	.ds 2	; $CD-$CE Mario / Luigi use kicking frame while > 0
	Title_ObjMPowerDown:	.ds 1	; Mario power down animation counter
	Title_ObjMLStop:	.ds 1	; Flag used briefly to "hold" Mario/Luigi from moving so they get a "running start"
	Title_CurMLIndex:	.ds 1	; 0 for Mario, 1 for Luigi
	Title_ObjFlags:		.ds 6	; $D2-$D7 Minor objects' sprite flags
	Title_ObjStates:	.ds 6	; $D8-$DD Title screen array of states for the individual objects (NOT including Mario/Luigi)
	Title_State:		.ds 1	; 00 = Prior to red curtain rise, 01 = Rising curtain...
	Title_ResetCnt:		.ds 1	; Title reset counter -- when on the menu, once this hits zero, the title sequence restarts
	Title_ResetCnt2:	.ds 1	; when this goes to zero, it decrements Title_ResetCnt
	Title_ResetTrig:	.ds 1	; when non-zero, resets title screen
	Title_UnusedFlag:	.ds 1	; doesn't seem to do anything useful but not do the "skip" state if Player presses START early on the title screen
	Title_Ticker:		.ds 1	; Tick counter for title screen intro "movie"
	Title_MActScriptPos:	.ds 1	; Offset within Mario's action script
	Title_LActScriptPos:	.ds 1	; Offset within Luigi's action script
	Title_MActScriptDelay:	.ds 1	; Mario's action script delay until next event
	Title_LActScriptDelay:	.ds 1	; Luigi's action script delay until next event
	Title_MActScriptDirSet:	.ds 1	; Mario's action script Buffer for last queue command (sets respective "Title_ObjMLDir" variable)
	Title_LActScriptDirSet:	.ds 1	; Luigi's action script Buffer for last queue command (sets respective "Title_ObjMLDir" variable)
	Title_ObjMLDir:		.ds 2	; $EA-$EB Mario / Luigi vector direction bitfield (1 = Left, 2 = Right, 4 = Down, 8 = Up, $10 = Sprite behind BG, $80 = Tail wagging)
	Title_ObjMLQueue:	.ds 2	; $EC-$ED Mario / Luigi queue to do something ($04 = Luigi's rebound off Mario, $10 = Kick shell, $20 = Begin carrying, $40 = Clear carry/bonk, do kick)
	Title_EventIndex:	.ds 1	; Title background event index (dynamic jump index for events on the title 
	Title_EventGrafX:	.ds 1	; Title background current graphic index to load (loads items from Video_Upd_Table2 in PRG025)
	Title_ObjInitIdx:	.ds 1	; Current title screen "event" ID during the intro scene with Mario and Luigi
	Title_ObjInitDly:	.ds 1	; Timer count before next object init
	Title_3GlowFlag:	.ds 1	; When non-zero, begins the "glowing" effect for the big '3'
	Title_3GlowIndex:	.ds 1	; Index into an array of colors to cause the big '3' on the title screen to glow

	; ASSEMBLER BOUNDARY CHECK, END OF CONTEXT @ $F5
.BoundZP_Title:	BoundCheck .BoundZP_Title, $F5, Zero Page Title Screen Context


; Ending-specific vars -- NOTE that Ending system uses some of the Title Screen code, so these variables overlap some of the above
; Basically don't assume anything here is free space without consulting above as well...

	.org $75
	Ending2_PicState:	.ds 1	; Ending part 2 picture loader state
	Ending2_ClearLen:	.ds 1	; Length of clear run
	Ending2_ClearPat:	.ds 1	; Pattern to clear the screen with
	Ending2_PicVRAMH:	.ds 1	; Ending part 2 picture VRAM Hi
	Ending2_PicVRAML:	.ds 1	; Ending part 2 picture VRAM Hi
	Ending2_QCmdEnd:	.ds 1	; Ending2_QueueCmd is incremented to this point
	Ending2_FadeTimer:	.ds 1	; Timer which controls the speed of the fade between worlds
	Ending2_QueueCmd:	.ds 1	; incremented after posting, up to Ending2_QCmdEnd
	Ending2_TimerH:		.ds 1	; Ending part 2 timer "high" part
	Ending2_TimerL:		.ds 1	; Ending part 2 timer "low" part
	Ending2_CurWorld:	.ds 1	; Current world we're showing (8 = THE END)

	.org $D2
	Ending_Timer:		.ds 2	; $D2-$D3 Twin ending timers, generally one for Mario and one for Princess
	EndText_Timer:		.ds 1	; Timer used for the ending text display
	Ending_State:		.ds 1	; Current state value for initial part of ending (the princess, prior to curtain)

	EndText_VL:		.ds 1	; Princess speech VRAM Address Low
	EndText_VH:		.ds 1	; Princess speech VRAM Address High
	EndText_CPos:		.ds 1	; Princess speech Character Position
	EndText_State:		.ds 1	; Princess speech state variable

	.org $F4
	Ending2_IntCmd:		.ds 1	; used during ending to buffer out the ending picture data on the interrupt.  Triggers "Do_Ending2_IntCmd" in PRG024 in interrupt context.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM: WORLD MAP CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $75	; $75-$F3 is available for this context-dependent situation

	World_Map_Y:		.ds 2	; $75-$76 (Mario/Luigi) Y pixel coordinate position of Mario on world map
	World_Map_XHi:		.ds 2	; $77-$78 (Mario/Luigi) X pixel (hi byte) coordinate position of Mario on world map
	World_Map_X:		.ds 2	; $79-$7A (Mario/Luigi) X pixel (lo byte) coordinate position of Mario on world map
	World_Map_Move:		.ds 2	; $7B-$7C (Mario/Luigi) Movement left in specified direction (even numbers only!)
	World_Map_Dir:		.ds 2	; $7D-$7E (Mario/Luigi) Specified travel direction (8=Up, 4=Down, 2=Left, 1=Right)

	Map_UnusedPlayerVal:	.ds 2	; $7F-$80 (Mario/Luigi) Set for each Player to $20 when returning to map, but apparently unused otherwise!

				.ds 1	; $81 unused
				.ds 1	; $82 unused
				.ds 1	; $83 unused

	Map_UnusedPlayerVal2:	.ds 2	; $84-$85 (Mario/Luigi) Apparently unused at all, but backed up and persisted on the world map

; All the WarpWind vars are shared with the HandTrap; they share code, too...
	Map_WWOrHT_Y:		.ds 1	; Warp Whistle wind or Hand Trap Y position
	Map_HandTrap_XHi:	.ds 1	; Hand Trap X Hi (most vars are shared with warp wind, but technically not this one!)
	Map_WWOrHT_X:		.ds 1	; Warp Whistle wind or Hand Trap X position
	Map_WWOrHT_Cnt:		.ds 1	; Warp Whistle wind or Hand Trap counter 
	Map_WWOrHT_Dir:		.ds 1	; Direction the Warp Whistle wind travels (0 = right, 1 = left)

	; Double use
	Map_WarpWind_FX:		; 1 - 4 is the warp whistle effect
	Map_StarFX_State:	.ds 1	; 0 - 2 NOTE: Shared with Map_WarpWind_FX

	World_Map_Twirl:	.ds 1	; If set, Mario is "twirling"

				.ds 1	; $8D unused

	; When Player is "skidding" backward (from death or "twirling" from game over continuation)
	Map_Skid_DeltaY:	.ds 1	; Delta applied directly to Y
	Map_Skid_DeltaFracY:	.ds 1	; Fractional delta Y
	Map_Skid_FracY:		.ds 1	; Fractional Y accumulator

				.ds 1	; $91 unused

	Map_Skid_DeltaX:	.ds 1	; Delta applied directly to X
	Map_Skid_DeltaFracX:	.ds 1	; Fractional delta X
	Map_Skid_FracX:		.ds 1	; Fractional X accumulator
	Map_Skid_FracCarry:	.ds 1	; Fractional carry over accumulator (I think?)
	Map_Skid_Count:		.ds 1	; Just a ticker controlling the display frame of the twirl
	Map_Skid_Counter:	.ds 1

	; Map_Skid_TravDirs -- specifies which way Player must "twirl" to get to the destination
	; Bit 0 Set = Player must travel to the right versus the left
	; Bit 1 Set = Player must travel downward versus upward
	Map_Skid_TravDirs:	.ds 1

				.ds 1	; $99 unused
				.ds 1	; $9A unused

	Map_StarsX:		.ds 8	; $9B-$A2 During World Intro, X position of each star
	Map_StarsY:		.ds 8	; $A3-$AA During World Intro, Y position of each star
	Map_StarsOutRad:	.ds 1	; During World Intro, stars take off radius (0 = smallest, increments for larger)

				.ds 1	; $AC unused
				.ds 1	; $AD unused
				.ds 1	; $AE unused

	Map_StarsXSteps:	.ds 1	; During World Intro, number of "steps" remaining in the X position adjustment
	Map_StarsRadCnt:	.ds 1	; During World Intro, adds $70 per display frame and adds 1 to the radius when it overflows
	Map_StarsCenterX:	.ds 1	; During World Intro, X center of stars 
	Map_StarsCenterY:	.ds 1	; During World Intro, Y center of stars
	Map_StarsDeltaR:	.ds 1	; During World Intro, delta to the star radii
	Map_StarsConst9:	.ds 1	; During World Intro, ... Constant 9?

				.ds 1	; $B5 unused

	Map_StarsAnimCnt:	.ds 1	; During World Intro, a simple counter that adds 32 per frame and toggles Map_StarsFrame when it overflows
	Map_StarsFrame:		.ds 1	; During World Intro, "frame" of stars (0/1)
	Map_StarsPattern:	.ds 1	; During World Intro, stars current VROM pattern
	Map_StarsLandRad:	.ds 1	; During World Intro, stars landing radius (0 = largest, increments for smaller)
	Map_StarsYSteps:	.ds 1	; During World Intro, number of "steps" remaining in the Y position adjustment

				.ds 1	; $BB unused

	Map_StarsRadius:	.ds 8	; $BC-$C3 During World Intro, each star's "radius" position (each radius position is 0-31)
	Map_StarsState:		.ds 1	; 0 = Stars coming out from center, 1 = Stars moving in towards Player start
	Map_SkidBack:		.ds 1	; Player is skidding back (Map_Player_SkidBack stores whether they skidded on their last turn at all)

				.ds 1	; $C6 unused

	Map_UnusedGOFlag:	.ds 1	; Set at map initialization or if Player gets Game Over and selects CONTINUE/END, no apparent purpose

				.ds 1	; $C8 unused
				.ds 1	; $C9 unused
				.ds 1	; $CA unused
				.ds 1	; $CB unused

	Map_Intro_CurStripe:	.ds 1	; Current stripe of the "World X" intro box to be erased (0 - 7)
	Map_Intro_NTOff:	.ds 1	; Offset into nametable for erasing the "World X" intro box
	Map_Intro_ATOff:	.ds 1	; Offset into the attribute table for erasing the "World X" intro box

	Map_Airship_DC:		.ds 1	; set to 1 when the Airship knows where it's going
	Map_Airship_DY:		.ds 1	; Airship delta between current and target Y coordinate
	Map_Airship_YNib:	.ds 1	; Map_Airship_DY shifts out its lower 4 bits as upper 4 bits to this value
	Map_Airship_YAcc:	.ds 1	; Additional Y accumulator when traveling
	Map_Airship_DXHi:	.ds 1	; Airship delta between current and target X Hi coordinate
	Map_Airship_DX:		.ds 1	; Airship delta between current and target X coordinate
	Map_Airship_XNib:	.ds 1	; Map_Airship_DXHi/Map_Airship_DX shifts out its lower 4 bits as upper 4 bits to this value
	Map_Airship_Dir:	.ds 1	; Airship horizontal travel direction in bit 0, vertical direction in bit 1
	Map_HideObj:		.ds 1	; used for completion)

	MapPoof_Y:		.ds 1	; When using a power-up, "poof" appears at this Y coordinate
	MapPoof_X:		.ds 1	; When using a power-up, "poof" appears at this X coordinate
	Map_UseItem:		.ds 1	; Flag to signal that item is to be used

				.ds 10	; $DB-$E4 unused

	World_Map_Tile:		.ds 1	; Current tile index Mario is standing on

				.ds 1	; $E6 unused
				.ds 1	; $E7 unused
				.ds 1	; $E8 unused

	Scroll_Temp:		.ds 1	; Scroll hold value

				.ds 1	; $EA unused
				.ds 1	; $EB unused

	Player_WalkFrame:	.ds 1	; relative, not the same as Player_Frame

				.ds 7	; $ED-$F3 unused

	; ASSEMBLER BOUNDARY CHECK, END OF CONTEXT @ $F4
.BoundZP_Map:	BoundCheck .BoundZP_Map, $F4, Zero Page World Map Context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM: BONUS GAME CONTEXT (see PRG022 for lots more info)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $75	; $75-$F3 is available for this context-dependent situation

				.ds 22	; $75-$8A unused

	BonusCoins_State:	.ds 1

				.ds 59	; $8C-$C6 unused

	BonusDie_Y:		.ds 1	; UNUSED Bonus Game Die (1-6) Y position
	BonusDie_X:		.ds 1	; UNUSED Bonus Game Die (1-6) X position
	BonusDie_YVel:		.ds 1	; UNUSED Bonus Game Die Y Velocity (when it departs)
	BonusDie_YVelFrac:	.ds 1	; UNUSED Bonus Game Die Y Velocity fractional accumulator

				.ds 41	; $CB-$F3 unused

	; ASSEMBLER BOUNDARY CHECK, END OF CONTEXT @ $F4
.BoundZP_Bonus:	BoundCheck .BoundZP_Bonus, $F4, Zero Page Bonus Context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM: 2P VS CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $75	; $75-$F3 is available for this context-dependent situation

	Vs_State:		.ds 1	; 2P Vs Mode state
	Vs_IsPaused:		.ds 1	; If set, 2P Vs is paused

				.ds 125	; $77-$F3 unused

	; ASSEMBLER BOUNDARY CHECK, END OF CONTEXT @ $F4
.BoundZP_Vs:	BoundCheck .BoundZP_Vs, $F4, Zero Page 2P Vs Context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ZERO PAGE RAM: GAMEPLAY CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $75	; $75-$F3 is available for this context-dependent situation

; There's a consistent difference of $12 between X and Y; this consistent distancing is meant to be maintained, so leave it alone!

	Player_XHi:		.ds 1	; Player X Hi 
	Objects_XHi:		.ds 8	; $76-$7D Other object's X Hi positions

				.ds 1	; $7E unused

	; Reuse of $7F
CineKing_DialogState:	; Toad & King Cinematic: When 1, we're doing the text versus the dialog box itself

; NOTE!! This object var is OBJECT SLOT 0 - 4 ONLY!
	Objects_Var4:		.ds 5	; $7F-$83 Generic variable 4 for objects SLOT 0 - 4 ONLY

	; Pipe_PlayerX/Y variables in use when traveling through pipes
	Pipe_PlayerX:		.ds 1	; Stores Player's X when they went into pipe (non-transit)
	Pipe_PlayerY:		.ds 1	; Stores Player's Y when they went into pipe (non-transit, aligned to nearest 16, minus 1)

	.org $84	; NOTE, the following two are also $84/$85
	; Otherwise, they are replaced with a lookup address
	Level_GndLUT_Addr:	.ds 2

				.ds 1	; $86 unused

	Player_YHi:		.ds 1	; Player Y Hi
	Objects_YHi:		.ds 8	; $88-$8F Other object's Y Hi positions
	Player_X:		.ds 1	; Player X
	Objects_X:		.ds 8	; $91-$98 Other object's X positions

				.ds 1	; $99 unused
	; Reuse of $9A
	CineKing_Var:		; General variable

	Objects_Var5:		.ds 8	; $9A-$A1 Generic variable 5 for objects
	Player_Y:		.ds 1	; Player Y
	Objects_Y:		.ds 8	; $A3-$A9 Other object's Y positions

	Player_SpriteX:		.ds 1	; Player's sprite X
	Objects_SpriteX:	.ds 8	; $AC-$B3 Other object's sprite X positions
	Player_SpriteY:		.ds 1	; Player's sprite Y
	Objects_SpriteY:	.ds 8	; $B5-$BC Other object's sprite Y positions
	; WARNING: The distance between Player/Objects_XVel and Player/Objects_YVel must be same as Player/Objects_X/YVelFrac!
	Player_XVel:		.ds 1	; Player's X Velocity (negative values to the left) (max value is $38)
	Objects_XVel:		.ds 8	; $BE-$C5 Other object's X velocities

	Objects_VarBSS:		.ds 7	; $C6-$CC OBJECT SLOTS 0 - 5 ONLY ... uncleared var??
	SlotIndexBackup:	.ds 1	; Used as a backup for the slot index (e.g. current object, current score, etc.)
	Player_HaltGame:	.ds 1	; Player is halting game (e.g. dying, shrinking/growing, etc.)

	; WARNING: The distance between Player/Objects_XVel and Player/Objects_YVel must be same as Player/Objects_X/YVelFrac!
	Player_YVel:		.ds 1	; Player's Y Velocity (negative values upward)
	Objects_YVel:		.ds 8	; $D0-$D7 Other object's Y velocities

	Player_InAir:		.ds 1	; When set, Player is in the air

	; Reuse of $D9
	CineKing_Frame2:		; Used only by the World 6 King (Seal juggling a crown, the crown's frame)

	; Objects_DetStat:
	; Object's detection bits:
	;	$01-hit wall right
	;	$02-hit wall left
	;	$04-hit ground
	;	$08-hit ceiling
	;	$80-object touching "32 pixel partition" floor (if active)
	Objects_DetStat:	.ds 8	; $D9-$E0  on screen

	Player_SprWorkL:	.ds 1	; Sprite work address low
	Player_SprWorkH:	.ds 1	; Sprite work address high

				.ds 1	; $E3 unused

	Level_TileOff:		.ds 1	; Tile mem offset
	Level_Tile:		.ds 1	; Temporary holding point for a detected tile index
	Player_Slopes:		.ds 3	; for sloped levels only (3 bytes allocated, but only one actually used)
				; *NOTE: Code at PRG030_9EDB clears Player_Slopes+1 and Player_Slopes+2, but these are never used!

				.ds 1	; $E9 unused
				.ds 1	; $EA unused

	Player_XStart:		.ds 1	; Set to Player's original starting X position (also used to check if level has initialized)

				.ds 1	; $EC unused

; Player_Suit -- Player's active powerup (see also: Player_QueueSuit)
PLAYERSUIT_SMALL	= 0
PLAYERSUIT_BIG		= 1
PLAYERSUIT_FIRE		= 2
PLAYERSUIT_RACCOON	= 3
PLAYERSUIT_FROG		= 4
PLAYERSUIT_TANOOKI	= 5
PLAYERSUIT_HAMMER	= 6
PLAYERSUIT_SUPERSUITBEGIN = PLAYERSUIT_FROG	; Marker for when "Super Suits" begin
PLAYERSUIT_LAST		= PLAYERSUIT_HAMMER	; Marker for "last" suit (Debug cycler needs it)
	Player_Suit:		.ds 1

	Player_Frame:		.ds 1	; Player display frame
	Player_FlipBits:	.ds 1	; Set to $00 for Player to face left, Set to $40 for Player to face right

	Player_WagCount:	.ds 1	; after wagging raccoon tail, until this hits zero, holding 'A' keeps your fall rate low
	Player_IsDying:		.ds 1	; 0 = Not dying, 1 = Dying, 2 = Dropped off screen, 3 = Death due to TIME UP

				.ds 1	; $F2 unused

	Obj01_Flag:		.ds 1	; Not sure what Obj01 is!! This blocks its left/right handler logic.

	; ASSEMBLER BOUNDARY CHECK, END OF CONTEXT @ $F4
.BoundZP_Game:	BoundCheck .BoundZP_Game, $F4, Zero Page Gameplay Context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $1xx LOW STACK VARIABLES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; These are actually "bottom" of the stack; I don't think this is normally recommended.
; but this is probably to keep them "safe" from other RAM clearing routines, since they directly effect the IRQ.
; The debug flag in particular is pretty precariously placed, and under some kind of heavy call stack, seems like
; there's risk it could be set by accident... but I guess this never happens... ?

	.data
	.org $0100

	Update_Select:	.ds 1		; Changes which path of "update routines" are selected; $00 = ??, $20 = Title Screen, $40 = Spade Game, $80 = Vertical level, $A0 = 32 pixel partition, $C0 = Normal

	Raster_Effect:	.ds 1		; $00 is standard status bar, $20 is title/ending, $40 = 32 pixel partition, $60 = Spade Bonus Game (3 sliding rows), $80 is nothing (e.g. as in 2P versus), $A0 = ???

	.org $0160
	Debug_Flag:	.ds 1		; Set to $80 by the debug menu, enables debug functionality like power level cycling and not dying from time over


; Main NES SRAM begin
	.data	; SB: Using .data instead of .bss to export labels

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $2xx SPRITE RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0200

; \$02([0-9A-F][0-9A-F])
; Sprite_RAM+$\1

; Sprite memory is laid out in four bytes:
; Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
; Byte 1 - Index number of the sprite in the pattern tables.
; Byte 2 - Stores the attributes of the sprite.
; * Bits 0-1 - Most significant two bits of the colour.
; * Bit 5 - Indicates whether this sprite has priority over the background.
; * Bit 6 - Indicates whether to flip the sprite horizontally.
; * Bit 7 - Indicates whether to flip the sprite vertically.
; Byte 3 - X coordinate
Sprite_RAM:	.ds 256		; $0200 - $02FF; This is where sprite memory is stored locally prior to being DMA'ed

; Relevant flags
SPR_PAL0	= %00000000
SPR_PAL1	= %00000001
SPR_PAL2	= %00000010
SPR_PAL3	= %00000011
SPR_BEHINDBG	= %00100000
SPR_HFLIP	= %01000000
SPR_VFLIP	= %10000000

	; ASSEMBLER BOUNDARY CHECK, END OF SPRITE RAM
.Bound_SprRAM:	BoundCheck .Bound_SprRAM, $0300, Sprite RAM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $03xx RAM (Largely graphics updating / control)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0300

	Graphics_BufCnt:	.ds 1	; first byte holds current position within buffer (Graphics_Buffer+) to store info
	Graphics_Buffer:	.ds 107	; $0301-$036B Simple (and small!) delayed write buffer; uses same format as Video_Upd_Table in PRG030, get format info there
	TileChng_VRAM_H:	.ds 1	; High part of VRAM address to change
	TileChng_VRAM_L:	.ds 1	; Low part of VRAM address to change
	TileChng_Pats:		.ds 4	; $036E-$0371 The four patterns required to change a tile (for Level_ChgTileEvent)
	Level_SizeOrig:		.ds 1	; Holds original size (width or height) of level (in screens)
	Level_PipeExitDir:	.ds 1	; Direction Player is going to exit from a pipe (1 = Up, 2 = Down, 3 = Right, 4 = Left, 5 = In-level Transit)
	Level_7VertCopy:	.ds 1	; Just seems to be an unmaintained copy of Level_7Vertical from level load, but that's it
	Level_PipeNotExit:	.ds 1	; If set, pipes do NOT exit to map (i.e. as in pipe junctions)
	Level_PauseFlag:	.ds 1	; Set to 0 when not paused, or 1 when paused
	Level_SkipStatusBarUpd:	.ds 1	; When set, skips updating the status bar for one frame (priority graphics buffer changes I think)
	Raster_State:		.ds 1	; This variable's meaning depends on the Raster_Effect in use; typically 0 is first pass, then more for further scanlines

				.ds 7	; $0379-$037F unused

	Scroll_ToVRAMHi:	.ds 1	; High byte for when pushing a column of tile data to VRAM (Set to $20, Name Table 0, after scroll update)

	; $381 dual use
	Scroll_LastCol8:		; Last 8x8 block column that was updated (non-vertical level ONLY)
	Scroll_LastOff8:	.ds 1	; Last 8x8 block offset that was updated (vertical level style ONLY)

	Scroll_PatStrip:	.ds 54	; $0382-$03B7 (may be less?) This stores a strip of 8x8 blocks, (non-vertical level: top to bottom with 2 columns), to render the next 16 pixel "sliver" of screen space
	Scroll_ToVRAMHA:	.ds 1	; High byte for when pushing attribute data to VRAM (Set to $23, attribute table 0)
	Scroll_LastAttr:	.ds 1
	Scroll_AttrStrip:	.ds 14	; $03BA-$03C7 (may be less?) This stores a 2x2 block of attribute coloring data
	World_Num_Debug:	.ds 1	; When debug mode is activated (KKKZSPIU), this is the world you select to start on
	Map_StarsDeltaX:	.ds 1	; Delta the stars move in X to reach the Player (always positive, code figures direction)
	Map_StarsDeltaY:	.ds 1	; Delta the stars move in Y to reach the Player (always positive, code figures direction)

				.ds 16	; $03CB-$03DA unused

	Map_Stars_PRelX:	.ds 1	; During world intro, screen relative position of Player X
	Map_Stars_PRelY:	.ds 1	; During world intro, screen relative position of Player Y
	Player_Power:		.ds 1	; >>>>>>[P] charge level ($7F max)

	; Level_JctCtl is configured when you enter a door or a pipe
	; * When $80, use current values for Level_AltLayout and Level_AltObjects
	; * When otherwise non-zero (inc $80), skips setting vertical start position
	;
	; Normal values for the junction:
	;  0 - Disables junction (i.e. no junction occurring)
	;  1 - Junction initialization
	;  2 - Big Question Block bonus area
	;  3 - General purpose junction (as specified by Level_AltLayout and Level_AltObjects)
	;  4 - Generic level exit (where you come up from a pipe in the generic exit area)
	;  5 - Special Toad House (used for the 1-3 warp whistle)
	Level_JctCtl:		.ds 1

	Level_JctFlag:		.ds 1	; Toggles when you junction

				.ds 1	; $03E0 unused

	Map_DrawPanState:	.ds 1	; Map draw/pan state
	ObjGroupRel_Idx:	.ds 1	; Holds relative index of object within its group (see PRG000_CA51)
	InvFlip_VAddrHi:	.ds 1	; Hi byte of VRAM address during inventory flip modifications

				.ds 1	; $03E4 unused

	; CLOSING
	;  0: Erase old status bar complete, palette changed to blue
	;  1: Draw top bar (at middle)
	;  2: Draw bottom bar (at middle)
	;  3: Erase top bar (at middle)
	;  4: Draw top middle row of normal status bar/cards
	;  5: Draw bottom middle row of normal status bar/cards
	;  6: Draw top bar (at top)
	;  7: Draw bottom bar (at bottom)

	; OPENING
	;  8: Erase old status bar complete, palette changed to yellow
	;  9: Draw top bar (at middle)
	; 10: Draw bottom bar (at middle)
	; 11: Erase top bar (at middle)
	; 12: Erase bottom bar (at middle)
	; 13: Draw top middle row of inventory
	; 14: Draw bottom middle row of inventory
	; 15: Draw top bar (at top)
	; 16: Draw bottom bar (at bottom)
	InvFlip_Frame:		.ds 1	; Sort of a "frame" of animation during flipping of the inventory box; 0-7 during closing, 8-15 during opening
	InvFlip_Counter:	.ds 1	; 0 = Closed, 4 = Fully Open
	InvStart_Item:		.ds 1	; Starting inventory item; typ. $00, $07, $0E, $15 (Rows 1-4)
	InvHilite_X:		.ds 1	; Current hilite position X coordinate
	InvHilite_Item:		.ds 1	; Which item in the current row is highlighted, 0-6

	THouse_ID:		.ds 1	; An unused ID value that would track boxes already opened in a Toad House (concept unused!)

	; Treasure type you'll get at this Toad House
	; 0 = INVALID
	; 1 = Warp Whistle
	; 2 = P-Wing
	; 3 = Frog
	; 4 = Tanooki
	; 5 = Hammer
	; 6 = Random Super Suit
	; 7 = Random Basic Item
	THouse_Treasure:	.ds 1

	Coins_Earned:		.ds 1	; A "buffer" of coins earned to be added to your total, actual coinage stored in Inventory_Coins[2]
	Map_Powerup_Poof:	.ds 1	; Counter that handles the "poof" effect when a powerup is used on the map (requires Inventory to be open, and forces it to close afterward)

	; Level_FreeVertScroll
	; 0 = Screen locked at $EF (lowest point) unless flying or climbing a vine
	; 1 = Free vertical scroll
	; 2 = Locked at arbitrary point (i.e. whatever Vert_Scroll is, it stays there)
	Level_FreeVertScroll:		.ds 1

	Level_7Vertical:		.ds 1	; Set in World 7 vertical type levels
	Level_SelXStart:		.ds 1	; Selects X starting position when level begins (valid values 0-3)

UPDATERASTER_32PIXPART	= 1	; 32 pixel partition; common use is for levels with water along the bottom
UPDATERASTER_SPADEGAME	= 2	; Spade game sliders
UPDATERASTER_WATERLINE	= 3	; "Water line" mode (described at ObjHorzAutoScroller_Init)
UPDATERASTER_32PIXSHOWSPR= $80	; If NOT set, hides sprites that fall beneath the partition (i.e. for fixed water effect)
	Update_Request:		.ds 1	; This changes the current Raster_Effect and Update_Select and doesn't persist
	Map_Starman:		.ds 1	; Player used a Starman!
	Map_Power_Disp:		.ds 1	; This is the powerup currently DISPLAYED on the map; it should be the same as $0746 World_Map_Power, except for Judgem's Cloud
	Map_Warp_PrevWorld:	.ds 1	; The world you're coming FROM when warping (also used as output from warp zone what world you're going to)

	; ASSEMBLER BOUNDARY CHECK, END OF $03xx
.Bound_0300:	BoundCheck .Bound_0300, $0400, $03xx


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $04xx WORLD MAP CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; $0400-$04CF (except $0461 and $0462, see "$04xx RAM SOUND/MUSIC ENGINE") is available for this context-dependent situation
	; $0400-$0443 unused in either of the following cases

	; Doing double .org's because of major overlap, but be careful!

	.org $0447
; W8D = World 8 Darkness; overlaps the vars used by the entrance transition
	Map_W8D_VAddrH:		.ds 1

				.ds 3	; $0448-$044A unused

	Map_W8D_VAddrL:		.ds 1

				.ds 5	; $044C-$0450 unused

	Map_W8D_VAddrH2:	.ds 1

				.ds 1	; $0452 unused

	Map_W8D_VAddrL2:	.ds 1

				.ds 1	; $0454 unused

	Map_W8D_TileOff:	.ds 1	; In-tile offset (0 = upper left, 1 = lower left, 2 = upper right, 3 = lower right)

				.ds 2	; $0456-$0457 unused

	Map_W8D_YOff:		.ds 1	; Y Offset from Player when doing darkness
	Map_W8D_XOff:		.ds 1	; X Offset from Player when doing darkness
	Map_W8D_RC:		.ds 1	; Row in the upper bits, column in the lower bits
	Map_W8D_Dir:		.ds 1	; Direction of travel in darkness (1 = Right, 2 = Left, 4 = Down, 8 = Up)
	Map_W8D_X:		.ds 1
	Map_W8D_Y:		.ds 1
	Map_W8D_Idx:		.ds 1

	; ASSEMBLER BOUNDARY CHECK, CONTEXT END OF $04D0
.BoundW8D_04D0:	BoundCheck .BoundW8D_04D0, $04D0, $04xx range World Map Entrance Transition context

	.org $0444
	; Entrance transition; overlaps with above
	; NOTE: Memory is cleared from here to +$1C, $460
	; For border arrays, 0-3: Top 0, bottom 1, right 2, left 3
	Map_EntTran_VLHalf:	.ds 1	; When 1, offset starts vertically "lower half" (at $F0 of first screen)
	Map_EntTran_TBCnt:	.ds 1	; decreasing counter as the transition moves inward top/bottom
	Map_EntTran_LRCnt:	.ds 1	; decreasing counter as the transition moves inward left/right
	Map_EntTran_BVAddrH:	.ds 4	; $0447-$044A Each border's current high part of VRAM address
	Map_EntTran_BVAddrL:	.ds 4	; $044B-$044E Each border's current low part of VRAM address
	Map_EntTran_BorderLoop:	.ds 1	; Border loop counter 
	Map_EntTran_Cnt:	.ds 1
	Map_EntTran_VAddrH:	.ds 1	; high part of VRAM address to modify
	Map_EntTran_VAddrHAdj:	.ds 1	; An adjusted version of the high address as needed to wrap (used in removed "box out" version only)
	Map_EntTran_VAddrL:	.ds 1	; low part of VRAM address to modify
	Map_EntTran_TileOff:	.ds 1	; Offset into tile memory (used in removed "box out" version only)
	Map_EntTran_Tile8x8:	.ds 1	; Offset to which 8x8 pattern of the tile we're grabbing that we need (used in removed "box out" version only)
	Map_EntTran_VRAMGap:	.ds 1	; Sets gap (i.e. 1 for vertical, 32 for horizontal; used in removed "box out" version only)

				.ds 8	; $0457-$045E unused

	Map_EntTran_Temp:	.ds 1	; Seems to me a multi-purpose value in entrance transition
	Map_EntTran_InitValIdx:	.ds 1	; Selects an index of values to initialize by

	; ASSEMBLER BOUNDARY CHECK, CONTEXT END OF $04D0
.BoundET_04D0:	BoundCheck .BoundET_04D0, $04D0, $04xx range World Map Entrance Transition context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $04xx BONUS GAME CONTEXT (see PRG022 for lots more info)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0400	; $0400-$04CF (except $0461 and $0462, see "$04xx RAM SOUND/MUSIC ENGINE") is available for this context-dependent situation
	; WARNING: $0400-$04CF gets cleared at end of bonus game!

	Roulette_Pos:		.ds 3	; $0400-$0402 horizontal position of each row
	Roulette_PosHi:		.ds 3	; $0403-$0405 Hi part of Roulette_Pos
	Roulette_ShapeLock:	.ds 3	; $0406-$0408 Locked position of each row (0 = Mushroom, 1 = Flower, 2 = Mushroom, 3 = Star)
	Roulette_ConfigRun:	.ds 1	; 0 = Configuring, 1 = Running
	Roulette_ConfigState:	.ds 1	; Early configuration state
	Roulette_RunState:	.ds 1	; Running state of game

	; NOTE: Watch the reuse here...
	Roulette_StopState:		; $040C-$040E Current "state" of each row while it is coming to a stop (1+)
	Roulette_xUpY:		.ds 1	; "x Up" display Y position (overlaps first byte of Roulette_StopState)
	Roulette_LivesToGive:	.ds 1	; Lives left to give in reward (overlaps second byte of Roulette_StopState)
				.ds 1	; Third byte of Roulette_StopState

	Roulette_Speed:		.ds 3	; $040F-$0411 Movement speed of each row (4.4FP)
	Roulette_StopCnt:	.ds 3	; $0412-$0414 Decrements to zero while each row is stopping
	Roulette_PosFrac:	.ds 3	; $0415-$0417 Fractional accumulator for position of row 1-3

				.ds 1	; $0418 unused

	Roulette_Turns:		.ds 1	; UNUSED "Turns Remaining" (if > 0, and you lose Roulette, hit a button and spin again!)

				.ds 12		; $041A-$0425 unused

	; UNUSED "Prize" that appears in some varities of the lost bonus games
	; (Or that's my best guess anyway.)  BMF54123's patch shows these as
	; Mushroom, Flower, Star, or Judgem's Cloud.  Perhaps it was a situation
	; like "Here's the prize on the table, if you can get it"...
	Card_SelectX:			; Card cursor X (NOTE: Shared with Bonus_PrizeX)
	Bonus_PrizeX:		.ds 1	; UNUSED Prize sprite X

	Card_SelectY:			; Card cursor Y (NOTE: Shared with Bonus_PrizeY)
	Bonus_PrizeY:		.ds 1	; UNUSED Prize sprite Y

	Card_Index:			; Currently selected card in "N-Spade" Card game (NOTE: Shared with Bonus_CurBufOffset)
	Bonus_CurBufOffset:	.ds 1	; Offset in graphics buffer while generating instruction box

	Card_FirstIndex:	.ds 1	; Card_Index of the first card you flipped (in case you get it wrong on the second...)

	Bonus_Round2:			; UNUSED Picks which "Round 2" game would be played (NOTE: Shared with Card_SelectXOrig)
	Card_SelectXOrig:	.ds 1	; Card cursor original X

	Card_MoveDelay:		.ds 1	; Decrements to zero; if not zero, can't move on N-Spade game
	Card_SprRAMOff:		.ds 1	; Sprite RAM offset after cursor is drawn; for drawing card flip
	Card_AnimTick:		.ds 1	; Animation tick, decrements to zero
	Card_VRAM_L:		.ds 1	; Low part of VRAM address of N-Spade card to modify
	Card_VRAM_H:		.ds 1	; High part of VRAM address of N-Spade card to modify

	Card_FlipCount:		.ds 1	; +1 for every card flip
	Card_MatchCard:		.ds 1	; Card to match, i.e. the first card you selected of the pair
	Card_UnusedVL:		.ds 1	; ?? Some VRAM Low; Seems to only be part of an unused routine
	Card_UnusedVH:		.ds 1	; ?? Some VRAM High; Seems to only be part of an unused routine

	; Bonus_GameHost
	;	0 = Toad Host: The only one we ever got
	; All others are UNUSED...
	;	1 = Koopa Troopa Host + "Prize" Game
	;	2 = Koopa Troopa Host, no "Prize" Game
	;	3 = Hammer Bro
	Bonus_GameHost:			; NOTE: Shared with Card_GameState
	Card_GameState:		.ds 1	; State of N-Spade card game
	Card_TurnsRemain:	.ds 1	; Number of turns remaining
	Card_FlipFrame:		.ds 1	; Frame of flipping card

; The next three vars belong to an unused routine @ PRG022:DA62; unclear what it did exactly
	Card_UnusedArray:	.ds 4	; $0437-$043A ??
	Card_UnusedAttr:	.ds 1	; Seems to only be part of an unused routine; attribute table offset of some sort
	Card_UnusedArrIdx:	.ds 1	; Seems to only be part of an unused routine; index for Card_UnusedArrIdx

	Card_Matches:		.ds 1	; Matches (local, this round; Seems to only be used as part of the unused routine)
	Card_CoinsToGive:	.ds 1	; If greater than zero, coins are being given

				.ds 1	; $043F unused

	; Bonus_GameState
	;
	; 0 = ?
	; 1 = Giving instructions die game
	; 2 = Rotating "die"
	; 3 = Coin spurt prize
	; 4 = Stopped die
	; 5 = Die flies away
	; 6 = ?? Initialize instructions?
	; 7 = Giving instructions
	; 8 = Pause before proceeding
	; 9 = Exiting
	Bonus_GameState:	.ds 1

	Card_InitState:		.ds 1	; Initialization state of N-Spade card game

	; Bonus_GameType
	; This appears to determine what game you're about to play.
	; This also reveals some of the greatest questionable loss in SMB3...
	; When this value is anything besides 1 or 2, it plays what I SUPPOSE
	; was a "roulette" game?  With a fixed graphics patch, it appears to
	; be a die cycling 1-6.
	;
	; 0 = Japanese text, translated as:
	;	If "1" appears, 1 (?)
	;	If "2" appears, I'll give you a key
	;	Otherwise, I'll give you coins.
	; 1 = Standard Spade game (UNUSED BONUS GAMES NOTE: May have once been the "odd" game spoken of in type 5)
	; 2 = N-Spade (UNUSED BONUS GAMES NOTE: May have once been the "even" game spoken of in type 5)
		; 3:		.ds 1	; I suspect this is a placeholder ('C' being the 3rd)
		; 4:		.ds 1	; I suspect this is a placeholder ('D' being the 4th)
	; 5 = Japanese: "If an odd number appears, I'll let you play the Roulette Game."
	; 6 = Japanese: "If an even number appears, I'll let you play the Card Game."
	; 7 = Japanese: "2, return (?)"
	;

	; The "unused" ones are just guesses (where even possible) based on the
	; semi-translated "greetings" for the sake of tracking...
BONUS_UNUSED_KEYCOIN	= 0
BONUS_SPADE		= 1	; Line up images Spade game
BONUS_NSPADE		= 2	; Card matching N-Spade game
BONUS_UNUSED_CCCC	= 3
BONUS_UNUSED_DDDD	= 4	; Unused placeholder (I think), but does actually set something when it exits!
BONUS_UNUSED_ODDROULETTE= 5
BONUS_UNUSED_EVENCARD	= 6
BONUS_UNUSED_2RETURN	= 7	; MAY have been Koopa Troopa's "Prize" Game...
	Bonus_GameType:		.ds 1

	Bonus_KTPrize:		.ds 1	; UNUSED Koopa Troopa's "Prize" Game Prize ID (0 = Mushroom, 1 = Star, 2 = Flower, 3 = Judgem's, by BMF54123's patch)

	; $0444-$04CF unused in this context (excluding $0461 and $0462, see "$04xx RAM SOUND/MUSIC ENGINE")

	; ASSEMBLER BOUNDARY CHECK, CONTEXT END OF $04D0
.BoundBonus_04D0:	BoundCheck .BoundBonus_04D0, $04D0, $04xx range Bonus context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $04xx GAMEPLAY CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0400	; $0400-$04CF (except $0461 and $0462, see "$04xx RAM SOUND/MUSIC ENGINE") is available for this context-dependent situation

	.ds 27	; $0400-$041A unused

	Fade_State:		.ds 1	; 0 = Nothing, 1 = Fade in, 3 = Fade out
	Fade_Tick:		.ds 1	; Ticks down and then decrements Fade_Level
	Fade_Level:		.ds 1	; 4 to 0, fade in level
	FadeOut_Cancel:		.ds 1	; If set, the next attempted fade out will be cancelled, which then resets this to zero
	Player_AllowAirJump:	.ds 1	; Counts down to zero, but while set, you can jump in the air
	Player_XVelAdj:		.ds 1	; Applies additional value to the X Velocity

	CineKing_Frame:			; King's animation frame (NOTE: Shared with Objects_Var7 first byte)
	Objects_Var7:		.ds 8	; $0421-$0428 General object variable 7

	; $0429-$04CF unused in this context (excluding $0461 and $0462, see "$04xx RAM SOUND/MUSIC ENGINE")

	; ASSEMBLER BOUNDARY CHECK, CONTEXT END OF $04D0
.BoundGame_04D0:	BoundCheck .BoundGame_04D0, $04D0, $04xx range Bonus context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $04xx RAM SOUND/MUSIC ENGINE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0461

; $0461-$0462 are reserved for use by the sound/music engine
; These ought to be moved into the greater range to spare this area...
; $04EB and $04EC are unused, good place for these vars!!

Level_MusicQueue:		.ds 1	; Requests a song from Set 2A/B (used to allow delayed start)
Level_MusicQueueRestore:	.ds 1	; What to "restore" the BGM to when it changes (e.g. Starman, P-Switch, etc.)

	.org $04D0

; $04D0-$04FF is reserved for use by the sound/music engine
; Lower ranges are context-dependent

	Music_TriTrkPos:	.ds 1	; Offset of triangle track in currently playing index
	Music_NseTrkPos:	.ds 1	; Offset of noise track in currently playing index
	Music_PCMTrkPos:	.ds 1	; Offset of DMC track in currently playing index
	Music_Sq2RestH:		.ds 1	; Square 2 Track hold for rest values to be applied after each event
	Music_Sq2Rest:		.ds 1	; Square 2 Track "Rest" period (counts down to zero)
	Music_Sq2NoteLen:	.ds 1	; Square 2 Track length of note (counts down to zero, cuts off sound)
	Music_Sq1Rest:		.ds 1	; Square 1 Track "Rest" period (counts down to zero)
	Music_Sq1NoteLen:	.ds 1	; Square 1 Track length of note (counts down to zero, cuts off sound)
	Music_TriRestH:		.ds 1	; Triangle Track hold for rest values to be applied after each event
	Music_TriRest:		.ds 1	; Triangle Track "Rest" period (counts down to zero)
	Music_NoiseRest:	.ds 1	; Noise Track "Rest" period (counts down to zero)
	Music_NseRestH:		.ds 1	; Noise Track hold for rest values to be applied after each event
	Music_DMCRest:		.ds 1	; DMC Track "Rest" period (counts down to zero)
	Music_DMCRestH:		.ds 1	; DMC Track hold for rest values to be applied after each event
	Music_PCMStart:		.ds 1	; Holds the starting offset of the DMC track
	Music_NextIndex:	.ds 1	; Next "index" to be played

	SFX_Counter1:		.ds 1	; Generic purpose SFX counter
	SndCur_Player:		.ds 1	; Currently playing Player sound (blocks music on Square 1)
	SndCur_Level1:		.ds 1	; Currently playing "level 1" sound (blocks music on Square 2)
	SndCur_Level2:		.ds 1	; Currently playing "level 2" sound
	SndCur_Music1:		.ds 1	; Currently playing BGM from Music 1 set
	SndCur_Music2:		.ds 1	; Currently playing BGM from Music 2 set
	SndCur_Map:		.ds 1	; Currently playing map sound (blocks music on Square 1)
	SndCur_Pause:		.ds 1	; Holds copy of Sound_QPause, to play sound while everything else is paused
	SFX_Counter2:		.ds 1	; Generic purpose SFX counter for level sounds
	SFX_Counter3:		.ds 1	; Generic purpose SFX counter
	SFX_Counter4:		.ds 1	; Generic purpose SFX counter

				.ds 1	; $04EB unused
				.ds 1	; $04EC unused

	Sound_IsPaused:		.ds 1	; When set, sound processing is PAUSED

				.ds 1	; $04EE ununsed
				.ds 1	; $04EF ununsed
				.ds 1	; $04F0 ununsed

; For any of these queues, the value is a bit value, which offers
; a simple prioritization system; lowest value plays over any other

; Queue Player sound effects
SND_PLAYERJUMP	= $01	; Jump
SND_PLAYERBUMP	= $02	; Bump
SND_PLAYERSWIM	= $04	; Swim / Squish
SND_PLAYERKICK	= $08	; Kick
SND_PLAYERPIPE	= $10 	; Pipe / shrink
SND_PLAYERFIRE	= $20 	; Fireball
SND_PLAYERPOWER	= $40	; Full power ringing (must be constantly set or you don't hear it)
SND_PLAYERFROG	= $80 	; frog hop
	Sound_QPlayer:		.ds 1

; Queue Level sound effects 1
SND_LEVELCOIN	= $01	; Coin
SND_LEVELRISE	= $02 	; Powerup rising from block
SND_LEVELVINE	= $04 	; Vine rising
SND_LEVELBABOOM	= $08 	; Cannon fire
SND_LEVELBLIP	= $10 	; Text "type" sound / card select
SND_LEVELPOWER	= $20 	; Power up
SND_LEVEL1UP	= $40 	; 1-up
SND_LEVELPOOF	= $80 	; Lost suit / wand shot
SND_LEVELUNK	= $90	; Unknown / lost sound
SND_LEVELSHOE	= $A0	; Lost Kuirbo's Shoe
SND_LEVELTAILWAG= $B0	; Tail wag
	Sound_QLevel1:		.ds 1

; Queue Level sound effects 2
SND_LEVELCRUMBLE= $01	; Crumbling brick
SND_LEVELFLAME	= $02 	; Flame jet
SND_BOOMERANG	= $04 	; Boomerang
SND_LEVELAIRSHIP= $08	; Airship fly
SND_LEVELMARCH	= $10 	; Hammer Bros. march around
; $20 - Unused
; $40 - Unused
SND_LEVELSKID	= $80 	; Skid
	Sound_QLevel2:		.ds 1


; Queue music request 1
; The following I've grouped into "Set 1" (which play song index 0-7):
MUS1_PLAYERDEATH	= $01	; Player death
MUS1_GAMEOVER		= $02	; Game over
MUS1_BOSSVICTORY	= $04	; Victory normal
MUS1_WORLDVICTORY	= $08	; Victory super (King reverted, Bowser defeated, etc.)
MUS1_BOWSERFALL		= $10	; Bowser dramatic falling
MUS1_COURSECLEAR	= $20	; Course Clear
MUS1_TIMEWARNING	= $40	; Time Warning (attempts to speed up song playing)
MUS1_STOPMUSIC		= $80	; Stops playing any music
	Sound_QMusic1:		.ds 1

; Queue music request 2
; The following I've grouped into "Set 2A":
MUS2A_WORLD1		= $01	; World 1
MUS2A_WORLD2		= $02	; World 2
MUS2A_WORLD3		= $03	; World 3
MUS2A_WORLD4		= $04	; World 4
MUS2A_WORLD5		= $05	; World 5
MUS2A_WORLD6		= $06	; World 6
MUS2A_WORLD7		= $07	; World 7
MUS2A_WORLD8		= $08	; World 8
MUS2A_SKY		= $09	; Coin Heaven / Sky World / Warp Zone (World 9)
MUS2A_INVINCIBILITY	= $0A	; Invincibility
MUS2A_WARPWHISTLE	= $0B	; Warp whistle
MUS2A_MUSICBOX		= $0C	; Music box
MUS2A_THRONEROOM	= $0D	; King's room
MUS2A_BONUSGAME		= $0E	; Bonus game
MUS2A_ENDING		= $0F	; Ending music


; The following I've grouped into "Set 2B":
MUS2B_OVERWORLD		= $10	; Overworld 1
MUS2B_UNDERGROUND	= $20	; Underground
MUS2B_UNDERWATER	= $30	; Water
MUS2B_FORTRESS		= $40	; Fortress
MUS2B_BOSS		= $50	; Boss
MUS2B_AIRSHIP		= $60	; Airship
MUS2B_BATTLE		= $70	; Hammer Bros. battle
MUS2B_TOADHOUSE		= $80	; Toad House
MUS2B_ATHLETIC		= $90	; Overworld 2
MUS2B_PSWITCH		= $A0	; P-Switch
MUS2B_BOWSER		= $B0	; Bowser
MUS2B_WORLD8LETTER	= $C0	; Bowser's World 8 Letter
MUS2B_MASK		= $F0	; Not intended for use in code, readability/traceability only
	Sound_QMusic2:		.ds 1

; Queue map sound effects
SND_MAPENTERWORLD	= $01	; World begin starry entrance sound
SND_MAPPATHMOVE		= $02	; Path move
SND_MAPENTERLEVEL	= $04	; Enter level
SND_MAPINVENTORYFLIP	= $08	; Flip inventory
SND_MAPBONUSAPPEAR	= $10	; Bonus appears
; $20: ?? unused ?
; $40: ?? unused ?
SND_MAPDENY		= $80	; Denied
	Sound_QMap:		.ds 1

; Queue pause sound
PAUSE_STOPMUSIC		= $01	; Pause sound effect (like pressing START, pauses music!)
PAUSE_RESUMEMUSIC	= $02	; Resume sound (resumes music)
	Sound_QPause:		.ds 1

	DMC_Time:		.ds 1	; Time remaining on DMC sound
	Music_Sq1RestH:		.ds 1	; Square 1 Track hold for rest values to be applied after each event
	Music_Sq1AltRamp:		.ds 1	; When Square 1 track encounters a $00 byte, it actives a ramping mode, the value of which is stored here
	Music_LOST4FB:		.ds 1	; AFAIK, value in music engine that is "lost"; nothing seems to set it, and it doesn't do very much (possibly was a note length override??)
	Music_LOST4FC:		.ds 1	; AFAIK, value in music engine that is "lost"; nothing seems to set it, and it doesn't do very much

	Music_RestH_Base:	.ds 1	; Base offset into Music_RestH_LUT
	Music_Sq2TrkOff:	.ds 1	; Offset of square wave 2 track in currently playing index
	Music_Sq1TrkOff:	.ds 1	; Offset of square wave 1 track in currently playing index

	; ASSEMBLER BOUNDARY CHECK, CONTEXT END OF $04D0
.BoundSound_0500:	BoundCheck .BoundSound_0500, $0500, $04xx Sound Engine



; NOTE: CONTEXT -- RAM in the $500-$5FF range changes meaning depending on the "context", i.e. what
; state of the game we're currently in!  This means that variables are defined with overlapping
; addresses, and care must be taken to use the correct labels depending on the code!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $05xx TITLE SCREEN CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0500	; $0500-$05FF is available for this context-dependent situation

				.ds 16	; $0500-$050F unused

	; NOTE: All of this block is cleared by the title screen
	Title_MLAccelCnt:	.ds 1	; constant moving counter which overflows to provide a more "natural" acceleration to the Bros
	Title_MarioPoof:	.ds 1	; countdown of Mario's "poof" when he collects the power up
	Title_MLHoldTick:	.ds 1	; Set to $40 when Mario/Luigi are "held" (count down to zero)
	Title_ObjVar:		.ds 6	; $513-$518 Minor objects user-defined variable 1 (automatically decrements if not zero!)
	Title_ObjVar2:		.ds 6	; $519-$51E Minor objects user-defined variable 2
	Title_ObjFrame:		.ds 6	; $51F-$524 Minor object "frame"; adds 2x the value here to the pattern selection for the object's sprites

	; $0525-$05FF unused

	; ASSEMBLER BOUNDARY CHECK, END OF $0600
.BoundTS_0600:	BoundCheck .BoundTS_0600, $0600, $05xx Title Screen context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $5xx MAP CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0500	; $0500-$05FF is available for this context-dependent situation

	; NOTE: Most of the memory in this space is shared with Gameplay Context
	; so don't assume that any value that should be spared is safe in here...

	; NOTE: There are 8 defined "core" map objects, but up to 15 (?) can exist!
	; *** Index 1 is assumed reserved for the Airship, however...
	Map_Object_ActY:	.ds 15	; $0500-$050E For map objects, their actual display Y coordinate (as it may modify, esp. with marchers)
	Map_Object_ActX:	.ds 15	; $050F-$051D For map objects, their actual display X coordinate (as it may modify, esp. with marchers)
	Map_Object_ActXH:	.ds 15	; $051E-$052C For map objects, their actual display X Hi byte (as it may modify, esp. with marchers)
	Map_Object_Data:	.ds 15	; $052D-$053B For marching objects, 0/1 for their direction, could be anything though
	Map_March_Count:	.ds 15	; $053C-$054A Simply counts and overflows, but used to determine position of marching map objects (PER ID, not object index ... Actually is seems they go back and forth on that??)

				.ds 60	; $054B-$0586 unused

	Map_Objects_Vis:	.ds 15	; $0587-$058E Set for map objects as visible, clear if it's not
	Map_MarchInit:		.ds 1	; Set when marching data has been initialized (done once per marching cycle on the map)
	Map_InCanoe_Flag:	.ds 1	; Set when Player is in Canoe (modifies movement, allows movement in water, etc.)
	World_8_Dark:		.ds 1	; Darkness on World 8 Map, level 2 -- counts 0-7 while setting up the effect
	World_Map_AnimF:	.ds 1	; World map animation frame (for bushes, etc.)
	World_Map_AnimT:	.ds 1	; World map animation tick


	; $059B-$05FF unused

	; ASSEMBLER BOUNDARY CHECK, END OF $0600
.BoundM_0600:	BoundCheck .BoundM_0600, $0600, $05xx World Map context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $5xx BONUS GAME CONTEXT (see PRG022 for lots more info)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0500	; $0500-$05FF is available for this context-dependent situation

				.ds 231	; $0500-$05E6 unused

	BonusText_VH:		.ds 1
	BonusText_VL:		.ds 1

	; $05E9-$05FF unused

	; ASSEMBLER BOUNDARY CHECK, END OF $0600
.BoundBonus_0600:	BoundCheck .BoundBonus_0600, $0600, $05xx World Map context

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $5xx GAMEPLAY CONTEXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0500	; $0500-$05FF is available for this context-dependent situation

				.ds 16	; $0500-$050F unused

	; Event_Countdown is context dependent; without context, does nothing
	; * When you come out of a pipe, this counter decrements until the pipe should be finished
	; * When you die, counts down until dropping back to map

	; NOTE: Event_Countdown and the following 7 are all decremented together!
	Event_Countdown:	.ds 1

	Player_TailCount:	.ds 1	; Determines display frame of tail wag
	Player_InAir_OLD:	.ds 1	; Stores backup of Player_InAir
	Player_FireCount:		; Player shoots fireball/hammer, sets sprite frame (shared with Player_FrogHopCnt)
	Player_FrogHopCnt:	.ds 1	; Counter used for frog hopping along the ground (shared with Player_FireCount)

				.ds 1	; $0514 unused

	Player_PMeterCnt:	.ds 1	; Tick counter used to count when to increase/decrease Power Meter
	B10Coin_Timer:		.ds 1	; Decrements until zero, which is how much time you have to get the max coins from a 10 coin block
	Player_TailAttack:	.ds 1	; Initiailized to $12; counts down to zero, performs tail attack!

	CineKing_Timer:			; Timer; decrements to zero (shares Objects_Timer first byte)
	Objects_Timer:		.ds 8	; $0518-$051F "Timer" values; automatically decrements to zero

	; NOTE: Until Timer2 expires, object will not hit other objects.
	; Probably used as a dampener to keep an object from slaughtering
	; another bunch of objects TOO quickly!
	Objects_Timer2:		.ds 8	; $0520-$0527 "Timer" values; automatically decrements to zero 

	; All the Level_BlockChgX/Y values are aligned to nearest 16 (i.e. tile coordinate)
	Level_BlockChgXHi:	.ds 1	; Player X High value when block change was queued
	Level_BlockChgXLo:	.ds 1	; Player X Low value when block change was queued
	Level_BlockChgYHi:	.ds 1	; Player Y High value when block change was queued
	Level_BlockChgYLo:	.ds 1	; Player Y Low value when block change was queued

	; the block "bounce" that occurs after hitting ? block, music note block, etc.
	Level_BlkBump_Pos:	.ds 2	; $052C-$052D Block bump effect slot "position" (from 10 down, "position" of bounce)
	Level_BlkBump:		.ds 3	; $052E-$0530 Block bump effect slot (use Level_ChgTileEvent value, or 0 for inactive)
	Level_BlkBump_XHi:	.ds 3	; $0531-$0533 Block bump slot X Hi
	Level_BlkBump_XLo:	.ds 3	; $0534-$0536 Block bump slot X Lo
	Level_BlkBump_YHi:	.ds 3	; $0537-$0539 Block bump slot Y Hi
	Level_BlkBump_YLo:	.ds 3	; $053A-$053C Block bump slot Y Lo

				.ds 5	; $053D-$0541 unused

	; The alternate vertical scrolls are used so that raster effects can be properly implemented!
	Level_VertScrollH:	.ds 1	; Alternate VertScroll_Hi used by engine, adjusted before being sent to Vert_Scroll_Hi
	Level_VertScroll:	.ds 1	; Alternate VertScroll used by engine, adjusted before being sent to Vert_Scroll

	Player_AboveTop:	.ds 1	; If Player is above top of level, this is $FF (-1), otherwise it is zero

	Level_InitAction:		; AT LEVEL INITIALIZATION ONLY: Performs a specific initialization routine (NOTE: Shared with Player_Slide)
	Player_Slide:		.ds 1	; Positive values sliding forward, negative values sliding backward; directly sets Player_XVel

	Player_UphillFlag:	.ds 1	; When set, Player is walking uphill, and uses speed index value at Player_UphillSpeedIdx

				.ds 8	; $0547-$054E unused

	Player_Flip:		.ds 1	; Invincibility Somersault is used when set; only works in air, reset on ground

	Level_AirshipH:			; Height of the airship during the Airship Intro (shared with Player_KuriboDir)
	Player_KuriboDir:	.ds 1	; While Kuribo's shoe is moving: 0 - Not requesting move, 1 - move right, 2 - move left

	Player_Grow:		.ds 1	; Tick counter used to animate growth into Super Mario (20 is starting value, or 2f to shrink)
	Player_FlashInv:	.ds 1	; Player "flashing invincibility" after being hit, counts down to zero
	Player_StarInv:		.ds 1	; Starman Invincibility counter; full/fatal invincibility, counts down to zero
	Player_SuitLost:	.ds 1	; Suit lost to hit discard "poof" counter
	Player_StarOff:		.ds 1	; Starman Invincibility wear-off (the last second or so when it slows and vanishes), counts down to zero
	Player_HaltTick:	.ds 1	; When non-zero, all action halts until this countdown hits zero
	Player_Kick:		.ds 1	; Kick frame in use, counts down to zero
	Player_PipeFace:	.ds 1	; Player forward frame, used for vertical pipe entrance, counts down to zero
	Player_EndLevel:	.ds 1	; Player's end of level run-off until count down to zero (player will actually wrap around horizontally if too large)
	Level_AirshipCtl:	.ds 1	; Airship control -- 1 = run and jump to catch air ship, 2 = climb to enter, 3 = enter

				.ds 1	; $055B unused

	Counter_Wiggly:		.ds 1	; "Wiggly" counter, provides rippled movement (like the airship rising during its intro)
	Counter_7to0:		.ds 1	; Counter that runs from 7 to 0 continuously while level is in progress

				.ds 1	; $055E unused

	LevelPartialInit:	.ds 1	; When set, performs a partial reinitialization of level data (notably does not perform the Level InitAction unless it is airship related)
	Level_TilesetIdx:	.ds 1	; Holds Level_Tileset as an "index" value instead, relative to levels (i.e. Level_Tileset - 1)
	Level_ChangeReset:	.ds 1	; When set to zero, a mass reset is performed (used when changing "scenes" in a single level)
	Level_UnusedFlag:	.ds 1	; Unused; only set in a couple places, but never read back!
	Level_SlopeEn:		.ds 1	; If set, enables slope tiles (otherwise they're considered flat top-only solids)

CHNGTILE_DELETECOIN	= $01
CHNGTILE_DELETETOBG	= $02
CHNGTILE_TOGNOTEBLOCK	= $03	; miscolored note block
CHNGTILE_TOBOUNCEWOOD	= $04
CHNGTILE_TONOTEBLOCK	= $05
CHNGTILE_COINHEAVEN	= $06
CHNGTILE_TOBRICK	= $07
CHNGTILE_TOMETALPLATE	= $08	; i.e. "plate" that appears after ? block is hit
CHNGTILE_PSWITCHSTOMP	= $09
CHNGTILE_TOBRICKCOIN	= $0B	; brick containing coin
CHNGTILE_DELETETOBGALT	= $0C
CHNGTILE_PIPEJCT	= $0E	; UNUSED replaces the unused TILE9_PIPEWORKS_JCT tile!
CHNGTILE_DELETEDONUT	= $0F
CHNGTILE_FROZENMUNCHER	= $10
CHNGTILE_FROZENCOIN	= $11
CHNGTILE_PSWITCHAPPEAR	= $12
CHNGTILE_DOORAPPEAR	= $13
CHNGTILE_TOADBOXOPEN	= $14
CHNGTILE_4WAYCANNON	= $15
CHNGTILE_GIANTBRICKBUST	= $16	; Giant World brick bust
CHNGTILE_GIANTBLOCKHIT	= $17	; Giant World [?] block hit to metal
CHNGTILE_GIANTBRICKFIX	= $18	; Giant World brick restore (small Mario hit giant brick)
	Level_ChgTileEvent:	.ds 1	; When non-zero, queues a "change tile" event

	Level_NoStopCnt:	.ds 1	; A counter which continuously increments unless something is "stopping" the action
	Level_Event:		.ds 1	; Check "LevelEvent_Do" for values; 0 means nothing
	Level_PSwitchCnt:	.ds 1	; When non-zero, P-Switch is active (init @ $80); counts down to zero and restarts music

				.ds 1	; $0568 unused

	Player_SlideRate:	.ds 1	; While Player is sliding, this is added to X Velocity (does not persist, however)

				.ds 1	; $056A unused

	Player_IsClimbing:	.ds 1	; Set when Player is climing vine
	Player_FlipBits_OLD:	.ds 1	; Holds backup of Player_FlipBits
	Player_HitCeiling:	.ds 1	; Flag set when Player has just hit head off ceiling
	Player_FlyTime:		.ds 1	; When > 0, Player can fly (for power ups that do so); decrements (unless $FF) to 0
	Player_IsDucking:	.ds 1	; Set when Player is ducking down
	Player_WhiteBlkCnt:	.ds 1	; White block counter; counts up while Player is standing on white block and holding down

	; Level_PipeMove is set to various values that dictate 
	; how Player is moving within a pipe
	; 
	; The lower 2 bits form a direction as follows:
	;	00 - right
	;	01 - left
	;	10 - down
	;	11 - up
	;
	; If bit 7 ($80) is NOT set, then we're just entering
	; the pipe, and next 3 bits say what it will do:
	; 000xx - Does nothing (not used, invalid)
	; 001xx - Exits level (i.e. World Map pipe junctions) 
	; 010xx - Junction to appropriate "Big Question Block" bonus area (Level_JctCtl = 2)
	; 011xx - Junction general (Level_JctCtl = 3)
	; 100xx - Junction to generic exit area (Level_JctCtl = 4)
	; 101xx - In-level transit (a la World 7 pipe mazes and other places; does not set Level_JctCtl)
	;
	; If bit 7 IS set, we're moving through the pipe (either exiting out one end or in-transit)
	Level_PipeMove:		.ds 1

	Level_CoinHeav:		.ds 1	; Enter coin heaven when set $80; Increments; at $D0, "soft jump" arrival; terminates at wrap to $00

	Player_MoveLR:		.ds 1	; 0 - Not moving left/right, 1 - Moving left, 2 - Moving right (reversed from the pad input)

	Player_WalkAnimTicks:	.ds 1	; Ticks between animation frames of walking; max value varies by Player's X velocity

	Player_InWater:		.ds 1	; Set for when in water (1 = Regular water specifically, other non-zero values indicate waterfall)
	Player_SwimCnt:		.ds 1	; Swim counter FIXME Describe better 0-3
	Player_Kuribo:		.ds 1	; Set for Kuribo's Shoe active
	Player_QueueSuit:	.ds 1	; Queues a suit change (values like Player_Suit, but add 1, EXCEPT: $0F = Statue enable, $40 = Splash, $80 = Kuribo's Shoe)
	Player_mGoomba:		.ds 1	; Player is caught by a micro Goomba (jump short)
	Player_Statue:		.ds 1	; Player is in Tanooki Statue mode; counts down to zero
	Player_RunFlag:		.ds 1	; Set while Player is actually considered "running" (holding down B and at enough speed; doesn't persist)
	Player_Bounce:		.ds 1	; Set to cause block bounce (upper 4 bits specifies what kind of block will be bounced)
	Player_BounceDir:	.ds 1	; Direction of Player bounce -- 0 = Down, 1 = Up, 2 = Left, 3 = Right
	Player_BounceObj:	.ds 1	; Set if it was a kicked shelled object that hit the bounce block (i.e. don't bounce the Player if the object is the one that hit) 
	Counter_ByPlayerSpd:	.ds 1	; A counter which increments faster as the Player goes faster

	Level_HAutoScroll:	.ds 1	; When set to 1, "auto horizontal scroll" is active (this can be toggled mid-level)
	B10Coin_Count:		.ds 1	; Decrements until -1, you continue to get a coin until it does so
	B10Coin_ID:		.ds 1	; Forms a sort of unique ID so game knows if you've switched blocks

	Player_OffScreen:	.ds 1	; Set when Player is completely off screen

	; FloatLevel_PlayerWaterStat: For levels that "float" and have a fixed set of water at the bottom
	; Bit 6: Set if Player is beneath bottom of water
	; Bit 7: Set if beneath top of water
	FloatLevel_PlayerWaterStat:	.ds 1


	Player_LowClearance:	.ds 1	; Set when Player is in a "low clearance" situation (big Mario in a single block high tunnel)

	PUp_StarManFlash:	.ds 1	; Set when a Starman is bouncing about so it cycles colors! (also used to get super suit if set in advance)

	; Player_Behind_En:
	; Specifies whether the "Behind the scenes" effect is actually active
	; If the Player has stepped out from behind the background, it can be
	; still active, but he won't get the effect of it!
	Player_Behind_En:	.ds 1
	Player_Behind:		.ds 1	; When non-zero, Player is "behind the scenes" (as by white block)

	Player_Slippery:	.ds 1	; 0 = Ground is not slippery, 1 = Ground is a little slippery, 2 = Ground is REALLY slippery
	Player_SandSink:	.ds 1	; Sinking in quicksand! (holds Y when quicksand hit in upper 4 bits, bit 0 sets '0' jumping, '1' sinking)

	; Player_PartDetEn: "32 Pixel Partition Detection" enabler
	; When set, if Player Y >= 160, Player detects bottom two rows of tiles implicitly
	; Used with Update_Request = UPDATERASTER_32PIXPART if there's a floor 
	; (i.e. NOT used in levels with fixed water; for that, see FloatLevel_PlayerWaterStat)
	Player_PartDetEn:	.ds 1
	Player_InPipe:		.ds 1	; Player is going through pipe
	Player_MushFall:	.ds 1	; Set to 0 when mushroom is to fall to the left, 1 to the right
	Player_SprOff:		.ds 1	; Player sprite offset (NOTE: Should be multiples of 4, otherwise bad unaligned stuff happens!)

	; Strange gapping here; there's pretty much enough room for a couple more special objects
	Object_SprRAM:		.ds 8	; $058F-$0596 Sprite_RAM offset by object

	SpecialObj_Var2:	.ds 8	; $0597-$059E General purpose variable 2

				.ds 2	; $059F-$05A0 unused

	SpecialObj_YVelFrac:	.ds 8	; $05A1-$05A8 Y velocity fractional accumulator

				.ds 2	; $05A9-$05AA unused

	SpecialObj_XVelFrac:	.ds 8	; $05AB-$05B2 X velocity fractional accumulator

				.ds 2	; $05B3-$05B4 unused

	SpecialObj_Var3:	.ds 8	; $05B5-$05BC General purpose variable 3

				.ds 2	; $05BD-$05BE unused

	SpecialObj_YLo:		.ds 8	; $05BF-$05C6 Y low coordinate of special object

				.ds 2	; $05C7-$05C8 unused

	SpecialObj_XLo:		.ds 8	; $05C9-$05D0 X low coordinate of special object

				.ds 2	; $05D1-$05D2 unused

	SpecialObj_YVel:	.ds 8	; $05D3-$05DA Y Velocity of special object

				.ds 2	; $05DB-$05DC unused

	SpecialObj_XVel:	.ds 8	; $05DD-$05E4 X Velocity of special object

				.ds 8	; $05E5-$05EC unused

	Misc_Counter:		.ds 1	; Miscellaneous loop counter ?
	Level_TimerMSD:		.ds 1	; Leftmost / most significant digit on timer
	Level_TimerMid:		.ds 1	; Middle digit on timer
	Level_TimerLSD:		.ds 1	; Rightmost / least significant digit on timer
	Level_TimerTick:	.ds 1	; Timer decrementing tick
	Inventory_Open:		.ds 1	; Set when inventory panel is open, also used to dictate whether it is "opening" (1) or "closing" (0)
	Level_TimerEn:		.ds 1	; Set to disable clock (bit 7 will also disable level animations, e.g. '?s')
	Kill_Tally:		.ds 1	; Counter that increases with each successful hit of an object without touching the ground

	Objects_KillTally:	.ds 5	; $05F5-$05F9 OBJECT SLOTS 0 - 4 ONLY: Kill_Tally for a kicked shell as it hits other enemies 

	PlayerProj_YHi:		.ds 2	; $05FA-$05FB Player projectile Y Hi

	; NOTE: Since Level_AScrlConfig checks are generally implemented as "BEQ/BNE", technically ANY
	; value enables auto scroll adjustments, but officially ASCONFIG_ENABLE is used to enable it
ASCONFIG_ENABLE		= $01	; Enables auto scroll coordinate adjustments of any sort
ASCONFIG_HDISABLE	= $80	; Disables horizontal auto scroll coordinate adjustment (generally if Horz Auto Scroll is not in use)
	Level_AScrlConfig:	.ds 1

	Cine_ToadKing:		.ds 1	; Set to 1, initializes Toad and transformed king; set to 2 while running that cinematic
	; The diagonal auto scroller wraps vertically several times to give the illusion
	; of a long vertical strip.  AScrlURDiag_WrapState is set to 1 and 2 during this
	; process which makes it possible.  Objects that need to offset themselves to
	; cope with this behavior utilize AScrlURDiag_WrapState_Copy to stay in sync.
	AScrlURDiag_WrapState_Copy:	.ds 1	; Copy of AScrlURDiag_WrapState
	AScrlURDiag_WrapState:		.ds 1

	; ASSEMBLER BOUNDARY CHECK, END OF $0600
.BoundGame_0600:	BoundCheck .BoundGame_0600, $0600, $05xx Gameplay context


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $06xx RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; DURING ENDING ONLY
	.org $0600
	Ending_CmdBuffer:		.ds 192	; $0600-$06C0 Buffer used during ending sequence

	; Normal purpose $06xx RAM...
	.org $0600

				.ds 2	; $0600-$0601 unused

	Level_Tile_Head:	.ds 1	; Tile at Player's head 
	Level_Tile_GndL:	.ds 1	; Tile at Player's feet left
	Level_Tile_GndR:	.ds 1	; Tile at Player's feet right
	Level_Tile_InFL:	.ds 1	; Tile "in front" of Player ("lower", at feet)
	Level_Tile_InFU:	.ds 1	; Tile "in front" of Player ("upper", at face)
	Level_Tile_Whack:	.ds 1	; Tile last hit by tail attack or shell
	Level_Tile_Quad:	.ds 4	; $0608-$060B Quadrant of tile for each of the positions above

				.ds 1	; $060C unused

	; Level_Tile_Slope: Slope of tile for each of the positions above (first byte also used by objects)
	; 0: Slope shape at feet
	; 1: Slope shape at head
	; 2: "in front" of Player ("lower", at feet)
	; 3: "in front" of Player ("upper", at face)
	Level_Tile_Slope:	.ds 4	; $060D-$0610

				.ds 1	; $0611 unused

	Scroll_Cols2Upd:	.ds 1	; Number of 8x8 columns to update (typically set to 32 for a full dirty update)

				.ds 6	; $0613-$0618 unused

	Bonus_CoinsYVel:	.ds 6	; $0619-$061E UNUSED Bonus game coins Y velocity
	Bonus_CoinsY:		.ds 6	; $061F-$0624 UNUSED Bonus game coins Y
	Bonus_CoinsXVel:	.ds 6	; $0625-$062A UNUSED Bonus game coins X velocity
	Bonus_CoinsX:		.ds 6	; $062B-$0630 UNUSED Bonus game coins X
	Bonus_CoinsYVelFrac:	.ds 6	; $0631-$0636 UNUSED Bonus game coins Y velocity fractional accumulator

				.ds 6	; $0637-$063C unused

	Bonus_CoinsXVelFrac:	.ds 6	; $063D-$0642 UNUSED Bonus game coins X velocity fractional accumulator

				.ds 8	; $0643-$064A unused

	Object_TileFeet:	.ds 1	; Object tile detected at "feet" of object
	Object_TileWall:	.ds 1	; Object tile detected in front of object, i.e. a wall

				.ds 1	; $064D unused

	Object_AttrFeet:	.ds 1	; Object tile quadrant of Object_TileFeet
	Object_AttrWall:	.ds 1	; Object tile quadrant of Object_TileWall

				.ds 1	; $0650 unused

	Objects_SprHVis:	.ds 8	; $0651-$0658 Flags; Bits 7-2 set when each 8x16 sprite is horizontally off-screen (left-to-right from MSb)
	Objects_SpawnIdx:	.ds 8	; $0659-$0660 Holds the index into level data that this object was spawned from

; Objects_State
OBJSTATE_DEADEMPTY	= 0	; Dead/Empty
OBJSTATE_INIT		= 1	; Init
OBJSTATE_NORMAL		= 2	; Normal (typical operation)
OBJSTATE_SHELLED	= 3	; Shelled (shelled enemy post-stomp)
OBJSTATE_HELD		= 4	; Held (held by Player)
OBJSTATE_KICKED		= 5	; Kicked (kicked by Player / spinning shell)
OBJSTATE_KILLED		= 6	; Killed (flipped over and falling off screen)
OBJSTATE_SQUASHED	= 7	; Squashed (generally Goomba only)
OBJSTATE_POOFDEATH	= 8	; "Poof" Death (e.g. Piranha death)
	Objects_State:		.ds 8

	Objects_Frame:		.ds 8	; $0669-$0670 "Frame" of object (see ObjectGroup_PatternSets)

	Level_ObjectID:		.ds 8	; $0671-$0678 All active actor IDs

	Objects_FlipBits:	.ds 8	; $0679-$0680 Applied sprite attributes for this object (usually just horizontal/vertical flip)

	Objects_SprVVis:	.ds 8	; $0681-$0688 Flags; Bits 3-0 set when each 8x16 sprite is vertically off-screen (top-to-bottom from MSb)
	Objects_Var1:		.ds 8	; $0689-$0690 Generic variable 1 for objects
	Objects_Var2:		.ds 8	; $0691-$0698 Generic variable 2 for objects

	Unused699:		.ds 1	; Absolutely no idea, it is set once in one place and never used again... MAY be lost bonus game related?

	; UNUSED Bonus Game Die counter
	; While the die is rotating, just used as a counter 0 to 3 to time the rolling animation.
	; After Player would press 'A', this value is immediately set to 0.
	; In the case of the odd/even game, if the Player "won", it is set to 5 or 6.
	Bonus_DieCnt:		.ds 1

				.ds 1	; $069B unused

	Score_Earned:		.ds 2	; $069C-$069D (16-bit value) A "buffer" of score earned to be added to your total, total score stored in Player_Score
	Score_Temp:		.ds 1	; Temp used when figuring out to display a 3-byte integer worth of score

				.ds 5	; $069F-$06A3 unused

	Player_IsHolding:	.ds 1	; Set when Player is holding something (animation effect only)
	Player_ISHolding_OLD:	.ds 1	; Holds onto whether Player WAS holding onto something (so we can be sure to clear Player_IsHolding)

; NOTE!! These object vars are OBJECT SLOT 0 - 4 ONLY!

; Objects_Timer3: Used as the "wake up" out of shell timer
; If timer is less than $60, it decrements normally, otherwise...
;	If object is in state 2, timer decrements normally
;	If object is in state 4 (being held), timer only decrements every 4 ticks
;	In all other states, timer decrements every 2 ticks
	Objects_Timer3:		.ds 5	; $06A6-$06AA Used as the "wake up" out of shell timer
	Objects_Timer4:		.ds 5	; $06AB-$06AF "Timer" values; automatically decrements to zero (used in "shakin' awake" effect)

				.ds 3	; $06B0-$06B2 unused

	Object_SlopeHeight:	.ds 1	; Object calculated slope height
	Buffer_Occupied:	.ds 2	; $06B4-$06B5 Set if respective Object_BufferX/Y buffer is already taken by an object

	Player_UphillSpeedIdx:		; Override when Player_UphillFlag is set (shared with Player_Microgoomba)
	Player_Microgoomba:	.ds 1	; Microgoomba stuck to Player
	Objects_InWater:	.ds 5	; $06B7-$06BB Set when object is in water

				.ds 1	; $06BC unused

	SpecialObj_Var1:	.ds 8	; $06BD-$06C4 General purpose variable 1

				.ds 2	; $06C5-$06C6 unused

	SpecialObj_Data:	.ds 8	; $06C7-$06CE Special object "data" field, defined by object

				.ds 2	; $06CF-$06D0 unused

	SpecialObj_Timer:	.ds 8	; $06D1-$06D8 "Timer" values; automatically decrements to zero

				.ds 2	; $06D9-$06DA unused

	CannonFire_Var:		.ds 8	; $06DB-$06E2
	CannonFire_Timer:	.ds 8	; $06E3-$06EA Cannon Fire timer, decrements to zero
	Objects_QSandCtr:	.ds 8	; $06EB-$06F2 When enemy has fallen into quicksand, increments until $90 which deletes it

	; ASSEMBLER BOUNDARY CHECK, END OF $0700
.Bound_0700:	BoundCheck .Bound_0700, $0700, $06xx RAM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $07xx RAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $0700

	TileAddr_Off:		.ds 1	; During level loading, specifies an offset into the current Mem_Tile_Addr setting

	; LevLoad_Unused1-4 are initialized when about to load a level, 
	; but never used.  May have been reserved or intended or 
	; even debugging, but who knows now...
	LevLoad_Unused1:	.ds 1
	LevLoad_Unused2:	.ds 1
	LevLoad_Unused3:	.ds 1
	LevLoad_Unused4:	.ds 1

				.ds 1	; $0705 unused

	LL_ShapeDef:		.ds 1	; During level loading, defines a shape of something (context-specific)

	Scroll_UpdAttrFlag:	.ds 1	; Set when it is time to update attributes

				.ds 2	; $0708-$0709 unused

	; Tileset values:
	; 00 = On map
	; 01 = Plains style; bushes, zigzag ground, blocks (includes blue-block bonus area)
	; 02 = Mini fortress style; gray blocks, lava (and king's room)
	; 03 = Hills style; green grass, bushes (works in desert like 2-2 also)
	; 04 = High-Up style; "cliffside" grass, swirly clouds, wooden block style ground
	; 05 = pipe world plant infestation
	; 06 = Water world
	; 07 = Toad House
	; 08 = Vertical pipe maze
	; 09 = desert level, sand, pyramids (and desert fortress)
	; 10 = Airship
	; 11 = Giant World
	; 12 = Ice level, frozen "1" style
	; 13 = Coin heaven / Sky level
	; 14 = Underground
	; 15 = Bonus game intro and N-Spade
	; 16 = Spade game sliders
	; 17 = N-Spade
	; 18 = 2P vs
	Level_Tileset:		.ds 1	; Different tilesets which changes the detection and meaning in levels

	Bonus_UnusedVH:			; VRAM High address ?? Seems to only be part of an unused routine
	ToadTalk_VH:		.ds 1	; Cinematic Toad & King / "Toad House" Toad VRAM Address High

	Bonus_UnusedVL:			; VRAM Low address ?? Seems to only be part of an unused routine
	ToadTalk_VL:		.ds 1	; Cinematic Toad & King / "Toad House" Toad VRAM Address Low

	BonusText_CPos:
	ToadTalk_CPos:		.ds 1	; Cinematic Toad & King / "Toad House" Toad Character Position

	BonusText_CharPause:	.ds 1	; Counter that decrements to zero between letters
	Bonus_UnusedFlag:	.ds 1	; Doesn't do much besides block an unused subroutine

	Map_Pan_Count:		.ds 1	; Map is panning, counts to zero (Scroll_LastDir sets which direction we're panning)

	; NOTE sharing
	CineKing_Timer2:		; Timer; decrements to zero
	Bonus_Timer:			; Decrements to zero
	Map_Intro_Tick:		.ds 1	; Counts down to zero while displaying the "World X" intro

				.ds 1	; $0712 unused

	Map_ReturnStatus:	.ds 1	; When 0, level panel is cleared; otherwise, Player is considered to have died (decrements life!)
	MaxPower_Tick:		.ds 1	; When Player has maximum "power" charge, this counts for the flashing [P]
	Player_Score:		.ds 3	; $0715 (H)-$0717 (L) treated as 3-byte integer, with least significant zero on display not part of this value 

				.ds 1	; $0718 unused

	; Each byte of PatTable_BankSel sets the VROM available at
	; 0000 (first half BG), 0800 (second half BG, typ animated), 
	; 1000 (1/4 sprites), 1400 (2/4 sprites), 1800 (3/4 sprites),
	; and 1C00 (4/4 sprites), respectively
	PatTable_BankSel:	.ds 6	; $0719-$071E  Provides an array of 6 pages to set the entire Pattern Table [BG_Full_CHRROM_Switch]
	PAGE_C000:		.ds 1	; Page to set PRG ROM C000 (PRGROM_Change_Both)
	PAGE_A000:		.ds 1	; Page to set PRG ROM A000 (PRGROM_Change_Both)
	PAGE_CMD:		.ds 1	; When using PRGROM_Change_Both2 or PRGROM_Change_A000, this value stores the MMC3 command
	Map_Prev_XOff:		.ds 2	; $0722-$0723 (Mario/Luigi) Stores previous scroll X offset on map
	Map_Prev_XHi:		.ds 2	; $0724-$0725 (Mario/Luigi) Stores previous "hi byte" of map X
	Player_Current:		.ds 1	; Which Player is currently up (0 = Mario, 1 = Luigi)
	World_Num:		.ds 1	; Current world index (0-8, where 0 = World 1, 7 = World 8, 8 = World 9 / Warp Zone)

	; NOTE: sharing
	World_EnterState:		; State variable during "world X" intro entrance, set to 3 when entering a level; overlaps GameOver_State
	CineKing_State:			; State of King-got-his-wand-back sequence
	GameOver_State:		.ds 1	; State variable used during "Gameover!" sequence only; overlaps World_EnterState

	Map_Operation:		.ds 1	; Map_Operation: Current "operation" happening on map (See Map_DoOperation in PRG010)

				.ds 1	; $072A unused

	Total_Players:		.ds 1	; Total players (0 = 1P, 1 = 2P)
	Map_Unused72C:		.ds 1	; No apparent use; only assigned to, but never read back
	Bonus_DDDD:		.ds 1	; ?? Set to '1' if you exit the unused bonus game BONUS_UNUSED_DDDD
	Map_HandState:		.ds 1	; Hand trap state

				.ds 1	; $072F unused

	Map_WW_Backup_Y:	.ds 1	; Warp Whistle wind backs up the Player's map Y

	Map_WW_Backup_XH:	.ds 1	; Warp Whistle wind backs up the Player's map X Hi byte
	Map_WW_Backup_X:	.ds 1	; Warp Whistle wind backs up the Player's map X
	Map_WW_Backup_UPV2:	.ds 1	; Warp Whistle wind backs up Map_UnusedPlayerVal2

				.ds 2	; $0734-$0735 unused

	Player_Lives:		.ds 2	; $0736-$0737 (Mario/Luigi) Player's lives
	Map_Unused738:		.ds 1	; Index used in some dead code in PRG011; sometimes index of unused array Map_Unused7DC6
	ClearPattern:		.ds 1	; Set by ClearPattern_ByTileset for use in Clear_Nametable_Short
	PalSel_Tile_Colors:	.ds 1	; Stores value to index which tile color set to use when palette loading routine is called
	PalSel_Obj_Colors:	.ds 1	; Stores value to index which object color set to use when palette loading routine is called
	Player_FallToKing:	.ds 2	; $073C-$073D (Mario/Luigi) Player will fall to king when Level_ExitToMap is nonzero (instead of map)
	Map_Player_SkidBack:	.ds 2	; $073E-$073F (Mario/Luigi) Set to '1' if Player died last turn or otherwise ejected (that is, they DID skid from their last turn, not necessarily currently skidding)

	Map_NSpadeMatches:	.ds 1	; Keeps count of N-Spade matches of active session (9 means game is done)
	Map_NSpadeInProg:	.ds 1	; If set, there's an N-Spade game "in progress" (so if you lose, you pick it up later)

	Map_Airship_Trav:	.ds 1	; Airship's current travel-table offset (randomly offset by 0-2, spices up life)

				.ds 2	; $0743-$0744 unused

	Map_DoFortressFX:	.ds 1	; Bust locks, build bridges, whatever after Mini-Fortress is toppled

	World_Map_Power:	.ds 2	; $0746-$0747 (Mario/Luigi) MAP Power up # (1 - big, 2 - Fire, 3 - Leaf, 4 - Frog, 5 - Tanooki, 6 - Hammer, 7 - Judgems, 8 - Pwing, 9 - Star)

				.ds 1	; $0748 unused

	Map_Unused749:		.ds 2	; $0749-$074A (Mario/Luigi) ? Another value just set once and never read back!

				.ds 1	; $074B unused

	Object_VelCarry:	.ds 1	; '1' when last Object Velocity fraction accumulation rolled over

	; WARNING: The distance between Player/Objects_XVelFrac and Player/Objects_YVelFrac must be same as Player/Objects_X/YVel!
	Player_XVelFrac:	.ds 1	; X velocity fractional accumulator
	Objects_XVelFrac:	.ds 8	; $074E-$0755 Other object's X velocity fractional accumulator

				.ds 1	; $0756 unused

	THouse_UnusedFlag:	.ds 1	; Cleared when Toad House gives you an item, but never used otherwise

				; WARNING: Though unused, this is required for the consistent padding between XVel(Frac) and YVel(Frac)
				; So use it if you want, but maintain the distance!!
				.ds 7	; $0758-$075E unused

	; WARNING: The distance between Player/Objects_XVelFrac and Player/Objects_YVelFrac must be same as Player/Objects_X/YVel!
	Player_YVelFrac:	.ds 1	; Y velocity fractional accumulator
	Objects_YVelFrac:	.ds 8	; $0760-$0767 Other object's Y velocity fractional accumulator

	Objects_ColorCycle:	.ds 8	; $0768-$076F Cycles colors of object and decrements to zero (e.g. "Melting" ice block, starman, etc.)

	; Objects_Var6: Special hardcoded behavior for the following objects ONLY:
	; OBJ_FIRECHOMP, OBJ_CHAINCHOMPFREE, OBJ_BLOOPERCHILDSHOOT, 
	; OBJ_BLOOPERWITHKIDS, or OBJ_FIRESNAKE
	; ... as the X/Y buffer slot they occupy (see Object_Delete)
	Objects_Var6:		.ds 5	; $0770-$0774 General purpose variable 6 (except as noted above)
	Objects_TargetingXVal:	.ds 5	; $0775-$0779 X velocity result of Object_CalcHomingVels for this object OR some other X pixel target

	King_Y:				; Y position (NOTE: shared with Objects_TargetingYVal)
	Objects_TargetingYVal:	.ds 5	; $077A-$077E Y velocity result of Object_CalcHomingVels for this object OR some other Y pixel target

	Pipe_TransYDelta:		; In-level transit pipe Y delta value (WARNING: Shared with Level_ScrollDiffV)
	Level_ScrollDiffV:	.ds 1	; Difference between desired vertical and the current Vert_Scroll (WARNING: Shared with Pipe_TransYDelta)
	Level_ScrollDiffH:	.ds 1	; Difference between desired horizontal and the current Horz_Scroll

	Random_Pool:		.ds 10	; $0781-$078A (or $0789?) Data pool for pseudo-random number generator algorithm
RandomN = Random_Pool+1			; Pull a random number from the sequence (NOTE: RandomN+1 is also good; If you need multiple random numbers, call Randomize)

	Map_PlayerLost2PVs:	.ds 1	; When > 0, (1=Mario, 2=Luigi) doesn't lose a life for "death" exiting to map, but does lose their turn

				.ds 1	; $078C unused

	Player_RescuePrincess:	.ds 1	; Player will jump to the princess rescue when Level_ExitToMap is nonzero (instead of map)

				.ds 8	; $078E-$0795 unused

	; Objects_PlayerHitStat:
	;	Bit 0 - Set if Player's bbox bottom is HIGHER than object's bbox bottom
	;	Bit 1 - Set if Player's bbox left edge is to the LEFT of object's bbox left edge
	;	Bit 4 - Set if Player tail attacked an object
	Objects_PlayerHitStat:	.ds 8	; $0796-$079D Player hit status

	; Up to five "scores" can be displayed at once
	Scores_Value:		.ds 5	; $079E-$07A2 score "value"; '0' none, (10, 20, 40, 80, 100, 200, 400, 800, 1000, 2000, 4000, 8000, 1-up)
	Scores_Counter:		.ds 5	; $07A3-$07A7 "counter" until score disappears
	Scores_Y:		.ds 5	; $07A8-$07AC Score's Y
	Scores_X:		.ds 5	; $07AD-$07B1 Score's X

	LRBounce_Y:		.ds 1	; Left/right bouncer as sprite Y ($FF is disabled)
	LRBounce_X:		.ds 1	; Left/right bouncer as sprite X
	LRBounce_Vel:		.ds 1	; Left/right bouncer absolute value of X velocity

	; NOTE!! These object vars are OBJECT SLOT 0 - 4 ONLY!
	Objects_Slope:		.ds 5	; $07B5-$07B9 Absolute slope calc value

				.ds 1	; $07BA unused

	World3_Bridge:		.ds 1	; 0 - Bridges are down, 1 - Bridges are up

	ArrowPlat_IsActive:	.ds 1	; Set if arrow platform is active

	Level_GetWandState:	.ds 1	; See Koopaling code in PRG001

; ********************************************************************************
; The Palette_* vars here form a graphics buffer to be committed in the
; style of the Video_Upd_Table; see "Video_Upd_Table" in PRG030 for format.
	Video_DoPalUpd:			; Name consistent with Video_Upd_Table 
	Palette_AddrHi:		.ds 1	; Stores high part of palette address when committing palettes
	Palette_AddrLo:		.ds 1	; Stores low part of palette address when committing palettes
	Palette_BufCnt:		.ds 1	; 32 for updating entire palette
	Palette_Buffer:		.ds 32	; $07C1-$07E0 Buffer of palette bytes to commit, used for fade in/out
	Palette_Term:		.ds 1	; Set to zero as terminator, per requirement of the Video_Upd_Table format
; ********************************************************************************

; BigQBlock_GotIt: 
;	Big ? Blocks can only be retrieved once; this is a bitfield that marks which
;	ones you've gotten by setting a bit per screen space in the Big ? Block area.
;	Basically, if you reenter a Big ? Block area after opening it, it won't reappear!
;	See ObjInit_BigQBlock and ObjNorm_BigQBlock for usage...
;	NOTE: This is cleared completely upon Player death which works since levels
;	are not re-enterable, but still seems a bit extreme...
	BigQBlock_GotIt:	.ds 1

				.ds 13	; $07E3-$07EF unused

	DMC_Queue:		.ds 1	; Stores value to play on DMC
	DMC_Current:		.ds 1	; Currently playing DMC sound

	Sound_Sq1_CurFL:	.ds 1	; Holds current "low" frequency of Square Wave 1 (Warning: Must be +4 to Sound_Sq2_CurFL, see PRG031_E808)

	Music_NseStart:		.ds 1	; Holds the starting offset of the noise track (CHECK: Reuse of $07F3, is this bad??)

				.ds 1	; $07F4 unused, but required for padding

	Music2_Hold:		.ds 1	; A very little used feature, Music Set 1 overrides Music Set 2, but after a M1 song finishes, it restarts the M2 song
	Sound_Sq2_CurFL:	.ds 1	; Holds current "low" frequency of Square Wave 1 (Warning: Must be +4 from Sound_Sq1_CurFL, see PRG031_E808)

	Music_Sq2Patch:		.ds 1	; Current "instrument patch" for Square 2 (only upper 4 bits stored, 0ppp 0000)
	Music_Sq1Patch:		.ds 1	; Current "instrument patch" for Square 1 (only upper 4 bits stored, 0ppp 0000)

				.ds 1	; $07F9 unused

	Sound_Map_L2Hld:	.ds 1	; Same as Sound_Map_LHold, used for the secondary track (Warning: Will be affected by triangle, see PRG031_E808)
	Sound_Map_Len2:		.ds 1	; Same as Sound_Map_Len, used for the secondary track
	Sound_Map_LHold:	.ds 1	; Current length setting, used as delay after each byte of map sound (changed by special bytes in range $80-$FF)
	Sound_Map_Len:		.ds 1	; Countdown tick for current note/rest that map sound effect is on
	Sound_Map_Off2:		.ds 1	; Same as Sound_Map_Off, used for the secondary track
	Sound_Unused7FF:	.ds 1	; Cleared once, never used otherwise

	; ASSEMBLER BOUNDARY CHECK, END OF $0800
.Bound_0800:	BoundCheck .Bound_0800, $0800, $07xx RAM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $68xx SRAM for 2P Vs ONLY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; NOTE: $6000-$67FF is still in considered tile grid memory (see next section)
; 2P Vs just utilizes a chunk where no tiles will ever exist in 2P Mode

; 2P Vs Only
	.data
	.org $6800

	Vs_MemStart:			; Should be at "top"; this point and 512 bytes forward are cleared at start of 2P Vs

	; Vs_PlayerFrame
	; 0/1: Standing (0) / walking (0/1) / falling-not-jumped (1) frames
	; 2: Skidding turnaround
	; 3: Jumping/Falling-jumped
	; 4: Dizzy
	; 5: Kicking
	; 6: Dying
	; 7: Climbing
	Vs_PlayerFrame:		.ds 2	; $6800-$6801 Mario/Luigi Frame
	Vs_PlayerState:		.ds 2	; $6802-$6803 Mario/Luigi State (0=Init, 1=Normal, 2=Dying, 3=Ladder climbing)
	Vs_ObjectState:		.ds 12	; $6804-$680F Objects State (0=Dead/empty, 1=Normal, 2=Flipped over, 3=Dying)

				.ds 1	; $6810 unused

	Vs_PlayerBlkHitCnt:	.ds 2	; $6811-$6812 Mario/Luigi Hit block counter value
	Vs_PlayerY:		.ds 2	; $6813-$6814 Mario/Luigi Y
	Vs_ObjectsY:		.ds 12	; $6815-$6820 Objects Y

				.ds 1	; $6821 unused

	Vs_PlayerBlkHitY:	.ds 2	; $6822-$6823 Mario/Luigi Aligned Y position where block was hit
	Vs_PlayerX:		.ds 2	; $6824-$6825 Mario/Luigi X
	Vs_ObjectsX:		.ds 12	; $6826-$6831 Objects X

				.ds 1	; $6832 unused

	Vs_PlayerBlkHitX:	.ds 2	; $6833-$6834 Mario/Luigi Aligned Y position where block was hit
	Vs_PlayerYVel:		.ds 2	; $6835-$6836 Mario/Luigi Y Velocity
	Vs_ObjectYVel:		.ds 12	; $6837-$6842 Objects Y Velocity

				.ds 1	; $6843 unused

	Vs_PlayerBlkHitYVel:	.ds 2	; $6844-$6845 Mario/Luigi Hit block Y velocity
	Vs_PlayerXVel:		.ds 2	; $6846-$6847 Mario/Luigi X Velocity
	Vs_ObjectXVel:		.ds 12	; $6848-$6853 Objects X Velocity

				.ds 3	; $6854-$6856 unused

	Vs_PlayerClimbFrame:	.ds 2	; $6857-$6858 incremented as Player climbs
	Vs_ObjectAnimCnt:	.ds 12	; $6859-$6864 A continuous counter per object for animating (typically 2 frames)

				.ds 1	; $6865 unused

	Vs_PlayerDir:		.ds 2	; $6866-$6867 Mario/Luigi direction (1=Right, 2=Left)
	Vs_ObjectDir:		.ds 12	; $6868-$6873 Objects direction (1=Right, 2=Left)

				.ds 1	; $6874 unused

	Vs_PlayerYVelFrac:	.ds 2	; $6875-$6876 Mario/Luigi Y velocity fractional accumulator
	Vs_ObjectYVelFrac:	.ds 12	; $6877-$6882

				.ds 3	; $6883-$6885 unused

	Vs_PlayerXVelFrac:	.ds 2	; $6886-$6887 Mario/Luigi X velocity fractional accumulator
	Vs_ObjectXVelFrac:	.ds 12	; $6888-$6893

				.ds 3	; $6894-$6896 unused

	Vs_PlayerDetStat:	.ds 2	; $6897-$6898 Mario/Luigi detection status
	Vs_ObjectDetStat:	.ds 12	; $6899-$68A4 Objects detection status

				.ds 3	; $68A5-$68A7 unused

	Vs_ObjectVar1:		.ds 12	; $68A8-$68B3 General variable 1

				.ds 1	; $68B4 unused

	Vs_PlayerKick:		.ds 2	; $68B5-$68B6 Mario/Luigi Player is kicking until decrements to zero
	Vs_PlayerDizzy:		.ds 2	; $68B7-$68B8 Mario/Luigi Player "dizzy" face until decrements to zero
	Vs_PlayerStick:		.ds 2	; $68B9-$68BA Mario/Luigi Mario/Luigi Player "sticking" to ceiling; decrements to zero
	Vs_PlayerBumpTimer:	.ds 1	; Mario/Luigi Players bumped off eachother (and can't again until zero); decrements to zero
	Vs_POWBlockCnt:		.ds 1	; POW block counter; decrements to zero; until then, POW shaking!

	; 2P Vs Object IDs
VSOBJID_SPINY		= 0	; Spiny
VSOBJID_SIDESTEPPER	= 2	; Sidestepper
VSOBJID_FIGHTERFLY	= 3	; Fighter Fly
VSOBJID_FIREBALL_HORZ	= 4	; Horizontal Fireball that spawns to keep Players from hiding down at the bottom
VSOBJID_FIREBALL_ENDER	= 5	; Game Ender Fireball (bounces around, attempts to kill Players who've stuck around too long!)
VSOBJID_FIREBALL_FOUNTAIN= 6	; Fountain Fireball
VSOBJID_COIN		= 7	; Coin (from [?] block)
VSOBJID_MUSHROOMCARD	= 8	; Mushroom card
VSOBJID_FLOWERCARD	= 9	; Flower card
VSOBJID_STARCARD	= 10	; Star card
VSOBJID_KICKEDBLOCK	= 11	; Kicked block (from [?] block match)
	Vs_ObjectId:		.ds 12	; $68BD-$68C8 Objects ID

				.ds 1	; $68C9 unused

	Vs_ObjectSprRAMOff:	.ds 1	; Current object Sprite RAM offset
	Vs_ObjectSprRAMSel:	.ds 1	; Counter that runs $D to $0 (inclusive) and helps distribute Sprite RAM offsets among the objects
	Vs_EnemyCount:		.ds 1	; Number of spawned enemies (in the typical game)
	Vs_PlayerHaltTimer:	.ds 2	; $68CD-$68CE Mario/Luigi timer which halts gameplay; decrements to zero
	Vs_ObjHaltTimer:	.ds 12	; $68CF-$68DA Object timer which halts object when greater than zero; decrements to zero

				.ds 1	; $68DB unused

	Vs_ObjectTimer3:	.ds 12	; $68DC-$68E7

				.ds 1	; $68E8 unused

	Vs_PlayerCnt:		.ds 2	; $68E9-$68EA Mario/Luigi "counter" value; decrements to zero
	Vs_EnemyGetUpTimer:	.ds 12	; $68EB-$68F6 Timer for flipped-over enemy; decrements to zero

				.ds 1	; $68F7 unused

	Vs_PlayerJumped:	.ds 2	; $68F8-$68F9 Set to 1 if Player jumped; prevents Player from jumping again until they hit floor
	Vs_PlayerTileL:		.ds 2	; $68FA-$68FB Mario/Luigi Tile detected at Player's feet
	Vs_ObjectTileL:		.ds 12	; $68FC-$6907

				.ds 2	; $6908-$6909 unused

	Vs_PlayerBlkHit:	.ds 2	; $690A-$690B Mario/Luigi Holds Tile_Mem offset to bounce block they hit
	Vs_PlayerFlashInv:	.ds 2	; $690C-$690D Mario/Luigi Flashing invicibility (?)
	Vs_SpawnCnt2:		.ds 1	; FIXME describe better
	Vs_TooLongCnt:		.ds 1	; Increments after each round of spawning; if it overflows, "game ender" fireballs are spawned 
	Vs_CurIndex:		.ds 1	; Current index (Player or object)
	Vs_PlayerTileU:		.ds 2	; $6911-$6912 Mario/Luigi Tile detected above Player's feet

				.ds 13	; $6913-$691F unused

	Vs_ObjectPipeTimer:	.ds 12	; $6920-$692B Timer used for enemies to exit and emerge from pipes; decrements to zero

				.ds 1	; $692C unused

	Vs_Random:		.ds 3	; $692D-$692F Random generator for 2P Vs mode
	Vs_PlayerCoins:		.ds 2	; $6930-$6931 Player's coins (in 2P Vs); 5 wins the match
	Vs_TimeToExit:		.ds 1	; Decrements to zero then exits the 2P Vs
	Vs_ObjectIsLast:	.ds 12	; $6933-$693E Set if this is the last object (turns blue, move fast)

				.ds 1	; $693F unused

	Vs_POWHits:		.ds 1	; Number of times POW block has been hit (disabled on 3)
	Vs_PlayerYOff:		.ds 2	; $6941-$6942 Mario/Luigi Y offset applied
	Vs_UNKGAMECnt:		.ds 1	; Unknown "game" counter; after overflow, we exit
	Vs_PlayerYHi:		.ds 2	; $6944-$6945 Mario/Luigi Y Hi
	Vs_ObjectYHi:		.ds 12	; $6946-$6951 Object Y Hi

				.ds 3	; $6952-$6954 unused
	Vs_ObjectIsAngry:	.ds 12	; $6955-$6960 Set when Sidestepper is angry (not used for anything else)

				.ds 1	; $6961 unused

	Vs_AngrySidesteppers:	.ds 1	; When greater than zero, and spawning a Sidestepper, next one is an "angry" Sidestepper (then decrement)

				.ds 1	; $6963 unused

	Vs_ObjectVDir:		.ds 12	; $6964-$696F Objects vertical direction (4=Down, 8=Up)

				.ds 1	; $6970

	Vs_ObjectRestoreXVel:	.ds 12	; $6971-$697C Flipped over object restore X velocity

				.ds 1	; $697D unused

	Vs_ObjTimer2:		.ds 12	; $697E-$6989 Object timer; decrements to zero

				.ds 1	; $698A unused

	Vs_CardFlash:		.ds 2	; $698B-$698C Mario/Luigi Cycles color for card (when picked up from another Player)
	Vs_HaltTimerBackup:	.ds 15	; $698D-$699B Backs up all halt timers
	Vs_EnemySet:		.ds 1	; Specifies an index of active enemy set, selecting one of the quintuples from Vs_5EnemySets
	Vs_ObjectXOff:		.ds 1	; A one-shot X offset for display of object FIXME: When?
	Vs_PlayerWalkCnt:	.ds 2	; $699E-$699F Mario/Luigi counts up and overflows to toggle walk frames
	Vs_PlayerWalkFrame:	.ds 2	; $69A0-$69A1 Mario/Luigi incremented when Vs_PlayerWalkCnt overflows
	Vs_NextObjectIsLast:	.ds 1	; If there are 5 enemies and this is set, next enemy out is the "last" (turns blue, moves fast)

	; Display of "x Up" after getting 3 cards
	Vs_xUpCnt:		.ds 2	; $69A3-$69A4 Mario/Luigi "x Up" counter
	Vs_xUpY:		.ds 2	; $69A5-$69A6 Mario/Luigi "x Up" Y pos
	Vs_xUpX:		.ds 2	; $69A7-$69A8 Mario/Luigi "x Up" X pos
	Vs_xUpLives:		.ds 2	; $69A9-$69AA Mario/Luigi "x Up" Lives amount (1, 2, 3, 5)
	Vs_SpawnCnt:		.ds 1	; Spawn counter; increments and triggers spawning

	; ASSEMBLER BOUNDARY CHECK, 2P VS END OF $7950
.Bound_7950:	BoundCheck .Bound_7950, $7950, 2P VS RAM


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $6000-$7FFF MMC3 SRAM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.org $6000

	; NOTE: $6800+ is used by 2P Vs RAM, see previous section

	; Tile_Mem stores for the greatest case:
	;	Vertical level max size is 	15 rows * 16 columns * 16 screens = 3840 ($0F00) bytes
	;	Non-vertical level max size is 	27 rows * 16 columns * 15 screens = 6480 ($1950) bytes
Tile_Mem:	.ds 6480	; $6000-$794F Space used to store the 16x16 "tiles" that make up the World Map or Level

	Map_MoveRepeat:		.ds 2	; $7950-$7951 (Mario/Luigi) counts up to $18 and then you keep moving without pause
	AScrlURDiag_OffsetX:	.ds 1	; When diagonal autoscroller is wrapping, this holds an X offset for Player/Objects to temporarily correct
	AScrlURDiag_OffsetY:	.ds 1	; When diagonal autoscroller is wrapping, this holds an Y offset for Player/Objects to temporarily correct
	StatusBar_UpdFl:	.ds 1	; Status bar Update Flag; toggles so to update status bar only every other frame
	UpdSel_Disable:		.ds 1	; When set, disables the Update_Select routine during the NMI, which halts most activity due to no reported V-Blanking
	Map_Objects_Itm:	.ds 13	; $7956-$795D, "Item given by" map objects

	; Item that will be given by treasure box; set by the object OBJ_TREASURESET by its row
	; Level_TreasureItem:
	; 0 = INVALID
	; 1 = Mushroom
	; 2 = Flower
	; 3 = Leaf
	; 4 = Frog
	; 5 = Tanooki
	; 6 = Hammer
	; 7 = Judgem's cloud
	; 8 = P-Wing
	; 9 = Star
	; A = Anchor
	; B = Hammer
	; C = Warp Whistle
	; D = Music Box
	Level_TreasureItem:	.ds 1
	Reset_Latch:		.ds 1	; If this value is anything besides $5A, the reset is run (I assume this is considered a safe value in case of data corruption, e.g. from runaway generator)
	Map_BonusType:		.ds 1	; 0 = No bonus, 1 = White Toad House, 2 = UNKNOWN WHITE THING (MAPOBJ_UNK0C)
	Map_BonusCoinsReqd:	.ds 1	; Number of coins you need for White Toad House (or the MAPOBJ_UNK0C thing!); value ranges 0-127
	Coins_ThisLevel:	.ds 1	; Internal counter of coins earned -this level- (so always starts at 0 and increments)

	Map_NSpade_NextScore:	.ds 3	; $7968 (H)-$796A (L) treated as 3-byte integer

	Map_BonusAppY:		.ds 1	; Map "white" bonus appearance Y (set to Player's last "succeeded" map position)
	Map_BonusAppXHi:	.ds 1	; Map "white" bonus appearance XHi (set to Player's last "succeeded" map position)
	Map_BonusAppX:		.ds 1	; Map "white" bonus appearance X (set to Player's last "succeeded" map position)

	Map_NoLoseTurn:		.ds 1	; If set, Player does not lose turn after having completed a level (used for Toad House, pipeways, etc.)
	Map_Got13Warp:		.ds 1	; Set non-zero if Player already got the 1-3 Warp Whistle
	Map_Anchored:		.ds 1	; Set if anchor is set on this map
	Map_WhiteHouse:		.ds 1	; Set if you have already earned the White Toad House for this world
	Map_CoinShip:		.ds 1	; Set if you have already earned the Coin Ship for this world
	Map_WasInPipeway:	.ds 1	; Set if you just came out of a pipeway
	EndCard_Flag:		.ds 1	; Set when End Level card is hit (can determine when level has ended)
	Map_PlyrSprOvrY:	.ds 1	; "Player Sprite Override Y"; If set to $F8 during warp, erases Player's map sprite; otherwise provides a Y to put it at
	Map_Entered_Y:		.ds 2	; $7976-$7977 (Mario/Luigi) Stores the Y value when you enter a level; this is the Y used if you complete the level
	Map_Entered_XHi:	.ds 2	; $7978-$7979 (Mario/Luigi) Hi byte for Map_Entered_X
	Map_Entered_X:		.ds 2	; $797A-$797B (Mario/Luigi) Same as Map_Entered_Y, only for X
	Map_Previous_UnusedPVal2:.ds 2	; $797C-$797D (Mario/Luigi) Backup of Map_UnusedPlayerVal2
	Map_Previous_Y:		.ds 2	; $797E-$797F (Mario/Luigi) Stores the previous Y you were "safe" at; this is the Y you go back to if you die
	Map_Previous_XHi:	.ds 2	; $7980-$7981 (Mario/Luigi) Same as Map_Previous_Y, only for XHi
	Map_Previous_X:		.ds 2	; $7982-$7983 (Mario/Luigi) Same as Map_Previous_Y, only for X
	Map_Unused7984:		.ds 2	; $7984-$7985 (Mario/Luigi) Unused; cleared and never touched again
	Map_Prev_XOff2:		.ds 2	; $7986-$7987 (Mario/Luigi) Holds a copy of Map_Prev_XOff, but I'm not sure why?
	Map_Prev_XHi2:		.ds 2	; $7988-$7989 (Mario/Luigi) Holds a copy of Map_Prev_XHi, but I'm not sure why?
	Map_Unused798A:		.ds 2	; $798A-$798B (Mario/Luigi) Unused; cleared and never touched again

	; These define values to use when you junction back
	; to the level you were before...
	Level_Jct_HSHi:		.ds 1	; Level junction horizontal scroll high value
	Level_Jct_HS:		.ds 1	; Level junction horizontal scroll value
	Level_Jct_VSHi:		.ds 1	; Level junction vertical scroll high value
	Level_Jct_VS:		.ds 1	; Level junction vertical scroll value

				.ds 2	; $7990-7991 unused

	Map_Unused7992:			; Value used in some dead code in PRG011; cleared elsewhere (NOT SURE if maybe it sometimes meant Bonus_DiePos?)
	Bonus_DiePos:		.ds 1	; UNUSED Die in the lost bonus games, counts 0-5

	Map_Previous_Dir:	.ds 2	; $7993-$7994 (Mario/Luigi) Backup movement dir (remember which way Player moved last) (8=Up, 4=Down, 2=Left, 1=Right)

	Map_Unused7995:		.ds 1	; Unused; cleared but never used otherwise

	Player_NoSlopeStick:	.ds 1	; If set, Player does not stick to slopes (noticeable running downhill)

				.ds 105	; $7997-$79FF unused
	; Auto scroll effect variables -- everything to do with screens that aren't scrolling in the normal way
	; NOTE: Post-airship cinematic scene with Toad and King ONLY uses $7A01-$7A11 MMC3 SRAM (from Level_AScrlSelect to Level_AScrlHVelCarry)

	AScroll_Anchor:		.ds 1	; Used as starting point for $7A00-$7A14 clear, but never actually used in Auto-Scroll

	Level_AScrlSelect:	.ds 1	; Selects auto scroll routine to use (see PRG009_B922)

	; Values used in horizontal scrolling (Level_AScrlSelect = 0/1) only:
	; $00: World 3-6 / 1-4
	; $01: World 3 Airship
	; $02: World 6-2
	; $03: World 5 Airship
	; $04: World 2 Airship
	; $05: World 4 Airship
	; $06: World 6 Airship
	; $07: World 5-6
	; $0A: World 6-7
	; $0B: World 1 Airship
	; $0C: World 7 Airship
	; $0D: World 8 Airship
	; $0E: World 8 Battleship
	; $0F: World 7-4
	; $10: World 1 Coin Heaven
	; $11: Coin Ship
	; $13: World 8 Tank 1
	; $14: World 8 Tank 2
	Level_AScrlLimitSel:	.ds 1	; "Limit Selector" for the auto scroll (typically selects an end or a start/end pair, depending on style)

	; Level_AScrlVar
	; Variable used for different things depending on the auto scroll style
	; In horizontal scroll style (Level_AScrlSelect = 0), it's the current "movement" (see table AScroll_Movement)
	Level_AScrlVar:		.ds 1

	Level_AScrlLoopSel:	.ds 1	; Currently selected "movement loop" (horizontal only, see AScroll_MovementLoopStart; Just a var in others?)
	Level_AScrlMoveRepeat:	.ds 1	; Repeat current move until zero (decrements each full expiration of Level_AScrlMoveTicks); $FF when on last move, passes control to movement loop
	Level_AScrlLoopCurMove:	.ds 1	; Current "movement loop" index (into AScroll_MovementLoop)
	Level_AScrlSclLastDir:	.ds 1	; Auto scroll "Scroll_LastDir" 
	Level_AScrlMoveTicks:	.ds 1	; Counts down to zero, decrements Level_AScrlMoveRepeat (goes to next "movement")
	Level_AScrlTimer:	.ds 1	; Auto scroll counter, decrements to zero
	Level_AScrlPosHHi:	.ds 1	; Raster effect horizontal "high" position

				.ds 1	; $7A0B

	Level_AScrlPosH:	.ds 1	; Raster effect horizontal position
	Level_AScrlPosV:	.ds 1	; Raster effect vertical position
	Level_AScrlHVel:	.ds 1	; Auto scroll horizontal "velocity"
	Level_AScrlVVel:	.ds 1	; Auto scroll vertical "velocity"
	Level_AScrlHVelFrac:	.ds 1	; Auto scroll horizontal velocity fractional accumulator 
	Level_AScrlVVelFrac:	.ds 1	; Auto scroll vertical velocity fractional accumulator 
	Level_AScrlHVelCarry:	.ds 1	; '1' when last auto scroll H Velocity fraction accumulation rolled over
	Level_AScrlVVelCarry:	.ds 1	; '1' when last auto scroll V Velocity fraction accumulation rolled over
	World8Tank_OnTank:	.ds 1	; Set when Player is standing on tank surface in Tank level (as opposed to ground); for the illusion the tank is moving through...
;;;;;;;;;;;;


; "Cannon Fire" are sort of objects that exist to repeatedly fire off cannon balls
; or other such armaments.  They are created by 

CFIRE_BULLETBILL	= $01	; Bullet Bill cannon
CFIRE_MISSILEBILL	= $02	; Missile Bill (homing Bullet Bill)
CFIRE_ROCKYWRENCH	= $03	; (Re-)Creates Rocky Wrench on timer
CFIRE_4WAY		= $04	; 4-way cannon
CFIRE_GOOMBAPIPE_L	= $05	; Goomba pipe (left output)
CFIRE_GOOMBAPIPE_R	= $06	; Goomba pipe (right output)
CFIRE_HLCANNON		= $07	; Fires cannonballs horizontally left
CFIRE_HLBIGCANNON	= $08	; Fires BIG cannonballs horizontally left
CFIRE_ULCANNON		= $09	; Fires cannonballs diagonally, upper left
CFIRE_URCANNON		= $0A	; Fires cannonballs diagonally, upper right
CFIRE_LLCANNON		= $0B	; Fires cannonballs diagonally, lower left
CFIRE_LRCANNON		= $0C	; Fires cannonballs diagonally, lower right
CFIRE_HLCANNON2		= $0D	; ?? Same as CFIRE_HLCANNON?
CFIRE_ULCANNON2		= $0E	; ?? Same as CFIRE_ULCANNON?
CFIRE_URCANNON2		= $0F	; ?? Same as CFIRE_URCANNON?
CFIRE_LLCANNON2		= $10	; ?? Same as CFIRE_LLCANNON?
CFIRE_HRCANNON		= $11	; Fires cannonballs horizontally right
CFIRE_HRBIGCANNON	= $12	; Fires BIG cannonballs horizontally right
CFIRE_LBOBOMBS		= $13	; Launches fused Bob-ombs to the left
CFIRE_RBOBOMBS		= $14	; Launches fused Bob-ombs to the right
CFIRE_LASER		= $15	; Laser fire

	CannonFire_ID:		.ds 8	; $7A15-$7A1C ID of the cannon fire
	CannonFire_YHi:		.ds 8	; $7A1D-$7A24 Cannon fire Y Hi
	CannonFire_Y:		.ds 8	; $7A25-$7A2C Cannon fire Y
	CannonFire_XHi:		.ds 8	; $7A2D-$7A34 Cannon fire X Hi
	CannonFire_X:		.ds 8	; $7A35-$7A3C Cannon fire X
	CannonFire_Parent:	.ds 8	; $7A3D-$7A44 Tie back to level object index of "parent" object

	Splash_DisTimer:	.ds 1	; Player water splashes are disabled until decrements to zero; set when Player hits any bounce block

	; For that little "flash" that comes from the shell kill impact!
	ShellKillFlash_Cnt:	.ds 1	; "Shell Kill Flash" counter
	ShellKillFlash_Y:	.ds 1	; "Shell Kill Flash" Y
	ShellKillFlash_X:	.ds 1	; "Shell Kill Flash" X

; NOTE!! Objects_DisPatChng for OBJECT SLOT 0 - 5 ONLY!
	Objects_DisPatChng:	.ds 6	; $7A49-$7A4E If set, this object no longer enforces a pattern bank change

; NOTE!! These object vars are OBJECT SLOT 0 - 5 ONLY!
	ObjSplash_DisTimer:	.ds 6	; $7A4F-$7A54 Object water/lava splashes are disabled until decrements to zero

	PlayerProj_XVelFrac:	.ds 2	; $7A55-$7A56 Player Projectile X velocity fractional accumulator

	CannonFire_Timer2:	.ds 8	; $7A57-$7A5E Cannon Fire timer (decrements to zero)

	Roulette_Unused7A5F:	.ds 1	; Unused value in Roulette game
	Roulette_Unused7A5F_Delta:.ds 1	; Delta value added to Roulette_Unused7A5F

	Bowser_Tiles:		.ds 2	; $7A61-$7A62 Bowser's detected tiles (to determine what to break)
	Bowser_Counter1:	.ds 1	; A counter used by Bowser, decrements to zero
	Bowser_Counter2:	.ds 1	; A counter used by Bowser, decrements to zero 
	Bowser_Counter3:	.ds 1	; A counter used by Bowser, random setting, decrements to zero

	CoinShip_CoinGlowIdx:	.ds 1	; Coin Ship only: Glowing coins palette color index
	CoinShip_CoinGlowCnt:	.ds 1	; Coin Ship only: Glowing coins palette color counter

	SObjBlooperKid_OutOfWater:.ds 8	; $7A68-$7A6F Blooper kid only; if set, Blooper Kid is trying to go out of water

				.ds 2	; $7A70-$7A71 unused

	Object_SplashAlt:	.ds 1	; Used to alternate the "splash slots" 1 and 2 as objects hit the water

				.ds 109	; $7A73-$7ADF unused

	Music_Start:		.ds 1	; Music start index (beginning of this song)
	Music_End:		.ds 1	; Music end index (inclusive last index to play before loop)
	Music_Loop:		.ds 1	; Music loop index (index to start from when song reaches end)

	Sound_Octave:		.ds 1	; Used for calculating octave

				.ds 12	; $7AE4-$7AEF unused

	Music_Sq1Bend:		.ds 1	; Alters PAPU_FT1 for bend effects

				.ds 3	; $7AF1-$7AF3 unused

	Music_Sq2Bend:		.ds 1	; Alters PAPU_FT2 for bend effects

				.ds 2	; $7AF5-$7AF6 unused

	Music_RestH_Off:	.ds 1	; Offset added to Music_RestH_Base; typically $00 or $10 (for low time warning on compatible songs)

				.ds 7	; $7AF8-$7AFE unused

	PAPU_MODCTL_Copy:	.ds 1	; Current PAPU_MODCTL register

	Level_ObjIdxStartByScreen:.ds 16	; $7B00-$7B0F Defines the starting index into Level_Objects for each "screen"

	Level_ObjectsSpawned:	.ds 48	; $7B10-$7B3F When $80 set, object is already spawned, $00 means not

; Level_ObjPtr_AddrL is an array that defines the level objects to appear
; The first byte copied in has no apparent purpose
; The rest is a repeating series of 3 bytes -- ID, Column, Row (C/R of tile grid, multiply by 16 for pixel location), $FF for terminator
	Level_Objects:		.ds 48*3	; $7B40-$7BCF

				.ds 80	; $7BD0-$7C1F unused

; For certain objects that require a buffer of X or Y values; only a couple are available.
; Each contains 32 bytes, intended for enemies that have "tails"; Buffer_Occupied determines
; which of the two buffers is free, if any at all.  The object will hold onto it then.
; Because of this, objects which employ it must also be hardcoded to release it; see
; "Object_Delete" for the hardcoded list of objects which must release this resource...
	Object_BufferX:		.ds 32*2	; $7C20-$7C3F / $7C40-$7C5F
	Object_BufferY:		.ds 32*2	; $7C60-$7C7F / $7C80-$7C9F

; Variables used by Chain Chomps ONLY -- manages the chain links 
	ChainChomp_ChainX1:	.ds 5	; $7CA0-$7CA4 Chain Link 1 X
	ChainChomp_ChainX2:	.ds 5	; $7CA5-$7CA9 Chain Link 2 X
	ChainChomp_ChainX3:	.ds 5	; $7CAA-$7CAE Chain Link 3 X
	ChainChomp_ChainX4:	.ds 5	; $7CAF-$7CB4 Chain Link 4 X

	ChainChomp_ChainY1:	.ds 5	; $7CB4-$7CB8 Chain Link 1 Y
	ChainChomp_ChainY2:	.ds 5	; $7CB9-$7CBD Chain Link 2 Y
	ChainChomp_ChainY3:	.ds 5	; $7CBE-$7CC2 Chain Link 3 Y
	ChainChomp_ChainY4:	.ds 5	; $7CC3-$7CC8 Chain Link 4 Y

; NOTE!! These object vars are OBJECT SLOT 0 - 4 ONLY!
	Objects_Var10:		.ds 5	; $7CC8-$7CCC Generic object variable 10
	Objects_Var11:		.ds 5	; $7CCD-$7CD1 Generic object variable 11
	Objects_Var12:		.ds 5	; $7CD2-$7CD6 Generic object variable 12
	Objects_Var13:		.ds 5	; $7CD7-$7CDB Generic object variable 13
	Objects_Var14:		.ds 5	; $7CDC-$7CE0 Generic object variable 14

; Player's hammer/fireball
	PlayerProj_ID:		.ds 2	; $7CE1-$7CE2 Player projectile ID (0 = not in use, 1 = fireball, 2 = hammer, 3+ = Fireball impact "Poof")
	PlayerProj_Y:		.ds 2	; $7CE3-$7CE4 Player projectile Y
	PlayerProj_X:		.ds 2	; $7CE5-$7CE6 Player projectile X
	PlayerProj_YVel:	.ds 2	; $7CE7-$7CE8 Player projectile Y Velocity (NOTE: Integer, not 4.4FP)
	PlayerProj_XVel:	.ds 2	; $7CE9-$7CEA Player projectile X Velocity (NOTE: Fireball is integer, 4.4FP for hammer ONLY)
	Fireball_HitChkPass:	.ds 2	; $7CEB-$7CEC Count of times Player's fireball has gone through hit check; when it hits 2, fireball poofs
	PlayerProj_Cnt:		.ds 2	; $7CED-$7CEE Player projectile counter

	Temp_VarNP0:		.ds 1	; A temporary not on page 0

	Lakitu_Active:		.ds 1	; Set while a Lakitu is active; keeps Lakitu "alive" even if off-screen etc.

	LevelEvent_Cnt:		.ds 1	; General purpose counter used by a couple LevelEvents
	Vert_Scroll_Off:	.ds 1	; Vertical scroll offset, used for "vibration" effects
	Level_Vibration:	.ds 1	; While greater than zero, screen vibrates (from impact of heavy fellow)
	Player_VibeDisable:	.ds 1	; While greater than zero, Player is unable to move (from impact of heavy fellow)
	Player_TwisterSpin:	.ds 1	; While greater than zero, Player is twirling from sand twister

; NOTE!! This object var is OBJECT SLOT 0 - 4 ONLY!
	Objects_HitCount:	.ds 5	; $7CF6-$7CFA Somewhat uncommon "HP" used generally for bosses only (e.g. they take so many fireballs)


	RotatingColor_Cnt:	.ds 1	; When non-zero, causes rainbow palettes in the background; $80 bit is used by Koopaling wand grab

; Some variables used by the recovered magic wand
	Wand_FrameCnt:		.ds 1	; A counter that overflows to increment Wand_Frame (added to by the wand's SpecialObj_Var1)
	Wand_Frame:		.ds 1	; Wand frame
	Wand_BounceFlag:	.ds 1	; Tracks the recovered wand bounce; odd on first bounce

	Player_DebugNoHitFlag:	.ds 1	; UNUSED: (Old debug routine) When set, disables getting hurt (would be toggled by pressing SELECT; see PRG000 $C91B)

; Map_Completions:
; Stores "rows" of completed levels or other map alterations (e.g. rock break,
; mini-fortress lock removal, etc.) for a given column, from the leftmost.
; Rows 1-7 use decending bits from $80, and row 9 uses bit $01.  This makes row 8
; invalid for hosting a level panel ever!
; --------- TOP OF MAP
; $80
; $40
; $20
; $10
; $08
; $04
; $02
; INVALID
; $01
; --------- BOT OF MAP
	Map_Completions:	.ds 16*4*2	; $7D00-$7D3F (Mario), $7D40-$7D7F (Luigi) Allows a MAX of 4 map screens (64 columns total each player, 16 columns per map screen)

	; Inventory_Items: 
	; 0 = Empty
	; 1 = Mushroom
	; 2 = Flower
	; 3 = Leaf
	; 4 = Frog
	; 5 = Tanooki
	; 6 = Hammer
	; 7 = Judgem's cloud
	; 8 = P-Wing
	; 9 = Star
	; A = Anchor
	; B = Hammer
	; C = Warp Whistle
	; D = Music Box
	Inventory_Items:	.ds 4*7	; $7D80-$7D9B Mario, 4 rows of 7 items 
	Inventory_Cards:	.ds 3	; $7D9C-$7D9E Mario, 3 cards
	Inventory_Score:	.ds 3	; $7D9F-$7DA1 Mario, 3 byte score
	Inventory_Coins:	.ds 1	; Mario's coins

	Inventory_Items2:	.ds 4*7	; $7DA3-$7DBE Luigi, 4 rows of 7 items 
	Inventory_Cards2:	.ds 3	; $7DBF-$7DC1 Luigi, 3 cards
	Inventory_Score2:	.ds 3	; $7DC2-$7DC4 Luigi, 3 byte score
	Inventory_Coins2:	.ds 1	; Luigi's coins
	Map_Unused7DC6:		.ds 5	; $7DC6-$7DCA? Indexed by Map_Unused738, value used in dead routine in PRG011 @ $A2AF

	Map_GameOver_CursorY:	.ds 1	; Game Over popup cursor Y ($60/$68)

				.ds 9	; $7DCC-$7DD4 unused

	Map_PrevMoveDir:	.ds 1	; Last SUCCESSFUL (allowed) movement direction on map R01 L02 D04 U08

				.ds 8	; $7DD6-$7DDD unused

	Pal_Data:		.ds 32	; $7DDE-$7DFD Holds an entire bg/sprite palette (this is the MASTER palette, what fades target, and others may source for "original" colors!)

	Level_AltLayout:	.ds 2	; $7DFE-$7DFF Pointer to level's "alternate" layout (when you go into bonus pipe, etc.)
	Level_AltObjects:	.ds 2	; $7E00-$7E01 Pointer to level's "alternate" object set (when you go into bonus pipe, etc.)

	Level_BlockGrabHitMem:	.ds 128	; $7E02-$7E81 Records coins and 1-ups grabbed, so they don't come back if you switch areas

CARD_MUSHROOM	= 0
CARD_FLOWER	= 1
CARD_STAR	= 2
CARD_1UP	= 3
CARD_10COIN	= 4
CARD_20COIN	= 5
CARD_WILD	= 8	; UNUSED Wild card (can match any other!)
	Card_ActiveSet:		.ds 18	; $7E82-$7E93 Active set of N-Spade game cards

	; Tile_AttrTable:
	; On the world map, it's always the following:
	; [03 67 BF E9] [03 67 BF E9]
	; There's a usage of checking which "quadrant" of tile the Player is standing on ($00, $40, $80, or $C0)
	; and using that as an index (shifted right 6) into the second half of this table
	; TILE_PANEL1		= $03	; Level Panel 1




	; TILE_FORT		= $67	; Mini-Fortress
	; TILE_POOL		= $BF	; Pool / Oasis
	; TILE_WORLD5STAR	= $E9	; Star used on World 5 Sky map
	; The check follows with a "less than", as a quick failure check (if you're in this "range"
	; of tiles, but less than that value, you can't possibly be on an enterable tile)
	; The second half is not used on the world map
	;
	; In levels, both "halves" define the first tile of a quadrant to be solid
	; The first half is solid at the ground (i.e. Player can stand on it)
	; The second half is solid at the head and walls (i.e. Player bumps head on it, typically "full solidity" when combined above)
	; Interestingly, the Sonic the Hedgehog games implemented this same solidity pattern...
	Tile_AttrTable:		.ds 8	; $7E94-$7E9B

	Level_UnusedSlopesTS5:	.ds 1	; UNUSED; If set to 2, forces slopes to be enabled for Level_Tileset = 5 (plant infestation)
	PlantInfest_ACnt_Max:	.ds 1	; Always set to $1A in plant infestation levels, sets max value for animation counter

				.ds 24	; $7E9E-$7EB5 unused

	LevelJctBQ_Flag:	.ds 1	; Set to '1' while in a Big Question block area, locks horizontal scrolling
	Level_JctBackupTileset:	.ds 1	; Level Junction tileset backup
	Level_AltTileset:	.ds 1	; Level's "alternate" tileset (when you go into bonus pipe, etc.)

	; The "ORIGINAL" series are so you can switch back after going to a level's "alternate"
	Level_LayPtrOrig_AddrL:	.ds 1	; ORIGINAL Low byte of address to tile layout
	Level_LayPtrOrig_AddrH:	.ds 1	; ORIGINAL High byte of address to tile layout
	Level_ObjPtrOrig_AddrL:	.ds 1	; ORIGINAL Low byte of address to object set
	Level_ObjPtrOrig_AddrH:	.ds 1	; ORIGINAL High byte of address to object set

	Level_BG_Page1_2:	.ds 1	; Sets which bank the first and second page (2K / 64 8x8 tiles) of BG is using (see Level_BG_Pages1/2)

	Map_BorderAttrFromTiles:.ds 44	; $7EBE-$7EC8 (?) Attributes collected from map tiles that get overwritten by border FIXME SIZE UNCERTAIN

	Map_Unused7EEA:		.ds 1	; Unused; Value retrieved from LUT at initialization of world, but never used otherwise
	Map_Objects_Y:		.ds 14	; $7EEB-$7EF8, Y coordinate of all map objects
	Map_Objects_XLo:	.ds 14	; $7EF9-$7F06, X coordinate lo byte of all map objects
	Map_Objects_XHi:	.ds 14	; $7F07-$7F14, X coordinate hi byte of all map objects

; Map_Objects_IDs: ID of all 8 map objects 
MAPOBJ_EMPTY		= $00	; None
MAPOBJ_HELP		= $01	; HELP
MAPOBJ_AIRSHIP		= $02	; Airship
MAPOBJ_HAMMERBRO	= $03	; Hammer Bro
MAPOBJ_BOOMERANGBRO	= $04	; Boomerang Bro
MAPOBJ_HEAVYBRO		= $05	; Heavy Bro
MAPOBJ_FIREBRO		= $06	; Fire Bro
MAPOBJ_W7PLANT		= $07	; World 7 Plant
MAPOBJ_UNK08		= $08	; Unknown marching glitch object
MAPOBJ_NSPADE		= $09 	; N-Spade
MAPOBJ_WHITETOADHOUSE	= $0A	; White Toad House
MAPOBJ_COINSHIP		= $0B	; Coin Ship
MAPOBJ_UNK0C		= $0C	; Unknown white colorization of $0F (goes to World 7 level??)
MAPOBJ_BATTLESHIP	= $0D	; World 8 Battleship
MAPOBJ_TANK		= $0E	; World 8 Tank
MAPOBJ_W8AIRSHIP	= $0F	; World 8 Airship
MAPOBJ_CANOE		= $10	; Canoe

MAPOBJ_TOTALINIT	= $08	; Total number of map objects initialized per world
MAPOBJ_TOTAL		= $0E	; Total POSSIBLE map objects
	Map_Objects_IDs:	.ds 14	; $7F15-$7F22

	Map_SprRAMOffDistr:	.ds 1	; A free running counter on the map only which distributes Sprite_RAM offsets to ensure visibility

	; Map_2PVsGame
	; Sets which "style" of 2P Vs game will be played
	;  0: Spiny Only
	;  1: Fighter Fly Only
	;  2: Spiny and Fighter Fly
	;  3: Static coins
	;  4: Spiny and Sidestepper
	;  5: Fighter Fly and Sidestepper
	;  6: Sidestepper Only
	;  7: Coin Fountain
	;  8: Spiny Only
	;  9: Fighter Fly Only 
	; 10: Sidestepper Only
	; 11: Ladder and [?] blocks
	Map_2PVsGame:		.ds 1

				.ds 8	; $7F25-$7F2C unused

	Map_Airship_Dest:	.ds 1	; Airship travel destination; 6 X/Y map coordinates defined per world, after that it just sits still
	THouse_OpenByID:	.ds 16	; $7F2E-$7F3D UNUSED would keep track of chests opened for a given Toad House ID (THouse_ID)
	StatusBar_PMT:		.ds 8	; $7F3E-$7F45, tiles that currently make up the power meter >>>>>>[P]
	StatusBar_CoinH:	.ds 1	; Status bar tile for coin MSD
	StatusBar_CoinL:	.ds 1	; Status bar tile for coin LSD
	StatusBar_LivesH:	.ds 1	; Status bar tile for lives MSD
	StatusBar_LivesL:	.ds 1	; Status bar tile for lives LSD
	StatusBar_Score:	.ds 6	; $7F4A-$7F4F Status bar tiles for score
	StatusBar_Time:		.ds 3	; $7F50-$7F52 Status bar tiles for time remaining
	Map_MusicBox_Cnt:	.ds 1	; Number of turns remaining until hammer brothers wake up (>= 1 and they're be asleep on the map)

	; Store arrays defined by level data as starts after an "alternate" level junction event
	; Level_JctXLHStart:
	;	Lower 4 bits: X Hi
	;	Upper 4 bits: X Lo
	; Level_JctYLHStart:
	;	Bits 0 - 3: Go into Level_PipeExitDir
	;	Bits 4 - 6: 0 to 7, selects start position from LevelJct_YLHStarts and sets proper vertical with LevelJct_VertStarts
	;	Bit      7: If set, entering in vertical mode (for "dirty" refresh purposes)
	Level_JctYLHStart:	.ds 16	; $7F54-$7F63 Array of Y / YHi starts
	Level_JctXLHStart:	.ds 16	; $7F64-$7F73 Array of X / XHi starts

	Object_TileFeet2:	.ds 1	; ? Difference against Object_TileFeet?
	Object_TileWall2:	.ds 1	; ? Difference against Object_TileWall?

	ObjTile_DetYHi:		.ds 1	; Object tile detect Y Hi
	ObjTile_DetYLo:		.ds 1	; Object tile detect Y Lo
	ObjTile_DetXHi:		.ds 1	; Object tile detect X Hi
	ObjTile_DetXLo:		.ds 1	; Object tile detect X Lo

	Bubble_Cnt:		.ds 3	; $7F7A-$7F7C Bubble counter value (0 = no bubble)

; NOTE: Object_WatrHit* values are set only once, then WatrHit_IsSetFlag latches
; and they will never update again; seems it is leftover debug code or maybe
; an unused feature (that an object could respond to a splashdown)
	WatrHit_IsSetFlag:	.ds 1	; Set when Object_WatrHit* values are stored (but never cleared, so only once!)
	Bubble_YHi:		.ds 3	; $7F7E-$7F80 Water Bubble Y Hi
	Object_WatrHitYHi:	.ds 1	; Y Hi of object that just hit water
	Bubble_Y:		.ds 3	; $7F82-$7F84 Water Bubble Y
	Object_WatrHitY:	.ds 1	; Y of object that just hit water
	Bubble_XHi:		.ds 3	; $7F86-$7F88 Water Bubble X Hi
	Object_WatrHitXHi:	.ds 1	; X Hi of object that just hit water
	Bubble_X:		.ds 3	; $7F8A-$7F8C Water Bubble X
	Object_WatrHitX:	.ds 1	; X of object that just hit water

	Splash_Counter:		.ds 3	; $7F8E-$7F90 Water splash counter
	Splash_Y:		.ds 3	; $7F91-$7F93 Water splash X
	Splash_X:		.ds 3	; $7F94-$7F96 Water splash Y
	Splash_NoScrollY:	.ds 3	; $7F97-$7F99 If set, flags this water splash to not display sprite Y as relative to screen scroll

	BrickBust_En:		.ds 3	; $7F9A-$7F9C Brick bust "Enable" (0 = disable, 2 = brick debris, anything else = "poof" away)
	BrickBust_YUpr:		.ds 3	; $7F9D-$7F9F Brick bust upper chunks Y
	BrickBust_X:		.ds 3	; $7FA0-$7FA2 Brick bust base X
	BrickBust_YVel:		.ds 3	; $7FA3-$7FA5 Brick bust Y velocity
	BrickBust_XDist:	.ds 3	; $7FA6-$7FA8 Brick bust X split
	BrickBust_YLwr:		.ds 3	; $7FA9-$7FAB Brick bust lower chunks Y
	BrickBust_HEn:		.ds 3	; $7FAC-$7FAE Bits to hide chunks (Bit 0 = Right, 1 = Left, 2 = Lower, 3 = Upper) OR poof counter

				.ds 3	; $7FAF-$7FB1 unused

	CoinPUp_State:		.ds 4	; $7FB2-$7FB5 State of up to 4 "Power Up" coins (i.e. coins that come out of ? blocks and bricks)
	CoinPUp_Y:		.ds 4	; $7FB6-$7FB9 Y of "Power Up" coins
	CoinPUp_X:		.ds 4	; $7FBA-$7FBD X of "Power Up" coins
	CoinPUp_YVel:		.ds 4	; $7FBE-$7FC1 Y velocity of "Power Up" coins
	CoinPUp_Counter:	.ds 4	; $7FC2-$7FC5 Counter used by "Power Up" coins

	; Special Object IDs:
SOBJ_HAMMER		= $01	; Hammer Bro hammer
SOBJ_BOOMERANG		= $02	; Boomerangs
SOBJ_UNKNOWN		= $03	; ??? Floats around, back and forth, some other strange movements (uses bits of boomerang code)
SOBJ_NIPPERFIREBALL	= $04 	; Nipper fireball (falls)
SOBJ_PIRANHAFIREBALL	= $05	; Piranha fireball
SOBJ_MICROGOOMBA	= $06 	; Micro goombas
SOBJ_SPIKEBALL		= $07 	; Spike's or Patooie's spike ball
SOBJ_WANDBLAST		= $08 	; Koopaling wand blast
SOBJ_KURIBOSHOE		= $09 	; Lost Kuribo shoe that "flies off" (NOTE: In Japanese original, this also featured super suits)
SOBJ_WRENCH		= $0A 	; Rocky's Wrench
SOBJ_CANNONBALL		= $0B 	; Cannonball
SOBJ_FIREBROFIREBALL	= $0C	; Fire bro bouncing fireball
SOBJ_EXPLOSIONSTAR	= $0D 	; Explosion star
SOBJ_BUBBLE		= $0E 	; Bubble
SOBJ_LAVALOTUSFIRE	= $0F	; Lava Lotus fire
SOBJ_RECOVEREDWAND	= $10 	; Recovered wand
SOBJ_POPPEDOUTCOIN	= $11 	; Popped out coin
SOBJ_FIRECHOMPFIRE	= $12 	; Fire Chomp's fire
SOBJ_BRICKDEBRIS	= $13 	; Brick debris (used for busting e.g. Piledriver Microgroomba, OR giant world brick busting)
SOBJ_BLOOPERKID		= $14 	; Blooper kid
SOBJ_LASER		= $15 	; Laser
SOBJ_POOF		= $16 	; Poof
	SpecialObj_ID:		.ds 8	; $7FC6-$7FCD Special object spawn event IDs

				.ds 2	; $7FCE-$7FCF unused

	Objects_Var3:		.ds 5	; $7FD0-$7FD4 Generic variable 3 for objects SLOT 0 - 4 ONLY

	SpecialObj_YHi:		.ds 8	; $7FD5-$7FDC Special object Y high coordinate

				.ds 2	; $7FDD-$7FDE unused

	Objects_LastTile:	.ds 8	; $7FDF-$7FE6 Last tile this object detected

	Objects_SprAttr:	.ds 8	; $7FE7-$7FEE Object sprite attributes (only uses bit 6 for H-Flip and bits 0-1 for palette)
	Objects_UseShortHTest:	.ds 8	; $7FEF-$7FF6 If set, object will use a short horizontal test to determine if it is off-screen

	Roulette_Lives:			; Number of lives you are rewarded from winning the Roulette (NOTE: Shared with first byte of Objects_IsGiant)
	Objects_IsGiant:	.ds 8	; $7FF7-$7FFE Set mainly for World 4 "Giant" enemies (but some others, like Bowser, also use it)

	; ASSEMBLER BOUNDARY CHECK, END OF $8000
.Bound_8000:	BoundCheck .Bound_8000, $8000, MMC3 SRAM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $7A01-$7A11 MMC3 SRAM as Cinematic for Wand Return (Post-Airship)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.data
	.org $7A01
; This uses the same space as most of the Auto Scroll data, I'm annoyed that I have to make a section for this

; After the wand is returned ONLY
	CineKing_WandState:		.ds 1	; Wand state; 0 = falling, 1 = spinning, 2 = held
	CineKing_WandFrame:		.ds 1	; Wand frame; 0 to 7
	CineKing_ToadFrame:		.ds 1	; Toad's frame
	CineKing_DiagHi:		.ds 1	; Text high address value

					.ds 3	; $7A05-$7A07 unused in this context

	CineKing_TimerT:		.ds 1	; Cheering Toad animation Timer
	CineKing_Timer3:		.ds 1	; Timer decremented every 4 ticks (does not appear to be used!)

					.ds 2	; $7A0A-$7A0B unused in this context

	CineKing_WandX:			.ds 1	; Wand X position
	CineKing_WandY:			.ds 1	; Wand Y position
	CineKing_WandXVel:		.ds 1	; Wand X velocity (4.4FP)
	CineKing_WandYVel:		.ds 1	; Wand Y velocity (4.4FP)
	CineKing_WandXVel_Frac:		.ds 1	; Wand X velocity fractional accumulator
	CineKing_WandYVel_Frac:		.ds 1	; Wand Y velocity fractional accumulator

	; ASSEMBLER BOUNDARY CHECK, END OF $7A12
.Bound_7A12:	BoundCheck .Bound_7A12, $7A12, Wand Return Cinematic Vars

	.code

; The objects are broken up into groups of 36 IDs across 5 ROM banks (1 - 5)
; These lookup table addresses are common, even though their banks are not,
; and so I define these constants for lack of a better solution:
ObjectGroup_InitJumpTable	= $A000
ObjectGroup_NormalJumpTable	= $A048
ObjectGroup_CollideJumpTable	= $A090
ObjectGroup_Attributes		= $A0D8
ObjectGroup_Attributes2		= $A0FC
ObjectGroup_Attributes3		= $A120
ObjectGroup_PatTableSel		= $A144
ObjectGroup_KillAction		= $A168
ObjectGroup_PatternStarts	= $A18C

ObjectGroup_PatternSets		= $A1B0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GAME CONSTANTS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Size of level (width or height, if vertical)
LEVEL1_SIZE_01		= %00000000
LEVEL1_SIZE_02		= %00000001
LEVEL1_SIZE_03		= %00000010
LEVEL1_SIZE_04		= %00000011
LEVEL1_SIZE_05		= %00000100
LEVEL1_SIZE_06		= %00000101
LEVEL1_SIZE_07		= %00000110
LEVEL1_SIZE_08		= %00000111
LEVEL1_SIZE_09		= %00001000
LEVEL1_SIZE_10		= %00001001
LEVEL1_SIZE_11		= %00001010
LEVEL1_SIZE_12		= %00001011
LEVEL1_SIZE_13		= %00001100
LEVEL1_SIZE_14		= %00001101
LEVEL1_SIZE_15		= %00001110
LEVEL1_SIZE_16		= %00001111

; Player Y Start positions (also selects appropriate starting vertical position)
LEVEL1_YSTART_170	= %00000000
LEVEL1_YSTART_040	= %00100000
LEVEL1_YSTART_000	= %01000000
LEVEL1_YSTART_140	= %01100000
LEVEL1_YSTART_070	= %10000000
LEVEL1_YSTART_0B0	= %10100000
LEVEL1_YSTART_0F0	= %11000000
LEVEL1_YSTART_180	= %11100000

LEVEL1_2PVS		= %00010000	; Unknown purpose flag set on 2P Vs levels

; Palettes (full 16 colors in category) are defined by tileset; objects are rooted at index 8
; BG palette set
LEVEL2_BGPAL_00		= %00000000
LEVEL2_BGPAL_01		= %00000001
LEVEL2_BGPAL_02		= %00000010
LEVEL2_BGPAL_03		= %00000011
LEVEL2_BGPAL_04		= %00000100
LEVEL2_BGPAL_05		= %00000101
LEVEL2_BGPAL_06		= %00000110
LEVEL2_BGPAL_07		= %00000111

; Object palette set
LEVEL2_OBJPAL_08	= %00000000
LEVEL2_OBJPAL_09	= %00001000
LEVEL2_OBJPAL_10	= %00010000
LEVEL2_OBJPAL_11	= %00011000

; Player X Start positions
LEVEL2_XSTART_18	= %00000000
LEVEL2_XSTART_70	= %00100000
LEVEL2_XSTART_D8	= %01000000
LEVEL2_XSTART_80	= %01100000

; Sets "Level_UnusedFlag", which is apparently not used for anything
LEVEL2_UNUSEDFLAG	= %10000000


; Sets "Level_AltTileset", the tileset of the "alternate" level
LEVEL3_TILESET_00	= %00000000	; Included for completeness, but not valid (for the world map only)
LEVEL3_TILESET_01	= %00000001
LEVEL3_TILESET_02	= %00000010
LEVEL3_TILESET_03	= %00000011
LEVEL3_TILESET_04	= %00000100
LEVEL3_TILESET_05	= %00000101
LEVEL3_TILESET_06	= %00000110
LEVEL3_TILESET_07	= %00000111
LEVEL3_TILESET_08	= %00001000
LEVEL3_TILESET_09	= %00001001
LEVEL3_TILESET_10	= %00001010
LEVEL3_TILESET_11	= %00001011
LEVEL3_TILESET_12	= %00001100
LEVEL3_TILESET_13	= %00001101
LEVEL3_TILESET_14	= %00001110
LEVEL3_TILESET_15	= %00001111	; Included for completeness, but not valid (bonus game, can't jump in this way)

; Sets "Level_7Vertical", i.e. states object is a vertical oriented one
LEVEL3_VERTICAL		= %00010000


; Sets the vertical scroll lock
LEVEL3_VSCROLL_LOCKLOW	= %00000000	; Screen locked at $EF (lowest point) unless flying or climbing a vine
LEVEL3_VSCROLL_FREE	= %00100000	; Free vertical scroll
LEVEL3_VSCROLL_LOCKED	= %01000000	; Locks either high (0) or low ($EF) depending on value of Vert_Scroll

; Sets Level_PipeNotExit
LEVEL3_PIPENOTEXIT	= %10000000


; BG pattern bank index
LEVEL4_BGBANK_INDEX	.func (\1 & %00011111)

; Level initial action
LEVEL4_INITACT_NOTHING	= %00000000	; Do nothing
LEVEL4_INITACT_SLIDE	= %00100000	; Start level sliding (if able by power-up)
LEVEL4_INITACT_PIPE_T	= %01000000	; Start by exiting top of pipe
LEVEL4_INITACT_PIPE_B	= %01100000	; Start by exiting bottom of pipe
LEVEL4_INITACT_PIPE_R	= %10000000	; Start by exiting right of pipe
LEVEL4_INITACT_PIPE_L	= %10100000	; Start by exiting left of pipe
LEVEL4_INITACT_AIRSHIP	= %11000000	; Airship intro run & jump init
LEVEL4_INITACT_AIRSHIPB	= %11100000	; Boarding the Airship

; Select "Music 2" set BGM (from table GamePlay_BGM)
LEVEL5_BGM_OVERWORLD	= %00000000
LEVEL5_BGM_UNDERGROUND	= %00000001
LEVEL5_BGM_UNDERWATER	= %00000010
LEVEL5_BGM_FORTRESS	= %00000011
LEVEL5_BGM_BOSS		= %00000100
LEVEL5_BGM_AIRSHIP	= %00000101
LEVEL5_BGM_BATTLE	= %00000110
LEVEL5_BGM_TOADHOUSE	= %00000111
LEVEL5_BGM_ATHLETIC	= %00001000
LEVEL5_BGM_THRONEROOM	= %00001001
LEVEL5_BGM_SKY		= %00001010

; Bits 4-5 are free apparently

; Set starting clock time
LEVEL5_TIME_300		= %00000000	; Clock at 300
LEVEL5_TIME_400		= %01000000	; Clock at 400
LEVEL5_TIME_200		= %10000000	; Clock at 200
LEVEL5_TIME_UNLIMITED	= %11000000	; Clock at 000, unlimited


; Special values that go into the Collide Jump Table
OCSPECIAL_HIGHSCORE	= $0400		; Stomp-killing this enemy gives you 1000 pts instead of 100 pts base score
OCSPECIAL_KILLCHANGETO	= $0800		; When enemy is killed, it changes to the object ID in the lower 8 bits (requires OA3_DIESHELLED)

; Object Attributes Set 1 Flags

OA1_PAL0		= %00000000	; Object uses sprite palette 0
OA1_PAL1		= %00000001	; Object uses sprite palette 1
OA1_PAL2		= %00000010	; Object uses sprite palette 2
OA1_PAL3		= %00000011	; Object uses sprite palette 3
OA1_PALMASK		= %00000011	; Not intended for use in attribute table, readability/traceability only

; NOTE: The width and heights here are for sprite visibility testing
; For the object's bounding box, see OAT_BOUNDBOXxx

OA1_HEIGHT16		= %00000000	; Object is 16 pixels tall
OA1_HEIGHT32		= %00000100	; Object is 32 pixels tall
OA1_HEIGHT48		= %00001000	; Object is 48 pixels tall
OA1_HEIGHT64		= %00001100	; Object is 64 pixels tall
OA1_HEIGHTMASK		= %00001100	; Not intended for use in attribute table, readability/traceability only

OA1_WIDTH8		= %00000000	; Object is 8 pixels wide
OA1_WIDTH16		= %00010000	; Object is 16 pixels wide
OA1_WIDTH24		= %00100000	; Object is 24 pixels wide
OA1_WIDTH32		= %00110000	; Object is 32 pixels wide
OA1_WIDTH40		= %01000000	; Object is 40 pixels wide
OA1_WIDTH48		= %01010000	; Object is 48 pixels wide
OA1_WIDTHMASK		= %01110000	; Not intended for use in attribute table, readability/traceability only


; Object Attributes Set 2 Flags

OA2_NOSHELLORSQUASH	= %00000001	; Enemy does not go into shell (state 3) or squash (state 7) states when stomped on
OA2_GNDPLAYERMOD	= %00000010	; "Grounded Player Mod"; Subtly modifies Player detection response; see comments in PRG000_D205
OA2_STOMPDONTCARE	= %00000100	; Object "doesn't care" about being stomped (indifferent, not same as OA3_NOTSTOMPABLE)
OA2_USE16BITX		= %00001000	; When applying X velocity, calculate "X Hi" position (applies to vertical levels only; if not set, Object_XHi will be fixed at zero)


; This selects what X/Y offsets are used by an object to detect a tile
; For tile detection groups, see Object_TileDetectOffsets in PRG000
OA2_TDOGRP0		= %00000000	; Use "Group 0" tile detection offsets
OA2_TDOGRP1		= %00010000	; Use "Group 1" tile detection offsets
OA2_TDOGRP2		= %00100000	; Use "Group 2" tile detection offsets
OA2_TDOGRP3		= %00110000	; Use "Group 3" tile detection offsets
OA2_TDOGRP4		= %01000000	; Use "Group 4" tile detection offsets
OA2_TDOGRP5		= %01010000	; Use "Group 5" tile detection offsets
OA2_TDOGRP6		= %01100000	; Use "Group 6" tile detection offsets
OA2_TDOGRP7		= %01110000	; Use "Group 7" tile detection offsets
OA2_TDOGRP8		= %10000000	; Use "Group 8" tile detection offsets
OA2_TDOGRP9		= %10010000	; Use "Group 9" tile detection offsets
OA2_TDOGRP10		= %10100000	; Use "Group 10" tile detection offsets
OA2_TDOGRP11		= %10110000	; Use "Group 11" tile detection offsets
OA2_TDOGRP12		= %11000000	; Use "Group 12" tile detection offsets
OA2_TDOGRPMASK		= %11110000	; Not intended for use in attribute table, readability/traceability only

; Object Attributes Set 3 Flags

; This selects what action should occur with the object when gameplay is halted (e.g. Player died)
;
; TIP: The most commonly used one is OA3_HALT_NORMALONLY, which means to continue executing the
;      object's "Normal" state if the object is in state 2, otherwise not do anything at all.
;      This does not mean that the other states will be ignored (i.e. object in shell state will
;      continue to use the built-in shell type drawing code) but no handling is performed.
;
;      Typically then the "Normal" state will have some kind of code to deal with halted gameplay,
;      e.g. calling its own draw routine.  The fact that there are enemy specific "special" halts
;      is ugly and hackish, and I fully recommend using OA3_HALT_NORMALONLY and handle gameplay
;      halts in the "Normal" state standard subroutine instead as much as possible.
OA3_HALT_HOTFOOTSPECIAL	= %00000000	; 0: Bank2/Hotfoot ONLY
OA3_HALT_JUSTDRAW	= %00000001	; 1: Standard draw
OA3_HALT_JUSTDRAWTALL	= %00000010	; 2: Draw tall 16x32 sprite
OA3_HALT_SPIKESPECIAL	= %00000011	; 3: Bank2/Spike ONLY
OA3_HALT_DONOTHING	= %00000100	; 4: Do nothing
OA3_HALT_NORMALONLY	= %00000101	; 5: If object is in "normal" state, do its normal routine, otherwise do nothing (COMMON)
OA3_HALT_JUSTDRAWWIDE	= %00000110	; 6: Draw wide 48x16 sprite
OA3_HALT_DONOTHING2	= %00000111	; 7: Do nothing
OA3_HALT_KURIBOSPECIAL	= %00001000	; 8: Bank2/Kuribo's Shoe ONLY
OA3_HALT_DONOTHING3	= %00001001	; 9: Do nothing
OA3_HALT_JUSTDRAWMIRROR	= %00001010	; 10: Draw mirrored 16x16 sprite
OA3_HALT_ENDCARDSPECIAL	= %00001011	; 11: Bank2/End Level Card ONLY
OA3_HALT_DONOTHING4	= %00001100	; 12: Do nothing
OA3_HALT_BUSTERSPECIAL	= %00001101	; 13: Bank2/Buster Beatle ONLY
OA3_HALT_PIRANHASPECIAL	= %00001110	; 14: Bank2/Piranha Spike Ball ONLY
OA3_HALT_MASK		= %00001111	; Not intended for use in attribute table, readability/traceability only

OA3_SQUASH		= %00010000	; Enemy should "squash" (state 7) not "shell" (state 3), or "killed" (state 6) in case of statue/Kuribo's shoe stomp; requires OA2_NOTSHELLED to be NOT SET
OA3_NOTSTOMPABLE	= %00100000	; If the Player tries to stomp this enemy, he will be HURT!  (E.g. Spikey enemy)
OA3_DIESHELLED		= %01000000	; The CollideJumpTable entry MAY contain the "special" entry; see CollideJumpTable; also "dies" into "shell" (state 3) (i.e. object "bumps" into shell when hit from beneath)
OA3_TAILATKIMMUNE	= %10000000	; Object cannot be Raccoon tail attacked


; Object Attribute Common Flags

; Selects a bounding box from Object_BoundBox
OAT_BOUNDBOX00		= %00000000
OAT_BOUNDBOX01		= %00000001
OAT_BOUNDBOX02		= %00000010
OAT_BOUNDBOX03		= %00000011
OAT_BOUNDBOX04		= %00000100
OAT_BOUNDBOX05		= %00000101
OAT_BOUNDBOX06		= %00000110
OAT_BOUNDBOX07		= %00000111
OAT_BOUNDBOX08		= %00001000
OAT_BOUNDBOX09		= %00001001
OAT_BOUNDBOX10		= %00001010
OAT_BOUNDBOX11		= %00001011
OAT_BOUNDBOX12		= %00001100
OAT_BOUNDBOX13		= %00001101
OAT_BOUNDBOX14		= %00001110
OAT_BOUNDBOX15		= %00001111
OAT_BOUNDBOXMASK	= %00001111	; Not intended for use in attribute table, readability/traceability only

OAT_BOUNCEOFFOTHERS	= %00010000	; Turn away from other enemies if their paths collide
OAT_WEAPONIMMUNITY	= %00100000	; Object is immune to Player's weapon (i.e. fireballs/hammers)
OAT_FIREIMMUNITY	= %01000000	; Object is immune to Player's fireballs
OAT_HITNOTKILL		= %10000000	; Object will run collision routine instead of standard "Kick"-sound/100 points/OBJSTATE_KILLED [i.e. object not killed by being rammed with held object]


; Flags for the ObjectGroup_PatTableSel table
OPTS_NOCHANGE		= 0		; Don't set a pattern table
OPTS_SETPT5		= $00		; Set pattern table bank 5
OPTS_SETPT6		= $80		; Set pattern table bank 6

; Determines what action is taken when object is in "Killed" state (6)
; See Object_DoKillAction for the jump table
; NOTE: Any action type other than zero always sets the frame to 2 (unless object is not general purpose, i.e. index >= 5)
KILLACT_STANDARD	= 0	; 0: Standard kill (does not set frame 2)
KILLACT_JUSTDRAW16X16	= 1	; 1: Standard sprite draw and kill
KILLACT_JUSTDRAWMIRROR	= 2	; 2: Draw mirrored sprite
KILLACT_JUSTDRAW16X32	= 3	; 3: Draw tall sprite
KILLACT_JUSTDRAWTALLFLIP= 4	; 4: Draw tall object horizontally flipped
KILLACT_NORMALANDKILLED	= 5	; 5: Do "Normal" state and killed action (sinking/vert flip)
KILLACT_GIANTKILLED	= 6	; 6: Giant enemy death
KILLACT_POOFDEATH	= 7	; 7: Do "poof" dying state while killed
KILLACT_DRAWMOVENOHALT	= 8	; 8: Draw and do movements unless gameplay halted
KILLACT_NORMALSTATE	= 9	; 9: Just do "Normal" state while killed

; Object IDs

OBJ_BOUNCEDOWNUP	= $06	; Down/up block bounce effect object
OBJ_WARPHIDE		= $07	; Hidden object that jumps you to the secret warp whistle in 1-3
OBJ_PSWITCHDOOR		= $08	; Door that appears under influence of P-Switch
OBJ_AIRSHIPANCHOR	= $09	; Airship anchor
OBJ_POWERUP_1UP		= $0B	; 1-Up Mushroom
OBJ_POWERUP_STARMAN	= $0C	; Starman (primarily, but also the super suits -- Tanooki, Frog, Hammer)
OBJ_POWERUP_MUSHROOM	= $0D 	; Super Mushroom
OBJ_BOSS_KOOPALING	= $0E 	; Koopaling (as appropriate to current world)
OBJ_SPINYCHEEP		= $17	; Spiny cheep
OBJ_BOSS_BOWSER		= $18 	; King Bowser
OBJ_POWERUP_FIREFLOWER	= $19	; Fire flower
OBJ_BOUNCELEFTRIGHT	= $1B	; Left/right block bounce effect object
OBJ_POWERUP_SUPERLEAF	= $1E	; Falling super leaf
OBJ_GROWINGVINE		= $1F	; Growing vine
OBJ_POWERUP_MUSHCARD	= $21	; Free mushroom card ????
OBJ_POWERUP_FIRECARD	= $22	; Free flower card ????
OBJ_POWERUP_STARCARD	= $23	; Free star card ????
OBJ_CLOUDPLATFORM_FAST	= $24	; Fast cloud platform
OBJ_PIPEWAYCONTROLLER	= $25	; "Pipe Way" Controller (World Map pipe-to-pipe location setter)
OBJ_WOODENPLAT_RIDER	= $26	; Log that rides you to the right after stepping on it
OBJ_OSCILLATING_H	= $27	; Horizontal oscillating log platform
OBJ_OSCILLATING_V	= $28	; Vertical Oscillating log platform
OBJ_SPIKE		= $29	; Spike (the spike ball barfer)
OBJ_PATOOIE		= $2A	; Patooie
OBJ_GOOMBAINSHOE	= $2B	; Goomba in Kuribo's Shoe (yes, I know Kuribo = Goomba, quiet)
OBJ_CLOUDPLATFORM	= $2C	; Cloud platform
OBJ_BIGBERTHA		= $2D	; Big Bertha that eats you
OBJ_INVISIBLELIFT	= $2E	; Invisible (until touched) lift that goes up to fixed position of Y/Hi = 64
OBJ_BOO			= $2F	; Boo Diddly
OBJ_HOTFOOT_SHY		= $30	; Hot Foot (returns to flame if looked at)
OBJ_BOOSTRETCH		= $31	; "Stretch" Boo, upright
OBJ_BOOSTRETCH_FLIP	= $32	; "Stretch" Boo, upside-down
OBJ_NIPPER		= $33 	; Stationary nipper plant
OBJ_TOAD		= $34 	; Toad and his house message
OBJ_TOADHOUSEITEM	= $35	; Item that pops out of a treasure box in a Toad House
OBJ_WOODENPLATFORM	= $36	; Floating wooden platform
OBJ_OSCILLATING_HS	= $37	; left/right short-oscillation log
OBJ_OSCILLATING_VS	= $38	; Up/down short-oscillation log
OBJ_NIPPERHOPPING	= $39 	; Hopping nipper plant
OBJ_FALLINGPLATFORM	= $3A	; Falling donut lift type platform
OBJ_CHARGINGCHEEPCHEEP	= $3B 	; Charging, hopping cheep cheep
OBJ_WOODENPLATFORMFALL	= $3C 	; Falling wooden platform
OBJ_NIPPERFIREBREATHER	= $3D	; Fire belching nipper plant
OBJ_WOODENPLATFORMFLOAT	= $3E	; Floating (on water) log
OBJ_DRYBONES		= $3F	; Dry Bones
OBJ_BUSTERBEATLE	= $40	; Buster Beatle
OBJ_ENDLEVELCARD	= $41	; End-of-level card
OBJ_CHEEPCHEEPPOOL2POOL	= $42	; Pool-to-pool-to-pool hopping cheep cheep
OBJ_CHEEPCHEEPPOOL2POOL2= $43	; Pool-to-pool hopping cheep cheep
OBJ_WOODENPLATUNSTABLE	= $44	; Fall-after-touch log platform
OBJ_HOTFOOT		= $45 	; Hot Foot (randomly walks and stops, doesn't care if you stare)
OBJ_PIRANHASPIKEBALL	= $46	; Tall plant carrying spike ball
OBJ_GIANTBLOCKCTL	= $47	; Enables Giant World blocks to function
OBJ_TINYCHEEPCHEEP	= $48	; Tiny cheep cheep
OBJ_FLOATINGBGCLOUD	= $49	; Floating background cloud
OBJ_BOOMBOOMQBALL	= $4A 	; Boom Boom (?) end-level ball
OBJ_BOOMBOOMJUMP	= $4B	; Jumping Boom-Boom (can actually hit ? blocks!)
OBJ_BOOMBOOMFLY		= $4C	; Flying Boom-boom
OBJ_CHAINCHOMPFREE	= $4F	; Jumping chain chomp head after he breaks free
OBJ_BOBOMBEXPLODE	= $50	; Ready-to-explode Bob-Omb
OBJ_ROTODISCDUAL	= $51	; Dual Rotodisc, sync, clockwise
OBJ_TREASUREBOX		= $52	; Treasure box
OBJ_PODOBOOCEILING	= $53	; Podoboo from ceiling
OBJ_DONUTLIFTSHAKEFALL	= $54	; Donut lift shake and fall object
OBJ_BOBOMB		= $55	; Bob-Omb
OBJ_PIRANHASIDEWAYSLEFT	= $56	; Sideways left-facing red piranha
OBJ_PIRANHASIDEWAYSRIGHT= $57 	; Sideways right-facing red piranha
OBJ_FIRECHOMP		= $58	; Fire chomp
OBJ_FIRESNAKE		= $59	; Fire snake
OBJ_ROTODISCCLOCKWISE	= $5A	; Standard Rotodisc clockwise
OBJ_ROTODISCCCLOCKWISE	= $5B	; Standard Rotodisc counter-clockwise
OBJ_ICEBLOCK		= $5C	; Iceblock as held by Mario or Buster Beatle
OBJ_TORNADO		= $5D	; Tornado
OBJ_ROTODISCDUALOPPOSE	= $5E	; Dual Rotodisc, opposites, horizontal meeting
OBJ_ROTODISCDUALOPPOSE2	= $5F 	; Dual Rotodisc, opposites, vertical meeting
OBJ_ROTODISCDUALCCLOCK	= $60	; Dual Rotodisc, sync, counter-clockwise
OBJ_BLOOPERWITHKIDS	= $61	; Blooper w/ kids
OBJ_BLOOPER		= $62	; Blooper
OBJ_BIGBERTHABIRTHER	= $63	; Big Bertha with spit-out child
OBJ_CHEEPCHEEPHOPPER	= $64	; Cheep Cheep water hopper
OBJ_WATERCURRENTUPWARD	= $65	; upward current
OBJ_WATERCURRENTDOWNARD	= $66	; Downward current
OBJ_LAVALOTUS		= $67 	; Underwater lava plant
OBJ_TWIRLINGBUZZY	= $68	; Twirling, upside down buzzy beatle
OBJ_TWIRLINGSPINY	= $69	; Twirling, upside down spiny
OBJ_BLOOPERCHILDSHOOT	= $6A	; Blooper (shoots off children)
OBJ_PILEDRIVER		= $6B	; Pile driver micro goomba
OBJ_GREENTROOPA		= $6C	; green koopa troopa
OBJ_REDTROOPA		= $6D	; red koopa troopa
OBJ_PARATROOPAGREENHOP	= $6E	; Hopping green paratroopa
OBJ_FLYINGREDPARATROOPA	= $6F	; Flying up/down red winged turtle
OBJ_BUZZYBEATLE		= $70	; Buzzy beatle
OBJ_SPINY		= $71	; Spiny
OBJ_GOOMBA		= $72	; Regular goomba
OBJ_PARAGOOMBA		= $73	; Hopping red flying goomba
OBJ_PARAGOOMBAWITHMICROS= $74	; Micro goomba dropping flying goomba
OBJ_BOSSATTACK		= $75	; Lemmy's ball, Wendy's ring, Bowser's fireball, depends
OBJ_JUMPINGCHEEPCHEEP	= $76	; Jumping Cheep Cheep
OBJ_GREENCHEEP		= $77	; Green Cheep Cheep
OBJ_BULLETBILL		= $78	; Regular Bullet bill
OBJ_BULLETBILLHOMING	= $79	; Homing Bullet Bill
OBJ_BIGGREENTROOPA	= $7A	; Big Green Turtle
OBJ_BIGREDTROOPA	= $7B	; Big Red Turtle
OBJ_BIGGOOMBA		= $7C	; Big Goomba
OBJ_BIGGREENPIRANHA	= $7D	; Big Green Piranha
OBJ_BIGGREENHOPPER	= $7E	; Big, bouncing turtle
OBJ_BIGREDPIRANHA	= $7F	; Big Red Pirahana
OBJ_FLYINGGREENPARATROOPA=$80	; Flying left/right green winged turtle
OBJ_HAMMERBRO		= $81	; Classic Hammer Brother
OBJ_BOOMERANGBRO	= $82	; Boomerang Brother
OBJ_LAKITU		= $83	; Lakitu throwing red spiny eggs
OBJ_SPINYEGG		= $84	; Working red spiny egg
OBJ_SPINYEGGDUD		= $85	; Rolling "dud" spiny egg
OBJ_HEAVYBRO		= $86	; Heavy brother
OBJ_FIREBRO		= $87	; Fire Brother
OBJ_ORANGECHEEP		= $88	; "Lost" orange cheep cheep
OBJ_CHAINCHOMP		= $89	; Chain chomp
OBJ_THWOMP		= $8A	; Standard Thwomp
OBJ_THWOMPLEFTSLIDE	= $8B	; Left sliding Thwomp
OBJ_THWOMPRIGHTSLIDE	= $8C	; Right sliding Thwomp
OBJ_THWOMPUPDOWN	= $8D	; Up-down sliding Thwomp
OBJ_THWOMPDIAGONALUL	= $8E	; Diagonal up-left Thwomp
OBJ_THWOMPDIAGONALDL	= $8F	; Diagonal down-left Thwomp
OBJ_TILTINGPLATFORM	= $90	; Tilting platform
OBJ_TWIRLINGPLATCWNS	= $91	; Twirling platform, clockwise, non-stop
OBJ_TWIRLINGPLATCW	= $92	; Twirling platform, clockwise
OBJ_TWIRLINGPERIODIC	= $93	; Twirling platform, periodic
OBJ_BIGQBLOCK_3UP	= $94	; Big ? block (3 1-ups)
OBJ_BIGQBLOCK_MUSHROOM	= $95	; Big ? block (biggie)
OBJ_BIGQBLOCK_FIREFLOWER= $96	; Big ? block (-flashing??- fireflower)
OBJ_BIGQBLOCK_SUPERLEAF	= $97	; Big ? block (-green??- leaf)
OBJ_BIGQBLOCK_TANOOKI	= $98	; Big ? block (tanooki)
OBJ_BIGQBLOCK_FROG	= $99	; Big ? block (frog suit)
OBJ_BIGQBLOCK_HAMMER	= $9A	; Big ? block (hammer suit)
OBJ_FIREJET_UPWARD	= $9D	; upward fire jet
OBJ_PODOBOO		= $9E	; Podoboo
OBJ_PARABEETLE		= $9F	; Parabeetle
OBJ_GREENPIRANHA	= $A0	; short pipe muncher
OBJ_GREENPIRANHA_FLIPPED= $A1	; upside down short pipe muncher
OBJ_REDPIRANHA		= $A2	; tall pipe muncher
OBJ_REDPIRANHA_FLIPPED	= $A3	; upside down tall pipe muncher
OBJ_GREENPIRANHA_FIRE	= $A4	; short green fire plant
OBJ_GREENPIRANHA_FIREC	= $A5	; short, upside down, green fire plant
OBJ_VENUSFIRETRAP	= $A6	; Tall red fire plant
OBJ_VENUSFIRETRAP_CEIL	= $A7	; upside down tall fire plant
OBJ_ARROWONE		= $A8	; One direction arrow platform in motion
OBJ_ARROWANY		= $A9	; Changeable direction arrow platform in motion
OBJ_AIRSHIPPROP		= $AA	; Airship Propellar
OBJ_FIREJET_LEFT	= $AC	; Left fire jet
OBJ_ROCKYWRENCH		= $AD	; Rocky wrench (red)
OBJ_BOLTLIFT		= $AE	; Bolt
OBJ_ENEMYSUN		= $AF	; Enemy sun
OBJ_BIGCANNONBALL	= $B0	; BIG cannon ball
OBJ_FIREJET_RIGHT	= $B1	; right fire jet
OBJ_FIREJET_UPSIDEDOWN	= $B2	; upside down fire jet

; NOTE: Starting here, all object IDs are now handled specially (see PRG005_B8DB or just before PRG005_BB5F)
OBJ_CHEEPCHEEPBEGIN	= $B4	; (Level_Event = 1) Begins swarm of cheep cheeps
OBJ_GREENCHEEPBEGIN	= $B5	; (Level_Event = 2) Begins Spike Cheeps floating by
OBJ_LAKITUFLEE		= $B6	; (Level_Event = 3) Causes active Lakitu to flee
OBJ_PARABEETLESBEGIN	= $B7	; (Level_Event = 4) Begins Green and red parabeetles flyby
OBJ_CLOUDSINBGBEGIN	= $B8	; (Level_Event = 5) Begins floating clouds in background 
OBJ_WOODPLATFORMBEGIN	= $B9	; (Level_Event = 6) Begins random wooden platforms 
OBJ_TREASUREBOXAPPEAR	= $BA	; (Level_Event = 7) Causes treasure box to appear
OBJ_CANCELEVENT		= $BB	; (Level_Event = 8) Cancels Level_Event (sets to zero)

; Objects $BC to $D0 create Cannon Fires
OBJ_CFIRE_BULLETBILL	= $BC + CFIRE_BULLETBILL - 1	; Bullet Bill cannon
OBJ_CFIRE_MISSILEBILL	= $BC + CFIRE_MISSILEBILL - 1	; Missile Bill (homing BUllet Bill)
OBJ_CFIRE_ROCKYWRENCH	= $BC + CFIRE_ROCKYWRENCH - 1	; Creates Rocky Wrench (um why?)
OBJ_CFIRE_4WAY		= $BC + CFIRE_4WAY - 1		; 4-way cannon
OBJ_CFIRE_GOOMBAPIPE_L	= $BC + CFIRE_GOOMBAPIPE_L - 1	; Goomba pipe (left output)
OBJ_CFIRE_GOOMBAPIPE_R	= $BC + CFIRE_GOOMBAPIPE_R - 1	; Goomba pipe (right output)
OBJ_CFIRE_HLCANNON	= $BC + CFIRE_HLCANNON - 1	; Fires cannonballs horizontally left
OBJ_CFIRE_HLBIGCANNON	= $BC + CFIRE_HLBIGCANNON - 1	; Fires BIG cannonballs horizontally left
OBJ_CFIRE_ULCANNON	= $BC + CFIRE_ULCANNON - 1	; Fires cannonballs diagonally, upper left
OBJ_CFIRE_URCANNON	= $BC + CFIRE_URCANNON - 1	; Fires cannonballs diagonally, upper right
OBJ_CFIRE_LLCANNON	= $BC + CFIRE_LLCANNON - 1	; Fires cannonballs diagonally, lower left
OBJ_CFIRE_LRCANNON	= $BC + CFIRE_LRCANNON - 1	; Fires cannonballs diagonally, lower right
OBJ_CFIRE_HLCANNON2	= $BC + CFIRE_HLCANNON2 - 1	; Fires cannonballs horizontally left
OBJ_CFIRE_ULCANNON2	= $BC + CFIRE_ULCANNON2 - 1	; Fires cannonballs diagonally, upper left
OBJ_CFIRE_URCANNON2	= $BC + CFIRE_URCANNON2 - 1	; Fires cannonballs diagonally, upper right
OBJ_CFIRE_LLCANNON2	= $BC + CFIRE_LLCANNON2 - 1	; Fires cannonballs diagonally, lower left
OBJ_CFIRE_HRCANNON	= $BC + CFIRE_HRCANNON - 1	; Fires cannonballs horizontally right
OBJ_CFIRE_HRBIGCANNON	= $BC + CFIRE_HRBIGCANNON - 1	; Fires BIG cannonballs horizontally right
OBJ_CFIRE_LBOBOMBS	= $BC + CFIRE_LBOBOMBS - 1	; Launches fused Bob-ombs to the left
OBJ_CFIRE_RBOBOMBS	= $BC + CFIRE_RBOBOMBS - 1	; Launches fused Bob-ombs to the right
OBJ_CFIRE_LASER		= $BC + CFIRE_LASER - 1		; Laser fire

; Objects in $D1+ appear to trigger special events
OBJ_SPAWN3GREENTROOPAS	= $D1	; Spawns up to 3 (depending on available slots) hopping green paratroops
OBJ_SPAWN3ORANGECHEEPS	= $D2	; Spawns up to 3 (depending on available slots) "lost" orange cheep cheeps (a school)
OBJ_AUTOSCROLL		= $D3	; Activates auto scrolling for e.g. World 1-4, World 8 Tank, etc.
OBJ_BONUSCONTROLLER	= $D4	; Handles the judgement of whether you get a White Toad House / Coin Ship
OBJ_TOADANDKING		= $D5	; Toad and the king from the end of the world
OBJ_TREASURESET		= $D6	; Sets the treasure box item (Level_TreasureItem) based on what row this object is placed at

; Miscellaneous Player frames
PF_KICK_SMALL		= $42	; Foot out kick when small
PF_KICK_BIG		= $2D	; Foot out kick when big
PF_DIE			= $4B	; Dying
PF_MIDGROW_SMALL	= $0B	; When going from small to big, "Mid-grow" showing small
PF_MIDGROW_HALFWAY	= $27	; When going from small to big, "Mid-grow" showing something in between
PF_SKID_SMALL		= $41	; Skidding while small
PF_SKID_BIG		= $30	; Skidding while not small
PF_SLIDE_SMALL		= $33	; Sliding down a slope while small
PF_SLIDE_BIG		= $31	; Sliding down a slope otherwise
PF_STATUE		= $1E	; Tanooki statue frame

; Jump / fall
PF_FALLBIG		= $06	; Falling when not small
PF_FASTJUMPBIG		= $38	; "Fast" jump frame when not small
PF_JUMPFALLSMALL	= $40	; Standard jump/fall frame when small
PF_FASTJUMPFALLSMALL	= $4E	; "Fast" jump/fall frame when small
PF_JUMPBIG		= $4F	; Jump as not small (except raccoon)
PF_JUMPRACCOON		= $50	; Jump frame as raccoon
PF_SOMERSAULT_BASE	= $1A	; $1A-$1D Invincibility somersault base frame

; Walking frames
PF_WALKSMALL_BASE	= $3E	; $3E-$3F Base frame of walking while "small"
PF_WALKBIG_BASE		= $0C	; $0C-$0E Base frame of walking while big/fire/hammer
PF_WALKSPECIAL_BASE	= $00	; $00-$02 Base frame of walking as Raccoon, Frog, or Tanooki
PF_FROGHOP_BASE		= $15	; $15-$17 Base frame for frog suit hopping along

; In-pipe frames
PF_INPIPE_SMALL		= $32	; "Small", in pipe
PF_INPIPE_SMALLKURIBO	= $43	; "Small", in pipe with Kuribo's shoe
PF_INPIPE_BIG		= $05	; "Not small", in pipe
PF_INPIPE_BIGKURIBO	= $18	; "Not small", in pipe with Kuribo's shoe

; Swim frames
PF_SWIMACTIVE_SMALL	= $46	; $46-$48 Base frame of actively swimming while small
PF_SWIMACTIVE_BIG	= $34	; $34-$36 Base frame of actively swimming while not small

PF_FROGSWIM_UPBASE	= $12	; $12-$14 Base frame for frog suit swimming up
PF_FROGSWIM_IDLEBASE	= $1F	; $1F-$20 Base frame for idling frog suit in the water (kick kick kick ...)
PF_FROGSWIM_LRBASE	= $21	; $21-$23 Base frame for frog suit swimming left/right
PF_FROGSWIM_DOWNBASE	= $24	; $24-$26 Base frame for frog suit swimming down

; Swim frames
PF_SWIMIDLE_SMALL	= $46	; $46,$49 Base frame of idle swimming while small
PF_SWIMIDLE_BIG		= $3C	; $34,$3C-$3D Base frame of idle swimming while not small

; Tail attack frames
PF_TAILATKGROUND_BASE	= $03	; $03-$05 Base frame of tail attack while on the ground
PF_TAILATKINAIR_BASE	= $09	; $04,$05,$09 Base frame of tail attack while in the air (okay not really the "base" I guess)

; Kuribo's Shoe
PF_KURIBO_SMALL		= $43	; Kuribo's shoe when small
PF_KURIBO_BIG		= $18	; Kuribo's shoe when big

; Ducking
PF_DUCK_NOTRACCOON	= $0F	; Ducking, not raccoon
PF_DUCK_RACCOON		= $07	; Ducking, raccoon

; Player throw (fire/hammer)
PF_THROWONGROUND_BASE	= $0E	; $0E,$10-$11 Base frame of throwing fire/hammer while on ground
PF_THROWINAIR_BASE	= $34	; $34-$36 Base frame oft hrowing fire/hammer while in air

; Player running spread-eagle
PF_RUNSMALL_BASE	= $4C	; $4C-$4D Base frame of running when small
PF_RUNBIG_BASE		= $39	; $39-$3B Base frame of running when not small

; Player tail wag
PF_TAILWAGFLY_BASE	= $36	; $36-$38 Base frame of flying tail wag
PF_TAILWAGFALL		= $08	; $08-$0A Base frame of fluttering tail wag

; Player holding frames
PF_HOLDSMALL_BASE	= $2E	; $2E-$2F Base frame of holding an object when small
PF_HOLDBIG_BASE		= $29	; $29-$2B Base frame of holding an object when not small

; Player spinning around (inside the desert land twister) (I don't like the determination by "suits that can slide", but that's what it is)
PF_SPINSMALLORFROG_BASE	= $32	; $32,$3E Base frame of "spinning" when small or in frog suit
PF_SPINSLIDESUITS_BASE	= $04	; $04-$05,$0E Base frame of "spinning" when in a suit that can slide (I guess that's just not hammer then)
PF_SPINOTHER_BASE	= $02	; $02,$04-$05 Base frame of "spinning" when in a suit that can't slide (just hammer suit I think)

; Airship "caught anchor" frame or general vine climbing (animation is mirroring this frame)
PF_CLIMB_SMALL		= $4A	; When small
PF_CLIMB_FROG		= $28	; When frog
PF_CLIMB_BIG		= $2C	; Otherwise


; Velocity affects for Player -- note they are in 4.4 fixed point, so divide them by 16 for pixels/frame
PLAYER_TOPWALKSPEED	= $18	; Highest X velocity considered as Player "walking"
PLAYER_TOPRUNSPEED	= $28	; Highest X velocity when Player runs
PLAYER_TOPPOWERSPEED	= $38	; Highest X velocity hit when Player is at full "power"
PLAYER_MAXSPEED		= $40	; Player's maximum speed
PLAYER_JUMP		= -$38	; Player's root Y velocity for jumping (further adjusted a bit by Player_SpeedJumpInc)
PLAYER_TAILWAG_YVEL	= $10	; The Y velocity that the tail wag attempts to lock you at
PLAYER_FLY_YVEL		= -$18	; The Y velocity the Player flies at
PLAYER_SWIMSTART_YVEL	= -$20	; The Y velocity the Player starts swimming at (or applied when sinking too fast)
PLAYER_SWIM_YVEL	= $20	; The swim Y velocity the rest of the time
PLAYER_FROG_MAXYVEL	= -$20

; Applies only to objects following Object_Move's standard movements, but most write their own physics
OBJECT_FALL		= $03
OBJECT_FALLINWATER	= $01
OBJECT_MAXFALL		= $40
OBJECT_MAXFALLINWATER	= $10
OBJECT_MAXWATERUPWARD	= -$18
OBJECT_FALLRATE		= $03
OBJECT_FALLRATEINWATER	= $01

; Some key map tiles defined
TILE_MARIOCOMP_P	= $00	; Mario Completed, standard panel
TILE_LUIGICOMP_P	= $01	; Luigi Completed, standard panel
TILE_PANEL1		= $03	; Level Panel 1
TILE_MARIOCOMP_O	= $40	; Mario Completed, orange color
TILE_LUIGICOMP_O	= $41	; Luigi Completed, orange color
TILE_HORZPATH		= $45	; Standard horizontal path
TILE_VERTPATH		= $46	; Standard vertical path
TILE_DOCK		= $4B	; Docking spot for canoe
TILE_BORDER3		= $4E
TILE_BORDER1		= $4F
TILE_TOADHOUSE		= $50	; Toad House
TILE_ROCKBREAKH		= $51	; Rock which breaks into horizontal path
TILE_ROCKBREAKV		= $52	; Rock which breaks into vertical path
TILE_ROCK		= $53	; Rock which does not break
TILE_LOCKVERT		= $54	; Mini-Fortress lock, removed to vertical path

TILE_LOCKHORZ		= $56	; Mini-Fortress lock, removed to horizontal path
TILE_SPIRAL		= $5F	; World 5 Spiral Castle
TILE_FORTRUBBLE		= $60	; Mini-Fortress Rubble
TILE_PATHANDNUB		= $66	; Path with nub (I think this is unused... in fact, you can "enter" it!)
TILE_FORT		= $67	; Mini-Fortress
TILE_LARGEFORT		= $6A	; UNUSED "Large Fortress" tile (usually gets visually corrupt by map animation)
TILE_MARIOCOMP_G	= $80	; Mario Completed, green color
TILE_LUIGICOMP_G	= $81	; Luigi Completed, green color
TILE_WATER_INVT		= $82	; Water meeting at inverted 'T' shape
TILE_RIVERVERT		= $9D	; Vertical river segment (gets bridged)
TILE_VERTPATHWLU	= $AA	; Standard vertical path over water, land on upper
TILE_VERTPATHWLL	= $AB	; Standard vertical path over water, land on lower
TILE_HORZPATHW		= $AC	; Standard horizontal path over water
TILE_VERTPATHW		= $B0	; Standard vertical path over water
TILE_DRAWBRIDGEV	= $B1	; World 3 Draw Bridge (Vertical)
TILE_DRAWBRIDGEH	= $B2	; World 3 Draw Bridge (Horizontal)
TILE_BRIDGE		= $B3	; Bridge
TILE_DANCINGBUSH	= $B4	; Dancing Bush
TILE_HORZPATHWLL	= $B7	; Standard horizontal path over water, land on left end
TILE_HORZPATHWLR	= $B8	; Standard horizontal path over water, land on right end
TILE_HORZPATHWLB	= $B9	; Standard horizontal path over water, land on both ends
TILE_VERTPATHWLB	= $BA	; Standard vertical path over water, land on both ends
TILE_DANCINGPALM	= $BB	; Dancing Palm Tree (World 2)
TILE_PIPE		= $BC	; Pipe
TILE_DANCINGFLOWER	= $BD	; Dancing Flower
TILE_POOL		= $BF	; Pool / Oasis
TILE_MARIOCOMP_R	= $C0	; Mario Completed, red color
TILE_LUIGICOMP_R	= $C1	; Luigi Completed, red color
TILE_CASTLEBOTTOM	= $C9	; Bottom of world castle
TILE_BOWSERCASTLELL	= $CC	; Bowser's castle lower left
TILE_HORZPATHSKY	= $DA	; World 5 Sky Horizontal path
TILE_VERTPATHSKY	= $DB	; World 5 Sky Vertical path
TILE_ALTSPIRAL		= $DF	; World 5 Spiral Castle Alternate Color (not used)
TILE_ALTTOADHOUSE	= $E0	; Alternate color Toad House
TILE_ALTRUBBLE		= $E3	; Alternate color Mini-Fortress Rubble
TILE_ALTLOCK		= $E4	; Alternate color lock
TILE_START		= $E5	; START panel
TILE_HANDTRAP		= $E6	; World 8 Hand Trap
TILE_BORDER2		= $E7
TILE_SPADEBONUS		= $E8	; Spade bonus panel
TILE_WORLD5STAR		= $E9	; Star used on World 5 Sky map
TILE_ALTFORT		= $EB	; Alternate color Mini-Fortress


; Commons (not really comprehensive)
TILEA_NOTEINVIS		= $03	; Invisible (until hit) note block
TILEA_PSWITCHCOIN	= $05	; Coins invisible unless P-Switch is active

TILEA_NOTE		= $2E	; Standard note block
TILEA_NOTEFLOWER	= $2F	; Note block with fire flower
TILEA_NOTELEAF		= $30	; Note block with leaf
TILEA_NOTESTAR		= $31	; Note block with star
TILEA_ICEBRICK		= $32	; Ice block

TILEA_ICEBLOCK		= $32

TILEA_COIN		= $40	; Coin
TILEA_COINREMOVED	= $41	; Tile used after coin has been collected
TILEA_DOOR1		= $42	; Doorway 1, typically black in appearance (apparently wired to only work in fortresses)
TILEA_DOOR2		= $43	; Doorway 2, typically red in appearance
TILEA_INVISCOIN		= $44	; Invisible coin block
TILEA_INVIS1UP		= $45	; Invisible 1-up
TILEA_NOTECOINHEAVEN	= $46	; Placeholder for invisible note block that takes you to coin heaven

TILEA_BLOCKEMPTY	= $5F	; Used up ? block type empty block

TILEA_QBLOCKFLOWER	= $60	; ? block with fire flower
TILEA_QBLOCKLEAF	= $61	; ? block with leaf
TILEA_QBLOCKSTAR	= $62	; ? block with star
TILEA_QBLOCKCOIN	= $63	; ? block with coin
TILEA_QBLOCKCOINSTAR	= $64	; ? block with coin OR star
TILEA_QBLOCKCOIN2	= $65	; ? block with coin (again??)
TILEA_MUNCHER		= $66	; Muncher plant!
TILEA_BRICK		= $67	; Standard brick
TILEA_BRICKFLOWER	= $68	; Brick containing fire flower
TILEA_BRICKLEAF		= $69	; Brick containing leaf
TILEA_BRICKSTAR		= $6A	; Brick containing star
TILEA_BRICKCOIN		= $6B	; Brick containing single coin
TILEA_BRICKCOINSTAR	= $6C	; Brick containing single coin OR star
TILEA_BRICK10COIN	= $6D	; Brick with 10 coins
TILEA_BRICK1UP		= $6E	; Brick with 1-up
TILEA_BRICKVINE		= $6F	; Brick with vine
TILEA_BRICKPSWITCH	= $70	; Brick with P Switch
TILEA_HNOTE		= $71	; Coin Heaven launcher note block
TILEA_WOODBLOCKBOUNCE	= $72	; Wood block which bounces (no contents)
TILEA_WOODBLOCKFLOWER	= $73	; Wood block which bounces and contains fire flower
TILEA_WOODBLOCKLEAF	= $74	; Wood block which bounces and contains leaf
TILEA_WOODBLOCKSTAR	= $75	; Wood block which bounces and contains star

TILEA_WOODBLOCK		= $79	; Standard solid wood block

TILEA_GNOTE		= $BC	; Green note block (functions like standard white, just colored wrong)

TILEA_PSWITCH_BLANK	= $C1	; Blank tile used to hide a P-Switch after it has been used on level reload

TILEA_PATH_HORZ		= $C8	; Horizontal path (typical)
TILEA_PATH_VERT		= $C9	; Vertical path (typical)
TILEA_PATH_45T2B	= $CA	; 45 degree path top-to-bottom (typical)
TILEA_PATH_45B2T	= $CB	; 45 degree path bottom-to-top (typical)
TILEA_PATH_625T2B_U	= $CC	; 62.5 degree path top-to-bottom, upper half (typical)
TILEA_PATH_625T2B_L	= $CD	; 62.5 degree path top-to-bottom, lower half (typical)
TILEA_PATH_625B2T_U	= $CE	; 62.5 degree path bottom-to-top, upper half (typical)
TILEA_PATH_625B2T_L	= $CF	; 62.5 degree path bottom-to-top, lower half (typical)

TILEA_PSWITCH_PRESSED	= $D7	; Referenced pressed P-Switch
TILEA_PSWITCH		= $F2	; P-Switch
TILEA_BLOCKBUMP_CLEAR	= $F3	; Tile used when a "bump" block (e.g. ? blocks, note block, etc.) is hit

; Tileset 1 (Plains style)
TILE1_GOALBLACK		= $00	; Black background of goal area
TILE1_GOALEDGE		= $01	; > shape goal edge
TILE1_SKYALT		= $02	; ?? Referenced, appears as sky?

TILE1_LITTLEFENCE	= $04	; Little fence (runs atop the 'oo' type cheep-cheep bridge)
TILE1_LILBGCLOUD	= $06	; Little background cloud
TILE1_WBLOCKLV		= $07	; White big block left vertical runner
TILE1_WBLOCKRV		= $08	; White big block right vertical runner
TILE1_WBLOCKM		= $09	; White big block center
TILE1_WBLOCKBH		= $0A	; White big block bottom horizontal runner
TILE1_WBLOCK_SHUR	= $0B	; White big block shadowed on by another
TILE1_WBLOCKSM		= $0C	; White big block shadow middle
TILE1_WBLOCKLL		= $0D	; White big block lower-left
TILE1_WBLOCKLR		= $0E	; White big block lower-right
TILE1_WBLOCKSB		= $0F	; White big block shadow bottom

TILE1_PUPCLOUD_M	= $10	; "Power Up Cloud" Mushroom
TILE1_PUPCLOUD_F	= $11	; "Power Up Cloud" Flower
TILE1_PUPCLOUD_S	= $12	; "Power Up Cloud" Star

TILE1_CLOUD_UL		= $1F	; Cloud upper left
TILE1_CLOUD_UM		= $20	; Cloud upper middle
TILE1_CLOUD_UR		= $21	; Cloud upper right
TILE1_CLOUD_LL		= $22	; Cloud lower left
TILE1_CLOUD_LM		= $23	; Cloud lower middle
TILE1_CLOUD_LR		= $24	; Cloud lower right

TILE1_WBLOCKUL		= $26	; White big block upper-left
TILE1_WBLOCKTH		= $25	; White big block top horizontal runner
TILE1_WBLOCKUR		= $27	; White big block upper-right

TILE1_JCLOUD		= $2C	; Judgem's style cloud, solid on top only
TILE1_JCLOUDSOLID	= $2D	; Judgem's style cloud, solid all around

TILE1_OBLOCKLV		= $47	; Orange big block left vertical runner
TILE1_OBLOCKRV		= $48	; Orange big block right vertical runner
TILE1_OBLOCKM		= $49	; Orange big block center
TILE1_OBLOCKBH		= $4A	; Orange big block bottom horizontal runner
TILE1_OBLOCK_SHUR	= $4B	; Orange big block shadowed on by another
TILE1_OBLOCKSM		= $4C	; Orange big block shadow middle
TILE1_OBLOCKLL		= $4D	; Orange big block lower-left
TILE1_OBLOCKLR		= $4E	; Orange big block lower-right
TILE1_OBLOCKSB		= $4F	; Orange big block shadow bottom
TILE1_OBLOCKUL		= $51	; Orange big block upper-left
TILE1_OBLOCKTH		= $50	; Orange big block top horizontal runner
TILE1_OBLOCKUR		= $52	; Orange big block upper-right

TILE1_GROUNDTM		= $53	; Ground top middle
TILE1_GROUNDMM		= $54	; Ground middle-middle
TILE1_GROUNDTL		= $55	; Ground top left
TILE1_GROUNDML		= $56	; Ground middle-left
TILE1_GROUNDTR		= $57	; Ground top right
TILE1_GROUNDMR		= $58	; Ground middle-right

TILE1_CANNONTOP1	= $76	; Upper top of cannon
TILE1_CANNONTOP2	= $77	; Lower top of cannon
TILE1_CANNONMID		= $78	; Mid part to ground

TILE1_SANDTOP		= $7A	; Solid sand ground, top
TILE1_SANDMID		= $7B	; Solid sand ground, middle

TILE1_SKY		= $80	; Official sky tile

TILE1_VINE		= $85	; Vine
TILE1_LITTLE_BUSH	= $86	; The little green bush

TILE1_GBLOCKLV		= $87	; Green big block left vertical runner
TILE1_GBLOCKRV		= $88	; Green big block right vertical runner

TILE1_GBLOCKM		= $89	; Green big block center
TILE1_GBLOCKBH		= $8A	; Green big block bottom horizontal runner
TILE1_GBLOCK_SHUR	= $8B	; Green big block shadowed on by another
TILE1_GBLOCKSM		= $8C	; Green big block shadow middle
TILE1_GBLOCKLL		= $8D	; Green big block lower-left
TILE1_GBLOCKLR		= $8E	; Green big block lower-right
TILE1_GBLOCKSB		= $8F	; Green big block shadow bottom

TILE1_BUSH_UL		= $90	; Bush upper left
TILE1_BUSH_UR		= $91	; Bush upper right
TILE1_BUSH_FUL		= $92	; Bush front (of another bush) upper left
TILE1_BUSH_FUR		= $93	; Bush front (of another bush) upper right
TILE1_BUSH_BL		= $94	; Bush bottom/middle left
TILE1_BUSH_BR		= $95	; Bush bottom/middle right
TILE1_BUSH_FBL		= $96	; Bush front (of another bush) bottom left
TILE1_BUSH_FBR		= $97	; Bush front (of another bush) bottom right
TILE1_BUSH_MID		= $98	; Bush middle
TILE1_BUSH_SUL		= $99	; Bush shadowed upper left
TILE1_BUSH_SUR		= $9A	; Bush shadowed upper right
TILE1_BUSH_SFUL		= $9B	; Bush shadowed front (of another bush) upper left
TILE1_BUSH_SFUR		= $9C	; Bush shadowed front (of another bush) upper right
TILE1_BUSH_SHUR		= $9D	; Bush with shadow of big block
TILE1_BUSH_SBL		= $9E	; Bush shadowed bottom/middle left
TILE1_BUSH_SBR		= $9F	; Bush shadowed bottom/middle right

TILE1_GBLOCKTH		= $A0	; Green big block top horizontal runner
TILE1_GBLOCKUL		= $A1	; Green big block upper-left
TILE1_GBLOCKUR		= $A2	; Green big block upper-right

TILE1_PIPETB1_L		= $AD	; Pipe top/bottom 1 left (alt level)
TILE1_PIPETB1_R		= $AE	; Pipe top/bottom 1 right
TILE1_PIPETB2_L		= $AF	; Pipe top/bottom 2 left (Big [?] area)
TILE1_PIPETB2_R		= $B0	; Pipe top/bottom 2 right
TILE1_PIPETB3_L		= $B1	; Pipe top/bottom 3 left (not enterable)
TILE1_PIPETB3_R		= $B2	; Pipe top/bottom 3 right
TILE1_PIPETB4_L		= $B3	; Pipe top/bottom 4 left (within level transit)
TILE1_PIPETB4_R		= $B4	; Pipe top/bottom 4 right
TILE1_PIPEH1_B		= $B5	; Pipe horizontal 1 bottom (alt level)
TILE1_PIPEH2_B		= $B6	; Pipe horizontal 2 bottom (not enterable)
TILE1_PIPEH_T		= $B7	; Pipe horizontal top (common)
TILE1_PIPEHT		= $B8	; Pipe horizontal middle top
TILE1_PIPEHB		= $B9	; Pipe horizontal middle bottom
TILE1_PIPEVL		= $BA	; Pipe middle vertical left
TILE1_PIPEVR		= $BB	; Pipe middle vertical right

TILE1_BLOCK_SHUR	= $C0	; Big block shadow upper-right
TILE1_BLOCK_SHUL	= $C1	; Big block shadow upper-left (actually none, also used as a cleared P-Switch on level reload, AKA TILEA_PSWITCH_BLANK)
TILE1_BLOCK_SHLL	= $C2	; Big block shadow lower-left
TILE1_BLOCK_SHLR	= $C3	; Big block shadow lower-right
TILE1_BLOCK_SHADOW	= $C4	; Big block general side-shadow
TILE1_BLOCK_SHADOWB	= $C5	; Big block general bottom shadow
TILE1_BBLOCKLV		= $C7	; Blue big block left vertical runner
TILE1_BBLOCKRV		= $C8	; Blue big block right vertical runner
TILE1_BBLOCKM		= $C9	; Blue big block center
TILE1_BBLOCKBH		= $CA	; Blue big block bottom horizontal runner
TILE1_BBLOCK_SHUR	= $CB	; Blue big block shadowed on by another
TILE1_BBLOCKSM		= $CC	; Blue big block shadow middle
TILE1_BBLOCKLL		= $CD	; Blue big block lower-left
TILE1_BBLOCKLR		= $CE	; Blue big block lower-right
TILE1_BBLOCKSB		= $CF	; Blue big block shadow bottom

TILE1_WATERBUMPS1	= $D8	; Water ... not sure how to describe it
TILE1_WATERBUMPS2	= $D9	; Water ... not sure how to describe it
TILE1_WATERBUMPSSH	= $D9	; Water ... not sure how to describe it, shaded
TILE1_WATERWAVEL	= $DB	; Water waving to the left
TILE1_WATERWAVE		= $DC	; Water waving but with no apparent current
TILE1_WATERWAVER	= $DD	; Water waving to the right

TILE1_WATER		= $DE	; Water

TILE1_WFALLTOP		= $E0	; Top of waterfall
TILE1_WFALLMID		= $E1	; Middle of water, extending downward

TILE1_BBLOCKUL		= $E3	; Blue big block upper-left
TILE1_BBLOCKTH		= $E2	; Blue big block top horizontal runner
TILE1_BBLOCKUR		= $E4	; Blue big block upper-right

TILE1_DIAMOND		= $F0	; Diamond block
TILE1_CCBRIDGE		= $F1	; Cheep-cheep 'oo' bridge
TILE1_WGROUNDTM		= $F4	; Underwater ground top middle
TILE1_WGROUNDMM		= $F5	; Underwater ground middle-middle
TILE1_WGROUNDTL		= $F6	; Underwater ground top left
TILE1_WGROUNDML		= $F7	; Underwater ground middle-left
TILE1_WGROUNDTR		= $F8	; Underwater ground top right
TILE1_WGROUNDMR		= $F9	; Underwater ground middle-right


; Tileset 2 (Fortress style)
TILE2_BLACK		= $02	; Solid black background

TILE2_WINDOWTOP		= $06	; Top of window
TILE2_WINDOWMID		= $07	; Middle of window
TILE2_WINDOWBOT		= $08	; Bottom of window

; NOTE: The path (for a moving platform to follow) is typically a
; different value for every Level_Tileset EXCEPT 2)
TILE2_PATH_HORZ		= $09	; Horizontal path (TS 2 only)
TILE2_PATH_VERT		= $0A	; Vertical path (TS 2 only)
TILE2_PATH_45T2B	= $0B	; 45 degree path top-to-bottom (TS 2 only)
TILE2_PATH_45B2T	= $0C	; 45 degree path bottom-to-top (TS 2 only)
TILE2_PATH_625T2B_U	= $0D	; 62.5 degree path top-to-bottom, upper half (TS 2 only)
TILE2_PATH_625T2B_L	= $0E	; 62.5 degree path top-to-bottom, lower half (TS 2 only)
TILE2_PATH_625B2T_U	= $0F	; 62.5 degree path bottom-to-top, upper half (TS 2 only)
TILE2_PATH_625B2T_L	= $10	; 62.5 degree path bottom-to-top, lower half (TS 2 only)

TILE2_GHOSTL		= $11	; Ghost block left
TILE2_GHOSTM		= $12	; Ghost block middle
TILE2_GHOSTR		= $13	; Ghost block right

TILE2_CHECKERBOARDUL	= $14	; Checkerboard floor pattern, upper left
TILE2_CHECKERBOARDUR	= $15	; Checkerboard floor pattern, upper right
TILE2_CHECKERBOARDLL	= $16	; Checkerboard floor pattern, lower left
TILE2_CHECKERBOARDLR	= $17	; Checkerboard floor pattern, lower right


TILE2_CONVEYORL		= $34	; Conveyor left

TILE2_CONVEYORR		= $35	; Conveyor right

TILE2_UNSURE		= $5A	; Not sure??  Complements TILE2_GHOST*
TILE2_DONUTLIFT		= $5B	; Donut lift

TILE2_PILLAR_T		= $81	; Background pillar top
TILE2_PILLAR_M		= $82	; Background pillar middle
TILE2_PILLAR_B		= $83	; Background pillar bottom

TILE2_PILLARSHADOW_T	= $84	; Background pillar top, shadowed
TILE2_PILLARSHADOW_M	= $86	; Background pillar middle, shadowed
TILE2_PILLARSHADOW_B	= $87	; Background pillar bottom, shadowed


TILE2_HANGGLOBE_TOP	= $88	; Cable ceiling connector for hanging globe thing
TILE2_HANGGLOBE_CABLE	= $89	; Cable for hanging globe thing
TILE2_HANGGLOBE_GLOBE	= $8A	; Hanging globe thing

TILE2_BGBRICK_SHADOW2	= $8B	; Background brickwork pattern, shadowed (same as $8F?)
TILE2_BGBRICK_NOSHADOW	= $8C	; Background brickwork pattern, non-shadowed
TILE2_BGBRICK_LSHADOW	= $8D	; Background brickwork pattern, shadowed on left
TILE2_BGBRICK_TOPSHADOW	= $8E	; Background brickwork pattern, shadowed on top
TILE2_BGBRICK_SHADOW	= $8F	; Background brickwork pattern, shadowed

TILE2_BGBRICK_UNDBRICK	= $90	; Background brickwork pattern, under the TILE2_SOLIDBRICK
TILE2_BGBRICK_LDSHADOW	= $91	; Background brickwork pattern, dark shadowed left
TILE2_BGBRICK_ULDSHADOW	= $92	; Background brickwork pattern, dark shadowed upper-left
TILE2_BGBRICK_TOPDSHADOW= $93	; Background brickwork pattern, dark shadowed on top

TILE2_LAVATOP		= $94	; Top lava tile
TILE2_LAVABOTTOM	= $95	; Bottom lava tile

TILE2_ENDDOOR_UL	= $97	; The final door to the princess, upper left
TILE2_ENDDOOR_UR	= $98	; The final door to the princess, upper right
TILE2_ENDDOOR_LL	= $99	; The final door to the princess, lower left
TILE2_ENDDOOR_LR	= $9A	; The final door to the princess, lower right

TILE2_CANDLE		= $9B	; Candle (for Hot Foot)
TILE2_SOLIDBRICK	= $9C	; Solid Bowser's Castle style brick
TILE2_DARKREDDIAMOND	= $9D	; Dark red diamond block
TILE2_ROTODISCBLOCK	= $9E	; Roto disc block

TILE2_SHADOW		= $A2	; Black

TILE2_SPIKEUP		= $E2	; Spikes pointing upward
TILE2_SPIKEDOWN		= $E3	; Spikes pointing downward
TILE2_DIAMONDBRIGHT	= $E4	; Bright color diamond block
TILE2_DIAMONDDARK	= $E5	; Dark color diamond block

TILE2_BOWSERSTATUEU	= $E8	; Bowser statue upper
TILE2_BOWSERSTATUEL	= $E9	; Bowser statue lower

TILE2_SOLIDBLACK	= $F4	; Black tile which is solid


; Tileset 3 (Hills style)
TILE3_UNK2		= $88	; Background referenced, but unknown; possibly belongs to another tileset?
TILE3_UNK3		= $89	; Background referenced, but unknown; possibly belongs to another tileset?
TILE3_UNK		= $C0	; Background referenced, but unknown; possibly belongs to another tileset?


TILE3_SKY		= $02	; Sky

TILE3_CLOUD_UL		= $06	; Cloud upper left
TILE3_CLOUD_UM		= $07	; Cloud upper middle
TILE3_CLOUD_UR		= $08	; Cloud upper right
TILE3_CLOUD_LL		= $09	; Cloud lower left
TILE3_CLOUD_LM		= $0A	; Cloud lower middle
TILE3_CLOUD_LR		= $0B	; Cloud lower right
TILE3_LILCLOUD		= $0C	; Little BG cloud

TILE3_ALTDIAMOND	= $48	; Alternate diamond type block, not apparently used (a blue version at $F0 is, but not this one!)
TILE3_QUICKSAND_TOP	= $49	; Quicksand top
TILE3_QUICKSAND_MID	= $4A	; Quicksand middle

TILE3_BGBUSH_L		= $81	; Background bush left
TILE3_BGBUSH_M		= $82	; Background bush middle
TILE3_BGBUSH_R		= $83	; Background bush right
TILE3_UNDERGROUND	= $86	; Underground speckled
TILE3_TUNNEL		= $87	; "Tunnel" under grassy ground
TILE3_SLOPE45B2T	= $99	; 45 degree slope, bottom-to-top
TILE3_HORZGROUND	= $9A	; Horizontal ground
TILE3_SLOPE45T2B	= $9B	; 45 degree slope, top-to-bottom
TILE3_SLOPE225B2T_L	= $9C	; 22.5 degree slope, bottom-to-top, lower
TILE3_SLOPE225B2T_U	= $9D	; 22.5 degree slope, bottom-to-top, upper
TILE3_SLOPE225T2B_U	= $9E	; 22.5 degree slope, top-to-bottom, lower
TILE3_SLOPE225T2B_L	= $9F	; 22.5 degree slope, top-to-bottom, upper
TILE3_CEILING		= $A6	; Ceiling
TILE3_ULCORNERGROUND	= $A7	; Upper left corner ground
TILE3_VERTGROUNDL	= $A8	; Vertical ground, left edge
TILE3_URCORNERGROUND	= $A9	; Upper right corner ground
TILE3_VERTGROUNDR	= $AA	; Vertical ground, right edge
TILE3_MIDGROUND		= $AB	; Middle ground
TILE3_LLCORNERGROUND	= $AC	; Lower left corner ground

TILE3_PIPETB5_L		= $BD	; Pipe top/bottom 5 left (exit to common end area)
TILE3_PIPETB5_R		= $BE	; Pipe top/bottom 5 right (exit to common end area)

TILE3_LRCORNERGROUND	= $BF	; Lower right corner ground

TILE3_WATERTOP		= $C2	; Top of water
TILE3_WATER		= $C3	; Mid water

TILE3_WSLOPE45B2T	= $E2	; Underwater 45 degree slope, bottom-to-top
TILE3_WHORZGROUND	= $E3	; Underwater Horizontal ground
TILE3_WSLOPE45T2B	= $E4	; Underwater 45 degree slope, top-to-bottom
TILE3_WSLOPE225B2T_L	= $E5	; Underwater 22.5 degree slope, bottom-to-top, lower
TILE3_WSLOPE225B2T_U	= $E6	; Underwater 22.5 degree slope, bottom-to-top, upper
TILE3_WSLOPE225T2B_U	= $E7	; Underwater 22.5 degree slope, top-to-bottom, lower
TILE3_WSLOPE225T2B_L	= $E8	; Underwater 22.5 degree slope, top-to-bottom, upper
TILE3_WCEILING		= $F4	; Underwater ceiling
TILE3_WCORNER_UL	= $F5	; Underwater upper-left corner ground
TILE3_WVERTGROUND_L	= $F6	; Underwater vertical ground, left edge
TILE3_WCORNER_UR	= $F7	; Underwater upper-right corner ground
TILE3_WVERTGROUND_R	= $F8	; Underwater vertical ground, right edge
TILE3_WMIDGROUND	= $F9	; Underwater middle ground
TILE3_WCORNER_LL	= $FA	; Underwater lower-left corner ground
TILE3_WCORNER_LR	= $FB	; Underwater lower-right corner ground


; Tileset 4 (High-Up style, technically shares with Tileset 12)
TILE4_LONGCLOUD_UL	= $02	; Long cloud upper left
TILE4_LONGCLOUD_UM	= $06	; Long cloud upper middle
TILE4_LONGCLOUD_UR	= $07	; Long cloud upper right
TILE4_LONGCLOUD_LL	= $1F	; Long cloud lower left
TILE4_LONGCLOUD_LM	= $20	; Long cloud lower middle
TILE4_LONGCLOUD_LR	= $21	; Long cloud lower right

TILE4_FATTRUNK		= $47	; Fat trunk (?) tile

TILE4_LONGWOOD_L	= $4A	; Long wooden block, left
TILE4_LONGWOOD_M	= $4B	; Long wooden block, middle
TILE4_LONGWOOD_R	= $4C	; Long wooden block, right

TILE4_LARGEWOOD_UL	= $4D	; Large wooden block, upper left
TILE4_LARGEWOOD_UM	= $4E	; Large wooden block, upper middle
TILE4_LARGEWOOD_UR	= $4F	; Large wooden block, upper right
TILE4_LARGEWOOD_LL	= $50	; Large wooden block, lower left
TILE4_LARGEWOOD_LM	= $51	; Large wooden block, lower middle
TILE4_LARGEWOOD_LR	= $52	; Large wooden block, lower right


; Unverified, this is actually garbage in Tileset 4
TILE4_LARGEBLOCK_LL	= $53	; Large platform, lower left
TILE4_LARGEBLOCK_LM	= $54	; Large platform, lower middle
TILE4_LARGEBLOCK_LR	= $55	; Large platform, lower right

TILE4_MUNCHER		= $66	; Muncher

TILE4_SKY		= $80	; Sky
TILE4_LITTLEBUSH	= $81	; Little background bush
TILE4_BUSHBUNCH_L	= $82	; Bush bunch left
TILE4_BUSHBUNCH_M	= $83	; Bush bunch middle
TILE4_BUSHBUNCH_R	= $84	; Bush bunch right

TILE4_SKY_STOPGEN	= $86	; Appears as sky, used to stop runaway "to ground" generators (I think)

TILE4_GREENBLOCK_LL	= $87	; Green platform, upper left
TILE4_GREENBLOCK_LM	= $88	; Green platform, upper middle
TILE4_GREENBLOCK_LR	= $89	; Green platform, upper right

TILE4_GREENBLOCK_UL	= $8A	; Green platform, upper left
TILE4_GREENBLOCK_UM	= $8B	; Green platform, upper middle
TILE4_GREENBLOCK_UR	= $8C	; Green platform, upper right

TILE4_UNKNOWN		= $8D	; UNKNOWN, referenced with TILE4_PLATFORMPULLER

TILE4_BGCLOUD_L		= $C0	; Wide BG cloud
TILE4_BGCLOUD_R		= $C2	; Wide BG cloud
TILE4_LILCLOUD		= $C3	; Little background cloud

TILE4_CABLE_MIDR	= $C4	; Suspension cable middle right side
TILE4_CABLE_CONR	= $C5	; Suspension cable connector right side
TILE4_CABLE_MIDL	= $C6	; Suspension cable middle left side
TILE4_CABLE_CONL	= $C7	; Suspension cable connector left side

TILE4_PLATFORMPULLER	= $D0	; Platform puller thingy


TILE4_JELECTRO		= $F4	; Jelectro


; Tileset 5 (World 7 plant infestations)
TILE5_SKY		= $80	; Common sky background tile
TILE5_MINIPIPE_TOP1	= $98	; Mini pipe top 1 (as seen in World 7 plant infested levels)
TILE5_MINIPIPE_MID	= $99	; Mini pipe mid section
TILE5_MINIPIPE_TOP2	= $9A	; Mini pipe top 2 (as seen in World 7 plant infested levels)
TILE5_PIPEH3_B		= $BF	; Pipe horizontal 3 bottom (not enterable)

TILE5_MUNCHER_1		= $C0	; Muncher 1 (the kind that move up and down the mini pipe)
TILE5_MUNCHER_2		= $C2	; Muncher 2 (the kind that move up and down the mini pipe)


; Tileset 6 (Water level)
TILE6_ORANGEBLK_UL	= $5D	; Orange block upper left
TILE6_ORANGEBLK_UM	= $5E	; Orange block upper middle
TILE6_ORANGEBLK_UR	= $7C	; Orange block upper right
TILE6_ORANGEBLK_LL	= $7D	; Orange block lower left
TILE6_ORANGEBLK_LM	= $7E	; Orange block lower middle
TILE6_ORANGEBLK_LR	= $7F	; Orange block lower right
TILE6_SKY		= $8A	; Sky
TILE6_WATERTOP		= $8B	; Top of water

TILE6_WATER		= $8C	; Water
TILE6_UNDERWATERPLANT_T	= $8F	; Underwater plant thing top
TILE6_UNDERWATERPLANT_M	= $90	; Underwater plant thing middle
TILE6_GRAYPLATFORM_MM	= $CF	; Gray platform mid middle
TILE6_UNDERWATERCIRCLE	= $E2	; Underwater circle thing
TILE6_GRAYPLATFORM_UL	= $E7	; Gray platform upper left
TILE6_GRAYPLATFORM_UM	= $E8	; Gray platform upper middle
TILE6_GRAYPLATFORM_UR	= $E9	; Gray platform upper right
TILE6_GRAYPLATFORM_ML	= $EA	; Gray platform mid left
TILE6_GRAYPLATFORM_MR	= $EB	; Gray platform mid right

; Tileset 7 (Toad house)
TILE7_BLACK		= $09	; The black background
TILE7_CHECKERBOARDUL	= $0A	; Checkerboard floor pattern, upper left
TILE7_CHECKERBOARDUR	= $0B	; Checkerboard floor pattern, upper right
TILE7_SKY		= $42	; Not visible, but appears as sky (or maybe the text box's BG?)
TILE7_TOADHOUSEBG	= $48	; Toad house background
TILE7_TOADHOUSEBGSHAD	= $49	; Toad house background, shadowed
TILE7_TOADHOUSEBGSHADUR	= $4A	; Toad house background, shadow upper-right
TILE7_TOADHOUSEBGSHADR	= $4B	; Toad house background, shadow right
TILE7_CHEST_UL		= $81	; Toad house chest upper left

TILE7_CHEST_UR		= $82	; Toad house chest upper right
TILE7_CHEST_LL		= $83	; Toad house chest lower left
TILE7_CHEST_LR		= $84	; Toad house chest lower right
TILE7_CHEST_OPEN_UL	= $86	; Toad house chest opened upper left
TILE7_CHEST_OPEN_UR	= $87	; Toad house chest opened upper right
TILE7_MINICHEST		= $88	; UNUSED mini chest tile?!
TILE7_MINICHEST_OPEN	= $89	; UNUSED mini chest OPENED tile?!
TILE7_UNK		= $E3	; Unknown background block; unsure who'd use it anyway...
TILE7_TOADHOUSEBLOCK	= $E6	; Main building block of Toad House

; Tileset 8 (Vertical levels typical of World 7)
TILE8_SPIKE_DOWN	= $0C	; Downward pointing spikes
TILE8_SPIKE_UP		= $0D	; Upward pointing spikes
TILE8_PIPEELBOW_UL	= $4C	; Pipe elbow upper left
TILE8_PIPEELBOW_UR	= $4D	; Pipe elbow upper right
TILE8_PIPEELBOW_LL	= $4E	; Pipe elbow lower left
TILE8_PIPEELBOW_LR	= $4F	; Pipe elbow lower right
TILE8_PIPEELBOW_CUL	= $50	; Pipe elbow corner upper left
TILE8_PIPEELBOW_CUR	= $51	; Pipe elbow corner upper right
TILE8_PIPEELBOW_CLL	= $52	; Pipe elbow corner lower left
TILE8_PIPEELBOW_CLR	= $53	; Pipe elbow corner lower right
TILE8_ARROWLIFT_UPL	= $54	; Arrow lift UP left tile
TILE8_ARROWLIFT_UPR	= $55	; Arrow lift UP right tile
TILE8_ARROWLIFT_RIGHTL	= $56	; Arrow lift RIGHT left tile
TILE8_ARROWLIFT_RIGHTR	= $57	; Arrow lift RIGHT right tile
TILE8_ARROWLIFT_LEFTL	= $58	; Arrow lift LEFT left tile
TILE8_ARROWLIFT_LEFTR	= $59	; Arrow lift LEFT right tile
TILE8_ARROWLIFT_RANDOML	= $5A	; Arrow lift RANDOM left tile
TILE8_ARROWLIFT_RANDOMR	= $5C	; Arrow lift RANDOM right tile
TILE8_BLACK		= $80	; Black space
TILE8_SCENPIPE_ENDVL	= $91	; Scenery pipe end vertical left
TILE8_SCENPIPE_ENDVR	= $92	; Scenery pipe end vertical right
TILE8_MINIPIPE_VT	= $93	; Minipipe vertical top
TILE8_MINIPIPE_VM	= $94	; Minipipe vertical middle
TILE8_MINIPIPE_VB	= $95	; Minipipe vertical bottom
TILE8_MINIPIPE_HL	= $96	; Minipipe horizontal left
TILE8_MINIPIPE_HM	= $97	; Minipipe horizontal middle
TILE8_MINIPIPE_HR	= $98	; Minipipe horizontal right
TILE8_SCENPIPE_HT	= $99	; Scenery pipe horizontal top
TILE8_SCENPIPE_ENDH1T	= $9A	; Scenery pipe end horizontal 1 top
TILE8_SCENPIPE_ENDH2T	= $9B	; Scenery pipe end horizontal 2 top
TILE8_SCENPIPE_ENDH3T	= $9C	; Scenery pipe end horizontal 3 top
TILE8_SCENPIPE_ENDH1B	= $9E	; Scenery pipe end horizontal 1 bottom (level transit)
TILE8_SCENPIPE_ENDH2B	= $9F	; Scenery pipe end horizontal 2 bottom (no entry)
TILE8_SCENPIPE_HB	= $9D	; Scenery pipe horizontal bottom
TILE8_SCENPIPE_VL_HMC	= $A1	; Scenery pipe vertical left with horizontal minipipe crossing
TILE8_SCENPIPE_VR_HMC	= $A2	; Scenery pipe vertical right with horizontal minipipe crossing
TILE8_SCENPIPE_VL_HTC	= $A3	; Scenery pipe vertical left with horizontal top crossing
TILE8_SCENPIPE_VR_HTC	= $A4	; Scenery pipe vertical right with horizontal top crossing
TILE8_SCENPIPE_HT_VLC	= $A5	; Scenery pipe horizontal top with vertical left crossing
TILE8_SCENPIPE_HT_VRC	= $A6	; Scenery pipe horizontal top with vertical right crossing
TILE8_SCENPIPE_HT_VMC	= $A7	; Scenery pipe horizontal top with vertical minipipe crossing
TILE8_SCENPIPE_VL_HBC	= $A8	; Scenery pipe vertical left with horizontal bottom crossing
TILE8_SCENPIPE_VR_HBC	= $A9	; Scenery pipe vertical right with horizontal bottom crossing
TILE8_SCENPIPE_HB_VLC	= $AA	; Scenery pipe horizontal bottom with vertical left crossing
TILE8_SCENPIPE_HB_VRC	= $AB	; Scenery pipe horizontal bottom with vertical right crossing
TILE8_SCENPIPE_HB_VMC	= $AC	; Scenery pipe horizontal bottom with vertical minipipe crossing
TILE8_PIPEH3_B		= $BF	; Pipe horizontal 3 bottom (not enterable)
TILE8_BGPIPE_HT		= $C0	; Background pipe horizontal top
TILE8_BGPIPE_ENDHT	= $C2	; Background pipe horizontal end top
TILE8_BGPIPE_HB		= $C3	; Background pipe horizontal top
TILE8_BGPIPE_ENDHB	= $C4	; Background pipe horizontal end top
TILE8_BGPIPE_ENDVL	= $C5	; Background pipe vertical end left
TILE8_BGPIPE_ENDVR	= $C6	; Background pipe vertical end right
TILE8_BGPIPE_VL		= $C7	; Background pipe vertical left
TILE8_BGPIPE_VR		= $C8	; Background pipe vertical right
TILE8_BGPIPE_MVT	= $C9	; Background pipe minipipe vertical top
TILE8_BGPIPE_MVM	= $CA	; Background pipe minipipe vertical middle
TILE8_BGPIPE_MVB	= $CB	; Background pipe minipipe vertical bottom
TILE8_BGPIPE_MHL	= $CC	; Background pipe minipipe horizontal left
TILE8_BGPIPE_MHM	= $CD	; Background pipe minipipe horizontal middle
TILE8_BGPIPE_MHR	= $CE	; Background pipe minipipe horizontal right


; Tileset 9 (desert)
TILE9_THINGROUND_LEDGE	= $07	; blue thin ground left edge (UNUSED?)
TILE9_THINGROUND_REDGE	= $08	; blue thin ground right edge (UNUSED?)
TILE9_CLOUD_L		= $12	; Cloud left
TILE9_CLOUD_R		= $13	; Cloud right
TILE9_THINGROUND_BLUE	= $33	; blue thin ground (UNUSED?)
TILE9_PYRAMID_SLOPE	= $4C	; Pyramid sloped edge
TILE9_PYRAMID		= $4D	; Pyramid fill
TILE9_CHAIN_LEFT_PILLAR	= $51	; Pillar to left of the chain tile (no different than TILE9_CHAIN_RIGHT_PILLAR)
TILE9_CHAIN_LEFT	= $52	; Chain on left side (UNUSED?)
TILE9_CHAIN_RIGHT	= $53	; Chain on right side (UNUSED?)
TILE9_CHAIN_RIGHT_PILLAR= $54	; Pillar to right of the chain tile (no different than TILE9_CHAIN_LEFT_PILLAR)
TILE9_BRICK_UL		= $55	; Sand brick upper left
TILE9_BRICK_UM		= $56	; Sand brick upper middle (also desert ground)
TILE9_BRICK_UR		= $57	; Sand brick upper right
TILE9_BRICK_ML		= $58	; Sand brick middle left
TILE9_BRICK_MM		= $59	; Sand brick middle middle
TILE9_BRICK_MR		= $5A	; Sand brick middle right
TILE9_BRICK_LL		= $5B	; Sand brick lower left
TILE9_BRICK_LM		= $5C	; Sand brick lower middle
TILE9_BRICK_LR		= $5D	; Sand brick lower right
TILE9_SPIKEDOWN		= $7D	; Spikes pointing downward
TILE9_SPIKEUP		= $7E	; Spikes pointing upward
TILE9_BLOCK		= $7F	; A simple orange block
TILE9_SKY		= $80	; Sky
TILE9_BIGBLOCK_ML	= $81	; Big block middle left
TILE9_BIGBLOCK_MM	= $82	; Big block middle middle
TILE9_BIGBLOCK_MR	= $83	; Big block middle right
TILE9_BIGBLOCK_LL	= $84	; Big block lower left
TILE9_BIGBLOCK_LM	= $86	; Big block lower middle
TILE9_BIGBLOCK_LR	= $87	; Big block lower right
TILE9_THINVBLOCK_B	= $88	; Thin vertical block bottom
TILE9_PYRAMIDSH_SLOPE	= $8B	; Pyramid shaded sloped edge
TILE9_PYRAMIDSH		= $8C	; Pyramid shaded fill
TILE9_TREETOP_LEFT	= $8F	; Tree top left


TILE9_TREETOP_MIDDLE	= $90	; Tree top middle
TILE9_TREETOP_RIGHT	= $91	; Tree top right
TILE9_TREE		= $92	; Tree trunk
TILE9_CACTUS		= $93	; BG cactus
TILE9_ALTBACKGROUND	= $97	; Alternate background?
TILE9_BIGBLOCK_UL	= $98	; Big block upper left
TILE9_BIGBLOCK_UM	= $99	; Big block upper middle
TILE9_BIGBLOCK_UR	= $9A	; Big block upper right
TILE9_THINVBLOCK_T	= $9B	; Thin vertical block top
TILE9_THINHBLOCK_L	= $9C	; Thin horizontal block left

TILE9_THINHBLOCK_R	= $9D	; Thin horizontal block right
TILE9_PIPEWORKS_CRACK	= $C8	; Cracked pipe hole
TILE9_PIPEWORKS_GROUNDL	= $C9	; Pipeworks left ground connection
TILE9_PIPEWORKS_GROUNDR	= $CA	; Pipeworks right ground connection
TILE9_PIPEWORKS_JCT	= $E2	; Pipeworks breakable junction (UNUSED)
TILE9_PIPEWORKS_CORNER	= $E3	; Pipeworks corner
TILE9_PIPEWORKS_H	= $E4	; Pipeworks horizontal
TILE9_PIPEWORKS_V	= $E5	; Pipeworks vertical
TILE9_CANNONBLOCK	= $E6	; Block which surrounds cannon
TILE9_PIPEWORKS_GROUND	= $E7	; Pipeworks ground connection
TILE9_CANNONTOP1	= $ED	; Upper top of cannon
TILE9_CANNONTOP2	= $EE	; Lower top of cannon
TILE9_CANNONMID		= $ED	; Mid part to ground

; Tileset 10 (Airship)
TILE10_SKY		= $06	; Sky
TILE10_UPRIGHTCANNON_L	= $24	; Upright cannon pointing left
TILE10_UPRIGHTCANNON_R	= $25	; Upright cannon pointing right
TILE10_CEILINGCANNON_L	= $26	; Ceiling cannon pointing left
TILE10_CEILINGCANNON_R	= $27	; Ceiling cannon pointing right
TILE10_BIGCANNONMID_T	= $28	; Big cannon middle top
TILE10_BIGCANNONEND_T	= $29	; Big cannon end top
TILE10_BIGCANNONMID_B	= $2A	; Big cannon middle bottom
TILE10_BIGCANNONEND_B	= $2B	; Big cannon end bottom
TILE10_LILCANNON_END	= $2C	; Little cannon end
TILE10_LILCANNON_MID	= $2D	; Little cannon mid
TILE10_WARGROUND_UL	= $33	; "War ground" upper left
TILE10_WARGROUND_UR	= $34	; "War ground" upper right
TILE10_WARGROUND_LL	= $35	; "War ground" lower left
TILE10_WARGROUND_LR	= $36	; "War ground" lower right
TILE10_INVISSOLID	= $37	; Generally solid in other tilsets, invisible here?
TILE10_CRATE_ML		= $49	; Crate middle left
TILE10_CRATE_MM		= $4A	; Crate middle middle
TILE10_CRATE_MR		= $4B	; Crate middle right
TILE10_CRATE_LL		= $4C	; Crate lower left
TILE10_CRATE_LM		= $4D	; Crate lower middle
TILE10_CRATE_LR		= $4E	; Crate lower right
TILE10_SUPPORT_UL	= $4F	; Wooden supports upper left
TILE10_SUPPORT_UM	= $50	; Wooden supports upper middle
TILE10_SUPPORT_UR	= $51	; Wooden supports upper right
TILE10_SUPPORT_LL	= $52	; Wooden supports lower left
TILE10_SUPPORT_LM	= $53	; Wooden supports lower middle
TILE10_SUPPORT_LR	= $54	; Wooden supports lower right
TILE10_SUPPORT_ML	= $55	; Wooden supports middle left
TILE10_SUPPORT_MR	= $56	; Wooden supports middle right
TILE10_WOODFLOOR_THK_L	= $57	; Wood floor thick left
TILE10_WOODFLOOR_THK_R	= $58	; Wood floor thick right
TILE10_WOODFLOOR_1	= $59	; Wood floor misc 1
TILE10_WOODFLOOR_2	= $5A	; Wood floor misc 2
TILE10_WOODFLOOR_3	= $5B	; Wood floor misc 3
TILE10_CRATE_UL		= $5C	; Crate upper left
TILE10_CRATE_UM		= $5D	; Crate upper middle
TILE10_CRATE_UR		= $5E	; Crate upper right
TILE10_BLACK		= $80	; Black
TILE10_THREAD_H		= $81	; Thread horizontal
TILE10_THREAD_V		= $82	; Thread vertical
TILE10_SCREW_H		= $83	; Screw horizontal
TILE10_SCREW_V		= $84	; Screw vertical
TILE10_METALBG		= $86	; Metal background
TILE10_METSUPPORT_LT	= $87	; Metal support left top
TILE10_METSUPPORT_LM	= $88	; Metal support left mid
TILE10_METSUPPORT_LB	= $89	; Metal support left bottom
TILE10_METSUPPORT_RT	= $8A	; Metal support right top
TILE10_METSUPPORT_RM	= $8B	; Metal support right mid
TILE10_METSUPPORT_RB	= $8C	; Metal support right bottom
TILE10_METSUPPORT_ML	= $8D	; Metal support middle left
TILE10_METSUPPORT_MR	= $8E	; Metal support middle left
TILE10_METALPLATE_LL	= $8F	; Metal plate lower left
TILE10_METALPLATE_LM	= $90	; Metal plate lower middle
TILE10_METALPLATE_LR	= $91	; Metal plate lower right
TILE10_4WAYCANNON_90_UL	= $92	; 4-way cannon at 90 degrees upper left
TILE10_4WAYCANNON_90_UR	= $93	; 4-way cannon at 90 degrees upper right
TILE10_4WAYCANNON_90_LL	= $94	; 4-way cannon at 90 degrees lower left
TILE10_4WAYCANNON_90_LR	= $95	; 4-way cannon at 90 degrees lower right
TILE10_4WAYCANNON_45_UL	= $96	; 4-way cannon at 45 degrees upper left
TILE10_4WAYCANNON_45_UR	= $97	; 4-way cannon at 45 degrees upper right
TILE10_4WAYCANNON_45_LL	= $98	; 4-way cannon at 45 degrees lower left
TILE10_4WAYCANNON_45_LR	= $99	; 4-way cannon at 45 degrees lower right
TILE10_4WAYCANNON_MNT_L	= $9A	; 4-way cannon ceiling mount left
TILE10_4WAYCANNON_MNT_R	= $9B	; 4-way cannon ceiling mount right
TILE10_BOLT_V		= $9C	; Bolt vertical
TILE10_BOLT_H		= $9D	; Bolt horizontal
TILE10_METSUPPORT_UM	= $9E	; Metal support upper middle
TILE10_METSUPPORT_UL	= $9F	; Metal support upper left
TILE10_METSUPPORT_UR	= $A0	; Metal support upper right
TILE10_METSUPPORT_LL	= $A1	; Metal support lower left
TILE10_METSUPPORT_LR	= $A2	; Metal support lower right
TILE10_METALPLATE_UL	= $A3	; Metal plate upper left
TILE10_METALPLATE_UM	= $A4	; Metal plate upper middle
TILE10_METALPLATE_UR	= $A5	; Metal plate upper right
TILE10_FLAMEJET_H	= $A6	; Flamejet horizontal
TILE10_FLAMEJET_V	= $A7	; Flamejet vertical
TILE10_WALLCANNONF_UL	= $A8	; Wall cannon "forward" (a la the slash) upper left
TILE10_WALLCANNONF_LL	= $A9	; Wall cannon "forward" (a la the slash) lower left
TILE10_WALLCANNONF_UR	= $AA	; Wall cannon "forward" (a la the slash) upper right
TILE10_WALLCANNONF_LR	= $AB	; Wall cannon "forward" (a la the slash) lower right
TILE10_WALLCANNONB_UL	= $AC	; Wall cannon "backward" (a la the slash) upper left
TILE10_WALLCANNONB_UR	= $BD	; Wall cannon "backward" (a la the slash) upper right
TILE10_WALLCANNONB_LL	= $BE	; Wall cannon "backward" (a la the slash) lower left
TILE10_WALLCANNONB_LR	= $BF	; Wall cannon "backward" (a la the slash) lower right
TILE10_WOODUNDERCURVE_L	= $C0	; Wood underside curve left
TILE10_WOODUNDERCURVE_R	= $C2	; Wood underside curve right
TILE10_ROCKYWRENCH_HOLE	= $C3	; Rocky Wrench's hole
TILE10_ROPERAIL		= $C6	; Rope railing (near end pipe)
TILE10_ROPERAIL_END	= $C7	; Rope railing end
TILE10_STOWEDANCHOR	= $C8	; Stowed anchor at front of ship
TILE10_PORTHOLE		= $C9	; Port hole (circular window)
TILE10_WOODH_L		= $E2	; Wood log horizontal left
TILE10_WOODH_M1		= $E3	; Wood log horizontal middle 1
TILE10_WOODH_M2		= $E4	; Wood log horizontal middle 2
TILE10_WOODH_R		= $E5	; Wood log horizontal right
TILE10_WOODV_T		= $E6	; Wood log vertical top
TILE10_WOODV_M1		= $E7	; Wood log vertical middle 1
TILE10_WOODV_M2		= $E8	; Wood log vertical middle 2
TILE10_WOODV_B		= $E9	; Wood log vertical bottom
TILE10_WOODTHICK_UL	= $EA	; Wood thick upper left
TILE10_WOODTHICK_UR	= $EB	; Wood thick upper left
TILE10_WOODTHICK_M1L	= $EC	; Wood thick middle 1 left
TILE10_WOODTHICK_M1R	= $ED	; Wood thick middle 1 right
TILE10_WOODTHICK_M2L	= $EE	; Wood thick middle 2 left
TILE10_WOODTHICK_M2R	= $EF	; Wood thick middle 2 right
TILE10_WOODTHICK_LL	= $F4	; Wood thick lower left
TILE10_WOODTHICK_LR	= $F5	; Wood thick lower left
TILE10_WOODTIP_SHORT	= $F6	; Wood tip short
TILE10_WOODTIP_LONGL	= $F7	; Wood tip long left
TILE10_WOODTIP_LONGR	= $F8	; Wood tip long right
TILE10_WOODBOTTOM_L	= $F9	; Wood bottom left
TILE10_WOODBOTTOM_M1	= $FA	; Wood bottom middle 1
TILE10_WOODBOTTOM_M2	= $FB	; Wood bottom middle 2
TILE10_WOODBOTTOM_R	= $FC	; Wood bottom right
TILE10_LEDGE		= $FD	; Wood ledge
TILE10_REARTIP		= $FE	; Wood rear tip

; Tileset 11 (Giant World)
TILE11_JCLOUD_LL	= $02	; Giant Judgem's Cloud Lower Left
TILE11_JCLOUD_LR	= $06	; Giant Judgem's Cloud Lower Right
TILE11_JCLOUD_UL	= $1F	; Giant Judgem's Cloud Upper Left
TILE11_JCLOUD_UR	= $20	; Giant Judgem's Cloud Upper Right

TILE11_BRICK_UL		= $47	; Giant brick upper left
TILE11_BRICK_UR		= $48	; Giant brick upper right
TILE11_BRICK_LL		= $49	; Giant brick lower left
TILE11_BRICK_LR		= $4A	; Giant brick lower right
TILE11_QBLOCKC_UL	= $4B	; Giant [?] block (with coin) upper left
TILE11_QBLOCKC_UR	= $4C	; Giant [?] block (with coin) upper right
TILE11_QBLOCKC_LL	= $4D	; Giant [?] block (with coin) lower left
TILE11_QBLOCKC_LR	= $4E	; Giant [?] block (with coin) lower right
TILE11_WOOD_UL		= $4F	; Giant wood block upper left
TILE11_WOOD_UR		= $50	; Giant wood block upper right
TILE11_WOOD_LL		= $51	; Giant wood block lower left
TILE11_WOOD_LR		= $52	; Giant wood block lower right
TILE11_METAL_UL		= $53	; Hit block metal plate upper left
TILE11_METAL_UR		= $54	; Hit block metal plate upper right
TILE11_METAL_LL		= $55	; Hit block metal plate lower left
TILE11_METAL_LR		= $56	; Hit block metal plate lower right
TILE11_GROUND_UL	= $57	; Giant ground upper left
TILE11_GROUND_UR	= $58	; Giant ground upper left
TILE11_GROUND_LL	= $59	; Giant ground upper left
TILE11_GROUND_LR	= $5A	; Giant ground upper left
TILE11_QBLOCKP_UL	= $5B	; Giant [?] block (with leaf) upper left
TILE11_QBLOCKP_UR	= $5C	; Giant [?] block (with leaf) upper right
TILE11_QBLOCKP_LL	= $5D	; Giant [?] block (with leaf) lower left
TILE11_QBLOCKP_LR	= $5E	; Giant [?] block (with leaf) lower right

TILE11_SKY		= $80

TILE11_HILL_PEAK	= $89	; Giant hill peak 
TILE11_HILL_LSLOPE	= $8A	; Giant hill left slope
TILE11_HILL_MID		= $8B	; Giant hill filler
TILE11_HILL_RSLOPE	= $8C	; Giant hill right slope

TILE11_PIPE_UL		= $A4	; Giant Pipe Upper Left
TILE11_PIPE_UM		= $A5	; Giant Pipe Upper Middle
TILE11_PIPE_UR		= $A6	; Giant Pipe Upper Right
TILE11_PIPE_ML		= $A7	; Giant Pipe Middle Left
TILE11_PIPE_MM		= $A8	; Giant Pipe Middle Middle
TILE11_PIPE_MR		= $A9	; Giant Pipe Middle Right
TILE11_PIPE_LL		= $AA	; Giant Pipe Lower Left
TILE11_PIPE_LM		= $AB	; Giant Pipe Lower Middle
TILE11_PIPE_LR		= $AC	; Giant Pipe Lower Right

TILE11_CORAL_UL		= $F4	; Giant coral upper left
TILE11_CORAL_UR		= $F5	; Giant coral upper right

TILE11_CORAL_LL		= $F6	; Giant coral lower left
TILE11_CORAL_LR		= $F7	; Giant coral lower right

; Tileset 12 (Ice, technically shares with Tileset 4)
TILE12_CLOUD_UL		= $08	; Cloud upper left
TILE12_CLOUD_UM		= $09	; Cloud upper middle
TILE12_CLOUD_UR		= $0A	; Cloud upper right
TILE12_CLOUD_LL		= $0B	; Cloud lower left
TILE12_CLOUD_LM		= $0C	; Cloud lower middle
TILE12_CLOUD_LR		= $0D	; Cloud lower right

TILE12_SNOWBLOCK_LL	= $0E	; Snow platform, lower left
TILE12_SNOWBLOCK_LM	= $0F	; Snow platform, lower middle
TILE12_SNOWBLOCK_LR	= $10	; Snow platform, lower right

TILE12_SNOWBLOCK_UL	= $22	; Snow platform, upper left
TILE12_SNOWBLOCK_UM	= $23	; Snow platform, upper middle
TILE12_SNOWBLOCK_UR	= $24	; Snow platform, upper right

TILE12_SNOWY_M		= $25	; Middle of large snowy platform

TILE12_LARGEICEBLOCK_UL	= $36	; Large 2x2 ice block, upper left
TILE12_LARGEICEBLOCK_UR	= $37	; Large 2x2 ice block, upper right
TILE12_LARGEICEBLOCK_LL	= $38	; Large 2x2 ice block, lower left
TILE12_LARGEICEBLOCK_LR	= $39	; Large 2x2 ice block, lower right

TILE12_ICEBLOCK		= $3A	; Ice block

TILE12_GROUND_L		= $4A	; Solid bottom ground left
TILE12_GROUND_M		= $4B	; Solid bottom ground middle
TILE12_GROUND_R		= $4C	; Solid bottom ground right

TILE12_FROZENCOIN	= $55	; Frozen coin
TILE12_FROZENMUNCHER	= $56	; Frozen muncher

TILE12_SKY		= $80	; Sky
TILE12_SNOWGREEN_UL	= $8E	; Frosty green platform, upper left
TILE12_SNOWGREEN_UM	= $8F	; Frosty green platform, upper middle
TILE12_SNOWGREEN_UR	= $90	; Frosty green platform, upper right


; Tileset 13 (Sky areas, inc. coin heaven)
TILE13_GOALBLACK	= $00	; Goal darkness
TILE13_GOALEDGE		= $01	; Goal edge
TILE13_STARS1		= $07	; Stars!  (Lost level)
TILE13_STARS2		= $08	; Stars!  (Lost level)
TILE13_STARS3		= $09	; Stars!  (Lost level)
TILE13_DBLCLOUD_UM	= $0A	; Double cloud upper middle
TILE13_DBLCLOUD_BM	= $0B	; Double cloud bottom middle
TILE13_DBLCLOUD_BR	= $0C	; Double cloud bottom right
TILE13_DBLCLOUD_BL	= $0D	; Double cloud bottom left
TILE13_DBLCLOUD_UL	= $0E	; Double cloud upper left
TILE13_DBLCLOUD_UR	= $0F	; Double cloud upper right
TILE13_GOALBLACKCLOUD	= $10	; Goal darkness on top of cloud
TILE13_GOALEDGECLOUD	= $11	; Goal edge on top of cloud
TILE13_DBLCLOUD_LM	= $21	; Double cloud lower middle
TILE13_DBLCLOUD_MM	= $22	; Double cloud middle middle
TILE13_DBLCLOUD_LR	= $23	; Double cloud lower right
TILE13_DBLCLOUD_MR	= $24	; Double cloud middle right
TILE13_DBLCLOUD_LL	= $25	; Double cloud lower left
TILE13_DBLCLOUD_ML	= $26	; Double cloud middle left
TILE13_THICKCLOUD_LM	= $36	; Thick cloud lower middle

; As far as I know, NONE of these are used, and they would have provided a fade
; from the bright skies of below into increasingly darker and eventually black
; sky... going into space perhaps?  Ultimately would have employed TILE13_STARS1/2/3
TILE13_SKY_DARKTOBLACK	= $81	; Gradient dark to black
TILE13_SKY_LIGHTTODARK	= $82	; Gradient light to dark
TILE13_SKY_BLACK	= $83	; Black sky
TILE13_SKY_DARK		= $84	; Dark sky
TILE13_SKY_LIGHT	= $86	; Light sky
TILE13_SKY_DARKSTAR	= $87	; Like TILE13_SKY_DARK, but one star visible
TILE13_SKY_DARKTOBLACKS	= $88	; Like TILE13_SKY_DARKTOBLACK, but one star visible

TILE13_ROUNDCLOUDBLU_T	= $C3	; Round cloud (blue sky BG) top
TILE13_ROUNDCLOUDWHT_T	= $C4	; Round cloud (white cloud BG) top
TILE13_CLOUD		= $C5	; General white cloud filler
TILE13_BALLCLOUD_UL	= $C6	; "Ball cloud" formation with ball formation upper left
TILE13_BALLCLOUD_UR	= $C7	; "Ball cloud" formation with ball formation upper right
TILE13_BALLCLOUD_LL	= $C8	; "Ball cloud" formation with ball formation lower left
TILE13_BALLCLOUD_LR	= $C9	; "Ball cloud" formation with ball formation lower right
TILE13_ROUNDCLOUDLAR_LT	= $CA	; Round cloud (large round cloud BG) left top
TILE13_ROUNDCLOUDLAR_RT	= $CB	; Round cloud (large round cloud BG) right top
TILE13_SKY		= $CC	; Sky

TILE13_LARGEROUND_UL	= $CD	; Large round cloud upper left
TILE13_LARGEROUND_UR	= $CE	; Large round cloud upper right
TILE13_LARGEROUND_LL	= $CF	; Large round cloud lower left
TILE13_LARGEROUND_LR	= $D0	; Large round cloud lower right

TILE13_LONGCLOUDWHIT_UL	= $D1	; Long cloud (white cloud BG) upper left
TILE13_LONGCLOUDWHIT_UM	= $D2	; Long cloud (white cloud BG) upper middle
TILE13_LONGCLOUDWHIT_UR	= $D3	; Long cloud (white cloud BG) upper right
TILE13_LONGCLOUDBLUE_UL	= $D4	; Long cloud (blue sky BG) upper left
TILE13_LONGCLOUDBLUE_UM	= $D5	; Long cloud (blue sky BG) upper middle
TILE13_LONGCLOUDBLUE_UR	= $D6	; Long cloud (blue sky BG) upper right

TILE13_POINTYCLOUDBLU_L	= $E2	; Pointy-end cloud platform (blue sky BG) left
TILE13_POINTYCLOUDBLU_M	= $E3	; Pointy-end cloud platform (blue sky BG) middle
TILE13_POINTYCLOUDBLU_R	= $E4	; Pointy-end cloud platform (blue sky BG) right
TILE13_POINTYCLOUDWHT_L	= $E5	; Pointy-end cloud platform (white cloud BG) left
TILE13_POINTYCLOUDWHT_M	= $E6	; Pointy-end cloud platform (white cloud BG) middle
TILE13_POINTYCLOUDWHT_R	= $E7	; Pointy-end cloud platform (white cloud BG) right

TILE13_LONGCLOUDWHIT_LL	= $E8	; Long cloud (white cloud BG) lower left
TILE13_LONGCLOUDWHIT_LM	= $E9	; Long cloud (white cloud BG) lower middle
TILE13_LONGCLOUDWHIT_LR	= $EA	; Long cloud (white cloud BG) lower right
TILE13_LONGCLOUDBLUE_LL	= $EB	; Long cloud (blue sky BG) lower left
TILE13_LONGCLOUDBLUE_LM	= $EC	; Long cloud (blue sky BG) lower middle
TILE13_LONGCLOUDBLUE_LR	= $ED	; Long cloud (blue sky BG) lower right
TILE13_ROUNDCLOUDLAY_T	= $EE	; Round cloud (cloud overlay BG) top

; Tileset 14 (Underground style)
TILE14_SKY		= $02	; Sky
TILE14_ABOVE_SLOPE45B2T	= $25	; Above ground 45 degree slope, bottom-to-top
TILE14_ABOVE_HORZGROUND	= $26	; Above ground horizontal ground
TILE14_ABOVE_SLOPE45T2B	= $27	; Above ground 45 degree slope, top-to-bottom
TILE14_ABOVE_SLOPE225B2T_L= $28	; Underwater 22.5 degree slope, bottom-to-top, lower
TILE14_ABOVE_SLOPE225B2T_U= $29	; Underwater 22.5 degree slope, bottom-to-top, upper


TILE14_ABOVE_SLOPE225T2B_U= $2A	; Underwater 22.5 degree slope, top-to-bottom, lower
TILE14_ABOVE_SLOPE225T2B_L= $2B	; Underwater 22.5 degree slope, top-to-bottom, upper
TILE14_ABOVE_CORNER_UL	= $33	; Above ground upper left corner
TILE14_ABOVE_CORNER_UR	= $35	; Above ground upper right corner

TILE14_ABOVE_VERTGROUNDL= $34	; Above ground vertical ground left edge
TILE14_ABOVE_VERTGROUNDR= $36	; Above ground vertical ground right edge
TILE14_ABOVE_MIDGROUND	= $37	; Above ground Middle ground
TILE14_SLOPE45T2B_CEIL	= $A0	; Ceiling slope 45 degrees, top-to-bottom
TILE14_SLOPE45B2T_CEIL	= $A1	; Ceiling slope 45 degrees, bottom-to-top
TILE14_SLOPE225T2B_L_CEIL= $A2	; Ceiling 22.5 degree slope, top-to-bottom, lower
TILE14_SLOPE225T2B_U_CEIL= $A3	; Ceiling 22.5 degree slope, top-to-bottom, upper
TILE14_SLOPE225B2T_U_CEIL= $A4	; Ceiling 22.5 degree slope, bottom-to-top, lower
TILE14_SLOPE225B2T_L_CEIL= $A5	; Ceiling 22.5 degree slope, bottom-to-top, upper
TILE14_WSLOPE45T2B_CEIL	= $E9	; Underwater Ceiling slope 45 degrees, top-to-bottom
TILE14_WSLOPE45B2T_CEIL	= $EA	; Underwater Ceiling slope 45 degrees, bottom-to-top
TILE14_WSLOPE225T2B_L_CEIL= $EB	; Underwater Ceiling 22.5 degree slope, top-to-bottom, lower
TILE14_WSLOPE225T2B_U_CEIL= $EC	; Underwater Ceiling 22.5 degree slope, top-to-bottom, upper
TILE14_WSLOPE225B2T_U_CEIL= $ED	; Underwater Ceiling 22.5 degree slope, bottom-to-top, lower
TILE14_WSLOPE225B2T_L_CEIL= $EE	; Underwater Ceiling 22.5 degree slope, bottom-to-top, upper

; Tileset 15/16/17 (Bonus Games)
TILE15_BLACK		= $09	; Black
TILE15_WHITESPACE_PAL0	= $0A	; White space tile in palette 0

TILE15_BRICKBG		= $40	; White/pink brick in the background

TILE15_PLAYERRAC_TOPM	= $41	; Middle of Top of Raccoon Player at table
TILE15_PLAYERRAC_TOPR	= $42	; Right of Top of Raccoon Player at table

TILE15_PLAYERBIG_HEADL	= $43	; Left Head of Big Player at table
TILE15_PLAYERBIG_HEADM	= $44	; Middle Head of Big Player at table
TILE15_PLAYERBIG_HEADR	= $45	; Right Head of Big Player at table
TILE15_PLAYERBIG_RACL	= $46	; Bottom left of Raccoon Player at table
TILE15_PLAYERBIG_TOPM	= $47	; Middle of Top of Big Player at table
TILE15_PLAYERBIG_TOPR	= $48	; Right of Top of Big Player at table
TILE15_PLAYERBIG_BOTL	= $49	; Bottom left of Big Player at table
TILE15_PLAYERSM_TOP	= $4A	; Top of Small Player at table

TILE15_UNKTALL_UL	= $4B	; Tile for unknown tall thing top upper left
TILE15_UNKTALL_UR	= $4C	; Tile for unknown tall thing top upper right
TILE15_UNKTALL_R1L	= $4D	; Tile for unknown tall thing top row 1 left
TILE15_UNKTALL_R1R	= $4E	; Tile for unknown tall thing top row 1 right
TILE15_UNKTALL_R2L	= $4F	; Tile for unknown tall thing top row 2 left
TILE15_UNKTALL_R2R	= $50	; Tile for unknown tall thing top row 2 right
TILE15_UNKTALL_LL	= $51	; Tile for unknown tall thing top lower left
TILE15_UNKTALL_LR	= $52	; Tile for unknown tall thing top lower right

TILE15_PLAYERBIG_TORL	= $80	; Left Torso of Big Player at table
TILE15_PLAYERBIG_TORM	= $81	; Middle Torso of Big Player at table
TILE15_PLAYERBIG_TORR	= $82	; Right Torso of Big Player at table

TILE15_PLAYERBIG_RACM	= $83	; Bottom middle of Raccoon Player at table
TILE15_PLAYERBIG_BOTR	= $84	; Bottom right of Big Player at table
TILE15_PLAYERBIG_BOTM	= $85	; Bottom middle of Big Player at table
TILE15_PLAYERSM_BOTTOM	= $86	; Bottom of Small Player at table

TILE15_BRICKFLOOR	= $C0	; Orange brick making up the floor
TILE15_BORDER_UL	= $C1	; Host greet border upper left
TILE15_BORDER_ML	= $C2	; Host greet border middle left
TILE15_BORDER_LL	= $C3	; Host greet border lower left
TILE15_BORDER_UM	= $C4	; Host greet border upper middle
TILE15_BORDER_LM	= $C5	; Host greet border lower middle
TILE15_BORDER_UR	= $C6	; Host greet border upper right
TILE15_BORDER_MR	= $C7	; Host greet border middle right
TILE15_BORDER_LR	= $C8	; Host greet border lower right
TILE15_WHITESPACE_PAL3	= $CD	; White space tile in palette 3
TILE15_TABLE_UL		= $CE	; Table upper left
TILE15_TABLE_UM		= $CF	; Table upper middle
TILE15_TABLE_UR		= $D0	; Table upper left

TILE15_TABLE_LL		= $D1	; Table lower left
TILE15_TABLE_LM		= $D2	; Table lower middle
TILE15_TABLE_LR		= $D3	; Table lower left


; Tileset 18 (2P Vs)
; NOTE: Several tiles 
TILE18_BLACK		= $02	; Black tile

TILE18_MSTATUS_UL	= $44
TILE18_STATUS_UM	= $45
TILE18_MSTATUS_UR	= $46
TILE18_LSTATUS_UL	= $47
TILE18_LSTATUS_UR	= $48

TILE18_MSTATUS_LL	= $49
TILE18_MSTATUS_LML	= $4A
TILE18_STATUS_LM	= $4B
TILE18_MSTATUS_LR	= $4C
TILE18_LSTATUS_LL	= $4D
TILE18_LSTATUS_LML	= $4E
TILE18_LSTATUS_LR	= $4F


TILE18_BRICKFLOOR	= $50	; Brick floor tiles
TILE18_DIAMOND		= $51	; NOT USED SMB1-ish diamond blocks
TILE18_QBLOCK		= $BC
TILE18_LADDER		= $C0	; Ladder (used in final variation)
TILE18_BOUNCEBLOCK	= $C1	; Block that bounces when Player hits underneath it
TILE18_BOUNCEDBLOCK	= $C2	; Temporary tile for when block has been bounced



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ASM INCLUDES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	; Object support routines
	.bank 0
	.org $C000
	.include "PRG/prg000.asm"

	; Objects $00-$23
	.bank 1
	.org $A000
	.include "PRG/prg001.asm"

	; Objects $24-$47
	.bank 2
	.org $A000
	.include "PRG/prg002.asm"

	; Objects $48-$6B
	.bank 3
	.org $A000
	.include "PRG/prg003.asm"

	; Objects $6C-$8F
	.bank 4
	.org $A000
	.include "PRG/prg004.asm"

	; Objects $90-$B3 and special-function object placeholders ($B4-$BC, $D1-$D6)
	.bank 5
	.org $A000
	.include "PRG/prg005.asm"

	; Object placement/layout data (for levels)
	.bank 6
	.org $C000
	.include "PRG/prg006.asm"

	; Special Objects, Cannon Fire, and some miscellaneous routines
	.bank 7
	.org $A000
	.include "PRG/prg007.asm"

	; Most of Player control code
	.bank 8
	.org $A000
	.include "PRG/prg008.asm"

	; 2P Vs and Autoscroll
	.bank 9
	.org $A000
	.include "PRG/prg009.asm"

	; Handles map BG graphics and logic code; also stores a few DMC samples
	.bank 10
	.org $C000
	.include "PRG/prg010.asm"

	; Main map logic and map sprites
	.bank 11
	.org $A000
	.include "PRG/prg011.asm"

	; Tileset 0 (Map), Map object code, map level layouts (links to level layouts/object sets), 
	; completion code, Airship / bonus host room / toad shop / coin ship / unused map object $0C layout pointers
	.bank 12
	.org $A000
	.include "PRG/prg012.asm"

	; Tileset 14 (Underground style)
	.bank 13
	.org $A000
	.include "PRG/prg013.asm"

	; Tileset 18 (2P Vs), 2P Vs battlefields, and shared level load routines
	.bank 14
	.org $C000
	.include "PRG/prg014.asm"

	; Tileset 1 (Plains style)
	.bank 15
	.org $A000
	.include "PRG/prg015.asm"

	; Tileset 3 (Hills style)
	.bank 16
	.org $A000
	.include "PRG/prg016.asm"

	; Tileset 4 (High-Up style) / 12 (Ice)
	.bank 17
	.org $A000
	.include "PRG/prg017.asm"

	; Tileset 6 (Water level), 7 (Toad house), 8 (Vertical levels typical of World 7)
	.bank 18
	.org $A000
	.include "PRG/prg018.asm"

	; Tileset 5 (World 7 plant infestations), 11 (Giant World), 13 (Sky areas, inc. coin heaven)
	.bank 19
	.org $A000
	.include "PRG/prg019.asm"

	; Tileset 9 (Desert)
	.bank 20
	.org $A000
	.include "PRG/prg020.asm"

	; Tileset 2 (Fortress)
	.bank 21
	.org $A000
	.include "PRG/prg021.asm"

	; Bonus games (Spade, N-Spade, and the lost games)
	.bank 22
	.org $C000
	.include "PRG/prg022.asm"

	; Tileset 10 (Airship)
	.bank 23
	.org $A000
	.include "PRG/prg023.asm"

	; Title screen, ending (logic and images), Toad and King cinematic (Pre-wand-return only!)
	; Also home a large copy/paste error from PRG022, first half of sprite lists for ending
	.bank 24
	.org $A000
	.include "PRG/prg024.asm"

	; Contains mostly command buffer graphics for title screen / ending (large images), 
	; second half of sprite lists for ending, and a table to access them
	.bank 25
	.org $C000
	.include "PRG/prg025.asm"

	; Tileset 15, 16, 17 (Bonus games)
	; Status bar routines (draw, use items, etc.), level junctions
	; (inc. pointers for Big [?] block area and generic pipe exits), border draw, fade routines
	.bank 26
	.org $A000
	.include "PRG/prg026.asm"

	; Palettes, palette routines, Toad and King Cinematic (Post-wand-return only!)
	.bank 27
	.org $A000
	.include "PRG/prg027.asm"

	; First bank of the sound engine
	.bank 28
	.org $A000
	.include "PRG/prg028.asm"

	; Some of the music segments, tile/block change event, pipe movement code, Toad House code,
	; Player's draw and animation routines
	.bank 29
	.org $C000
	.include "PRG/prg029.asm"

	; This bank is ALWAYS active in ROM, sitting at 8000h-9FFFh
	; Contains interrupt handling code and other constantly reused functionality
	.bank 30
	.org $8000
	.include "PRG/prg030.asm"

	; This bank is ALWAYS active in ROM, sitting at E000h-FFFFh
	; Contains interrupt handling code and other constantly reused functionality
	.bank 31
	.org $E000
	.include "PRG/prg031.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CHR ROM BEGINS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.incchr "CHR/chr000.pcx"
	.incchr "CHR/chr001.pcx"
	.incchr "CHR/chr002.pcx"
	.incchr "CHR/chr003.pcx"
	.incchr "CHR/chr004.pcx"
	.incchr "CHR/chr005.pcx"
	.incchr "CHR/chr006.pcx"
	.incchr "CHR/chr007.pcx"
	.incchr "CHR/chr008.pcx"
	.incchr "CHR/chr009.pcx"
	.incchr "CHR/chr010.pcx"
	.incchr "CHR/chr011.pcx"
	.incchr "CHR/chr012.pcx"
	.incchr "CHR/chr013.pcx"
	.incchr "CHR/chr014.pcx"
	.incchr "CHR/chr015.pcx"
	.incchr "CHR/chr016.pcx"
	.incchr "CHR/chr017.pcx"
	.incchr "CHR/chr018.pcx"
	.incchr "CHR/chr019.pcx"
	.incchr "CHR/chr020.pcx"
	.incchr "CHR/chr021.pcx"
	.incchr "CHR/chr022.pcx"
	.incchr "CHR/chr023.pcx"

	.incchr "CHR/chr024.pcx"
	.incchr "CHR/chr025.pcx"
	.incchr "CHR/chr026.pcx"
	.incchr "CHR/chr027.pcx"
	.incchr "CHR/chr028.pcx"
	.incchr "CHR/chr029.pcx"
	.incchr "CHR/chr030.pcx"
	.incchr "CHR/chr031.pcx"
	.incchr "CHR/chr032.pcx"
	.incchr "CHR/chr033.pcx"
	.incchr "CHR/chr034.pcx"
	.incchr "CHR/chr035.pcx"
	.incchr "CHR/chr036.pcx"
	.incchr "CHR/chr037.pcx"

	.incchr "CHR/chr038.pcx"
	.incchr "CHR/chr039.pcx"
	.incchr "CHR/chr040.pcx"
	.incchr "CHR/chr041.pcx"
	.incchr "CHR/chr042.pcx"
	.incchr "CHR/chr043.pcx"
	.incchr "CHR/chr044.pcx"
	.incchr "CHR/chr045.pcx"
	.incchr "CHR/chr046.pcx"
	.incchr "CHR/chr047.pcx"
	.incchr "CHR/chr048.pcx"
	.incchr "CHR/chr049.pcx"
	.incchr "CHR/chr050.pcx"
	.incchr "CHR/chr051.pcx"
	.incchr "CHR/chr052.pcx"
	.incchr "CHR/chr053.pcx"
	.incchr "CHR/chr054.pcx"
	.incchr "CHR/chr055.pcx"
	.incchr "CHR/chr056.pcx"
	.incchr "CHR/chr057.pcx"
	.incchr "CHR/chr058.pcx"
	.incchr "CHR/chr059.pcx"
	.incchr "CHR/chr060.pcx"
	.incchr "CHR/chr061.pcx"
	.incchr "CHR/chr062.pcx"
	.incchr "CHR/chr063.pcx"
	.incchr "CHR/chr064.pcx"
	.incchr "CHR/chr065.pcx"
	.incchr "CHR/chr066.pcx"
	.incchr "CHR/chr067.pcx"
	.incchr "CHR/chr068.pcx"
	.incchr "CHR/chr069.pcx"
	.incchr "CHR/chr070.pcx"
	.incchr "CHR/chr071.pcx"
	.incchr "CHR/chr072.pcx"
	.incchr "CHR/chr073.pcx"
	.incchr "CHR/chr074.pcx"
	.incchr "CHR/chr075.pcx"
	.incchr "CHR/chr076.pcx"
	.incchr "CHR/chr077.pcx"
	.incchr "CHR/chr078.pcx"
	.incchr "CHR/chr079.pcx"
	.incchr "CHR/chr080.pcx"
	.incchr "CHR/chr081.pcx"
	.incchr "CHR/chr082.pcx"
	.incchr "CHR/chr083.pcx"
	.incchr "CHR/chr084.pcx"
	.incchr "CHR/chr085.pcx"
	.incchr "CHR/chr086.pcx"
	.incchr "CHR/chr087.pcx"
	.incchr "CHR/chr088.pcx"
	.incchr "CHR/chr089.pcx"
	.incchr "CHR/chr090.pcx"
	.incchr "CHR/chr091.pcx"
	.incchr "CHR/chr092.pcx"
	.incchr "CHR/chr093.pcx"
	.incchr "CHR/chr094.pcx"
	.incchr "CHR/chr095.pcx"
	.incchr "CHR/chr096.pcx"
	.incchr "CHR/chr097.pcx"
	.incchr "CHR/chr098.pcx"
	.incchr "CHR/chr099.pcx"
	.incchr "CHR/chr100.pcx"
	.incchr "CHR/chr101.pcx"
	.incchr "CHR/chr102.pcx"
	.incchr "CHR/chr103.pcx"
	.incchr "CHR/chr104.pcx"
	.incchr "CHR/chr105.pcx"
	.incchr "CHR/chr106.pcx"
	.incchr "CHR/chr107.pcx"
	.incchr "CHR/chr108.pcx"
	.incchr "CHR/chr109.pcx"
	.incchr "CHR/chr110.pcx"
	.incchr "CHR/chr111.pcx"
	.incchr "CHR/chr112.pcx"
	.incchr "CHR/chr113.pcx"
	.incchr "CHR/chr114.pcx"
	.incchr "CHR/chr115.pcx"
	.incchr "CHR/chr116.pcx"
	.incchr "CHR/chr117.pcx"
	.incchr "CHR/chr118.pcx"
	.incchr "CHR/chr119.pcx"
	.incchr "CHR/chr120.pcx"
	.incchr "CHR/chr121.pcx"
	.incchr "CHR/chr122.pcx"
	.incchr "CHR/chr123.pcx"
	.incchr "CHR/chr124.pcx"
	.incchr "CHR/chr125.pcx"
	.incchr "CHR/chr126.pcx"
	.incchr "CHR/chr127.pcx"

