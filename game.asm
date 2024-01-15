;; Pandelis Margaronis
;; Spring 2023

DOSEXIT = 4C00h
DOS = 21h
BIOS = 10h
TIMER = 8h

.8086

.data
message	BYTE "P R E S S  A N Y  K E Y  T O  S T A R T", 0

Alarms	LABEL	WORD
	    WORD	60 DUP(0)
HandlerCount = ($ - Alarms) / 4
colorVar BYTE 0
currLocation BYTE 0                 ; talking about column
alienKilled BYTE 0
alienKilled1 BYTE 0
alienKilled2 BYTE 0
alienKilled3 BYTE 0
alienKilled4 BYTE 0
alienKilled5 BYTE 0
alienKilled6 BYTE 0
alienKilled7 BYTE 0
alienKilled8 BYTE 0
alienKilled9 BYTE 0
alienKilled10 BYTE 0
score10s BYTE 48
score100s BYTE 48
score1000s BYTE 48
score10000s BYTE 48
alienDown BYTE 0
SpaceshipHit BYTE 0
DroneHit BYTE 0
spaceshipMovement BYTE 0
enemyshipMovement BYTE 0
drone1Movement BYTE 12
drone2Movement BYTE 12
drone3Movement BYTE 12
spaceshipPosition BYTE 0
bulletMovement BYTE 22
shot BYTE 0
currRowEnemy1 BYTE 7
currColEnemy1 BYTE 0

currRowEnemy2 BYTE 7
currColEnemy2 BYTE 0

currRowEnemy3 BYTE 7
currColEnemy3 BYTE 0

currRowEnemy4 BYTE 7
currColEnemy4 BYTE 0

currRowEnemy5 BYTE 7
currColEnemy5 BYTE 0

currRowEnemy6 BYTE 7
currColEnemy6 BYTE 0

currRowEnemy7 BYTE 7
currColEnemy7 BYTE 0

currRowEnemy8 BYTE 7
currColEnemy8 BYTE 0

currRowEnemy9 BYTE 7
currColEnemy9 BYTE 0

currRowEnemy10 BYTE 7
currColEnemy10 BYTE 0

activeEnemyCol BYTE 1
EnemyDirection BYTE 1       ; if 1, moving to right (increasing col) // if 0, moving to left (decreasing col)

drone1hit BYTE 0
drone2hit BYTE 0
drone3hit BYTE 0

GameOver BYTE 0
.code

mWrite MACRO text
    LOCAL string
.data
    string BYTE text, 0
.code
    push dx
    mov dx, OFFSET string
    call WriteString
    call NewLine
    pop dx
ENDM

.data

splash LABEL BYTE
BYTE "  1 U P                          H I - S C O R E                         2 U P  "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                            A S T R O   I N V A D E R                           "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "      2 0 2 3   M A R G A R O N I S R O U H A N A   E L E C T R O N I C S       "
BYTE "                                                                                "
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 0

gameStart LABEL BYTE
BYTE "  1 U P                          H I - S C O R E                         2 U P  "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                     P R E S S  A N Y  K E Y  T O  S T A R T                    "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 0

gameMap LABEL BYTE
BYTE "  1 U P                          H I - S C O R E                         2 U P  "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, "      ", 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176 
BYTE 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                 ",220, 219,"  VV  ",219,220,"                                 ", 176, 176
BYTE 176, 176, "                                ", 219, 223,"        ",223, 219, "                                ", 176, 176
BYTE 176, 176, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219,"   ", 219,"   ", 219,"   ", 219,"   ", 219,"   ", 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219,"   ", 219,"   ", 219,"   ", 219,"   ", 219,"   ", 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 219, 176, 176
BYTE 176, 176, "            ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"          ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"            ", 176, 176
BYTE 176, 176, "            ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"          ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"            ", 176, 176
BYTE 176, 176, "            ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"          ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"            ", 176, 176
BYTE 176, 176, "            ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"          ",219,"   ",219,"   ",219,"   ",219,"   ",219,"   ",219,"            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE 176, 176, "                                                                            ", 176, 176
BYTE "                                                                                "
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 219, 219, 219, 219, 219, 219, 219, 219
BYTE 0

gameOverSplash LABEL BYTE
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "    _______  _______  _______  _______    _______           _______  _______    "
BYTE "   (  ____ \(  ___  )(       )(  ____ \  (  ___  )|\     /|(  ____ \(  ____ )   "
BYTE "   | (    \/| (   ) || () () || (    \/  | (   ) || )   ( || (    \/| (    )|   "
BYTE "   | |      | (___) || || || || (__      | |   | || |   | || (__    | (____)|   "
BYTE "   | | ____ |  ___  || |(_)| ||  __)     | |   | |( (   ) )|  __)   |     __)   "
BYTE "   | | \_  )| (   ) || |   | || (        | |   | | \ \_/ / | (      | (\ (      "
BYTE "   | (___) || )   ( || )   ( || (____/\  | (___) |  \   /  | (____/\| ) \ \__   "
BYTE "   (_______)|/     \||/     \|(_______/  (_______)   \_/   (_______/|/   \__/   "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE "                                                                                "
BYTE 0

.code

OriginalTimerHandler DWORD	0AAAA5555h

crumb	BYTE	0

EXTERNDEF OldTimerInterruptVector: DWORD
OldTimerInterruptVector DWORD 1234ABCDh

timerTickCount	WORD 0

NewTimerHandler PROC
	inc	cs:timerTickCount
	jmp	cs:OriginalTimerHandler
NewTimerHandler ENDP


CursorOn PROC
	push	ax
	push	cx

	mov	cx, 0607h	; CH = start, CL = stop
	mov	ah, 01h
	int	BIOS

	pop	cx
	pop	ax
	ret
CursorON ENDP

CursorOff PROC
	push	ax
	push	cx

	mov	cx, 2000h	; CH = 32, cursor off
	mov	ah, 01h
	int	BIOS

	pop	cx
	pop	ax
	ret
CursorOff ENDP

Status MACRO text
	LOCAL string
	.data
	string BYTE text, 0
	.code
	push	dx
	mov	dx, OFFSET string
	call	DisplayStatus
	pop	dx
ENDM

ClearStatus PROC
	Status	" "
	ret
ClearStatus ENDP

DisplayStatus PROC
	;; DX = offset of ASCIIZ message

	pushf
	push	ax
	push	bx
	push	cx
	push	si
	push	di
	push	es

	mov	si, dx

	mov	bx, 0B900h
	mov	es, bx
	mov	cx, 0
	mov	di, 24*80*2	; Offset of bottom line of display
	mov	bl, 00010111b
	jmp	cond
top:
	mov	es:[di], al	; Write the read byte
	inc	di
	mov	es:[di], bl	; Write the attribute byte

	inc	cx		; move on
	inc	si
	inc	di

cond:
	mov	al, [si]	; Read the byte
	cmp	al, 0		; Continue if it is non-zero
	jne	top

	mov	al, ' '		; Blanks for the rest of the line
	mov	bl, 00010111b
	jmp	cond2
top2:
	mov	es:[di], al	; Write the read byte
	inc	di
	mov	es:[di], bl	; Write the attribute byte
	inc	cx		; move on
	inc	si
	inc	di
cond2:
	cmp	cx, 80
	jl	top2

over:
	pop	es
	pop	di
	pop	si
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
DisplayStatus ENDP

DisplayLine1 PROC
	;; AL = attribute
	;; BX = offset of buffer
	;; CX = page number
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si
	push	es

	mov	dl, al
	mov	si, bx

	;; Set the segment

	mov	bx, cx
	mov	cl, 8
	shl	bx, cl
	add	bx, 0B800h
	mov	es, bx

	mov	di, 0

	mov	cx, 0
	jmp	cond
top:
	mov	al, [si]
 	mov	es:[di], al
	inc	di
	mov	al, dl
	mov	es:[di], al
	inc	di
	inc	si
	inc	cx
cond:
	cmp	cx, 80
	jl	top

	pop	es
	pop	si
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
DisplayLine1 ENDP

DisplayLine2 PROC
	;; AL = attribute
	;; BX = offset of buffer
	;; CX = page number
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si
	push	es
    mov cx, 80*5
	mov	dl, al
	mov	si, bx

	;; Set the segment

	mov	bx, cx
	mov	cl, 8
	shl	bx, cl
	add	bx, 0B800h
	mov	es, bx

	mov	di, 0

	mov	cx, 0
	jmp	cond
top:
	mov	al, [si]
 	mov	es:[di], al
	inc	di
	mov	al, dl
	mov	es:[di], al
	inc	di
	inc	si
	inc	cx
cond:
	cmp	cx, 80*6
	jl	top

	pop	es
	pop	si
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
DisplayLine2 ENDP

DisplayScreen PROC
	;; AL = attribute
	;; BX = offset of buffer
	;; CX = page number
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	si
	push	es

	mov	dl, al
	mov	si, bx

	;; Set the segment

	mov	bx, cx
	mov	cl, 8
	shl	bx, cl
	add	bx, 0B800h
	mov	es, bx

	mov	di, 0

	mov	cx, 0
	jmp	cond
top:
	mov	al, [si]
 	mov	es:[di], al
	inc	di
	mov	al, dl
	mov	es:[di], al
	inc	di
	inc	si
	inc	cx
cond:
	cmp	cx, 80*25
	jl	top

	pop	es
	pop	si
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
DisplayScreen ENDP

