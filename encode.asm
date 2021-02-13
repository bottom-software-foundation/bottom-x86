section .bss
   char resb 1 ; allocate storage for char

section .data
    lf db 0xa ; regular newline

    phg db 240, 159, 171, 130                       ; 200 ; People HugginG  ; 🫂
    sph db 240, 159, 146, 150                       ; 50  ; SParkling Heart ; 💖
    spk db 226, 156, 168                            ; 10  ; SParKles        ; ✨
    pld db 240, 159, 165, 186                       ; 5   ; PLeaDing        ; 🥺
    cma db 44                                       ; 1   ; CoMmA           ; ,
    hrt db 226, 157, 164, 239, 184, 143             ; 0   ; HeaRT           ; ❤️
    bsp db 240, 159, 145, 137, 240, 159, 145, 136   ;     ; Byte SeParator  ; 👉👈

section .text
global _start
_start:
    ; temp hack
    ;mov edx, 1             ; max length
    ;mov ecx, buf           ; buffer
    ;mov ebx, 0             ; stdin
    ;mov eax, 3             ; sys_read
    ;int 0x80

main:
    ; read stdin into buffer of size 1
    mov edx, 1             ; max length
    mov ecx, char           ; buffer
    mov ebx, 0             ; stdin
    mov eax, 3             ; sys_read
    int 0x80

    ; encode
    cmp eax, 0             ; encode if length > 0
    jg encode_entry

    ; add newline
    mov edx, 1             ; length
    mov ecx, lf            ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    ; exit
    mov eax, 1
    mov ebx, 0
    int 0x80

add_heart:
    ; write ❤️ to stdout and continue to add_byte_separator
    mov edx, 6             ; length
    mov ecx, hrt           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80
    
add_byte_separator:
    ; write 👉👈 to stdout and jmp back to main
    mov edx, 8             ; length
    mov ecx, bsp           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp main

encode_entry:
    ; if (char == 0) { jmp add_heart } else { push buf; continue to loop }
    mov eax, [char]
    cmp eax, 0
    je add_heart
    
loop:
    mov eax, [char] ; copy char to eax

    cmp eax, 200
    jge over200

    cmp eax, 50
    jge over50

    cmp eax, 10
    jge over10

    cmp eax, 5
    jge over5

    cmp eax, 1
    jge over1

    jmp add_byte_separator

over1:
    ; subtract char by 1
    mov eax, [char] ; copy char to eax
    dec eax
    mov [char], eax ; copy char to eax
    
    ; write , to stdout
    mov edx, 1             ; length
    mov ecx, cma           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp loop

over5:
    ; subtract char by 5
    mov eax, [char] ; copy char to eax
    sub eax, 5
    mov [char], eax ; copy char to eax
    
    ; write 🥺 to stdout
    mov edx, 4             ; length
    mov ecx, pld           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp loop

over10:
    ; subtract char by 10
    mov eax, [char] ; copy char to eax
    sub eax, 10
    mov [char], eax ; copy char to eax
    
    ; write ✨ to stdout
    mov edx, 3             ; length
    mov ecx, spk           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp loop

over50:
    ; subtract char by 50
    mov eax, [char] ; copy char to eax
    sub eax, 50
    mov [char], eax ; copy char to eax
    
    ; write 💖 to stdout
    mov edx, 4             ; length
    mov ecx, sph           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp loop

over200:
    ; subtract char by 200
    mov eax, [char] ; copy char to eax
    sub eax, 200
    mov [char], eax ; copy char to eax
    
    ; write 🫂 to stdout
    mov edx, 4             ; length
    mov ecx, phg           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    jmp loop