section .data
    num1 dd 10             ; Primer número (32 bits)
    num2 dd 3              ; Segundo número
    num3 dd 2              ; Tercer número
    msg db "Resultado: ", 0 ; Mensaje inicial

section .bss
    buffer resb 12         ; Espacio para el resultado como texto (máximo 10 dígitos + terminador nulo)

section .text
    global _start

_start:
    ; Cargar números y realizar la resta
    mov eax, [num1]        ; Cargar num1 en EAX
    sub eax, [num2]        ; Restar num2
    sub eax, [num3]        ; Restar num3

    ; Mostrar mensaje inicial
    mov ecx, msg           ; Dirección del mensaje
    mov edx, 11            ; Longitud del mensaje
    call print_string      ; Llamar a subrutina para imprimir

    ; Convertir el resultado a texto
    call int_to_string

    ; Mostrar el resultado
    mov ecx, buffer        ; Dirección del buffer con el resultado
    call print_string      ; Llamar a subrutina para imprimir

    ; Salir del programa
    mov eax, 1             ; Llamada al sistema sys_exit
    xor ebx, ebx           ; Código de salida 0
    int 0x80               ; Interrupción del sistema

print_string:
    mov eax, 4             ; Llamada al sistema sys_write
    mov ebx, 1             ; File descriptor (1 = salida estándar)
    int 0x80               ; Interrupción del sistema
    ret

int_to_string:
    mov esi, buffer        ; Apuntar al inicio del buffer
    mov ecx, 10            ; Base decimal
    xor edx, edx           ; Limpiar DX

.int_to_string_loop:
    xor edx, edx           ; Limpiar DX
    div ecx                ; Dividir EAX por 10 (cociente en EAX, residuo en EDX)
    add dl, '0'            ; Convertir el residuo a carácter ASCII
    mov [esi], dl          ; Almacenar carácter en buffer
    inc esi                ; Mover al siguiente carácter
    test eax, eax          ; Verificar si EAX es 0
    jnz .int_to_string_loop ; Repetir si no es 0

    ; Terminar la cadena con nulo y revertir el orden
    mov byte [esi], 0      ; Agregar terminador nulo
    call reverse_string    ; Revertir cadena
    ret

; Subrutina para revertir la cadena
reverse_string:
    mov esi, buffer        ; Inicio del buffer
    mov edi, esi           ; Copia del puntero
    xor ecx, ecx

    ; Contar caracteres hasta el terminador nulo
.count_chars:
    cmp byte [edi], 0      
    je .reverse_done       
    inc edi                
    inc ecx                
    jmp .count_chars

.reverse_done:
    dec edi                ; Ajustar para apuntar al último carácter

    ; Revertir los caracteres
.reverse_loop:
    cmp esi, edi           
    jge .reverse_exit      
    mov al, [esi]          
    xchg al, [edi]         
    mov [esi], al          
    inc esi                
    dec edi                
    jmp .reverse_loop

.reverse_exit:
    ret


