global detect

;Michal Kaminski - ECOAR 17z
;symbolic adressess [ebp + x]

	%define     row_in_bytes[ebp-4]		;960 = 320 * 3 - row in image in bytes
	%define     black_start	[ebp-8]		;saving the adress of the black box beggining
	%define     black_count [ebp-12]	;the width of black block ix pixels

detect:
	; creating the frame - Prolog
	push    	ebp
	mov     	ebp, esp

	; pushing used registers
    	push    	esi
	push		ecx

	; the address of image to esi 
    	mov     	esi, [ebp+8]		;ebp+8 - first argument of our function - image
	xor		ecx,ecx			;zeroing ecx- dynamic counter
	
	;length of row in bytes
    	mov     	eax, 320		;mov	row_in_bytes, 960
    	lea     	edx, [eax+eax*2]	
    	mov		row_in_bytes, edx

	;looking for black block in our image
Look_For_Black:  
	cmp		BYTE [esi], 0 
	je		Black_Appeared	
	cmp		ecx, 75799		;240*320 - 1
	je		White_BMP
	add		esi, 3
	inc		ecx		
	jmp		Look_For_Black

	;first black pixel appeared on the image
Black_Appeared:
	mov		black_start, esi
	xor		ecx,ecx

	;counting the width of our black box
Width_Of_Black_Block:
	cmp		BYTE [esi], 0 
	jne		Setting_Up
	add		esi, 3
	inc		ecx
	jmp		Width_Of_Black_Block

	;moving to next row and saving the current counter - the end of block
Setting_Up:
	sub		ecx,1
	mov		black_count,ecx
	mov		esi, black_start
	add		esi, row_in_bytes
	xor		ecx,ecx

	;looking for our shape in black box
Look_For_White:
	cmp		ecx,black_count
	je		Next_Row
	cmp		BYTE [esi], 0 
	jne		Subbing
	add		esi,3
	inc		ecx
	jmp		Look_For_White

	;end of row in black box
Next_Row:
	xor		ecx,ecx
	mov		esi, black_start
	add		esi, row_in_bytes
	mov		black_start, esi
	jmp		Look_For_White

	;we found white pixel in our box so we are moving one pixel back(one left - black one)
Subbing:
	sub		esi,3

	;we are moving up, pixel by pixel - checking if it is white
Shape_Checking:
	cmp		BYTE [esi], 0 
	jne		Shape_1
	add		esi, 3
	cmp		BYTE [esi], 0 
	je		Shape_2
	sub		esi, 3
	add		esi, row_in_bytes
	jmp		Shape_Checking

White_BMP:
	mov		eax, 0
	jmp		Exit

Shape_1:
	mov		eax, 1
	jmp		Exit

Shape_2:
	mov		eax, 2

Exit:
	;poping registers
	pop		ecx
    	pop     	esi
	
	;epilog        
   	mov		esp, ebp
    	pop		ebp
    	ret		