GameScreen PROC
	push	ax
	push	bx
	push	cx
    push    dx

	;; Copy the game screen to page 1

	mov	bx, OFFSET gameMap
	mov	cx, 1
	mov	al, 0000100b
	call	DisplayScreen

    mov	bx, OFFSET gameMap
	mov	cx, 1
	mov	al, 0001110b
	call	DisplayLine1
    
    mov	bx, OFFSET gameMap
	mov	cx, 1
	mov	al, 0001001b
	call	DisplayLine2

	;; Switch display to page 1

	mov	al, 1
	call	ChangeVideoPage

    pop dx
	pop	cx
	pop	bx
	pop	ax
	ret
GameScreen ENDP

ChangeVideoPage PROC
	mov ah, 05
	int 10h
	ret
ChangeVideoPage ENDP

GameOverScreen PROC
	push	ax
	push	bx
	push	cx

	;; Copy the spash screen to page 2

	mov	bx, OFFSET gameOverSplash
	mov	cx, 3
	mov	al, 00000100b
	call	DisplayScreen

	;; Switch display to page 2

	mov	al, 3
	call	ChangeVideoPage

    call EndGameScore

	;; Wait for a key

	call	ReadCharNoEcho	; Returns in AL

	pop	cx
	pop	bx
	pop	ax
	ret
GameOverScreen ENDP

SplashScreen PROC
	push	ax
	push	bx
	push	cx

	;; Copy the spash screen to page 2

	mov	bx, OFFSET splash
	mov	cx, 2
	mov	al, 00001110b
	call	DisplayScreen

	;; Switch display to page 2

	mov	al, 2
	call	ChangeVideoPage

	;; Wait for a key

	call	ReadCharNoEcho	; Returns in AL

	pop	cx
	pop	bx
	pop	ax
	ret
SplashScreen ENDP

startScreen PROC
	push	ax
	push	bx
	push	cx

	;; Copy the spash screen to page 3

	mov	bx, OFFSET gameStart
	mov	cx, 3
	mov	al, 00001110b
	call	DisplayScreen

	;; Switch display to page 2

	mov	al, 3
	call	ChangeVideoPage

	;; Wait for a key

	call	ReadCharNoEcho	; Returns in AL

	pop	cx
	pop	bx
	pop	ax
	ret
startScreen ENDP

ReadCharNoEcho PROC
	;; Returns:
	;; AL = char

	push	bx
	push	ax

	mov	ah, 7h
	int	DOS

	mov	bl, al
	pop	ax
	mov	al, bl
	pop	bx

	ret
ReadCharNoEcho ENDP

KeyPress PROC
	;; returns:
	;; AL=0 if no character read, otherwise ASCII character value
	push	bx
	push	ax
	mov	ah, 0Bh		; Check for character
	int	DOS
	cmp	al, 0		; FF is character available
	je	done

	call	ReadCharNoEcho	; Char in AL
done:
	mov	bl, al
	pop	ax
	mov	al, bl
	pop	bx
	ret
KeyPress ENDP

SetCursorPosition PROC
	;; BH = page number
	;; DX = position
	push	ax

	mov	ah, 02h
	int	BIOS

	pop	ax
	ret
SetCursorPosition ENDP

WriteStringToPage PROC
	push	ax
	push	bx
	push	cx
	push	dx
	push	bp
	push	es

	mov	bh, 2
	mov	dx, 0000h
	call	SetCursorPosition

	mov	bl, 00001100b		  ; Video attribute
	mov	bh, 2		  ; Video page number
	mov	dx, 0000h	; Starting position
	mov	cx, 80*24	; Length
	mov	bp, OFFSET splash ; ES:BP string location
	mov	ax, ds
	mov	es, ax

	mov	al, 0		; Subservice number
	mov	ah, 13h		; Write character string
	int	BIOS

	pop	es
	pop	bp
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
WriteStringToPage ENDP

WriteVector PROC
	;; DX:BX = vector to display
	push	dx

	call	WriteHexWord
	mov	dl, ':'
	call	WriteChar
	mov	dx, bx
	call	WriteHexWord

	pop	dx
	ret
WriteVector ENDP

WriteInterruptVector PROC
	;; CS:BX = double word memory location
	push	bx
	push	dx

	mov	dx, cs:[bx + 2]
	mov	bx, cs:[bx]
	call	WriteVector

	pop	dx
	pop	bx
	ret
WriteInterruptVector ENDP

WriteInstalledVector PROC
	;; AL = interrupt number
	push	bx
	push	dx
	push	es

	call	DOS_GetInterruptVector ; Returns in ES:BX

	mov	dx, es
	call	WriteHexWord
	mov	dl, ':'
	call	WriteChar
	mov	dx, bx
	call	WriteHexWord

	pop	es
	pop	dx
	pop	bx
	ret
WriteInstalledVector ENDP

InstallInterruptHandler PROC
	;; AL = interrupt number
	;; CS:DX = new interrupt handler

	push	bx
	push	es

	mov	bx, cs
	mov	es, bx
	call	DOS_SetInterruptVector

	pop	es
	pop	bx
	ret
InstallInterruptHandler ENDP

RestoreInterruptVector PROC
	;; AL = interrupt number
	;; CS:BX = double word memory location of vector

	push	dx
	push	di
	push	es

	mov	di, bx
	mov	dx, cs:[di]	; Set the offset
	mov	es, cs:[di + 2]	; Set the segment
	call	DOS_SetInterruptVector

	pop	es
	pop	di
	pop	dx
	ret
RestoreInterruptVector ENDP

SaveInterruptVector PROC
	;; AL = interrupt number
	;; CS:BX = double word memory location to store vector

	push	bx
	push	di
	push	es

	mov	di, bx
	call	DOS_GetInterruptVector ; ES:BX = current interrupt handler

	mov	cs:[di], bx	; Save the offset
	mov	cs:[di + 2], es	; Save the segment

	pop	es
	pop	di
	pop	bx
	ret
SaveInterruptVector ENDP

DOS_SetInterruptVector PROC
	;; AL = interrupt number
	;; ES:DX = new interrupt handler

	push	ax
	push	bx
	push	ds

	mov	bx, es		; DS = ES
	mov	ds, bx
	mov	ah, 25h		; DOS function to set vector
	int	DOS		; Call DOS

	pop	ds
	pop	bx
	pop	ax
	ret
DOS_SetInterruptVector ENDP

DOS_GetInterruptVector PROC
	;; AL = interrupt number
	;; Returns:
	;; ES:BX = current interrupt handler

	push	ax

	mov	ah, 35h		; DOS function to get vector
	int	DOS		; Call DOS

	pop	ax
	ret
DOS_GetInterruptVector ENDP

UserAction PROC
	pushf
	push	ax
    push dx

	call	KeyPress	; Character in AL (or 0 for no character)
	cmp	al, 0		; Was a key pressed?
	je	ignore		; No, return
	cmp shot, 1
	je ignore
    cmp al, 61h
    je move
    cmp al, 64h
    je move
  	cmp al, 20h
    je shoot

	cmp	al, 27		; Is it the ESC key?
	je	endGame
	jmp	ignore
	call GameLoop
shoot:
	mov shot, 1
	mov bulletMovement, 22
	call GameLoop
	mov shot, 0
	jmp ignore
move:
	call GameLoop
	jmp ignore
endGame:
	mov	GameOver, 1

ignore:
done:
    pop dx
	pop	ax
	popf
	ret
UserAction ENDP

bullet PROC
	pushf
	push ax
    push bx
	push cx
    push dx

	cmp shot, 1
	je cont

	jmp done
cont:
	cmp al, 20h
    je shoot

	jmp done

shoot: 							; SHOOT A BULLET
	mov cl, spaceshipMovement
	mov spaceshipPosition, cl
    dec bulletMovement
    mov ah, bulletMovement
    mov al, spaceshipPosition
    mov dx, 1
    call GetVideoChar
    cmp bl, 148
    je alien
    inc bulletMovement
	mov ah, bulletMovement
    mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 148
    je alien
    cmp bl, 240
    je drone
	dec bulletMovement
    mov ah, bulletMovement
    call GetVideoChar
    cmp bl, 148
    je alien
    cmp bl, 240
    je drone
	cmp bulletMovement, 15
	je boom
	cmp bulletMovement, 11
	je wall
    cmp bulletMovement, 10
	je maxHeight
    mov ah, bulletMovement
	mov al, spaceshipPosition
    mov bl, 179
    mov bh, 1101b
    mov dx, 1
	call WriteVideoChar
	jmp done
drone:
    mov DroneHit, 1
    
    cmp spaceshipPosition, 7
    je drone1location
    cmp spaceshipPosition, 39
    je drone2location
    cmp spaceshipPosition, 73
    je drone3location
    jmp noDroneHit
drone1location:
    mov drone1hit, 1
    jmp elare
drone2location:
    mov drone2hit, 1
    jmp elare
drone3location:
    mov drone3hit, 1
noDroneHit:   
elare:    
    
    mov ah, bulletMovement
    mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    
    push dx
    mov dx, 0
    mov dl, spaceshipPosition
    mov currLocation, dl
    pop dx

    call UpdateScore
    jmp done
alien:
    inc bulletMovement
    mov alienDown, 1
    ;cmp al, 16
    ;je alien1
    ;cmp al, 20
    ;je alien2
    ;cmp al, 24
    ;je alien3
    ;cmp al, 28
    ;je alien4
    ;cmp al, 32
    ;je alien5
    ;cmp al, 47
    ;je alien6
    ;cmp al, 51
    ;je alien7
    ;cmp al, 55
    ;je alien8
    ;cmp al, 59
    ;je alien9
    ;cmp al, 63
    ;je alien10
    ;jmp next
alien1:
    ;mov alienKilled1, 1
    ;jmp next
alien2:
    ;mov alienKilled2, 1
    ;jmp next
alien3:
    ;mov alienKilled3, 1
    ;jmp next
alien4:
    ;mov alienKilled4, 1
    ;jmp next
