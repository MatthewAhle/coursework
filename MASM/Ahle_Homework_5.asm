TITLE Ahle_Homework_5		(Ahle_Homework_5.asm)

; Matthew Ahle
; CS71 / Homework 5               Date: 3/2/2014
; Description: This program sorts randomly generated numbers.  After introducing the program,
; the program takes user input in the range of 10-999.  It stores the numbers in an array,
; and displays the sorted numbers in descending order after first displaying the random 
; numbers, 10 numbers per line.  It also calculates and displays the median value, rounded
; to the nearest integer.

INCLUDE Irvine32.inc

    MIN = 10            ;lower range limit
    MAX = 200           ;upper range limit
    LO = 100        
    HI = 999        

.data

;title, intro, and prompts
	introduction_1		BYTE    "Homework 5: Sorting Random Lists			Author: Matthew Ahle", 0dh, 0ah, 0
	introduction_2		BYTE    "This program generates random numbers in the range  of 100-999, displays", 0dh, 0ah
						BYTE    "the original list, sorts the list, and calculates the median value.", 0dh, 0ah
						BYTE    "Finally, it displays the sorted list in descending order.", 0dh, 0ah, 0
	introduction_3		BYTE    "Input the number of random integers to be generated (10-200): ", 0 
	invalid_1			BYTE    "Number not in range!", 0dh, 0ah, 0
	output_1			BYTE    "The unsorted list: ", 0dh, 0ah, 0
	output_2			BYTE    "The median is: ", 0
	output_3			BYTE    "The sorted list: ", 0dh, 0ah, 0
	random_array		DWORD   MAX DUP(?)
	user_input			DWORD   ?
	farewell_1			BYTE    "Thank you, goodbye!", 0

.code
main PROC
    call    Randomize

; Introduction
    push    OFFSET  introduction_1
    push    OFFSET  introduction_2
    call    introduction

; Receive and validate user input
    push    OFFSET  invalid_1
    push    OFFSET  introduction_3
    push    OFFSET  user_input
    call    get_data

; Fill the array with random numbers in range 100-999
    push    OFFSET  random_array
    push    user_input
    call    fill_array

; Print unsorted results
    push    OFFSET  random_array
    push    user_input
    push    OFFSET  output_1
    call    display_list

; Sorting results for printing
    push    OFFSET  random_array
    push    user_input
    call    sort_list

; Print median
    push    OFFSET  random_array
    push    user_input
    push    OFFSET  output_2
    call    median

; Print sorted array
    push    OFFSET  random_array
    push    user_input
    push    OFFSET  output_3
    call    display_list

; Farewell statement
    push    OFFSET  farewell_1
    call    farewell

    exit
main ENDP


;-------------------------------------------------------
; Procedure introduction
; Gives an introduction to the program
; Registers modified: ebp, esp, edx
;-------------------------------------------------------
introduction PROC
    pushad
    mov     ebp, esp
    mov     edx, [ebp+40]
    call    writeString
    call    CrLf
    mov     edx, [ebp+36]
    call    writeString
    call    CrLf
    popad
    ret     8
introduction   ENDP


;-------------------------------------------------------
; Procedure get_data
; Prompts user for input and stores input
; Registers modified: ebp, esp, edx, ebx, eax
;-------------------------------------------------------
get_data PROC
    pushad

; Set up and prompt user for input  
    mov     ebp, esp
redo_input:
    mov     edx, [ebp+40]
    mov     ebx, [ebp+36]
    call    WriteString
    call    ReadInt

; Validating user input
    cmp     eax, MIN
    jl      invalid_input
    cmp     eax, MAX
    jg      invalid_input
    jmp     valid_input

; If user input is invalid
invalid_input:
    mov     edx, [ebp+44]
    call    WriteString
    jmp     redo_input
valid_input:
    call    CrLf
    mov     [ebx], eax
    popad
    ret     12
get_data ENDP


;-------------------------------------------------------
; Procedure fill_array
; Fills array with random integers
; Registers modified: ecx, edi, esp, ebp
;-------------------------------------------------------
fill_array   PROC
    pushad
    mov     ebp, esp    
    mov     ecx, [ebp+36]
    mov     edi, [ebp+40]
    fill_loop:
    call    next_random_number
    add     edi, 4  
    loop    fill_loop
    popad
    ret     8
fill_array   ENDP


