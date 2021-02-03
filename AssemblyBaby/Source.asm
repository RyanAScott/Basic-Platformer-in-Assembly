.386
INCLUDE Irvine32.inc
.model small
.stack 100h

; data declarations are basically variables
.data	

ground BYTE "------------------------------------------------------------------------------------------------------------------------",0

strScore BYTE "Your score is: ",0
score BYTE 0

xPos BYTE 20
yPos BYTE 20

xCoinPos BYTE ?
yCoinPos BYTE ?

inputChar BYTE ?

; actual assembly code
.code
main proc
	; draw ground at (0,29):
	mov dl, 0 ; x position
	mov dh, 29; y position
	call Gotoxy ; moves ground
	; allows the edx register to handle that large string
	mov	edx, OFFSET ground 
	call WriteString

	; draw player
	call DrawPlayer

	; draw coins!!!
	call CreateRandomCoin
	call DrawCoin

	call Randomize

	; this loop keeps the game running until the player quits
	gameLoop:
		
		; draw score
		mov dl, 0
		mov dh, 0
		call Gotoxy
		mov edx, OFFSET strScore
		call WriteString
		mov al, score
		; converts integer score into character score
		add al, '0'
		call WriteChar

		; getting points
		mov bl, xPos
		cmp bl, xCoinPos
		jne notCollecting
		mov bl, yPos
		cmp bl, yCoinPos
		jne notCollecting

		; player is intersecting coin
		inc score
		call CreateRandomCoin
		call DrawCoin

		notCollecting:
		; set the color of the player
		mov eax, white (black * 16)
		call SetTextColor

		; gravity logic
		gravity:
		cmp yPos, 28
		jge onGround
		; make player fall
		call UpdatePlayer
		inc yPos
		call DrawPlayer

		; this is the delay for the gravity 
		mov eax, 80
		call Delay

		jmp gravity
		onGround:

		; get user key input
		call ReadChar
		mov inputChar, al

		; exit game if user types 'x':
		cmp inputChar, "x"
		je exitGame

		cmp inputChar, "w"
		je moveUp

		cmp inputChar, "s"
		je moveDown

		cmp inputChar, "a"
		je moveLeft

		cmp inputChar, "d"
		je moveRight

		moveUp:
			; allow player to jump
			mov ecx, 1
			jumpLoop:
				call UpdatePlayer
				; decrease the y position of the player
				dec yPos 
				; draw the player in the new spot
				call DrawPlayer
				; delay so the jump can be seen
				mov eax, 50
				call Delay
			loop jumpLoop
			; acts as a break statement
			jmp gameLoop

		moveDown:
			call UpdatePlayer
			; increase the y position of the player
			inc yPos 
			; draw the player in the new spot
			call DrawPlayer 
			; acts as a break statement
			jmp gameLoop

		moveLeft:
			call UpdatePlayer
			; decrease the x position of the player
			dec xPos 
			; draw the player in the new spot
			call DrawPlayer 
			; acts as a break statement
			jmp gameLoop

		moveRight:
			call UpdatePlayer
			; increase the x position of the player
			inc xPos 
			; draw the player in the new spot
			call DrawPlayer 
			; acts as a break statement
			jmp gameLoop

	jmp gameLoop

	exitGame:
		exit
main endp

; procedures go out here
DrawPlayer PROC
	; draw player at (xPos, yPos)
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	; I could put a sprite here, technically
	mov al, "X" 
	call WriteChar
	ret
DrawPlayer ENDP

UpdatePlayer PROC
	; draw player at (xPos, yPos)
	mov dl, xPos
	mov dh, yPos
	call Gotoxy
	; Erase the player trail
	mov al, " " 
	call WriteChar
	ret
UpdatePlayer ENDP

DrawCoin PROC
	mov eax, yellow (yellow * 16)
	call SetTextColor
	mov dl, xCoinPos
	mov dh, yCoinPos
	call Gotoxy
	mov al, "X"
	call WriteChar
	ret
DrawCoin ENDP

CreateRandomCoin PROC
	mov eax, 35
	inc eax
	call RandomRange
	mov xCoinPos, al
	mov yCoinPos, 27
	ret
CreateRandomCoin ENDP

end main