alien5:
    ;mov alienKilled5, 1
    ;jmp next
alien6:
    ;mov alienKilled6, 1
    ;jmp next
alien7:
    ;mov alienKilled7, 1
    ;jmp next
alien8:
    ;mov alienKilled8, 1
    ;jmp next
alien9:
    ;mov alienKilled9, 1
    ;jmp next
alien10:
    ;mov alienKilled10, 1
next:
    mov SpaceshipHit, 1
    
    push dx 
    mov dh, spaceshipPosition
    mov currLocation, dh
    pop dx

    call UpdateScore
    cmp bulletMovement, 15
    je moveOn
	mov ah, bulletMovement
    mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
moveOn:
	mov shot, 0
    call WriteVideoChar
	jmp done
boom:
	cmp spaceshipPosition, 14
	je disappear
	cmp spaceshipPosition, 18
	je disappear
	cmp spaceshipPosition, 22
	je disappear
	cmp spaceshipPosition, 26
	je disappear
	cmp spaceshipPosition, 30
	je disappear
	cmp spaceshipPosition, 34
	je disappear
	cmp spaceshipPosition, 45
	je disappear
	cmp spaceshipPosition, 49
	je disappear
	cmp spaceshipPosition, 53
	je disappear
	cmp spaceshipPosition, 57
	je disappear
	cmp spaceshipPosition, 61
	je disappear
	cmp spaceshipPosition, 65
	je disappear
    jmp done
wall:
    cmp spaceshipPosition, 1
	je gone
	cmp spaceshipPosition, 2
	je gone
	cmp spaceshipPosition, 3
	je gone
    cmp spaceshipPosition, 4
	je gone
	cmp spaceshipPosition, 5
	je gone
	cmp spaceshipPosition, 6
	je gone
    cmp spaceshipPosition, 7
	je gone
	cmp spaceshipPosition, 8
	je gone
	cmp spaceshipPosition, 9
	je gone
    cmp spaceshipPosition, 10
	je gone
	cmp spaceshipPosition, 11
	je gone
	cmp spaceshipPosition, 12
	je gone
    cmp spaceshipPosition, 13
	je gone

    cmp spaceshipPosition, 35
	je gone
	cmp spaceshipPosition, 36
	je gone
	cmp spaceshipPosition, 37
	je gone
    cmp spaceshipPosition, 38
	je gone
	cmp spaceshipPosition, 39
	je gone
	cmp spaceshipPosition, 40
	je gone
    cmp spaceshipPosition, 41
	je gone
	cmp spaceshipPosition, 42
	je gone
	cmp spaceshipPosition, 43
	je gone
    cmp spaceshipPosition, 44
	je gone

    cmp spaceshipPosition, 66
	je gone
    cmp spaceshipPosition, 67
	je gone
	cmp spaceshipPosition, 68
	je gone
	cmp spaceshipPosition, 69
	je gone
    cmp spaceshipPosition, 70
	je gone
	cmp spaceshipPosition, 71
	je gone
	cmp spaceshipPosition, 72
	je gone
    cmp spaceshipPosition, 73
	je gone
	cmp spaceshipPosition, 74
	je gone
	cmp spaceshipPosition, 75
	je gone
    cmp spaceshipPosition, 76
	je gone
    cmp spaceshipPosition, 77
	je gone
    cmp spaceshipPosition, 78
	je gone
    cmp spaceshipPosition, 79
	je gone
	jmp done
disappear:
	mov ah, 16
	mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
	mov shot, 0
    call WriteVideoChar
	jmp done
gone:
	mov ah, 12
	mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
	mov shot, 0
    call WriteVideoChar
	jmp done
maxHeight:
	mov ah, 7
    mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
	mov shot, 0
    call WriteVideoChar
	jmp done
fall:
    dec bulletMovement
    mov ah, bulletMovement
    mov al, spaceshipPosition
    mov dx, 1
    call GetVideoChar
    cmp bl, 148
    je fall
    inc bulletMovement
    mov ah, bulletMovement
    mov al, spaceshipPosition
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov alienDown, 0
done:
    cmp alienDown, 1
    je fall
	mov	ax, 1
	mov	dx, OFFSET bullet
	call    RegisterAlarm
	pop dx
	pop cx
    pop bx
    pop ax
	popf
	ret
bullet ENDP

spaceship PROC
	pushf
    push ax
    push bx
    push dx

    cmp al, 61h
    je left

    cmp al, 64h
    je right

	jmp done
left:                           ; MOVEMENT LEFT

    call CheckDeath 

    mov ah, 23
    mov al, spaceshipMovement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov bl, 1Eh
    mov bh, 1011b
    mov dx, 1
    dec spaceshipMovement
	cmp spaceshipMovement, 1
	je leftedge
    mov al, spaceshipMovement
    call WriteVideoChar
    jmp done

right:                          ; MOVEMENT RIGHT

    call CheckDeath 


    mov ah, 23
    mov al, spaceshipMovement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov bl, 1Eh
    mov bh, 1011b
    mov dx, 1
    inc spaceshipMovement
	cmp spaceshipMovement, 78
	je rightedge
    mov al, spaceshipMovement
    call WriteVideoChar
	jmp done
leftedge:
	jmp right
rightedge:
	jmp left

done:
    mov	ax, 1
	mov	dx, OFFSET spaceship
	call    RegisterAlarm
finish:
    pop dx
    pop bx
    pop ax
	popf
    ret
spaceship ENDP

enemyship PROC
	pushf
	push ax
    push bx
    push dx

	mov ah, 3
    mov al, enemyshipMovement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	mov ah, 3
    mov bl, 232
    mov bh, 1011b
    mov dx, 1
    dec enemyshipMovement
	cmp enemyshipMovement, 39
	je enemyDrop
    mov al, enemyshipMovement
    call WriteVideoChar
	jmp done
enemyDrop:
    mov ah, 3
    mov bl, 232
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
	jmp finish
done:
	mov	ax, 1
	mov	dx, OFFSET enemyship
	call    RegisterAlarm
finish:
    pop dx
    pop bx
    pop ax
	popf
    ret
enemyship ENDP

drone1 PROC
    pushf
	push ax
    push bx
    push dx

    cmp drone1hit, 1
    je finish

	mov ah, drone1Movement
    mov al, 7
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
	mov ah, drone1Movement
    mov al, 7
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	mov al, 7
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    inc drone1Movement
	cmp drone1Movement, 23
	je explode
    mov ah, drone1Movement
    call WriteVideoChar
	jmp done
explode:
    mov al, 6
    mov ah, drone1Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 7
    mov ah, drone1Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 8
    mov ah, drone1Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 5
    mov ah, drone1Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 9
    mov ah, drone1Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    jmp cont
gameEnd:
    mov	GameOver, 1
cont:
    mov al, 7
    mov ah, drone1Movement
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 5
    mov ah, drone1Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 6
    mov ah, drone1Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 8
    mov ah, drone1Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 7
    mov ah, drone1Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 9
    mov ah, drone1Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 5
    mov ah, drone1Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 6
    mov ah, drone1Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 8
    mov ah, drone1Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 7
    mov ah, drone1Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 9
    mov ah, drone1Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 5
    mov ah, drone1Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 6
    mov ah, drone1Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 8 
    mov ah, drone1Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 7
    mov ah, drone1Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 9
    mov ah, drone1Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	jmp finish
done:
	mov	ax, 10
	mov	dx, OFFSET drone1
	call    RegisterAlarm
finish:
    pop dx
    pop bx
    pop ax
	popf
    ret
drone1 ENDP

drone2 PROC
    pushf
	push ax
    push bx
    push dx

    cmp drone2hit, 1
    je finish

	mov ah, drone2Movement
    mov al, 39
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
	mov ah, drone2Movement
    mov al, 39
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	mov al, 39
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    inc drone2Movement
	cmp drone2Movement, 23
	je explode
    mov ah, drone2Movement
    call WriteVideoChar
	jmp done
explode:
    mov al, 38
    mov ah, drone2Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 39
    mov ah, drone2Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 40
    mov ah, drone2Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 37
    mov ah, drone2Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 41
    mov ah, drone2Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    jmp cont
gameEnd:
    mov	GameOver, 1
cont:
    mov al, 39
    mov ah, drone2Movement
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov ah, drone2Movement
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 37
    mov ah, drone2Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 38
    mov ah, drone2Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 40
    mov ah, drone2Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 39
    mov ah, drone2Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 41
    mov ah, drone2Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 37
    mov ah, drone2Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 38
    mov ah, drone2Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 40
    mov ah, drone2Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 39
    mov ah, drone2Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 41
    mov ah, drone2Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 37
    mov ah, drone2Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 41
    mov ah, drone2Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 38
    mov ah, drone2Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 40
    mov ah, drone2Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 39
    mov ah, drone2Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	jmp finish
done:
	mov	ax, 10
	mov	dx, OFFSET drone2
	call    RegisterAlarm
finish:
    pop dx
    pop bx
    pop ax
	popf
    ret
drone2 ENDP

drone3 PROC
    pushf
	push ax
    push bx
    push dx

    cmp drone3hit, 1
    je finish

	mov ah, drone3Movement
    mov al, 73
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
	mov ah, drone3Movement
    mov al, 73
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	mov al, 73
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    inc drone3Movement
	cmp drone3Movement, 23
	je explode
    mov ah, drone3Movement
    call WriteVideoChar
	jmp done
explode:
    mov al, 72
    mov ah, drone3Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 73
    mov ah, drone3Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 74
    mov ah, drone3Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 71
    mov ah, drone3Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov al, 75
    mov ah, drone3Movement
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    jmp cont
gameEnd:
    mov	GameOver, 1
