    .equ JTAG_DATA, 0x10001000
    .equ JTAG_CTRL, 0x10001004
    .equ LEDR,      0x10000000
    .equ HEX3_0,    0x10000020
    .equ HEX7_4,    0x10000030

    .equ STACK_TOP, 0x00100000   
    .equ DELAY_COUNT, 150000    
    .equ LED_ON_DELAY,  6000000   
    .equ LED_OFF_DELAY, 2500000  

    .org 0x0
    .global _start
_start:
    movia   sp, STACK_TOP
    call    main
stop:
    br      stop


main:
    movia   r8, HEX3_0
    stwio   r0, 0(r8)           
    movia   r8, HEX7_4
    stwio   r0, 0(r8)             

    movia   r4, welcome_msg
    call    print_string

menu_loop:
    movia   r4, menu_msg
    call    print_string
    call    read_char
    mov     r5, r2
    call    putc
    movia   r4, newline
    call    print_string

    movi    r6, '1'
    beq     r2, r6, op_suma
    movi    r6, '2'
    beq     r2, r6, op_resta
    movi    r6, '3'
    beq     r2, r6, op_mult
    movi    r6, '4'
    beq     r2, r6, op_div
    movi    r6, '5'
    beq     r2, r6, op_fx
    movi    r6, '6'
    beq     r2, r6, op_juego
    movi    r6, '0'
    beq     r2, r6, pc_no         

    movia   r4, invalid_msg
    call    print_string
    br      menu_loop

op_suma:
    movia   r4, sel_suma_msg
    call    print_string
    call    pedir_ab
    mov     r16, r2
    mov     r17, r3
    add     r18, r16, r17
    call    delay
    movia   r4, msg_resultado
    call    print_string
    mov     r5, r18
    call    print_sdec
    movia   r4, newline
    call    print_string
    mov     r5, r18
    call    mostrar_hex
    call    preguntar_continuar
    br      menu_loop

op_resta:
    movia   r4, sel_resta_msg
    call    print_string
    call    pedir_ab
    mov     r16, r2
    mov     r17, r3
    sub     r18, r16, r17
    call    delay
    movia   r4, msg_resultado
    call    print_string
    mov     r5, r18
    call    print_sdec
    movia   r4, newline
    call    print_string
    mov     r5, r18
    call    mostrar_hex
    call    preguntar_continuar
    br      menu_loop

op_mult:
    movia   r4, sel_mult_msg
    call    print_string
    call    pedir_ab
    mov     r16, r2
    mov     r17, r3
    mov     r5, r16
    mov     r6, r17
    call    multiplicar
    mov     r18, r2
    call    delay
    movia   r4, msg_resultado
    call    print_string
    mov     r5, r18
    call    print_sdec
    movia   r4, newline
    call    print_string
    mov     r5, r18
    call    mostrar_hex
    call    preguntar_continuar
    br      menu_loop

op_div:
    movia   r4, sel_div_msg
    call    print_string
    call    pedir_ab
    mov     r16, r2
    mov     r17, r3
    bne     r17, r0, div_ok
    movia   r4, msg_div_cero
    call    print_string
    call    preguntar_continuar
    br      menu_loop
div_ok:
    mov     r5, r16
    movi    r18, 0
div_loop:
    blt     r5, r17, div_done
    sub     r5, r5, r17
    addi    r18, r18, 1
    br      div_loop
div_done:
    mov     r19, r5
    call    delay
    movia   r4, msg_resultado
    call    print_string
    movia   r4, msg_cociente
    call    print_string
    mov     r5, r18
    call    print_sdec
    movia   r4, msg_residuo
    call    print_string
    mov     r5, r19
    call    print_sdec
    movia   r4, msg_close_paren
    call    print_string
    mov     r5, r18
    call    mostrar_hex
    call    preguntar_continuar
    br      menu_loop

