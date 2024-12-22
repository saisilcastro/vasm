DDRA = $6003
DDRB = $6002
PORTA = $6001
PORTB = $6000

    .ORG $8000

setup:
	LDX #$FF
	TXS

    LDA #%11111111
    STA DDRB                ; Set PORTB as output (for data lines)

    LDA #%11100000
    STA DDRA                ; Set control lines (PORTA) as output

	JSR lcd_init_8bits
	JSR lcd_string

	LDA #$50
	STA PORTB
loop:
	ROR
	STA PORTB
	JSR little_wait
    JMP loop                 ; Infinite loop

little_wait:
	LDX #$10
wait_x:
	DEX
	BNE wait_x
	RTS

	.include "lcd.s"
    .ORG $FFFC
    .WORD setup              ; Set the reset vector to 'setup'
    .WORD $0000