cont:
    mov al, 73
    mov ah, drone3Movement
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov ah, drone3Movement
    mov bl, 240
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 71
    mov ah, drone3Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 72
    mov ah, drone3Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 74
    mov ah, drone3Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 73
    mov ah, drone3Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 75
    mov ah, drone3Movement
    mov bl, '='
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 71
    mov ah, drone3Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 72
    mov ah, drone3Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 74
    mov ah, drone3Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 73
    mov ah, drone3Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov al, 75
    mov ah, drone3Movement
    mov bl, '-'
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov al, 72
    mov ah, drone3Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov al, 74
    mov ah, drone3Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 73
    mov ah, drone3Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 75
    mov ah, drone3Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov al, 71
    mov ah, drone3Movement
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
	jmp finish
done:
	mov	ax, 10
	mov	dx, OFFSET drone3
	call    RegisterAlarm
finish:
    pop dx
    pop bx
    pop ax
	popf
    ret
drone3 ENDP

nonsense PROC
   	push	bx
   	push	cx

   	mov	cx, 3
toptop:
   	push	cx

   	mov	cx, 0
top:
   	inc	bx
   	loop	top

   	pop	cx
   	loop	toptop

   	pop	cx
   	pop	bx
   	ret
nonsense ENDP

CheckAlarms PROC

	pushf
	push	bx
	push	cx

	cmp	cs:timerTickCount, 0
	je	notick
	mov	cs:timerTickCount, 0

	;; for (cx = 0; cx < HandlerCount; cx += 4)...
	mov	cx, 0
	mov	bx, OFFSET Alarms ;
	jmp	cond
top:
	cmp	WORD PTR [bx], 0 ; See if this alarm is in use
	je	unused
	dec	WORD PTR [bx]	; Yup. Take a tick away
	cmp	WORD PTR [bx], 0 ; Did it go off?
	ja	running
	call	WORD PTR [bx + 2] ; Yup. Call the alarm code

running:
unused:
	add	bx, 4		; Skip to the next handler
	inc	cx
cond:
	cmp	cx, HandlerCount
	jl	top

notick:
	pop	cx
	pop	bx
	popf
	ret
CheckAlarms ENDP

GameLoop PROC
	pushf
	push	ax

	jmp	cond
top:
	call	CheckAlarms
	call	UserAction
cond:
	cmp	GameOver, 0
	je	top

	pop	ax
	popf
	ret
GameLoop ENDP

SetInterruptVector PROC
    pushf
    push ax
    push bx
    push dx
    push es
    push si

    mov ah, 0
    mov bl, 4
    mul bl
    mov bx, ax
    mov ax, 0
    mov es, ax

    mov es:[bx+2], cs
    mov es:[bx], dx
	call DOS_SetInterruptVector

    pop si
    pop es
    pop dx
    pop bx
    pop ax
    popf
    ret
SetInterruptVector ENDP

InstallTimerHandler PROC
	push ax
	push dx
	mov	al, TIMER
	mov	bx, OFFSET OriginalTimerHandler
	call	SaveInterruptVector ; AL = interrupt number, CS:BX = location
    mov	al, TIMER
 	mov	dx, OFFSET NewTimerHandler
 	call SetInterruptVector ; AL = interrupt vector, CS:DX = offset of code

	pop dx
	pop ax
	ret
InstallTimerHandler ENDP

RestoreTimerHandler PROC
	push ax
	push bx

    mov	al, TIMER
	mov	bx, OFFSET OriginalTimerHandler
	call RestoreInterruptVector ; AL = interrupt number, CS:BX = location

	pop bx
	pop ax
	ret
RestoreTimerHandler ENDP

RegisterAlarm PROC
	;; AX=tick count
	;; DX=Handler offset

	pushf
	push	bx
	push	cx

	mov	cx, 0
	mov	bx, OFFSET Alarms
	jmp	cond
top:
	cmp	WORD PTR [bx], 0
	jne	used
	mov	WORD PTR [bx], ax
	mov	WORD PTR [bx + 2], dx
	jmp	done
used:
	inc	cx
	add	bx, 4
cond:
	cmp	cx, HandlerCount
	jl	top

	mWrite	"Error, out of handler slots"

done:
	pop	cx
	pop	bx
	popf
	ret
RegisterAlarm ENDP

WriteVideoChar PROC
	;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	si
	push	di

	mov	si, 0B800h
	mov	es, si
	mov	si, bx
	shl	al, 1
	mov	cl, 12
	shl	dx, cl
	add	dl, al
	mov	di, dx

	mov	bl, ah
	mov	bh, 0
	mov	ax, 160
	mul	bx
	add	di, ax

	mov	es:[di], si

	pop	di
	pop	si
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
WriteVideoChar ENDP

WriteVideoString PROC
	;; BP = offset of string
	;; AH = row
	;; AL = col
	;; BH = attribute
	;; DX = video page
	pushf
	push	bx
	push	bp
	push	ax
	mov	bl, ds:[bp]
	jmp	cond
top:
	call	WriteVideoChar
	inc	bp
	inc	al
	mov	bl, ds:[bp]
cond:
	cmp	bl, 0
	jne	top

	pop	ax
	pop	bp
	pop	bx
	popf
	ret
WriteVideoString ENDP

ShowScreen PROC
	;; AX = offset
	;; DX = page
	;; BH = attribute

	mov	bp, ax
	mov	ah, 0
	mov	al, 0
	mov	cx, 0
	jmp	cond
top:
	;; BP = offset of string
	;; AH = row
	;; AL = col
	;; BH = attribute
	;; DX = video page
	call	WriteVideoString

	add	bp, 81
	inc	ah
	inc	cx
cond:
	cmp	cx, 25
	jl	top

	ret
ShowScreen ENDP

SetColOne PROC
    mov currColEnemy1, 16
    ret
SetColOne ENDP

SetColTwo PROC
    mov currColEnemy2, 20
    ret
SetColTwo ENDP

SetColThree PROC
    mov currColEnemy3, 24
    ret
SetColThree ENDP

SetColFour PROC
    mov currColEnemy4, 28
    ret
SetColFour ENDP

SetColFive PROC
    mov currColEnemy5, 32
    ret
SetColFive ENDP

SetColSix PROC
    mov currColEnemy6, 47
    ret
SetColSix ENDP

SetColSeven PROC
    mov currColEnemy7, 51
    ret
SetColSeven ENDP

SetColEight PROC
    mov currColEnemy8, 55
    ret
SetColEight ENDP

SetColNine PROC
    mov currColEnemy9, 59
    ret
SetColNine ENDP

SetColTen PROC
    mov currColEnemy10, 63
    ret
SetColTen ENDP

DecideCol PROC
    pushf

    cmp activeEnemyCol, 1       ; first col
    jne checktwo
    call SetColOne
    jmp done
checktwo:
    cmp activeEnemyCol, 2       ; second col
    jne checkthree
    call SetColTwo
    jmp done
checkthree:
    cmp activeEnemyCol, 3       ; third col
    jne checkfour
    call SetColThree
    jmp done
checkfour:
    cmp activeEnemyCol, 4       ; fourth col
    jne checkfive
    call SetColFour
    jmp done
checkfive:
    cmp activeEnemyCol, 5       ; fifth col
    jne checksix
    call SetColFive
    jmp done
checksix:
    cmp activeEnemyCol, 6       ; sixth col
    jne checkseven
    call SetColSix
    jmp done
checkseven:
    cmp activeEnemyCol, 7       ; seventh col
    jne checkeight
    call SetColSeven
    jmp done
checkeight:
    cmp activeEnemyCol, 8       ; eighth col
    jne checknine
    call SetColEight
    jmp done
checknine:
    cmp activeEnemyCol, 9       ; ninth col
    jne checkten
    call SetColNine
    jmp done
checkten:
    cmp activeEnemyCol, 10       ; tenth col
    jne done
    call SetColTen

done:
    popf
    ret
DecideCol ENDP

FirstCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 1
    call DecideCol
    cmp alienKilled1, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy1
    mov ah, currRowEnemy1
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy1-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy1-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy1+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy1+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled1, 1
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy1, 15
    je stop
    mov ah, currRowEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy1, 11
    je fall
    cmp currRowEnemy1, 24
    je detonate
    dec currRowEnemy1
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy1, 16
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy1
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip1 BYTE 0
    .code
    mov detonateOnShip1, 0
    ;; checking cols 15,16,17,18,19 for the triangle spaceship
check15:
    mov ah, 23
    mov al, 15
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check16
    mov detonateOnShip1, 1
    jmp moveonnow
Check16:
    mov ah, 23
    mov al, 16
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check17
    mov detonateOnShip1, 1
    jmp moveonnow
check17:
    mov ah, 23
    mov al, 17
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check18
    mov detonateOnShip1, 1
    jmp moveonnow
check18:
    mov ah, 23
    mov al, 18
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check19
    mov detonateOnShip1, 1
    jmp moveonnow
check19:
    mov ah, 23
    mov al, 19
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip1, 1
    jmp moveonnow
moveOnNow:



    mov ah, 23
    mov al, 17
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call nonsense
    mov ah, 23
    mov al, 15
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 16
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 17
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 18
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 19
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 15
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 16
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 17
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 18
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 19
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip1, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 15
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 16
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 17
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 18
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 19
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy1
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy1
    mov al, currColEnemy1
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET FirstCol
    call    RegisterAlarm
    mov alienKilled1, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
FirstCol ENDP
        ; create vars for each row and col location for all 10 channels
SecondCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page

    mov activeEnemyCol, 2
    call DecideCol
    cmp alienKilled2, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy2
    mov ah, currRowEnemy2
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy2-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy2-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy2+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy2+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled2, 1
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy2, 15
    je stop
    mov ah, currRowEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy2, 11
    je fall
    cmp currRowEnemy2, 24
    je detonate
    dec currRowEnemy2
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy2, 16
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy2
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip2 BYTE 0
    .code
    mov detonateOnShip2, 0
    ;; checking cols 19-23 for the triangle spaceship
