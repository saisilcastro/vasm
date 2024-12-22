
binary_2_decimal:
    ; Initialize value to be the number to convert
    LDA #0
    STA message

	SEI
    LDA counter
    STA value
    LDA counter + 1
    STA value + 1
	CLI

    ; Initialize the remainder to be zero
divide:
    LDA #0
    STA mod10
    STA mod10 + 1

    LDX #16
    CLC
div_loop:
    ; Rotate quotient and remainder
    ROL value
    ROL value + 1
    ROL mod10
    ROL mod10 + 1

    ; a, y = dividend - divisor
    SEC
    LDA mod10
    SBC #10
    TAY ; transfer a low byte to y register
    LDA mod10 + 1
    SBC #0
    BCC ignore_result ; branch if dividend < divisor
    STY mod10
    STA mod10 + 1

ignore_result:
    DEX
    BNE div_loop
    ROL value
    ROL value + 1

    LDA mod10
    CLC
    ADC #"0"
    JSR push_byte

    ; if value != 0 continue dividing
    LDA value
    ORA value + 1
    BNE divide
    RTS

push_byte:
    PHA
    LDY #0
byte_loop:
    LDA message, Y
    TAX
    PLA
    STA message, Y
    INY
    TXA
    PHA
    BNE byte_loop
    PLA
    STA message, Y
    RTS

print_decimal:
	JSR binary_2_decimal 
	LDX #0
decimal_loop:
	LDA message, X
	BEQ decimal_end
	JSR lcd_byte
	INX
	JMP decimal_loop
decimal_end:
	RTS	

value = $0200
mod10 = $0202
message = $0204
counter = $020A
