section .data
    num1 db 5      ; Primer número (5)
    num2 db 10     ; Segundo número (10)
    msg db 'Resultado: ', 0

section .bss
    result resb 1  ; Espacio para almacenar el resultado

section .text
    global _start

_start:
    ; Cargar los valores en los registros
    mov al, [num1] ; Cargar num1 en al
    mov bl, [num2] ; Cargar num2 en bl

    ; Realizar la multiplicación
    mul bl          ; al = al * bl

    ; Almacenar el resultado en la memoria
    mov [result], al ; Guardar el resultado en "result"

    ; Mostrar mensaje "Resultado: "
    mov eax, 4        ; syscall número 4 
    mov ebx, 1        ; file descriptor 1 
    mov ecx, msg      ; Dirección del mensaje
    mov edx, 12       ; Longitud del mensaje
    int 0x80          ; Llamada al sistema

    ; Mostrar el resultado (el valor de al es el resultado de la multiplicación)
    mov eax, 4        ; syscall número 4 
    mov ebx, 1        ; file descriptor 1 
    mov ecx, result   ; Dirección del resultado
    mov edx, 1        ; Longitud de los caracteres a escribir
    int 0x80          ; Llamada al sistema

    ; Salir del programa
    mov eax, 1        
    xor ebx, ebx      
    int 0x80          