check19:
    mov ah, 23
    mov al, 19
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check20
    mov detonateOnShip2, 1
    jmp moveonnow
Check20:
    mov ah, 23
    mov al, 20
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check21
    mov detonateOnShip2, 1
    jmp moveonnow
check21:
    mov ah, 23
    mov al, 21
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check22
    mov detonateOnShip2, 1
    jmp moveonnow
check22:
    mov ah, 23
    mov al, 22
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check23
    mov detonateOnShip2, 1
    jmp moveonnow
check23:
    mov ah, 23
    mov al, 23
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip2, 1
    jmp moveonnow
moveOnNow:


    mov ah, 23
    mov al, 21
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 19
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 20
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 21
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 22
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 23
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 19
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 20
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 21
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 22
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 23
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd

    cmp detonateOnShip2, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 19
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 20
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 21
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 22
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 23
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy2
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy2
    mov al, currColEnemy2
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET SecondCol
    call    RegisterAlarm
    mov alienKilled2, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
SecondCol ENDP

ThirdCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page

    mov activeEnemyCol, 3
    call DecideCol
    cmp alienKilled3, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy3
    mov ah, currRowEnemy3
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy3-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy3-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy3+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy3+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled3, 1
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy3, 15
    je stop
    mov ah, currRowEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy3, 11
    je fall
    cmp currRowEnemy3, 24
    je detonate
    dec currRowEnemy3
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy3, 16
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy3
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip3 BYTE 0
    .code
    mov detonateOnShip3, 0
    ;; checking cols 23-27 for the triangle spaceship
check23:
    mov ah, 23
    mov al, 23
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check24
    mov detonateOnShip3, 1
    jmp moveonnow
Check24:
    mov ah, 23
    mov al, 24
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check25
    mov detonateOnShip3, 1
    jmp moveonnow
check25:
    mov ah, 23
    mov al, 25
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check26
    mov detonateOnShip3, 1
    jmp moveonnow
check26:
    mov ah, 23
    mov al, 26
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check27
    mov detonateOnShip3, 1
    jmp moveonnow
check27:
    mov ah, 23
    mov al, 27
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip3, 1
    jmp moveonnow
moveOnNow:


    mov ah, 23
    mov al, 25
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 23
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 24
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 25
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 26
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 27
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 23
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 24
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 25
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 26
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 27
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip3, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 23
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 24
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 25
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 26
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 27
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy3
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy3
    mov al, currColEnemy3
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET ThirdCol
    call    RegisterAlarm
    mov alienKilled3, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
ThirdCol ENDP

FourthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page

    mov activeEnemyCol, 4
    call DecideCol
    cmp alienKilled4, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy4
    mov ah, currRowEnemy4
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy4-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy4-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy4+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy4+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled4, 1
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy4, 15
    je stop
    mov ah, currRowEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy4, 11
    je fall
    cmp currRowEnemy4, 24
    je detonate
    dec currRowEnemy4
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy4, 16
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy4
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip4 BYTE 0
    .code
    mov detonateOnShip4, 0
    ;; checking cols 27-31 for the triangle spaceship
check27:
    mov ah, 23
    mov al, 27
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check28
    mov detonateOnShip4, 1
    jmp moveonnow
Check28:
    mov ah, 23
    mov al, 28
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check29
    mov detonateOnShip4, 1
    jmp moveonnow
check29:
    mov ah, 23
    mov al, 29
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check30
    mov detonateOnShip4, 1
    jmp moveonnow
check30:
    mov ah, 23
    mov al, 30
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check31
    mov detonateOnShip4, 1
    jmp moveonnow
check31:
    mov ah, 23
    mov al, 31
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip4, 1
    jmp moveonnow
moveOnNow:



    mov ah, 23
    mov al, 29
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 27
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 28
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 29
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 30
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 31
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 27
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 28
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 29
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 30
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 31
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip4, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 27
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 28
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 29
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 30
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 31
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy4
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy4
    mov al, currColEnemy4
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET FourthCol
    call    RegisterAlarm
    mov alienKilled4, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
FourthCol ENDP

FifthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 5
    call DecideCol
    cmp alienKilled5, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy5
    mov ah, currRowEnemy5
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy5-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy5-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy5+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy5+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled5, 1
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy5, 15
    je stop
    mov ah, currRowEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy5, 11
    je fall
    cmp currRowEnemy5, 24
    je detonate
    dec currRowEnemy5
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy5, 16
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy5
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip5 BYTE 0
    .code
    mov detonateOnShip5, 0
    ;; checking cols 31-35 for the triangle spaceship
check31:
    mov ah, 23
    mov al, 31
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check32
    mov detonateOnShip5, 1
    jmp moveonnow
Check32:
    mov ah, 23
    mov al, 32
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check33
    mov detonateOnShip5, 1
    jmp moveonnow
check33:
    mov ah, 23
    mov al, 33
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check34
    mov detonateOnShip5, 1
    jmp moveonnow
check34:
    mov ah, 23
    mov al, 34
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check35
    mov detonateOnShip5, 1
    jmp moveonnow
check35:
    mov ah, 23
    mov al, 35
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip5, 1
    jmp moveonnow
moveOnNow:


    mov ah, 23
    mov al, 33
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 31
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 32
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 33
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 34
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 35
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 31
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 32
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 33
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 34
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 35
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip5, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 31
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 32
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 33
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 34
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 35
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy5
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy5
    mov al, currColEnemy5
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET FifthCol
    call    RegisterAlarm
    mov alienKilled5, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
FifthCol ENDP

SixthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 6
    call DecideCol
    cmp alienKilled6, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy6
    mov ah, currRowEnemy6
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy6-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy6-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy6+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy6+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled6, 1
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy6, 15
    je stop
    mov ah, currRowEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy6, 11
    je fall
    cmp currRowEnemy6, 24
    je detonate
    dec currRowEnemy6
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy6, 16
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy6
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip6 BYTE 0
    .code
    mov detonateOnShip6, 0
    ;; checking cols 46-50 for the triangle spaceship
check46:
    mov ah, 23
    mov al, 46
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check47
    mov detonateOnShip6, 1
    jmp moveonnow
Check47:
    mov ah, 23
    mov al, 47
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check48
    mov detonateOnShip6, 1
    jmp moveonnow
check48:
    mov ah, 23
    mov al, 48
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check49
    mov detonateOnShip6, 1
    jmp moveonnow
check49:
    mov ah, 23
    mov al, 49
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check50
    mov detonateOnShip6, 1
    jmp moveonnow
check50:
    mov ah, 23
    mov al, 50
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip6, 1
    jmp moveonnow
moveOnNow:


    mov ah, 23
    mov al, 48
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 46
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 47
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 48
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 49
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 50
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 46
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 47
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 48
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 49
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 50
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip6, 1
    je gameend

    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 46
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 47
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 48
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 49
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 50
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy6
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy6
    mov al, currColEnemy6
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET SixthCol
    call    RegisterAlarm
    mov alienKilled6, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
SixthCol ENDP

SeventhCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 7
    call DecideCol
    cmp alienKilled7, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy7
    mov ah, currRowEnemy7
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy7-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy7-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy7+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy7+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled7, 1
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy7, 15
    je stop
    mov ah, currRowEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy7, 11
    je fall
    cmp currRowEnemy7, 24
    je detonate
    dec currRowEnemy7
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy7, 16
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy7
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip7 BYTE 0
    .code
    mov detonateOnShip7, 0
    ;; checking cols 50-54 for the triangle spaceship
check50:
    mov ah, 23
    mov al, 50
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check51
    mov detonateOnShip7, 1
    jmp moveonnow
Check51:
    mov ah, 23
    mov al, 51
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check52
    mov detonateOnShip7, 1
    jmp moveonnow
check52:
    mov ah, 23
    mov al, 52
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check53
    mov detonateOnShip7, 1
    jmp moveonnow
check53:
    mov ah, 23
    mov al, 53
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check54
    mov detonateOnShip7, 1
    jmp moveonnow
check54:
    mov ah, 23
    mov al, 54
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip7, 1
    jmp moveonnow
moveOnNow:



    mov ah, 23
    mov al, 52
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 50
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 51
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 52
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 53
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 54
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 50
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 51
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 52
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 53
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 54
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip7, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 50
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 51
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 52
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 53
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 54
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy7
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy7
    mov al, currColEnemy7
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET SeventhCol
    call    RegisterAlarm
    mov alienKilled7, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
SeventhCol ENDP

EigthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 8
    call DecideCol
    cmp alienKilled8, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy8
    mov ah, currRowEnemy8
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy8-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy8-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy8+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy8+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled8, 1
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy8, 15
    je stop
    mov ah, currRowEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy8, 11
    je fall
    cmp currRowEnemy8, 24
    je detonate
    dec currRowEnemy8
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy8, 16
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy8
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip8 BYTE 0
    .code
    mov detonateOnShip8, 0
    ;; checking cols 54-58 for the triangle spaceship
check54:
    mov ah, 23
    mov al, 54
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check55
    mov detonateOnShip8, 1
    jmp moveonnow
Check55:
    mov ah, 23
    mov al, 55
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check56
    mov detonateOnShip8, 1
    jmp moveonnow
check56:
    mov ah, 23
    mov al, 56
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check57
    mov detonateOnShip8, 1
    jmp moveonnow
check57:
    mov ah, 23
    mov al, 57
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check58
    mov detonateOnShip8, 1
    jmp moveonnow
