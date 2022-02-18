org 0x7c00
bits 16

%define ENDL 0x0d, 0x0a

start:
    jmp main

;
; print string to screen
; params
;   - ds:si points to string
;
puts:
    ; save registers
    push si
    push ax
    push bx

.loop
    lodsb               ; loads next char in al
    or al, al           ; check if it's 0
    jz .done

    mov ah, 0x0e        ; call bios interrupt
    mov bh, 0           ; set page number to 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7c00      ; stack grows downwords

    ; prints message
    mov si, msg_hello
    call puts


    hlt

.halt
    jmp .halt

msg_hello: db 'Hello, world!', ENDL, 0

times 510 - ($-$$) db 0
dw 0xaa55