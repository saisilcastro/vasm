E  = %10000000
RW = %01000000
RS = %00100000

lcd_wait:
	PHA					; backup Accumulator value

	LDA #%00000000		; set bus B as input
	STA DDRB			; apply the changes
lcd_busy:
	LDA #RW				; put RW flag into Accumulator
	STA PORTA			; store Accumulator into bus A 
	ORA #E				; put RW + E into Accumulator
	STA PORTA			; store Accumulator into bus A to retreave read mode
	LDA PORTB			; load the read value from lcd to Accumulator
	AND #%10000000		; clear all data but busyflag
	BNE lcd_busy		; if busyflag is 1 go back to lcd_busy

	LDA #RW				; load RW flag into Accumulator
	STA PORTA			; store Accumulator into bus A
	LDA #%11111111		; set bus B as output
	STA DDRB			; apply the changes
	PLA					; restore Accumulator value
	RTS					; return from subroutine

lcd_init_8bits:
    LDX #$00
lcd_loop:
    LDA instruction, X
    BEQ lcd_done
	JSR lcd_instruction
   	INX
    JMP lcd_loop
lcd_done:
	RTS

lcd_string:
    LDX #$00
lcd_string_loop:
    LDA fucker, X
	BEQ lcd_string_done
	JSR lcd_wait
	JSR lcd_byte
    
	INX
	JMP lcd_string_loop
lcd_string_done:
	RTS

lcd_instruction:
	STA PORTB           ; Write instruction to PORTB
    LDA #0
	JSR lcd_wait
    STA PORTA           ; Clear RS (Instruction Mode)
    
    LDA #E
    STA PORTA           ; Set E high

    LDA #0
    STA PORTA           ; Set E low
	RTS

lcd_byte:
	STA PORTB           ; Write instruction to PORTB

    LDA #RS
    STA PORTA           ; Clear RS (Instruction Mode)
    
	ORA #E
    STA PORTA           ; Set E high

    LDA #RS
    STA PORTA           ; Set E low
	RTS

instruction:
	.DB $38, $0E, $06, $01, 0
fucker: .asciiz "Hello fucking World!"
