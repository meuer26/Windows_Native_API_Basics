# Windows Native API Basics

Reversing and Calling Windows 11 Native API Syscalls with x64 Assembly (An oldy but a goody)

Dan O’Malley



## Why Do This?

Sure, we COULD use the normal/recommended Win API in Kernel32.dll
(either via C++ or Assembly), but...
- This allows us to better understand the Windows kernel syscall user-
side boundary activities
- This allows us to use native functions that may not be exposed in
Kernel32.dll
- This allows our binaries to be as compact as possible (~20-30 times
smaller than the smallest C++ binary I could write that does the same
function)
- Could be used to bypass certain EDR monitoring methods


## What do we need to know (4 items)?

- You need the to know the SSDT index to place in EAX prior to the syscall
(we can get this from NTDLL.DLL for our version of Windows)
- You need to know what arguments the native API function needs
(theoretically, this is straightforward inference from the C++
documentation, but there are several low-level gotcha’s)
- You need to know the architecture-specific calling conventions (ABI) for
the architecture (syscall is just an optimized function call to a lower CPL
value (Ring 0), which is a higher privilege level)
- You need to know how to layout the arguments in the registers and on the
stack correctly to make it work. There are several Windows-specific details
that are needed including Unicode strings, etc.


This included PDF will give you a starting point [Windows_Native_API_Basics](https://github.com/meuer26/Windows_Native_API_Basics/blob/main/Windows_Native_API_Basics.pdf).