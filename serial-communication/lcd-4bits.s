E  = %00000100
RW = %00000010
RS = %00000001

lcd_wait:
    PHA
	LDA #%00001111
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
	AND #%10000000      ; clear everything but busyflag
    BNE lcd_busy		; If busy, keep waiting

	LDA #RW
    STA PORTB
    LDA #%11111111      ; Restore PORTB as output
    STA DDRB
    PLA
    RTS

lcd_init_4bits:
	LDY #0
lcd_init_loop:
	LDA instruction, Y
	BEQ lcd_init_done
	JSR lcd_instruction
	INY
	JMP lcd_init_loop
lcd_init_done:
	RTS
	
lcd_instruction:
	JSR lcd_wait
	PHA
	AND #$F0
	STA PORTB
	ORA #E
	STA PORTB
	AND #$F0
	PLA
	ASL
	ASL
	ASL
	ASL
	STA PORTB
	ORA #E
	STA PORTB
	AND #$F0
	STA PORTB
	RTS
	
lcd_byte:
	JSR lcd_wait
	PHA
	AND #$F0
	ORA #RS
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	PLA
	ASL
	ASL
	ASL
	ASL
	ORA #RS
	STA PORTB
	ORA #E
	STA PORTB
	EOR #E
	STA PORTB
	RTS

instruction: .byte $02, $28, $0E, $06, $01, 0