check58:
    mov ah, 23
    mov al, 58
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip8, 1
    jmp moveonnow
moveOnNow:



    mov ah, 23
    mov al, 56
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 54
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 55
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 56
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 57
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 58
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 54
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 55
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 56
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 57
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 58
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip8, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 54
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 55
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 56
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 57
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 58
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy8
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy8
    mov al, currColEnemy8
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET EigthCol
    call    RegisterAlarm
    mov alienKilled8, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
EigthCol ENDP

NinthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 9
    call DecideCol
    cmp alienKilled9, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy9
    mov ah, currRowEnemy9
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy9-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy9-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy9+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy9+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled9, 1
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy9, 15
    je stop
    mov ah, currRowEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy9, 11
    je fall
    cmp currRowEnemy9, 24
    je detonate
    dec currRowEnemy9
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy9, 16
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy9
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip9 BYTE 0
    .code
    mov detonateOnShip9, 0
    ;; checking cols 58-62 for the triangle spaceship
check58:
    mov ah, 23
    mov al, 58
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check59
    mov detonateOnShip9, 1
    jmp moveonnow
Check59:
    mov ah, 23
    mov al, 59
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check60
    mov detonateOnShip9, 1
    jmp moveonnow
check60:
    mov ah, 23
    mov al, 60
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check61
    mov detonateOnShip9, 1
    jmp moveonnow
check61:
    mov ah, 23
    mov al, 61
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check62
    mov detonateOnShip9, 1
    jmp moveonnow
check62:
    mov ah, 23
    mov al, 62
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip9, 1
    jmp moveonnow
moveOnNow:



    mov ah, 23
    mov al, 60
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 58
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 59
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 60
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 61
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 62
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 58
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 59
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 60
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 61
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 62
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip9, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 58
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 59
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 60
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 61
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 62
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy9
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy9
    mov al, currColEnemy9
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET NinthCol
    call    RegisterAlarm
    mov alienKilled9, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
NinthCol ENDP

TenthCol PROC
    pushf
    push ax
    push bx
    push dx

    cmp gameOver, 1
    je finish

    ;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
    mov activeEnemyCol, 10
    call DecideCol
    cmp alienKilled10, 1
    jne doIt
    jmp finish
doIt:
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call GetVideoChar
    cmp bl, 179
    je die
    inc currRowEnemy10
    mov ah, currRowEnemy10
    call GetVideoChar
    cmp bl, 179
    je die
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov dx, 1
    call GetVideoChar
    cmp bl, 20h
    je cont
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy10-2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy10-1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate    
    mov al, currColEnemy10+1
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    mov al, currColEnemy10+2
    call GetVideoChar
    cmp bl, 1Eh
    je detonate
    jmp stackIt
die:
    mov alienKilled10, 1
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
cont:
    cmp currRowEnemy10, 15
    je stop
    mov ah, currRowEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
stackIt:
    cmp currRowEnemy10, 11
    je fall
    cmp currRowEnemy10, 24
    je detonate
    dec currRowEnemy10
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
fall:
    mov currRowEnemy10, 16
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    inc currRowEnemy10
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp done
detonate:
    .data 
    detonateOnShip10 BYTE 0
    .code
    mov detonateOnShip10, 0
    ;; checking cols 62-66 for the triangle spaceship
check62:
    mov ah, 23
    mov al, 62
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check63
    mov detonateOnShip10, 1
    jmp moveonnow
Check63:
    mov ah, 23
    mov al, 63
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check64
    mov detonateOnShip10, 1
    jmp moveonnow
check64:
    mov ah, 23
    mov al, 64
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check65
    mov detonateOnShip10, 1
    jmp moveonnow
check65:
    mov ah, 23
    mov al, 65
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne check66
    mov detonateOnShip10, 1
    jmp moveonnow
check66:
    mov ah, 23
    mov al, 66
    mov dx, 1
    call GetVideoChar
    cmp bl, 1Eh
    jne moveOnNow
    mov detonateOnShip10, 1
    jmp moveonnow
moveOnNow:




    mov ah, 23
    mov al, 64
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 62
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 63
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 64
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 65
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 66
    mov bl, '='
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    call nonsense
    mov ah, 23
    mov al, 62
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 63
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 64
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 65
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    mov ah, 23
    mov al, 66
    mov bl, '-'
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    call GetVideoChar
    cmp bl, 1Eh
    je gameEnd
    cmp detonateOnShip10, 1
    je gameend


    jmp goOn
gameEnd:
    mov GameOver, 1
goOn:
    call nonsense
    mov ah, 23
    mov al, 62
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 63
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar  
    mov ah, 23
    mov al, 64
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 65
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov ah, 23
    mov al, 66
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    jmp finish
gameDone:
    mov ah, 23
    mov al, currColEnemy10
    mov bl, 20h
    mov bh, 0000b
    mov dx, 1
    call WriteVideoChar
    mov	GameOver, 1
    jmp finish
stop:
    mov ah, currRowEnemy10
    mov al, currColEnemy10
    mov bl, 148
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    jmp finish
done:
    mov	ax, 5
    mov	dx, OFFSET TenthCol
    call    RegisterAlarm
    mov alienKilled10, 0
finish:
    pop dx
    pop bx
    pop ax
    popf
    ret
TenthCol ENDP

AllColsForward PROC
    push ax
    push bx
    push dx
    cmp GameOver, 1
    je next9
    mov alienKilled1, 0
    mov alienKilled2, 0
    mov alienkilled3, 0
    mov alienKilled4, 0
    mov alienKilled5, 0
    mov alienKilled6, 0
    mov alienKilled7, 0
    mov alienKilled8, 0
    mov alienKilled9, 0
    mov alienKilled10, 0
    mov currRowEnemy1, 7
    mov currRowEnemy2, 7
    mov currRowEnemy3, 7
    mov currRowEnemy4, 7
    mov currRowEnemy5, 7
    mov currRowEnemy6, 7
    mov currRowEnemy7, 7
    mov currRowEnemy8, 7
    mov currRowEnemy9, 7
    mov currRowEnemy10, 7
    cmp alienKilled1, 1
    je next1
    mov ax, 3
    mov dx, OFFSET FirstCol
    call RegisterAlarm
next1:
    cmp alienKilled2, 1
    je next2
    mov	ax, 18
    mov	dx, OFFSET SecondCol
    call    RegisterAlarm
next2:
    cmp alienKilled3, 1
    je next3
    mov ax, 33
    mov dx, OFFSET ThirdCol
    call RegisterAlarm
next3:
    cmp alienKilled4, 1
    je next4
    mov ax, 48
    mov dx, OFFSET FourthCol
    call RegisterAlarm
next4:
    cmp alienKilled5, 1
    je next5
    mov ax, 63
    mov dx, OFFSET FifthCol
    call RegisterAlarm
next5:
    cmp alienKilled6, 1
    je next6
    mov ax, 78
    mov dx, OFFSET SixthCol
    call RegisterAlarm
next6:
    cmp alienKilled7, 1
    je next7
    mov ax, 93
    mov dx, OFFSET SeventhCol
    call RegisterAlarm
next7:
    cmp alienKilled8, 1
    je next8
    mov ax, 108
    mov dx, OFFSET EigthCol
    call RegisterAlarm
next8:
    cmp alienKilled9, 1
    je next9
    mov ax, 123
    mov dx, OFFSET NinthCol
    call RegisterAlarm
next9:
    pop dx
    pop bx
    pop ax
    ret
AllColsForward ENDP

AllColsBackward PROC
    push ax
    push bx
    push dx
    cmp GameOver, 1
    je next
    mov alienKilled1, 0
    mov alienKilled2, 0
    mov alienkilled3, 0
    mov alienKilled4, 0
    mov alienKilled5, 0
    mov alienKilled6, 0
    mov alienKilled7, 0
    mov alienKilled8, 0
    mov alienKilled9, 0
    mov alienKilled10, 0
    mov currRowEnemy1, 7
    mov currRowEnemy2, 7
    mov currRowEnemy3, 7
    mov currRowEnemy4, 7
    mov currRowEnemy5, 7
    mov currRowEnemy6, 7
    mov currRowEnemy7, 7
    mov currRowEnemy8, 7
    mov currRowEnemy9, 7
    mov currRowEnemy10, 7
    cmp alienKilled9, 1
    je next9
    cmp GameOver, 1
    je next9
    mov	ax, 3
    mov	dx, OFFSET TenthCol
    call    RegisterAlarm
next9:
    cmp alienKilled8, 1
    je next8
    cmp GameOver, 1
    je next8
    mov	ax, 18
    mov	dx, OFFSET NinthCol
    call    RegisterAlarm
next8:
    cmp alienKilled7, 1
    je next7
    cmp GameOver, 1
    je next7
    mov	ax, 33
    mov	dx, OFFSET EigthCol
    call    RegisterAlarm
next7:
    cmp alienKilled6, 1
    je next6
    cmp GameOver, 1
    je next6
    mov ax, 48
    mov dx, OFFSET SeventhCol
    call RegisterAlarm
next6:
    cmp alienKilled5, 1
    je next5
    cmp GameOver, 1
    je next5
    mov ax, 63
    mov dx, OFFSET SixthCol
    call RegisterAlarm
next5:
    cmp alienKilled4, 1
    je next4
    cmp GameOver, 1
    je next4
    mov ax, 78
    mov dx, OFFSET FifthCol
    call RegisterAlarm
next4:
    cmp alienKilled3, 1
    je next3
    cmp GameOver, 1
    je next3
    mov ax, 93
    mov dx, OFFSET FourthCol
    call RegisterAlarm
