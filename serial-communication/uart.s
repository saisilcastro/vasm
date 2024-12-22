ACIA_DATA = $5000
ACIA_STATUS = $5001
ACIA_CMD = $5002
ACIA_CTRL = $5003

IER = $600E				; interrupt Enable register
IFR = $600D				; interrupt Flag Register
PCR = $600C				; peripheral control register
DDRA = $6003			; data direction bus A
DDRB = $6002			; data direction bus B
PORTA = $6001
PORTB = $6000

	.ORG $8000
setup:
	LDX #$FF
    TXS
	
	LDA #%11111111
    STA DDRB           ; Set PORTB as output
    LDA #%10111111
	
	JSR lcd_init_4bits
	
	LDA #$00
	STA ACIA_STATUS
	
	LDA #$1F
	STA ACIA_CTRL
	
	LDA #$0B
	STA ACIA_CMD
	
	LDX #0
send_msg:
	LDA message, X
	BEQ done
	JSR tx_byte
	INX
	JMP send_msg
done:
	
rx_wait:
	LDA ACIA_STATUS
	AND #$08
	BEQ rx_wait
	
	LDA ACIA_DATA
	JSR lcd_byte
;JSR tx_byte
	JMP rx_wait
	
tx_byte:
	STA ACIA_DATA
	PHA
tx_wait:
	LDA ACIA_STATUS
	AND #$10
	BEQ tx_wait
	JSR tx_delay
	PLA
	RTS

tx_delay:
	PHX
	LDX #100
tx_delay_loop:
	DEX
	BNE tx_delay_loop
	PLX
	RTS
	
message: .asciiz "Hello World"
	.include "lcd-4bits.s"
	.ORG $FFFC
	.WORD setup
	.WORD $0000