op_fx:
    movia   r4, sel_fx_msg
    call    print_string

    movia   r4, prompt_fx_a
    call    read_value
    mov     r16, r2
    movia   r4, prompt_fx_b
    call    read_value
    mov     r17, r2
    movia   r4, prompt_fx_c
    call    read_value
    mov     r18, r2
    movia   r4, prompt_fx_x
    call    read_value
    mov     r19, r2

    movia   r4, confirm_values_msg
    call    print_string
    movia   r4, msg_a_eq
    call    print_string
    mov     r5, r16
    call    print_dec
    movia   r4, msg_b_eq
    call    print_string
    mov     r5, r17
    call    print_dec
    movia   r4, msg_c_eq
    call    print_string
    mov     r5, r18
    call    print_dec
    movia   r4, msg_x_eq
    call    print_string
    mov     r5, r19
    call    print_dec
    movia   r4, newline
    call    print_string

    mov     r5, r19
    mov     r6, r19
    call    multiplicar          
    mov     r5, r16
    mov     r6, r2
    call    multiplicar         
    mov     r20, r2

    mov     r5, r17
    mov     r6, r19
    call    multiplicar          

    add     r20, r20, r2
    add     r20, r20, r18        

    call    delay
    movia   r4, msg_resultado
    call    print_string
    mov     r5, r20
    call    print_sdec
    movia   r4, newline
    call    print_string
    mov     r5, r20
    call    mostrar_hex
    call    preguntar_continuar
    br      menu_loop

op_juego:
    movia   r4, sel_juego_msg
    call    print_string
    movia   r4, juego_instrucciones_msg
    call    print_string

    movia   r4, juego_listo_msg
    call    print_string
    call    read_char             
    mov     r6, r2                 
    mov     r5, r2
    call    putc
    movia   r4, newline
    call    print_string

    mov     r5, r6
    call    generar_secuencia      
                                       

    movia   r16, secuencia_juego   
    movi    r17, 5                  

    movia   r4, juego_mostrando_msg
    call    print_string
    mov     r18, r16
    mov     r19, r17
jg_show_loop:
    beq     r19, r0, jg_show_done
    ldb     r20, 0(r18)
    mov     r5, r20
    call    mostrar_led_pos          
    addi    r18, r18, 1
    subi    r19, r19, 1
    br      jg_show_loop
jg_show_done:
    movia   r4, juego_turno_msg
    call    print_string

    mov     r18, r16
    mov     r19, r17
jg_check_loop:
    beq     r19, r0, jg_win
    ldb     r20, 0(r18)
    movia   r4, juego_esperando_msg
    call    print_string
    call    leer_posicion_juego     
    movia   r4, juego_recibido_msg
    call    print_string
    mov     r5, r2
    call    print_dec
    movia   r4, newline
    call    print_string

    beq     r2, r20, jg_correcto
    movia   r4, juego_fallo_msg
    call    print_string
    br      op_juego_fin
jg_correcto:
    addi    r18, r18, 1
    subi    r19, r19, 1
    br      jg_check_loop
jg_win:
    movia   r4, juego_gano_msg
    call    print_string
op_juego_fin:
    call    preguntar_continuar
    br      menu_loop

pedir_ab:
    subi    sp, sp, 8
    stw     ra, 4(sp)

    movia   r4, prompt_a
    call    read_value
    stw     r2, 0(sp)        

    movia   r4, prompt_b
    call    read_value
    mov     r6, r2               
    ldw     r7, 0(sp)          

    movia   r4, confirm_values_msg
    call    print_string
    movia   r4, msg_a_eq
    call    print_string
    mov     r5, r7
    call    print_dec
    movia   r4, msg_b_eq
    call    print_string
    mov     r5, r6
    call    print_dec
    movia   r4, newline
    call    print_string

    mov     r2, r7              
    mov     r3, r6             

    ldw     ra, 4(sp)
    addi    sp, sp, 8
    ret

preguntar_continuar:
    subi    sp, sp, 4
    stw     ra, 0(sp)

    movia   r4, preg_continuar_msg
    call    print_string
pc_leer:
    call    read_char
    mov     r5, r2
    call    putc
    movia   r4, newline
    call    print_string

    movi    r6, 'S'
    beq     r2, r6, pc_si
    movi    r6, 's'
    beq     r2, r6, pc_si
    movi    r6, 'N'
    beq     r2, r6, pc_no
    movi    r6, 'n'
    beq     r2, r6, pc_no

    movia   r4, preg_invalida_msg
    call    print_string
    br      pc_leer
pc_si:
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret
pc_no:
    movia   r4, despedida_msg
    call    print_string
fin_programa:
    br      fin_programa

read_value:
    subi    sp, sp, 8
    stw     ra, 4(sp)
    stw     r4, 0(sp)
