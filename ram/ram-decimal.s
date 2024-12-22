IER = $600E				; interrupt Enable register
IFR = $600D				; interrupt Flag Register
PCR = $6001				; peripheral control register
DDRA = $6003			; data direction bus A
DDRB = $6002			; data direction bus B
PORTA = $6001
PORTB = $6000


    .ORG $8000
setup:
	LDX #$FF
    TXS

	LDA #$01			; select CA1 as rising edge
	STA PCR

	LDA #$82			; enable CA1
	STA IER
	CLI

    LDA #%11111111
    STA DDRB           ; Set PORTB as output
    LDA #%00000000
    STA DDRA           ; Set PORTA for control signals

	JSR lcd_init_4bits

loop:
	LDA #02
	JSR lcd_instruction
	JSR print_decimal
	LDX counter
	CMX #$78
	BNE loop
	LDA #01
	JSR lcd_instruction
    JMP loop           ; Infinite loop to prevent exit

keyboard_interrupt:
	PHA
	LDA PORTA
	STA counter
	PLA
	RTI
nmi:
	RTI

	.include "lcd-4bits.s"
	.include "binary-2-decimal.s"
	.ORG $FFFA
	.WORD nmi
    .WORD setup        ; Reset vector
    .WORD keyboard_interrupt
