include masm32rt.inc

.data
  
  Node STRUCT
    key DWORD 0
    data DWORD 0    
    next DWORD 0
  Node ENDS

  n DWORD 0
  inp_format BYTE "%d", 0
  out_format BYTE "%d (%d) ", 0  
  newline BYTE 13, 10, 0
  heapHandle DWORD 0
  root DWORD 0

.code

insert PROC r: DWORD, key: DWORD, data: DWORD  
  .IF r == 0
    invoke HeapAlloc, heapHandle, HEAP_ZERO_MEMORY, SIZEOF(Node)
    mov ebx, key
    mov (Node PTR [eax]).key, ebx
    mov ebx, data
    mov (Node PTR [eax]).data, ebx  
    ret
  .ELSE
    mov esi, r
    invoke insert, (Node PTR [esi]).next, key, data  
    mov esi, r
    mov (Node PTR [esi]).next, eax
  .ENDIF
  mov eax, r
  ret
insert ENDP

printList PROC r: DWORD
   mov esi, r
  .IF esi != 0
     mov eax, (Node PTR [esi]).key
     mov ebx, (Node PTR [esi]).data  
     pushad
     invoke crt_printf, ADDR out_format, eax, ebx  
     invoke printList, (Node PTR [esi]).next
     popad
     mov esi, r
  .ENDIF
  ret
printList ENDP

Swap PROC a: DWORD, b: DWORD, _r: DWORD
   pushad
   mov ecx, a
   dec ecx
   mov edx, _r

   .IF ecx != 0
   @loop1:
     mov edx, (Node PTR [edx]).next
   loop @loop1
   .ENDIF

   mov ecx, b
   dec ecx
   mov ebx, _r
   
   .IF ecx != 0
   @loop2:
     mov ebx, (Node PTR [ebx]).next
   loop @loop2
   .ENDIF

   mov esi, (Node PTR [edx]).key
   mov edi, (Node PTR [ebx]).key
   
   mov (Node PTR [edx]).key, edi
   mov (Node PTR [ebx]).key, esi

   mov esi, (Node PTR [edx]).data  
   mov edi, (Node PTR [ebx]).data
   mov (Node PTR [edx]).data, edi
   mov (Node PTR [ebx]).data, esi
   popad
   ret
Swap ENDP

IndexInf PROC r: DWORD, i: DWORD
  push ebx
  push ecx
  mov ebx, r
  mov ecx, i
  dec ecx
  .IF ecx != 0
  @loop:
     mov ebx, (Node PTR [ebx]).next
  loop @loop 
  .ENDIF

  mov eax, (Node PTR [ebx]).key
  pop ecx
  pop ebx
  ret 
IndexInf ENDP

sort PROC r: DWORD, _n: DWORD
    pushad
    mov ecx, _n
    .IF ecx > 1
         mov ebx, _n
      @outer_loop:
        mov edi, 1
        mov esi, 1
          @inner_loop:
          inc esi
         .IF esi <= ebx
            invoke IndexInf, r, edi
            mov edx, eax  

            invoke IndexInf, r, esi
           
                
            .IF eax < edx  
                invoke Swap, edi, esi, r   
            .ENDIF
            inc edi     
             jmp @inner_loop
         .ENDIF
            dec ebx
                cmp ebx, 1
                jg @outer_loop
    .ENDIF
    popad
    ret
sort ENDP


main PROC
  invoke GetTickCount
  invoke nseed, eax
  invoke crt_scanf, ADDR inp_format, ADDR n
  invoke GetProcessHeap
  mov heapHandle, eax
  mov ecx, n
 @begin:
  push ecx
  invoke nrandom, 1000
  mov ebx, eax
  invoke nrandom, 1000
  pushad
  invoke crt_printf, ADDR out_format, ebx, eax 
  popad
  
  invoke insert, root, ebx, eax  
  mov root, eax
  pop ecx
  loop @begin
  
  pushad
  invoke crt_printf, ADDR newline
  popad
  
  invoke sort, root, n
  invoke printList, root
  
  ret
main ENDP

end main