DEFAULT REL 

;Michal Kaminski - ECOAR 17z
section .data
row_in_bytes	        dq 960 		;960 = 320 * 3 - row in image in bytes
black_start		dq 0		;saving the adress of the black box beggining
black_count		dq 0		;the width of black block ix pixels

section .text
global detect

detect:
	;Prolog
   	push   		rbp
	mov    		rbp, rsp

	;pushing used registers
    	push		rdi
	push		r10
	push		rbx

	mov		rbx,rdi		;address of our image is on rbx
	xor		r10,r10		;zeroing of dynamic counter
	
	;looking for black block in our image
Look_For_Black:  
	cmp		BYTE [rbx], 0 
	je		Black_Appeared
	cmp		r10, 75999
	je		WhiteBMP
	add		rbx, 3
	inc		r10		
	jmp		Look_For_Black

	;first black pixel appeared on the image
Black_Appeared:
	mov		[black_start], rbx
	mov		r10, 1
	
	;counting the width of our black box
Width_Of_Black_Block:
	cmp		BYTE [rbx], 0 
	jne		Setting_Up
	add		rbx, 3
	inc		r10
	jmp		Width_Of_Black_Block
	
	;moving to next row and saving the current counter - the end of block
Setting_Up:
	sub		r10,1
	mov		[black_count],r10
	mov		rbx, [black_start]
	add		rbx, [row_in_bytes]
	xor		r10,r10
	
	;looking for our shape in black box
Look_For_White:
	cmp		r10,[black_count]
	je		Next_Row
	cmp		BYTE [rbx], 0 
	jne		Subbing
	add		rbx,3
	inc		r10
	jmp		Look_For_White

	;end of row in black box
Next_Row:
	xor		r10,r10
	mov		rbx, [black_start]
	add		rbx, [row_in_bytes]
	mov		[black_start], rbx
	jmp		Look_For_White

	;we found white pixel in our box so we are moving one pixel back(one left - black one)
Subbing:
	sub		rbx,3
	
Shape_Checking:
	cmp		BYTE [rbx], 0 
	jne		Shape_1
	add		rbx, 3
	cmp		BYTE [rbx], 0 
	je		Shape_2
	sub		rbx, 3
	add		rbx, [row_in_bytes]
	jmp		Shape_Checking

WhiteBMP:
	mov		rax, 0
	jmp		Exit
	
Shape_1:
	mov		rax, 1
	jmp		Exit
	
Shape_2:
	mov		rax, 2
	
Exit:
    	;Popping used registers
	pop		rbx
	pop		r10
   	pop     	rdi
	
    	;Epilog       
    	mov     	rsp, rbp
    	pop     	rbp
    	ret		