next3:
    cmp alienKilled2, 1
    je next2
    cmp GameOver, 1
    je next2
    mov ax, 108
    mov dx, OFFSET ThirdCol
    call RegisterAlarm
next2:
    cmp alienKilled1, 1
    je next
    cmp GameOver, 1
    je next
    mov ax, 123
    mov dx, OFFSET SecondCol
    call RegisterAlarm
next:
    pop dx
    pop bx
    pop ax
    ret
AllColsBackward ENDP

ColSnake PROC
    push ax
    push bx
    push dx
    cmp GameOver, 1
    je done
    mov alienKilled1, 0
    mov alienKilled2, 0
    mov alienkilled3, 0
    mov alienKilled4, 0
    mov alienKilled5, 0
    mov alienKilled6, 0
    mov alienKilled7, 0
    mov alienKilled8, 0
    mov alienKilled9, 0
    mov alienKilled10, 0
    cmp GameOver, 1
    je done
    mov	ax, 35
    mov	dx, OFFSET AllColsForward
    call    RegisterAlarm

    mov alienKilled1, 0
    mov alienKilled2, 0
    mov alienkilled3, 0
    mov alienKilled4, 0
    mov alienKilled5, 0
    mov alienKilled6, 0
    mov alienKilled7, 0
    mov alienKilled8, 0
    mov alienKilled9, 0
    mov alienKilled10, 0
    cmp GameOver, 1
    je done
    mov	ax, 220
    mov	dx, OFFSET AllColsBackward
    call    RegisterAlarm

    mov alienKilled1, 0
    mov alienKilled2, 0
    mov alienkilled3, 0
    mov alienKilled4, 0
    mov alienKilled5, 0
    mov alienKilled6, 0
    mov alienKilled7, 0
    mov alienKilled8, 0
    mov alienKilled9, 0
    mov alienKilled10, 0
    cmp GameOver, 1
    je done
    mov ax, 400
    mov dx, OFFSET ColSnake
    call RegisterAlarm
done:
    pop dx
    pop bx
    pop ax
    ret
ColSnake ENDP

droneDrop PROC
    push ax
    push bx
    push dx

    mov drone1hit, 0
    mov drone2hit, 0
    mov drone3hit, 0

    cmp gameover, 1
    je done

    mov drone1Movement, 12
    mov drone2Movement, 12
    mov drone3Movement, 12
    mov	ax, 70
    mov	dx, OFFSET drone1
    call    RegisterAlarm

    mov	ax, 200
    mov	dx, OFFSET drone2
    call    RegisterAlarm

    mov ax, 310
    mov dx, OFFSET drone3
    call RegisterAlarm

    cmp gameover, 1
    je done

    mov ax, 450
    mov dx, OFFSET droneDrop
    call RegisterAlarm
done:
    pop dx
    pop bx
    pop ax
    ret
droneDrop ENDP

GetVideoChar PROC               ; get the character at a specific part of the video screen
    ;; AH = row
    ;; AL = col
    ;; DX = video page
    pushf
    push    ax
    push    cx
    push    dx
    push    es
    push    di

    mov    di, 0B800h
    mov    es, di
    shl    al, 1
    mov    cl, 12
    shl    dx, cl
    add    dl, al
    mov    di, dx

    mov    bl, ah
    mov    bh, 0
    mov    ax, 160
    mul    bx
    add    di, ax

    mov    bx, es:[di]     ; should put the character in bx

    pop    di
    pop    es
    pop    dx
    pop    cx
    pop    ax
    popf
    ret
GetVideoChar ENDP

DisplayInitialScore PROC 
DXOne:
    mov ah, 1
    mov al, 0
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
BXOne:
    mov ah, 1
    mov al, 2
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
BXTwo:
    mov ah, 1
    mov al, 4
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
BXThree:
    mov ah, 1
    mov al, 6
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
BXFour:
    mov ah, 1
    mov al, 8
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar

    mov ah, 1
    mov al, 79
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    mov ah, 1
    mov al, 77
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    mov ah, 1
    mov al, 75
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    mov ah, 1
    mov al, 73
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    mov ah, 1
    mov al, 71
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar

    ret 
DisplayInitialScore ENDP

UpdateScore PROC
    pushf
    push ax
    push bx
    push dx


    cmp currLocation, 16
    jne alien2
    mov alienKilled1, 1
alien2:
    cmp currLocation, 20
    jne alien3
    mov alienKilled2, 1
alien3:
    cmp currLocation, 24
    jne alien4
    mov alienKilled3, 1
alien4:
    cmp currLocation, 28
    jne alien5
    mov alienKilled4, 1
alien5:
    cmp currLocation, 32
    jne alien6
    mov alienKilled5, 1
alien6:
    cmp currLocation, 47
    jne alien7
    mov alienKilled6, 1
alien7:
    cmp currLocation, 51
    jne alien8
    mov alienKilled7, 1
alien8:
    cmp currLocation, 55
    jne alien9
    mov alienKilled8, 1
alien9:
    cmp currLocation, 59
    jne alien10
    mov alienKilled9, 1
alien10:
    cmp currLocation, 63
    jne ontoNext
    mov alienKilled10, 1
ontoNext:

    cmp DroneHit, 1
    je DHit
    cmp SpaceshipHit, 1
    je SpaceHit
    jmp done

DHit:
    mov ah, 1
    mov al, 6
    mov bl, score10s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score100s
    inc score100s
    inc score100s
    inc score100s
    mov DroneHit, 0
    cmp score100s, 57
    ja dronethousands
    mov ah, 1
    mov al, 4
    mov bl, score100s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done
dronethousands:
    sub score100s, 10
    mov ah, 1
    mov al, 4
    mov bl, score100s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score1000s
    mov DroneHit, 0
    cmp score1000s, 57
    ja dronetenthousands
    mov ah, 1
    mov al, 2
    mov bl, score1000s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done
dronetenthousands:
    sub score100s, 10
    sub score1000s, 10
    mov ah, 1
    mov al, 2
    mov bl, score1000s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score10000s
    mov DroneHit, 0
    cmp score10000s, 57
    ja done
    mov ah, 1
    mov al, 0
    mov bl, score10000s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done

SpaceHit:
    inc score10s
    cmp score10s, 58
    je spacehundreds
    mov ah, 1
    mov al, 6
    mov bl, score10s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done
spacehundreds:
    mov score10s, 48
    mov ah, 1
    mov al, 6
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score100s
    mov SpaceshipHit, 0
    cmp score100s, 58
    je spacethousands
    mov ah, 1
    mov al, 4
    mov bl, score100s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done
spacethousands:
    mov score10s, 48
    mov score100s, 48
    mov ah, 1
    mov al, 4
    mov bl, score100s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score1000s
    mov SpaceshipHit, 0
    cmp score1000s, 58
    je spacetenthousands
    mov ah, 1
    mov al, 2
    mov bl, score1000s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    jmp done
spacetenthousands:
    mov score10s, 48
    mov score100s, 48
    mov score1000s, 48
    mov ah, 1
    mov al, 2
    mov bl, 48
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc score10000s
    mov SpaceshipHit, 0
    cmp score10000s, 58
    je done
    mov ah, 1
    mov al, 0
    mov bl, score10000s
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
done:
    pop dx
    pop bx
    pop ax
    popf
    ret
UpdateScore ENDP

recolor PROC
    push ax
    push bx
    push cx
    push dx
                                ; B O R D E R
; LIGHT BLUE
    mov colorVar, 0
    jmp cond
top:
    mov ah, 6
    mov al, colorVar
    mov bl, 176
    mov bh, 1001b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
cond:
    cmp colorVar, 80
    jb top

; YELLOW
    mov colorVar, 0
    mov ah, 7
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 7
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 7
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 7
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 0
    mov ah, 8
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 8
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 8
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 8
    mov al, colorVar
    mov bl, 176
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar

; PINK
    mov colorVar, 0
    mov ah, 9
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 9
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 9
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 9
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 0
    mov ah, 10
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 10
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 10
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 10
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
        mov colorVar, 0
    mov ah, 11
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 11
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 11
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 11
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
        mov colorVar, 0
    mov ah, 12
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 12
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 12
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 12
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
        mov colorVar, 0
    mov ah, 13
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 13
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 13
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 13
    mov al, colorVar
    mov bl, 176
    mov bh, 0101b
    mov dx, 1
    call WriteVideoChar

; WHITE
    mov colorVar, 0
    mov ah, 14
    mov al, colorVar
    mov bl, 176
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 14
    mov al, colorVar
    mov bl, 176
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 14
    mov al, colorVar
    mov bl, 176
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 14
    mov al, colorVar
    mov bl, 176
    mov bh, 1111b
    mov dx, 1
    call WriteVideoChar

; CYAN
    mov colorVar, 0
    mov ah, 15
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 15
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 15
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 15
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 0
    mov ah, 16
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 16
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 16
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 16
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
        mov colorVar, 0
    mov ah, 17
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 17
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 17
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 17
    mov al, colorVar
    mov bl, 176
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar

