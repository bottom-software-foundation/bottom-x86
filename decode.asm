section .bss
   buf resb 4 ; allocate storage for asserting and checking characters
   sum resb 1 ; allocate storage for sum
   length resb 1 ; allocate storage for length argument

section .data
    lf db 0xa ; regular newline
    hu db 'h' ; regular newline
    err db 0xa, 'Invalid bottom.', 0xa

section .text
global _start
read:
    ; read stdin into buf
    mov edx, [length]       ; length to read
    mov ecx, buf           ; buffer
    mov ebx, 0             ; stdin
    mov eax, 3             ; sys_read
    int 0x80

    cmp eax, [length]      ; error if length equals doesn't equal length
    jne _error

    ret
_start:
    ; read stdin into buffer of size 1
    mov edx, 1             ; max length
    mov ecx, buf          ; buffer
    mov ebx, 0             ; stdin
    mov eax, 3             ; sys_read
    int 0x80

    cmp eax, 0             ; exit if length equals 0
    je exit

    cmp byte [buf], 240
    je match240

    cmp byte [buf], 226
    je match226

    cmp byte [buf], 44
    je cma
    nop

_error:
    mov byte eax, [buf]
    mov byte ebx, [buf + 1]
    nop
    mov edx, 17             ; length
    mov ecx, err            ; buffer
    mov ebx, 2             ; stderr
    mov eax, 4             ; sys_write
    int 0x80
    
    ; exit
    mov eax, 1
    mov ebx, 1
    int 0x80

exit:
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

match240: ; consumed: 240
    ; assert next byte is 159
    mov byte [length], 3 ; specify 3 bytes to read
    call read

    cmp byte [buf], 159
    jne _error

    ; read next byte
    cmp byte [buf + 1], 171
    je phg

    cmp byte [buf + 1], 146
    je sph

    cmp byte [buf + 1], 165
    je pld

    ; assert that this is a seperator and continue to bsp
    cmp byte [buf + 1], 145
    jne _error

bsp: ; consumed: 240, 159, 145
    ; assert next byte is 137
    cmp byte [buf + 2], 137
    jne _error

    mov byte [length], 4 ; specify 4 bytes to read
    call read

    ; assert next byte is 240
    cmp byte [buf], 240
    jne _error

    ; assert next byte is 159
    cmp byte [buf + 1], 159
    jne _error

    ; assert next byte is 145
    cmp byte [buf + 2], 145
    jne _error

    ; assert next byte is 136
    cmp byte [buf + 3], 136
    jne _error

    ; reset sum and print to stdout
    mov edx, 1             ; length
    mov ecx, sum           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

    ; reset to 0
    mov byte [sum], 0

    jmp _start

phg: ; consumed 240, 159, 171
    ; assert next byte is 130
    cmp byte [buf + 2], 130
    jne _error

    ; add 200 to sum
    mov eax, [sum]
    add eax, 200
    mov [sum], eax

    jmp _start

sph: ; consumed 240, 159, 146
    ; assert next byte is 150
    cmp byte [buf + 2], 150
    jne _error

    ; add 50 to sum
    mov eax, [sum]
    add eax, 50
    mov [sum], eax

    jmp _start

pld: ; consumed 240, 159, 165
    ; assert next byte is 186
    cmp byte [buf + 2], 186
    jne _error

    ; add 5 to sum
    mov eax, [sum]
    add eax, 5
    mov [sum], eax

    jmp _start

match226: ; consumed: 226
    ; read next 2 bytes
    mov byte [length], 2
    call read

    ; if current byte is 156, jmp to spk
    cmp byte [buf], 156
    je spk

    ; assert current byte is 157, then continue to heart
    cmp byte [buf], 157
    jne _error

heart: ; consumed: 226, 157
    cmp byte [buf + 1], 164
    jne _error

    ; read next 3 bytes
    mov byte [length], 3
    call read

    ; assert next byte is 239
    cmp byte [buf], 239
    jne _error

    ; assert next byte is 184
    cmp byte [buf + 1], 184
    jne _error

    ; assert next byte is 143
    cmp byte [buf + 2], 143
    jne _error

    jmp _start

spk: ; consumed: 226, 156
    ; assert next byte is 168
    cmp byte [buf + 1], 168
    jne _error

    ; add 10 to sum
    mov eax, [sum]
    add eax, 10
    mov [sum], eax
    
    jmp _start


cma: ; consumed: 44
    ; add 1 to sum
    inc byte [sum]

    jmp _start
    
