; ml64 NTCreateFile.asm /Zf /link /subsystem:console /entry:main

; c000000d - invalid parameter??

; ULONG = QWORD

;stack parameters are pushed in opposite order
; RCX = ACCESS_MASK/DESIRED ACCESS
; RDX = POBJECT_ATTRIBUTES/OBJECT ATTRIBUTES
; R8 = PLARGE_INTEGER/ALLOCATION SIZE (Optional)
; R9 = ULONG/FILE ATTRIBUTES (Can be zero)

;these are pushed in this order (opposite of how they are in C++)
; PUSH ULONG/EALENGTH (size of bytes of EABUFFER)
; PUSH PVOID/EABUFFER (optional)
; PUSH ULONG/CREATEOPTIONS (required bit flag)


        .data

; path is in unicode (UTF-16) and in NT device form
; this (below) will go the symbolic links directory (GLOBAL??) and go from there
; check in winobj from sysinternals

        path dw "\", "?", "?", "\", "c", ":", "\", 
                "U", "s", "e", "r", "s", "\", 
                "D", "a", "n", "\", 
                "t", "e", "s", "t", ".", "t", "x", "t"

        align 8                                         ;extremely critical or RAX will store the 80000002 - data alignment mismatch error
        objatr qword 0,0,0,0,0,0
        unistring qword 0,0

        align 8
        filehandle qword 0

        align 8
        iostatusblock qword 0,0

        .code

main    proc
 
        mov qword ptr objatr[0], 48                     ;size of object attributes struct
        mov qword ptr objatr[8], 0                      ;root directory
        lea rax, [unistring]                            ;pointer to unicode string
        mov qword ptr objatr[16], rax                   ;add pointer of unicode string to object attributes struct
        mov qword ptr objatr[24], 64                    ;perms
        mov qword ptr objatr[32], 0        
        mov qword ptr objatr[40], 0

        mov word ptr unistring[0], 50                   ;specific 0x32 length (ushort), 0x34 max length (ushort) of unicode string
        mov word ptr unistring[2], 52
        lea rax, [path]                                 ;pointer to unicode string buffer
        mov qword ptr unistring[8], rax                 ;add pointer to unicode string to unicode pointer


        lea rcx, [filehandle]                           ;file handle is null
        mov edx, 120116h                                ;FILE_GENERIC_WRITE -> 0001 0010 0000 0001 0001 0110
        lea r8, [objatr]
        lea r9, [iostatusblock]
        
        ; pushing stack arguments in reverse order

        xor rax, rax
        push rax                                        ;EALENGTH

        push rax                                        ;EABUFFER

        mov rax, 20h
        push rax                                        ;CREATEOPTIONS

        mov rax, 5
        push rax                                        ;CREATEDISPOSITION

        mov rax, 2
        push rax                                        ;SHAREACCESS

        mov rax, 80h
        push rax                                        ;FILEATTRIBUTES

        xor rax, rax
        push rax                                        ;ALLOCATIONSIZE


        ; return address plus shadow space for 4 register arguments - RCX, RDX, R8, R9
        xor rax, rax
        push rax 
        push rax
        push rax
        push rax
        push rax


        mov r10, rcx
        mov eax, 055h                                   ;windows 11 NTDLL NTCREATFILE address
        syscall


main    endp
        end
