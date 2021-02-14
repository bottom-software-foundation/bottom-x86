section .bss
   char resb 1 ; allocate storage for current char
   sum resb 1 ; allocate storage the sum

section .data
    lf db 0xa ; regular newline
    hu db 'h' ; regular newline
    err db 0xa, 'Invalid bottom.', 0xa

section .text
global _start
read:
    ; read stdin into buffer of size 1
    mov edx, 1             ; max length
    mov ecx, char          ; buffer
    mov ebx, 0             ; stdin
    mov eax, 3             ; sys_read
    int 0x80

    cmp eax, 0             ; error if length equals 0
    je _error

    ret
_start:
    ; read stdin into buffer of size 1
    mov edx, 1             ; max length
    mov ecx, char          ; buffer
    mov ebx, 0             ; stdin
    mov eax, 3             ; sys_read
    int 0x80

    cmp eax, 0             ; exit if length equals 0
    je exit

    mov ebx, [char]

    cmp ebx, 240
    je match240

    cmp ebx, 226
    je match226

    cmp ebx, 44
    je cma

    mov edx, 1             ; length
    mov ecx, char           ; buffer
    mov ebx, 1             ; stdout
    mov eax, 4             ; sys_write
    int 0x80

_error:
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
    call read
    mov ebx, [char]
    cmp ebx, 159
    jne _error

    ; read next byte
    call read
    mov ebx, [char]

    cmp ebx, 171
    je phg

    cmp ebx, 146
    je sph

    cmp ebx, 165
    je pld

    ; assert that this is a seperator and continue to bsp
    cmp ebx, 145
    jne _error

bsp: ; consumed: 240, 159, 145
    ; assert next byte is 137
    call read
    mov ebx, [char]
    cmp ebx, 137
    jne _error

    ; assert next byte is 240
    call read
    mov ebx, [char]
    cmp ebx, 240
    jne _error

    ; assert next byte is 159
    call read
    mov ebx, [char]
    cmp ebx, 159
    jne _error

    ; assert next byte is 145
    call read
    mov ebx, [char]
    cmp ebx, 145
    jne _error

    ; assert next byte is 136
    call read
    mov ebx, [char]
    cmp ebx, 136
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
    call read
    mov ebx, [char]
    cmp ebx, 130
    jne _error

    ; add 200 to sum
    mov eax, [sum]
    add eax, 200
    mov [sum], eax

    jmp _start

sph: ; consumed 240, 159, 146
    ; assert next byte is 150
    call read
    mov ebx, [char]
    cmp ebx, 150
    jne _error

    ; add 50 to sum
    mov eax, [sum]
    add eax, 50
    mov [sum], eax

    jmp _start

pld: ; consumed 240, 159, 165
    ; assert next byte is 186
    call read
    mov ebx, [char]
    cmp ebx, 186
    jne _error

    ; add 5 to sum
    mov eax, [sum]
    add eax, 5
    mov [sum], eax

    jmp _start

match226: ; consumed: 226
    ; read next byte
    call read
    mov ebx, [char]

    ; if current byte is 156, jmp to spk
    cmp ebx, 156
    je spk

    ; assert current byte is 157, then continue to heart
    cmp ebx, 157
    jne _error

heart: ; consumed: 226, 157
    ; assert next byte is 164
    call read
    mov ebx, [char]
    cmp ebx, 164
    jne _error

    ; assert next byte is 239
    call read
    mov ebx, [char]
    cmp ebx, 239
    jne _error

    ; assert next byte is 184
    call read
    mov ebx, [char]
    cmp ebx, 184
    jne _error

    ; assert next byte is 143
    call read
    mov ebx, [char]
    cmp ebx, 143
    jne _error

    jmp _start

spk: ; consumed: 226, 156
    ; assert next byte is 168
    call read
    mov ebx, [char]
    cmp ebx, 168
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
    
