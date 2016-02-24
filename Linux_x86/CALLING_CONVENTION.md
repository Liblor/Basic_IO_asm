Calling Convention Basm x86
============================

##Parameters

Parameters in registers: `ecx`, `edx`, `eax`, `esi`, `edi`  
Parameters in stack: right to left  
The stack cleanup has to be done by the caller.  

Pseudocode to Basm:
```
many_parameters(a,b,c,d,e,f,g)
```

```
mov ecx, [a]  
mov edx, [b]  
mov eax, [c]  
mov esi, [d]  
mov edi, [e]  
push [g]  
push [f]  
call many_parameters
```

## Return value
Values are returned in ```eax```

## Caller/Callee Save
callee save: `ebx`  
caller save: `ecx`, `edx`, `eax`, `esi`, `edi`
