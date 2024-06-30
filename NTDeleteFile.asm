; ml64 NTDeleteFile.asm /Zf /link /subsystem:console /entry:main

        .data

        path dw "\", "?", "?", "\", "c", ":", "\", 
                "U", "s", "e", "r", "s", "\", 
                "D", "a", "n", "\", 
                "t", "e", "s", "t", ".", "t", "x", "t"

        align 8                                         ;extremely critical or RAX will store the 80000002 - data alignment mismatch error
        objatr qword 0,0,0,0,0,0
        unistring qword 0,0

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

        lea rcx, [objatr]                               ;place memory location of object attributes struct in RCX (64 bit ABI) when doing the syscall to delete

        mov r10, rcx
	mov eax, 0d7h                                   ;windows 11 NTDLL NTDELETEFILE address
        syscall

main    endp
        end