;-------------------------------------------------------
; Procedure next_random_number
; Gets the next random number in the range specified by the user.
; Registers used:  eax, edi
;-------------------------------------------------------
next_random_number    PROC            
    mov     eax, HI
    sub     eax, LO
    inc     eax
    call    RandomRange 
    add     eax, LO         ; Confirming that eax is in range
    mov     [edi],eax       
    ret                     
next_random_number    ENDP


;-------------------------------------------------------
; Procedure sort_list
; Sorts the contents of an integer array
; Registers modified: ebp, esp, ecx, edi, eax, ebx, esi
;-------------------------------------------------------
sort_list    PROC
    pushad
    mov     ebp, esp
    mov     ecx, [ebp+36]
    mov     edi, [ebp+40]
    dec     ecx
    mov     ebx, 0

loop_outer:
    mov     eax, ebx
    mov     edx, eax
    inc     edx
    push    ecx
    mov     ecx, [ebp+36]
loop_inner:
    mov     esi, [edi+edx*4]
    cmp     esi, [edi+eax*4]
    jle     jump_to_next
    mov     eax, edx
jump_to_next:
    inc     edx
    cmp		edx, ecx
	jb		loop_inner

; Swap elements
    lea     esi, [edi+ebx*4]
    push    esi
    lea     esi, [edi+eax*4]
    push    esi
    call    exchange_elements
    pop     ecx
    inc     ebx
    loop    loop_outer

    popad
    ret     8
sort_list    ENDP


;-------------------------------------------------------
; Procedure exchange_elements
; Exchange_elements exchanges k and i
; Registers modified: ebp, esp, eax, ecx, ebx, edx
;-------------------------------------------------------
exchange_elements    PROC
    pushad
    mov		ebp,esp
    mov     eax, [ebp+40]       ;array[k] low number
    mov     ecx, [eax]
    mov     ebx, [ebp+36]       ;array[i] high number
    mov     edx, [ebx]
    mov     [eax], edx
    mov     [ebx], ecx
    popad       
    ret 8
exchange_elements    ENDP


;-------------------------------------------------------
; Procedure median
; Displays the median of an integer array
; Registers modified: ebp, esp, edi, edx, eax
;-------------------------------------------------------
median PROC
    pushad
    mov     ebp, esp
    mov     edi, [ebp+44]
    mov     edx, [ebp+36]
    call    writeString

; Calculates the median element
    mov     eax, [ebp+40]
    cdq
    mov     ebx, 2
    div     ebx
    shl     eax, 2
    add     edi, eax
    cmp     edx, 0
    je      even_array_average_median

; If the array size is odd, displays the middle value of the array         
    mov     eax, [edi]
    call    writeDec
    call    CrLf
    call    CrLf
    jmp     median_proc_end

even_array_average_median: ; Averaging the middle two values to obtain the true median
    mov     eax, [edi]
    add     eax, [edi-4]
    cdq     
    mov     ebx, 2
    div     ebx
    call    WriteDec
    call    CrLf
    call    CrLf
median_proc_end:
    popad
    ret 12
median ENDP


;-------------------------------------------------------
; Procedure display_list
; Displays the contents of an integer array, 10 per row
; with just one procedure for the sorted/unsorted lists
; Registers modified: ebp, esp, edx, ebx, eax
;-------------------------------------------------------
display_list PROC
    pushad
    mov     ebp, esp

;display string
    mov     edx, [ebp+36]
    call    writeString
    call    CrLf
    mov     ecx, [ebp+40]
    mov     edi, [ebp+44]
    mov     ebx, 0

; Counter for number of items per line
line_counter_loop:
    inc     ebx
    mov     eax, [edi]      
    call    writeDec
    add     edi, 4
    cmp     ebx, 10
    jne     do_not_CrLf
    call    CrLf
    mov     ebx, 0
    jmp     do_not_tab
do_not_CrLf:
    mov     al, TAB
    call    writeChar	; Places a tab if a new line is not needed
do_not_tab:
    loop line_counter_loop
    call    CrLf		; Places a carriage return when needed
    popad
    ret 12
display_list ENDP


;-------------------------------------------------------
; Procedure farewell
; Says farewell to the user
; Registers modified: ebp, esp, edx
;-------------------------------------------------------
farewell PROC
    pushad
    mov     ebp, esp
    mov     edx, [ebp+36]
    call    writeString
    call    CrLf
    popad
    ret     4
farewell ENDP

END main