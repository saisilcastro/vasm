IER = $600E				; interrupt Enable register
IFR = $600D				; interrupt Flag Register
PCR = $600C				; peripheral control register
DDRA = $6003			; data direction bus A
DDRB = $6002			; data direction bus B
PORTA = $6001
PORTB = $6000

ACIA_DATA = $5000
ACIA_STATUS = $5001
ACIA_CMD = $5002
ACIA_CTRL = $5003

	.ORG $8000
setup:
	LDX #$FF
    TXS
	
	LDA #%11111111
    STA DDRB           ; Set PORTB as output
    LDA #%10111111
	
	JSR lcd_init_4bits
	
	LDA #1
	STA PORTA
	
	LDA #"*"
	STA $03FD
	
	LDA #$01
	TRB PORTA
	
	LDX #8
write_bit:
	JSR bit_delay
	ROR $03FD
	BCS send_1
	TRB PORTA
	JMP tx_done
send_1:
	TSB PORTA
tx_done:
	DEX
	BNE write_bit
	
	JSR bit_delay
	TSB PORTA
	JSR bit_delay
	
rx_wait:
	BIT PORTA
	BVS rx_wait
	
	JSR half_bit_delay
	
	LDX #8
read_bit:
	JSR bit_delay
	BIT PORTA
	BVS recv_1
	CLC
	JMP rx_done
recv_1:
	NOP
	NOP
	SEC
rx_done:
	ROR
	DEX
	BNE read_bit
	JSR lcd_byte
	
	JSR bit_delay
	JMP rx_wait
	
bit_delay:
	PHX
	LDX #13
bit_delay_1:
	DEX
	BNE bit_delay_1
	PLX
	RTS
	
half_bit_delay:
	PHX
	LDX #6
half_bit_delay_1:
	DEX
	BNE half_bit_delay_1
	PLX
	RTS

IRQ_KEY:
nmi:
	RTI

	.include "lcd-4bits.s"
	.ORG $FFFA
	.WORD nmi
	.WORD setup
	.WORD IRQ_KEY