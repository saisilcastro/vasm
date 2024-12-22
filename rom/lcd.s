lcd_init_8bits:
    LDX #$00                ; Initialize index for instructions
lcd_instruction_loop:
    LDA instruction, X       ; Load instruction byte
    BEQ done                 ; If it's zero, we are done
    JMP lcd_instruction      ; Jump to handle instruction

lcd_instruction:
    STA PORTB                ; Send instruction to PORTB (data lines)
    LDA #0                   ; Set control lines (RS = 0, E = 0, RW = 0)
    STA PORTA                ; Clear E
    LDA #E                   ; Set E (Enable pulse)
    STA PORTA                ; Send E pulse
    LDA #0                   ; Clear E again
    STA PORTA                ; End pulse
    INX                      ; Move to the next instruction
    JMP lcd_instruction_loop ; Continue loop

done:
    JMP setup_done           ; Return to main program

lcd_byte:
    STA PORTB                ; Send data byte to PORTB (data lines)
    LDA #RS                  ; Set RS (Data mode), E = 0, RW = 0
    STA PORTA                ; Send RS = 1
    LDA #(RS | E)            ; Set RS and E
    STA PORTA                ; Send E pulse
    LDA #RS                  ; Clear E, keep RS = 1
    STA PORTA                ; End pulse
    JMP lcd_byte_done        ; Continue to main program

instruction:
    .DB $38, $0E, $06, $01, 0 ; Initialization commands