rv_retry:
    ldw     r4, 0(sp)
    call    print_string
    call    read_char
    mov     r5, r2
    call    putc
    movia   r4, newline
    call    print_string

    movi    r6, '0'
    blt     r2, r6, rv_invalid
    movi    r6, '9'
    bgt     r2, r6, rv_check_af
    movi    r6, '0'
    sub     r2, r2, r6
    br      rv_done
rv_check_af:
    movi    r6, 'A'
    blt     r2, r6, rv_check_lower
    movi    r6, 'F'
    bgt     r2, r6, rv_check_lower
    movi    r6, 'A'
    sub     r2, r2, r6
    addi    r2, r2, 10
    br      rv_done
rv_check_lower:
    movi    r6, 'a'
    blt     r2, r6, rv_invalid
    movi    r6, 'f'
    bgt     r2, r6, rv_invalid
    movi    r6, 'a'
    sub     r2, r2, r6
    addi    r2, r2, 10
    br      rv_done
rv_invalid:
    movia   r4, invalid_val_msg
    call    print_string
    br      rv_retry
rv_done:
    ldw     ra, 4(sp)
    addi    sp, sp, 8
    ret

multiplicar:
    subi    sp, sp, 4
    stw     ra, 0(sp)
    movi    r2, 0
    mov     r7, r5
    mov     r8, r6
mul_loop:
    beq     r8, r0, mul_done
    add     r2, r2, r7
    subi    r8, r8, 1
    br      mul_loop
mul_done:
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret

leer_posicion_juego:
    subi    sp, sp, 4
    stw     ra, 0(sp)
lpj_retry:
    call    read_char
    mov     r5, r2
    call    putc
    movia   r4, newline
    call    print_string

    movi    r6, '1'
    beq     r2, r6, lpj_p1
    movi    r6, '2'
    beq     r2, r6, lpj_p2
    movi    r6, '3'
    beq     r2, r6, lpj_p3
    movi    r6, '4'
    beq     r2, r6, lpj_p4
    movi    r6, '5'
    beq     r2, r6, lpj_p5

    movia   r4, juego_tecla_invalida_msg
    call    print_string
    br      lpj_retry
lpj_p1:
    movi    r2, 1
    br      lpj_done
lpj_p2:
    movi    r2, 2
    br      lpj_done
lpj_p3:
    movi    r2, 3
    br      lpj_done
lpj_p4:
    movi    r2, 4
    br      lpj_done
lpj_p5:
    movi    r2, 5
lpj_done:
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret

generar_secuencia:
    subi    sp, sp, 4
    stw     ra, 0(sp)

    mov     r7, r5                 
    movia   r8, secuencia_juego
    movi    r9, 5                   
gs_loop:
    beq     r9, r0, gs_done
    slli    r10, r7, 2               
    add     r10, r10, r7             
    addi    r10, r10, 3                
    andi    r7, r10, 0xFF               

    mov     r11, r7
gs_mod:
    movi    r12, 5
    blt     r11, r12, gs_mod_done
    subi    r11, r11, 5
    br      gs_mod
gs_mod_done:
    addi    r11, r11, 1                 
    stb     r11, 0(r8)
    addi    r8, r8, 1
    subi    r9, r9, 1
    br      gs_loop
gs_done:
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret


mostrar_led_pos:
    subi    sp, sp, 4
    stw     ra, 0(sp)
    subi    r6, r5, 1         
    movi    r7, 1
    sll     r8, r7, r6       
    movia   r9, LEDR
    stwio   r8, 0(r9)
    movia   r5, LED_ON_DELAY
    call    delay_custom
    stwio   r0, 0(r9)           
    movia   r5, LED_OFF_DELAY
    call    delay_custom
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret

delay_custom:
dc_loop:
    subi    r5, r5, 1
    bne     r5, r0, dc_loop
    ret

mostrar_hex:
    subi    sp, sp, 4
    stw     ra, 0(sp)

    andi    r9, r5, 0xF
    srli    r10, r5, 4
    andi    r10, r10, 0xF

    movia   r11, seg7_table
    add     r12, r11, r9
    ldbu    r13, 0(r12)        
    add     r12, r11, r10
    ldbu    r14, 0(r12)         

    slli    r7, r14, 8          
    or      r7, r7, r13           

    movia   r8, HEX3_0
    stwio   r7, 0(r8)

    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret
	
delay:
    movia   r8, DELAY_COUNT
delay_loop:
    subi    r8, r8, 1
    bne     r8, r0, delay_loop
    ret

