E  = %10000000
RW = %01000000
RS = %00100000

lcd_wait:
	pha

	LDA #%00000000
	STA DDRB
lcd_busy:
	LDA #RW
	STA PORTA
	LDA #(RW | E)
	STA PORTA
	LDA PORTB
	AND #%10000000
	BNE lcd_busy

	LDA #RW
	STA PORTA
	LDA #%11111111
	STA DDRB
	PLA
	RTS
lcd_init_8bits:
    LDX #$00
lcd_loop:
    LDA instruction, X
    BEQ lcd_done
	JSR lcd_wait
    STA PORTB           ; Write instruction to PORTB
    LDA #0
    STA PORTA           ; Clear RS (Instruction Mode)
    
    LDA #E
    STA PORTA           ; Set E high

    LDA #0
    STA PORTA           ; Set E low
	INX
    JMP lcd_loop
lcd_done:
	RTS

lcd_string:
    LDX #$00
lcd_string_loop:
    LDA message, X
	BEQ lcd_string_done
	JSR lcd_wait
	JSR lcd_byte
    
	INX
	JMP lcd_string_loop
lcd_string_done:
	RTS

lcd_byte:
	STA PORTB           ; Write instruction to PORTB

    LDA #RS
    STA PORTA           ; Clear RS (Instruction Mode)
    
    LDA #(RS | E)
    STA PORTA           ; Set E high

    LDA #RS
    STA PORTA           ; Set E low
	RTS

instruction: .DB $38, $0E, $06, $01, 0
message: .asciiz "Hello fucking World!"