; GREEN
    mov colorVar, 0
    mov ah, 20
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 20
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 20
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 20
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 0
    mov ah, 21
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 21
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 21
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 21
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
        mov colorVar, 0
    mov ah, 22
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 22
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 78
    mov ah, 22
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 22
    mov al, colorVar
    mov bl, 176
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar



                                ; C H A N N E L S
    mov colorVar, 13
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 18
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 22
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 26
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 30
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 34
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
top2:
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    inc colorVar
    cmp colorVar, 46
    jb top2

    mov colorVar, 34
    mov ah, 10
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 45
    mov ah, 10
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar

    mov colorVar, 49
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 53
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 57
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 61
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 65
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 66
    mov ah, 11
    mov al, colorVar
    mov bl, 219
    mov bh, 1110b
    mov dx, 1
    call WriteVideoChar


    mov colorVar, 14
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 18
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 22
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 26
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 30
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 34
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar

    mov colorVar, 45
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 49
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 53
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 57
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 61
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 65
    mov ah, 12
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
;===========================================
    mov colorVar, 14
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 18
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 22
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 26
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 30
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 34
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar

    mov colorVar, 45
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 49
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 53
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 57
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 61
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 65
    mov ah, 13
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
;=========================================
    mov colorVar, 14
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 18
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 22
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 26
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 30
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 34
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar

    mov colorVar, 45
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 49
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 53
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 57
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 61
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 65
    mov ah, 14
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
;===========================================
    mov colorVar, 14
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 18
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 22
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 26
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 30
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 34
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    inc colorVar

    mov colorVar, 45
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 49
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 53
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 57
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 61
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    mov colorVar, 65
    mov ah, 15
    mov al, colorVar
    mov bl, 219
    mov bh, 0010b
    mov dx, 1
    call WriteVideoChar
    pop dx
    pop cx
    pop bx
    pop ax
    ret
recolor ENDP

.data


.code

TIMER_DATA_PORT		= 42h
TIMER_CONTROL_PORT	= 43h
SPEAKER_PORT		= 61h
READY_TIMER		= 0B6h

; # CITE: Kai Haesslein
; # DESC: Collaborated with Kai to determine a list note frequencies in the early stages of creating sound
MusicScore WORD 978h, 978h, 978h, 978h, 978h, 978h, 978h, 978h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 978h, 978h, 978h, 978h, 978h, 978h, 978h, 978h
           WORD 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0FD4h, 0FD4h, 0FD4h, 0FD4h, 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h
           WORD 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0FD4h, 0FD4h, 0FD4h, 0FD4h, 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0FD4h, 0FD4h, 0FD4h, 0FD4h
           WORD 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h,0BE3h, 0BE3h, 0FD4h, 0FD4h, 0FD4h, 0FD4h
           WORD 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 0BE3h, 0BE3h, 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 0BE3h, 0BE3h
           WORD 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h, 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 0BE3h, 0BE3h
           WORD 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 0A9Ch, 0A06h, 0A9Ch, 0D52h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0BE3h, 0E1Bh, 0E1Bh, 0E1Bh, 0E1Bh, 0E1Bh, 0E1Bh, 0E1Bh, 0E1Bh
           WORD 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0BE3h, 0A9Ch, 0A06h, 0A06h, 0D52h, 0D52h, 0D52h, 0D52h, 0D52h, 0D52h, 0BE3h, 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0A9Ch, 0BE3h, 0A9Ch
           WORD 0A06h, 0A06h, 0D52h, 0D52h, 0D52h, 0D52h, 0D52h, 8F1h, 7F8h, 7F8h, 7F8h, 7F8h, 7F8h, 7F8h, 7F8h, 7F8h, 8F1h, 8F1h, 8F1h, 8F1h, 978h, 978h, 978h, 978h
           WORD 8F1h, 8F1h, 8F1h, 8F1h, 8F1h, 784h, 7F8h, 8F1h, 7F8h, 7F8h, 0A06h, 0A06h, 0A06h, 0A06h, 0A06h, 7F8h, 6ABh, 646h, 646h, 646h, 646h, 646h, 646h, 646h, 646h
           WORD 646h, 646h, 646h, 646h, 646h, 646h, 646h, 646h

SpeakerOn PROC
	pushf
	push	ax
	
	in	al, SPEAKER_PORT		; Read the speaker register
	or	al, 03h				; Set the two low bits high
	out	SPEAKER_PORT, al		; Write the speaker register

done:	
	pop	ax
	popf
	ret
SpeakerOn ENDP
	
SpeakerOff PROC

	pushf
	push	ax
	
	in	al, SPEAKER_PORT		; Read the speaker register
	and	al, 0FCh			; Clear the two low bits high
	out	SPEAKER_PORT, al		; Write the speaker register

	pop	ax
	popf
	ret
SpeakerOff ENDP

nextNote PROC
    push dx
    push si

    mov dx, MusicScore[si]

    pop si
    pop dx
    ret
nextNote ENDP
	
PlayFrequency PROC
	;; Frequency is found in DX

	pushf
	push	ax

	cmp	dx, 0
	je	rest

;when going through my music score, inc by 2!!!!!

    mov dx, MusicScore[si]

	mov	al, READY_TIMER			; Get the timer ready
	out	TIMER_CONTROL_PORT, al

	mov	al, dl
	out	TIMER_DATA_PORT, al		; Send the count low byte
	
	mov	al, dh
	out	TIMER_DATA_PORT, al		; Send the count high byte
	
	call	SpeakerOn

done:	
    pop ax
	popf
	ret
rest:
	call	SpeakerOff
	jmp	done
PlayFrequency ENDP

PlayScore PROC
	push	ax
	push	dx

    cmp gameover, 1
    je done

	call	PlayFrequency
    inc si
    inc si
    cmp si, 484
    ja resetMusic
    jmp cont
resetMusic:
    mov si, 0
cont:
 	mov	ax, 3
 	mov	dx, OFFSET PlayScore
	call	RegisterAlarm
done:
	pop	dx
	pop	ax
	ret
PlayScore ENDP

StopNote PROC
	pushf
	push	ax
	push	dx

	call	SpeakerOff
	
 	mov	ax, 1
 	mov	dx, OFFSET PlayScore
	call	RegisterAlarm

done:	
	pop	dx
	pop	ax
	popf
	ret
StopNote ENDP

SoundLoop PROC
	pushf
	push	ax
	mov si, 0
	jmp	cond
top:	
	call	CheckAlarms
	call	UserAction
cond:
	cmp	GameOver, 0
	je	top
	
	pop	ax
	popf
	ret
SoundLoop ENDP

PrintScoreWord PROC
    ; SCORE: S = 83, C = 67, O = 79, R = 82, E = 69
    ; HI- ... H: 72, I: 73,

H:
    mov ah, 13
    mov al, 32
    mov bl, 72
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
I:
    mov ah, 13
    mov al, 34
    mov bl, 73
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
hyphen:
    mov ah, 13
    mov al, 36
    mov bl, '-'
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
S: 
    mov ah, 13
    mov al, 38
    mov bl, 83
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
CLetter:
    mov ah, 13
    mov al, 40
    mov bl, 67
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
O:
    mov ah, 13
    mov al, 42
    mov bl, 79
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
R:
    mov ah, 13
    mov al, 44
    mov bl, 82
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
E:
    mov ah, 13
    mov al, 46
    mov bl, 69
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
Colon:
    mov ah, 13
    mov al, 47
    mov bl, ':'
    mov bh, 1110b
    mov dx, 3
    call WriteVideoChar
    ret 
PrintScoreWord ENDP

EndGameScore PROC               ; row has AH, col has AL
        ; col at 28, row at 12
    call PrintScoreWord
First:
    mov ah, 14
    mov al, 35
    mov bl, score10000s
    mov bh, 1111b
    mov dx, 3
    call WriteVideoChar
Second:
    mov ah, 14
    mov al, 37
    mov bl, score1000s
    mov bh, 1111b
    mov dx, 3
    call WriteVideoChar
Third: 
    mov ah, 14
    mov al, 39
    mov bl, score100s
    mov bh, 1111b
    mov dx, 3
    call WriteVideoChar
Fourth:
    mov ah, 14
    mov al, 41
    mov bl, score10s
    mov bh, 1111b
    mov dx, 3
    call WriteVideoChar
Fifth:                      ; always a zero, this is how the game scoring works.
    mov ah, 14
    mov al, 43
    mov bl, 48
    mov bh, 1111b
    mov dx, 3
    call WriteVideoChar
    ret 
EndGameScore ENDP

CheckDeath PROC 
    mov ah, 23
    mov al, spaceshipMovement
    mov dx, 1
    call GetVideoChar               ; char in BX

    cmp bl, '-'
    jne next 
    mov gameover, 1
next: 
    cmp bl, '='
    jne nah
    mov GameOver, 1
nah:
    
    ret 
CheckDeath ENDP

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	call CursorOff
	call InstallTimerHandler
	call SplashScreen
	call startScreen
	call GameScreen
    call recolor

    call DisplayInitialScore

    mov ah, 23
    mov al, 40
    mov bl, 1Eh
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar

	mov ah, 3
    mov al, 79
    mov bl, 232
    mov bh, 1011b
    mov dx, 1
    call WriteVideoChar

	mov enemyshipMovement, 79
	mov spaceshipMovement, 40
	mov spaceshipPosition, 40

	mov ax, 1
    mov dx, OFFSET enemyship
    call RegisterAlarm


    mov ax, 1
    mov dx, OFFSET spaceship
    call RegisterAlarm


	mov ax, 1
    mov dx, OFFSET bullet
    call RegisterAlarm


    mov ax, 1
    mov dx, OFFSET ColSnake
    call RegisterAlarm

    ;mov ax, 1
    ;mov dx, OFFSET CheckDeath
    ;call RegisterAlarm

    mov ax, 1
    mov dx, OFFSET droneDrop
    call RegisterAlarm

    
    mov ax, 8
    mov dx, OFFSET PlayScore
    call RegisterAlarm

    cmp gameover, 1
    je done

    call SoundLoop

    cmp gameover, 1
    je done

	call GameLoop
done:
    call SpeakerOff
	call GameOverScreen
	mov	al, 0
	call	ChangeVideoPage

	call RestoreTimerHandler
	call CursorOn
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main


;   ASCII REPRESENTATIONS:
;   148 = ö
;   207 = ╧
;   240 = ≡