print_sdec:
    subi    sp, sp, 4
    stw     ra, 0(sp)
    bge     r5, r0, psd_pos
    mov     r7, r5
    movi    r5, '-'
    call    putc
    sub     r5, r0, r7
    call    print_udec
    br      psd_done
psd_pos:
    call    print_udec
psd_done:
    ldw     ra, 0(sp)
    addi    sp, sp, 4
    ret

print_udec:
    subi    sp, sp, 24
    stw     ra, 20(sp)
    stw     r5, 16(sp)
    movi    r9, 0
    stw     r9, 12(sp)

    movia   r7, pow_table
    movi    r11, 4
pu_loop:
    ldw     r9, 0(r7)
    movi    r10, 0
pu_sub:
    ldw     r5, 16(sp)
    blt     r5, r9, pu_digit_done
    sub     r5, r5, r9
    stw     r5, 16(sp)
    addi    r10, r10, 1
    br      pu_sub
pu_digit_done:
    ldw     r9, 12(sp)
    bne     r9, r0, pu_print
    bne     r10, r0, pu_print
    movi    r9, 1
    beq     r11, r9, pu_print
    br      pu_skip
pu_print:
    movi    r9, 1
    stw     r9, 12(sp)
    addi    r5, r10, '0'
    call    putc
pu_skip:
    addi    r7, r7, 4
    subi    r11, r11, 1
    bne     r11, r0, pu_loop

    ldw     ra, 20(sp)
    addi    sp, sp, 24
    ret

print_dec:
    subi    sp, sp, 8
    stw     ra, 4(sp)
    stw     r5, 0(sp)
    movi    r8, 10
    bge     r5, r8, pd_tens
    ldw     r5, 0(sp)
    addi    r5, r5, '0'
    call    putc
    br      pd_done
pd_tens:
    movi    r5, '1'
    call    putc
    ldw     r5, 0(sp)
    subi    r5, r5, 10
    addi    r5, r5, '0'
    call    putc
pd_done:
    ldw     ra, 4(sp)
    addi    sp, sp, 8
    ret

print_string:
    subi    sp, sp, 8
    stw     ra, 4(sp)
    stw     r4, 0(sp)
ps_loop:
    ldb     r5, 0(r4)
    beq     r5, r0, ps_done
    call    putc
    ldw     r4, 0(sp)
    addi    r4, r4, 1
    stw     r4, 0(sp)
    br      ps_loop
ps_done:
    ldw     ra, 4(sp)
    addi    sp, sp, 8
    ret

/* ============================================================
 * putc: espera espacio en el JTAG UART y envia r5
 * ============================================================ */
putc:
    movia   r8, JTAG_CTRL
pc_wait:
    ldwio   r9, 0(r8)
    movhi   r10, 0xffff
    and     r9, r9, r10
    beq     r9, r0, pc_wait
    movia   r8, JTAG_DATA
    stwio   r5, 0(r8)
    ret
	
read_char:
    movia   r8, JTAG_DATA
rc_wait:
    ldwio   r9, 0(r8)
    srli    r10, r9, 15
    andi    r10, r10, 1
    beq     r10, r0, rc_wait
    andi    r2, r9, 0xff
    ret

/*
 * Datos
 */
    .align 2
pow_table:
    .word   1000, 100, 10, 1

seg7_table:               
                                    
    .byte   0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07
    .byte   0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71

secuencia_juego:
    .byte   3, 5, 1, 4, 2       
welcome_msg:
    .asciz "\n=================================================\n Bienvenido a la Calculadora Nios II - DE2-115\n=================================================\n"

menu_msg:
    .asciz "\nSeleccione una opcion escribiendo un numero (no necesita Enter):\n  1) Suma\n  2) Resta\n  3) Multiplicacion\n  4) Division\n  5) F(x) = a*x^2 + b*x + c\n  6) Juego de memoria (LEDs, se responde con 1-5)\n  0) Salir\n> "

newline:
    .asciz "\n"

invalid_msg:
    .asciz "Esa opcion no existe. Por favor escriba un numero del 0 al 6.\n"

invalid_val_msg:
    .asciz "Valor invalido. Escriba un digito 0-9 o una letra A-F (para 10-15).\n"

sel_suma_msg:
    .asciz ">> Seleccionaste SUMA.\n"
