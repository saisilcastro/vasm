DDRA = $6003
DDRB = $6002
PORTA = $6001
PORTB = $6000

E  = $80        ; Binary: %10000000
RW = $40        ; Binary: %01000000
RS = $20        ; Binary: %00100000

    .ORG $8000

setup:
    LDA #$FF
    STA DDRB                ; Set PORTB as output (for data lines)

    LDA #$E0
    STA DDRA                ; Set control lines (PORTA) as output

    .include "lcd.s"        ; Include LCD instructions and functions
    
    JMP lcd_init_8bits      ; Jump to initialize the LCD

setup_done:
    LDX #$00                ; Initialize index for the string

print_string:
    LDA message, X          ; Load character from the message
    BEQ loop                ; If zero (end of string), stop
    JMP lcd_byte            ; Send the byte to the LCD
    INX                     ; Move to the next character
    JMP print_string        ; Repeat

loop:
    JMP loop                ; Infinite loop

message:
    .DB "Hello, World!", 0   ; Null-terminated message

    ; Now, correctly set the vectors without causing an overflow
    .ORG $FFFC
    .WORD setup              ; Set the reset vector to 'setup'
    ; No IRQ/BRK vector needed here

