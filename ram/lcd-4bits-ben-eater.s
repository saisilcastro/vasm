E  = %10000000
RW = %01000000
RS = %00100000

lcd_wait:
    PHA
	LDA #%11110000
	STA DDRB
lcd_busy:
    LDA #RW				; tranfer the RW flag the to A
	STA PORTB			; transfer A to PORTB
    ORA #E				; tranfer RW + E flags to A
	STA PORTB
	LDA PORTB
	PHA
	LDA #RW
	STA PORTB
	ORA #E
	STA PORTB
	LDA PORTB
	PLA
    AND #%00001000      ; clear everything but busyflag
    BNE lcd_busy		; If busy, keep waiting

	LDA #RW
    STA PORTB
    LDA #%11111111      ; Restore PORTB as output
    STA DDRB
    PLA
    RTS

lcd_init:
	LDA #%00000010
	STA PORTB
	ORA #E
	STA PORTB
	AND #%00001111
	STA PORTB
	RTS

lcd_init_4bits:
	JSR lcd_init
	LDA #%00101000
	JSR lcd_instruction
	LDA #%00001110
	JSR lcd_instruction
	LDA #%00000110
	JSR lcd_instruction
	LDA #%00000001
	JSR lcd_instruction
	RTS
	
lcd_string:
	LDX #0
lcd_string_loop:
	LDA fucker, X
	BEQ lcd_null_byte
	JSR lcd_byte
	INX				; increment the X register
	JMP lcd_string_loop
lcd_null_byte:
	RTS

lcd_instruction:
	JSR lcd_wait
	PHA
	LSR
	LSR
	LSR
	LSR
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	PLA
	AND #%00001111
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	RTS
	
lcd_byte:
	JSR lcd_wait
	PHA
	LSR
	LSR
	LSR
	LSR
	ORA #RS
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	PLA
	AND #%00001111
	ORA #RS
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	RTS

short_delay:
	LDY #$FF
short_loop:
	DEY
	BNE short_loop
	RTS

fucker: .asciiz "Hello bloody world!"