sel_resta_msg:
    .asciz ">> Seleccionaste RESTA.\n"
sel_mult_msg:
    .asciz ">> Seleccionaste MULTIPLICACION.\n"
sel_div_msg:
    .asciz ">> Seleccionaste DIVISION.\n"
sel_fx_msg:
    .asciz ">> Seleccionaste F(x) = a*x^2 + b*x + c.\n"
sel_juego_msg:
    .asciz ">> Seleccionaste el JUEGO DE MEMORIA.\n"

prompt_a:
    .asciz "Escriba el valor de A (0-9 o A-F para 10-15): "
prompt_b:
    .asciz "Escriba el valor de B (0-9 o A-F para 10-15): "
prompt_fx_a:
    .asciz "Escriba el coeficiente a (0-9 o A-F para 10-15): "
prompt_fx_b:
    .asciz "Escriba el coeficiente b (0-9 o A-F para 10-15): "
prompt_fx_c:
    .asciz "Escriba el coeficiente c (0-9 o A-F para 10-15): "
prompt_fx_x:
    .asciz "Escriba el valor de x (0-9 o A-F para 10-15): "

confirm_values_msg:
    .asciz "Valores que se usaran:\n"
msg_a_eq:
    .asciz "  A = "
msg_b_eq:
    .asciz "  B = "
msg_c_eq:
    .asciz "  C = "
msg_x_eq:
    .asciz "  X = "

msg_resultado:
    .asciz "Calculando... Resultado: "
msg_cociente:
    .asciz " (cociente = "
msg_residuo:
    .asciz ", residuo = "
msg_close_paren:
    .asciz ")\n"
msg_div_cero:
    .asciz "Error: no se puede dividir entre 0. Elige otra vez desde el menu.\n"

preg_continuar_msg:
    .asciz "\n¿Deseas hacer otra operacion? Escriba S para SI o N para SALIR: "
preg_invalida_msg:
    .asciz "Respuesta invalida. Escriba S o N.\n"
despedida_msg:
    .asciz "\n¡Gracias por usar la calculadora! Sesion terminada."

juego_instrucciones_msg:
    .asciz "\n=========== COMO JUGAR ===========\nSe van a encender 5 LEDs, uno por uno, en cierto\norden (puede repetirse el mismo LED mas de una vez). Debes\nmemorizar ese orden.\n\nLa POSICION de cada LED se cuenta del mas a la izquierda hasta la quinto posicion hacia la derecha:\n\n   LED encendido                =  Posicion  =  Tecla a presionar\n   -----------------------------------------------------------------\n   LED 0 (el mas a la derecha)  =  1          =  1\n   LED 1                        =  2          =  2\n   LED 2                        =  3          =  3\n   LED 3                        =  4          =  4\n   LED 4                        =  5          =  5\n\n(La tecla es SIEMPRE el mismo numero que la posicion.)\n\nIMPORTANTE: mientras se muestra la secuencia, el programa NO\nte va a decir por texto cual LED se encendio -- tienes que\nfijarte tu mismo en cual LED se prende y recordar que numero\nle corresponde (segun la tabla de arriba). Despues, cuando sea\ntu turno, escribe esos numeros en el mismo orden (sin Enter,\nuna tecla a la vez). Si escribes algo que no sea 1-5, te lo\nvoy a avisar y podras intentar de nuevo, sin perder tu progreso.\n===================================\n"
juego_listo_msg:
    .asciz "\nEscribe cualquier tecla cuando estes listo para ver la secuencia: "
juego_mostrando_msg:
    .asciz "\nAhi va la secuencia (mira los LEDs con atencion):\n"
juego_turno_msg:
    .asciz "\n¡Tu turno! Escribe la secuencia completa, EN ORDEN, usando\nlos numeros del 1 al 5 (el mismo numero de cada posicion).\n"
juego_esperando_msg:
    .asciz "Escribe la siguiente posicion (1, 2, 3, 4 o 5)... "
juego_recibido_msg:
    .asciz "Escribiste la posicion: "
juego_tecla_invalida_msg:
    .asciz "  Esa tecla no se puede usar. Intenta de nuevo con una tecla valida (1, 2, 3, 4 o 5): "
juego_fallo_msg:
    .asciz "\nSecuencia incorrecta. Fallaste el juego.\n"
juego_gano_msg:
    .asciz "\n¡Felicidades! Completaste la secuencia correctamente.\n"

    .end