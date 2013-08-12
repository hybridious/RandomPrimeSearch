.586 ;586 required for rdtsc
.model flat,stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib

.data
NotPrime db 'Sorry, %u is not prime',13,10,0
IsPrime db '%u is prime',13,10,0

.data?
RandomSeed    dd    ? ;holds our seed
Buffer db 100 dup (?) ;good for concating strings
.code

; Entry: EAX == Max_Val.
;
; Return: EAX == Random number between 0..Max_Val-1.
; routine by T-2000

Rand:            assume ebp:ptr vars
            push ecx
                push edx
                push eax

            rdtsc
            mov ecx,RandomSeed ; random seed
            add eax,ecx

            rol ecx, 1
            add ecx, 666h
            mov RandomSeed,ecx ; random seed

            push 32
            pop ecx

CRC_Bit:             shr eax, 1
                jnc Loop_CRC_Bit
                xor eax,0EDB88320h

Loop_CRC_Bit:       loop CRC_Bit    
                pop ecx
                xor edx,edx
                div ecx

            xchg edx,eax
            or eax,eax

            pop edx
            pop ecx
            retn

ProcStart:
Step1:
mov eax,1000
call Rand ;get random number between 0 and 999
mov ecx,eax ;store our rnd
mov ebx,2
xor edx,edx ;clear out edx
div ebx ;eax/2
cmp edx,0 ; Check if remainder is 0
jne Step2 ; if its anything but 0 jmp to next step
je Step1 ;we know it is an odd number

Step2:

cmp ecx,1
je PrimeJump
mov esi,ecx ;use esi as our incremental divisior
@@: ;short jump marker
sub esi,1 ;subtract 1 from esi
cmp esi,1 ; is esi 1 (if its this far then yes its prime)
je PrimeJump ;print prime
mov eax,ecx ; move our random number to eax for div
xor edx,edx ;clear out edx
div esi ;eax/esi (random number/ randomumber - number of times this has looped)
cmp edx,0 ;is remainder (edx) 0? this means it divided evenly (4/2 == remainder of 0 and 4 is not prime)
je NonPrimeJump ;if it is, inform our user we are nolonger prime
jne @B ;if it is not 0 lets do our loop again

PrimeJump: ;Print if the number is prime
invoke wsprintf,addr Buffer,addr IsPrime,ecx
invoke StdOut,addr Buffer
invoke Sleep,10000

NonPrimeJump: ;Print if the number is not prime
invoke wsprintf,addr Buffer,addr NotPrime,ecx
invoke StdOut,addr Buffer
jmp Step1
end ProcStart
