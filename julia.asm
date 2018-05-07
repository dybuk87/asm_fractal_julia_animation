.386p
.model huge

STACK_SIZE equ 200h
d	   equ dword ptr

kod16 segment para public use16
 assume  cs:kod16, ds:kod16, ss:MYSTACK
start16:
 mov ax, kod16
 mov ds, ax

 mov ax, 0013h
 int 10h

 call pal
 
 finit
petla_p:
 mov ax, 09000h
 mov es, ax

 fld  d k1
 fadd d ak1
 fld  d k2
 fadd d ak2
 fst  d k2
 fst  d k1
 fsin
 fmul d l1024 
 fistp d cxx
 fcos
 fmul  d l1024
 fistp d cyy

 call julia
 
 

 mov ax, 0A000h
 mov es, ax
 push ds
  mov ax, 09000h
  mov ds, ax
  xor si, si
  xor di, di
  mov cx, 16000
  rep movsd
 pop ds

 mov ah, 1
 int 16h
jz petla_p

mov ax, 0003h
 int 10h

 mov ah, 4ch
 int 21h

k1      DD 0.0
k2      DD 0.0
ak1     DD 0.01
ak2     DD 0.015

l1024 dd 900.0

 x dd ?
 y dd ?
x2 dd ?
y2 dd ?
 i dw ?
 j dw ?

cxx dd 0
cyy dd 0

julia:
 mov ax, -2000
 mov j, ax
 xor di, di

 @petY:
   mov ax, -1920
   mov i, ax 

  @petX:  
    xor 	cl,	cl
    movsx	eax,	i
    movsx	ebx,	j
    mov		x,	eax
    mov		y,	ebx
    imul	eax
    mov		x2,	eax
    xchg	eax,	ebx
    imul	eax
    mov		y2,	eax
    add		eax,	ebx
    jc		koniec_while
    while_:
     cmp 	eax,	4*1024*1024
     jge	koniec_while	
     cmp	cl,	31
     jz		koniec_while

     inc 	cl
     mov	eax,	x
     imul	d y
     sar	eax,	9
     add	eax,	cyy
     mov	y,	eax
     mov	eax,	x2
     sub	eax,	y2
     sar	eax,	10
     add	eax,	cxx
     mov	x,	eax
     imul	eax
     mov	x2,	eax
     mov	eax,	y
     imul	eax
     mov	y2,	eax
     add	eax,	x2
     jc		koniec_while
    jmp while_
     koniec_while:
      mov es:[di], cl
      inc di
        


    mov ax, i
    add ax, 12
    mov i, ax
    cmp ax, 1920
  jl @petX 


  mov ax, j
  add ax, 20
  mov j, ax
  cmp ax, 2000
 jl @petY
ret  

pal:
 mov al,0d
 mov dx,3c8h
 out dx,al
 mov dx,3c9h
 mov bx,0
 ppp:
  mov ax,bx
  shl ax,1
  out dx,al
 
  mov al,0d
  out dx,al

  mov al,0d
  out dx,al
  inc bx
 cmp bx,32d
 jne ppp
ret

kod16 ends

MyStack segment para stack 'stack'
 db STACK_size dup(?)
MyStack ends

end start16