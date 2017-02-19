title	Pong
.486

stck	segment para stack 'stack' use16
		dw	64 dup(?)
stck	ends

data	segment para public 'data' use16
prevt	dw	?				;used to store the time of the last frame
kbdbuf	db	128 dup(0)		;state of all the keys (1 = pressed, 0 = released)	
objx	dw	?				;x coordinate of the object to draw on screen
objy	dw	?				;y coordinate of the object to draw on screen
objw	dw	?				;width of the object to draw on screen
objh	dw	?				;height of the object to draw on screen
objl	dw	?				;length of the image of the object to draw on screen
obji	dw	?				;address of the image to be drawn on screen
objaux1	db	?				;auxiliary data for the draw procedure
objaux2	db	?				;auxiliary data for the draw procedure
colors	db	7h, 1h, 2h, 3h, 4h, 5h, 6h, 9h, 0eh, 0fh	;color codes that can be used to draw with
colorsl	equ	$ - colors		;length of the colors array
ccolori	db	0				;index of the color code that is currently in use
ccolor	db	7h				;color code that is currently in use
gstate	db	0				;game state (0 = main menu, 1 = in game, 2 = winner screen)
score1	db	0				;score of player 1
score2	db	0				;score of player 2
winner	db	?				;winner (1 = player 1 / 2 = player 2)

;data for the ball
ballx	dw	0					;x
bally	dw	0					;y
ballw	equ	5					;width
ballh	equ	5					;height
balli	db	77h, 0ffh, 0f7h, 0	;image
balll	equ	$ - balli			;image length
balls	equ 5					;speed on 1 coordinate
ballvx	dw	?					;x coordinate of the velocity vector
ballvy	dw	?					;y coordinate of the velocity vector

;data for the paddles
pad1x	dw	0					;x of paddle 1
pad1y	dw	0					;y of paddle 1
pad2x	dw	320 - padw			;x of paddle 2
pad2y	dw	0					;y of paddle 2
padw	equ	3					;width
padh	equ	25					;height
padi	db	10 dup(0ffh)		;image
padl	equ	$ - padi			;image length
pads	equ	10					;speed

;data for the score numbers
num0	db	0ffh, 0fch, 0f3h, 0cfh, 3ch, 0f3h, 0ffh, 0f0h	;image for number 0
num1	db	0ch, 30h, 0c3h, 0ch, 30h, 0c3h, 0ch, 30h		;image for number 1
num2	db	0ffh, 0f0h, 0c3h, 0ffh, 0fch, 30h, 0ffh, 0f0h	;image for number 2
num3	db	0ffh, 0f0h, 0c3h, 0ffh, 0f0h, 0c3h, 0ffh, 0f0h	;image for number 3
num4	db	0cfh, 3ch, 0f3h, 0ffh, 0f0h, 0c3h, 0ch, 30h		;image for number 4
num5	db	0ffh, 0fch, 30h, 0ffh, 0f0h, 0c3h, 0ffh, 0f0h	;image for number 5
num6	db	0ffh, 0fch, 30h, 0ffh, 0fch, 0f3h, 0ffh, 0f0h	;image for number 6
num7	db	0ffh, 0f0h, 0c3h, 0ch, 30h, 0c3h, 0ch, 30h		;image for number 7
num8	db	0ffh, 0fch, 0f3h, 0ffh, 0fch, 0f3h, 0ffh, 0f0h	;image for number 8
num9	db	0ffh, 0fch, 0f3h, 0ffh, 0f0h, 0c3h, 0ffh, 0f0h	;image for number 9
numl	equ	$ - num9										;length of an image
num1x	dw	150												;x of the first score number
num1y	dw	10												;y of the first score number
num2x	dw	164												;x of the second score number
num2y	dw	10												;y of the second score number
numw	equ	6												;width
numh	equ	10												;height

;data for the separator
sepx	dw	159									;x
sepy	dw	0									;y
sepw	equ	2									;width
seph	equ	200									;height
sepi	db	16 dup(0ffh, 0ffh, 0), 0ffh, 0ffh	;image
sepl	equ	$ - sepi							;image length

;data for the image that says 'Pong'
;i didn't write all these bytes myself
;these were generated using a third party program (written by me in C#)
;i don't know if there is a better way to do this, other than using external files
titlei	db	0ffh,0ffh,0ffh,0ffh,0f8h,000h,07fh,0ffh,0ffh,0ffh,0c0h,03fh,0f8h,000h,000h,0ffh,0e0h,01fh,0ffh,0ffh,0ffh,0f8h,07fh,0ffh,0ffh
		db	0ffh,0fch,000h,03fh,0ffh,0ffh,0ffh,0e0h,01fh,0fch,000h,000h,07fh,0f0h,00fh,0ffh,0ffh,0ffh,0fch,03fh,0ffh,0ffh,0ffh,0feh,000h
		db	01fh,0ffh,0ffh,0ffh,0f0h,00fh,0feh,000h,000h,03fh,0f8h,007h,0ffh,0ffh,0ffh,0feh,01fh,0ffh,0ffh,0ffh,0ffh,000h,00fh,0ffh,0ffh
		db	0ffh,0f8h,007h,0ffh,000h,000h,01fh,0fch,003h,0ffh,0ffh,0ffh,0ffh,00fh,0ffh,0ffh,0ffh,0ffh,0f8h,07fh,0ffh,0ffh,0ffh,0ffh,0c3h
		db	0ffh,0f8h,000h,00fh,0feh,01fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,03fh,0ffh,0ffh,0ffh,0ffh,0e1h,0ffh,0fch,000h
		db	007h,0ffh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,01fh,0ffh,0ffh,0ffh,0ffh,0f0h,0ffh,0feh,000h,003h,0ffh,087h
		db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,0ffh,0ffh,0ffh,0ffh,0f8h,07fh,0ffh,000h,001h,0ffh,0c3h,0ffh,0ffh,0ffh
		db	0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,087h,0ffh,0ffh,0ffh,0ffh,0fch,03fh,0ffh,080h,000h,0ffh,0e1h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
		db	0ffh,0ffh,0ffh,0ffh,0c3h,0ffh,0ffh,0ffh,0ffh,0feh,01fh,0ffh,0c0h,000h,07fh,0f0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
		db	0ffh,0e1h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,0ffh,0e0h,000h,03fh,0f8h,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,07fh,0f0h,0ffh
		db	0e0h,000h,003h,0ffh,087h,0ffh,0ffh,000h,01fh,0fch,03fh,0f8h,000h,000h,07fh,0ffh,0feh,000h,000h,03fh,0f8h,07fh,0f0h,000h,001h
		db	0ffh,0c3h,0ffh,0ffh,080h,00fh,0feh,01fh,0fch,000h,000h,03fh,0ffh,0ffh,000h,000h,01fh,0fch,03fh,0f8h,000h,000h,0ffh,0e1h,0ffh
		db	0ffh,0c0h,007h,0ffh,00fh,0feh,000h,000h,01fh,0ffh,0ffh,080h,000h,00fh,0feh,01fh,0fch,000h,000h,07fh,0f0h,0ffh,0ffh,0e0h,003h
		db	0ffh,087h,0ffh,000h,000h,00fh,0ffh,0ffh,0c0h,000h,007h,0ffh,00fh,0feh,000h,000h,03fh,0f8h,07fh,0ffh,0f0h,001h,0ffh,0c3h,0ffh
		db	080h,000h,000h,000h,0ffh,0e0h,000h,003h,0ffh,087h,0ffh,000h,000h,01fh,0fch,03fh,0ffh,0f8h,000h,0ffh,0e1h,0ffh,0c0h,000h,000h
		db	000h,07fh,0f0h,000h,001h,0ffh,0c3h,0ffh,080h,000h,00fh,0feh,01fh,0ffh,0fch,000h,07fh,0f0h,0ffh,0e0h,000h,000h,000h,03fh,0f8h
		db	000h,000h,0ffh,0e1h,0ffh,0c0h,000h,007h,0ffh,00fh,0ffh,0feh,000h,03fh,0f8h,07fh,0f0h,000h,000h,000h,01fh,0fch,000h,000h,07fh
		db	0f0h,0ffh,0e0h,000h,003h,0ffh,087h,0ffh,0ffh,0e0h,01fh,0fch,03fh,0f8h,000h,000h,000h,00fh,0feh,000h,000h,03fh,0f8h,07fh,0f0h
		db	000h,001h,0ffh,0c3h,0ffh,0ffh,0f0h,00fh,0feh,01fh,0fch,000h,000h,000h,007h,0ffh,000h,000h,01fh,0fch,03fh,0f8h,000h,000h,0ffh
		db	0e1h,0ffh,0ffh,0f8h,007h,0ffh,00fh,0feh,000h,000h,000h,003h,0ffh,0ffh,0ffh,0ffh,0feh,01fh,0fch,000h,000h,07fh,0f0h,0ffh,0ffh
		db	0fch,003h,0ffh,087h,0ffh,000h,00fh,0ffh,0e1h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,0feh,000h,000h,03fh,0f8h,07fh,0ffh,0feh,001h,0ffh
		db	0c3h,0ffh,080h,007h,0ffh,0f0h,0ffh,0ffh,0ffh,0ffh,0ffh,087h,0ffh,000h,000h,01fh,0fch,03fh,0ffh,0ffh,000h,0ffh,0e1h,0ffh,0c0h
		db	003h,0ffh,0f8h,07fh,0ffh,0ffh,0ffh,0ffh,0c3h,0ffh,080h,000h,00fh,0feh,01fh,0ffh,0ffh,080h,07fh,0f0h,0ffh,0e0h,001h,0ffh,0fch
		db	03fh,0ffh,0ffh,0ffh,0ffh,0e1h,0ffh,0c0h,000h,007h,0ffh,00fh,0feh,01fh,0fch,03fh,0f8h,07fh,0f0h,000h,0ffh,0ffh,0ffh,0ffh,0ffh
		db	0ffh,0ffh,0f0h,0ffh,0e0h,000h,003h,0ffh,087h,0ffh,00fh,0feh,01fh,0fch,03fh,0f8h,000h,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h
		db	07fh,0f0h,000h,001h,0ffh,0c3h,0ffh,087h,0ffh,00fh,0feh,01fh,0fch,000h,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,03fh,0f8h,000h
		db	000h,0ffh,0e1h,0ffh,0c3h,0ffh,087h,0ffh,00fh,0feh,000h,01fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,01fh,0fch,000h,000h,07fh,0f0h
		db	0ffh,0e0h,01fh,0ffh,0ffh,087h,0ffh,000h,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,00fh,0feh,000h,000h,03fh,0f8h,07fh,0f0h,00fh
		db	0ffh,0ffh,0c3h,0ffh,080h,007h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,007h,0ffh,000h,000h,01fh,0fch,03fh,0f8h,007h,0ffh,0ffh,0e1h
		db	0ffh,0c0h,003h,0ffh,0ffh,0ffh,0f0h,000h,000h,000h,003h,0ffh,080h,000h,00fh,0feh,01fh,0fch,003h,0ffh,0ffh,0f0h,0ffh,0e0h,000h
		db	001h,0ffh,0ffh,0f8h,000h,000h,000h,001h,0ffh,0c0h,000h,007h,0ffh,00fh,0feh,001h,0ffh,0ffh,0f8h,07fh,0f0h,000h,000h,0ffh,0ffh
		db	0fch,000h,000h,000h,000h,0ffh,0e0h,000h,003h,0ffh,087h,0ffh,000h,0ffh,0ffh,0fch,03fh,0f8h,000h,000h,07fh,0ffh,0feh,000h,000h
		db	000h,000h,07fh,0f0h,000h,001h,0ffh,0c3h,0ffh,080h,07fh,0ffh,0feh,01fh,0fch,000h,000h,03fh,0ffh,0ffh,000h,000h,000h,000h,03fh
		db	0f8h,000h,000h,0ffh,0e1h,0ffh,0c0h,007h,0ffh,0ffh,00fh,0feh,000h,000h,01fh,0ffh,0ffh,080h,000h,000h,000h,01fh,0fch,000h,000h
		db	07fh,0f0h,0ffh,0e0h,003h,0ffh,0ffh,087h,0ffh,000h,000h,00fh,0ffh,0ffh,0c0h,000h,000h,000h,00fh,0feh,000h,000h,03fh,0f8h,07fh
		db	0f0h,001h,0ffh,0ffh,0c3h,0ffh,080h,000h,007h,0ffh,0ffh,0e0h,000h,000h,000h,007h,0ffh,000h,000h,01fh,0fch,03fh,0f8h,000h,0ffh
		db	0ffh,0e1h,0ffh,0c0h,000h,003h,0ffh,0ffh,0f0h,000h,000h,000h,003h,0ffh,080h,000h,00fh,0feh,01fh,0fch,000h,07fh,0ffh,0f0h,0ffh
		db	0e0h,000h,001h,0ffh,0ffh,0f8h,000h,000h,000h,001h,0ffh,0c0h,000h,007h,0ffh,00fh,0feh,000h,03fh,0ffh,0f8h,07fh,0f0h,000h,000h
		db	0ffh,0ffh,0fch,000h,000h,000h,000h,0ffh,0e0h,000h,003h,0ffh,087h,0ffh,000h,01fh,0ffh,0fch,03fh,0f8h,000h,000h,07fh,0ffh,0feh
		db	000h,000h,000h,000h,07fh,0f0h,000h,001h,0ffh,0c3h,0ffh,080h,00fh,0ffh,0feh,01fh,0fch,000h,000h,03fh,0ffh,0ffh,000h,000h,000h
		db	000h,03fh,0ffh,0ffh,0ffh,0ffh,0e1h,0ffh,0c0h,000h,07fh,0ffh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,000h,000h,000h,01fh,0ffh
		db	0ffh,0ffh,0ffh,0f0h,0ffh,0e0h,000h,03fh,0ffh,087h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,000h,000h,000h,00fh,0ffh,0ffh,0ffh,0ffh
		db	0f8h,07fh,0f0h,000h,01fh,0ffh,0c3h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,000h,000h,000h,007h,0ffh,0ffh,0ffh,0ffh,0fch,03fh,0f8h
		db	000h,00fh,0ffh,0e1h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,000h,000h,000h,003h,0ffh,0ffh,0ffh,0ffh,0feh,01fh,0fch,000h,007h,0ffh
		db	0f0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,000h,000h,000h,001h,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,0feh,000h,003h,0ffh,0f8h,07fh,0ffh
		db	0ffh,0ffh,0ffh,0ffh,0fch,000h,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,087h,0ffh,000h,001h,0ffh,0fch,03fh,0ffh,0ffh,0ffh,0ffh
		db	0ffh,0feh,000h,000h,000h,000h,007h,0ffh,0ffh,0ffh,0fch,003h,0ffh,080h,000h,00fh,0feh,001h,0ffh,0ffh,0ffh,0ffh,087h,0ffh,000h
		db	000h,000h,000h,003h,0ffh,0ffh,0ffh,0feh,001h,0ffh,0c0h,000h,007h,0ffh,000h,0ffh,0ffh,0ffh,0ffh,0c3h,0ffh,080h,000h,000h,000h
		db	001h,0ffh,0ffh,0ffh,0ffh,000h,0ffh,0e0h,000h,003h,0ffh,080h,07fh,0ffh,0ffh,0ffh,0e1h,0ffh,0c0h,000h,000h,000h,000h,0ffh,0ffh
		db	0ffh,0ffh,080h,07fh,0f0h,000h,001h,0ffh,0c0h,03fh,0ffh,0ffh,0ffh,0f0h
titlel	equ	$ - titlei				;length of the image
titlex	dw	320 / 2 - titlew / 2	;x
titley	dw	35						;y
titlew	equ	177						;width
titleh	equ	56						;height

;data for the image that specifies the name of the developer
title2i	db	0fch,0c6h,01fh,08fh,098h,0dbh,0f0h,063h,03eh,07eh,03eh,07eh,03eh,07fh,0b6h,03fh,0ech,061h,0fdh,0fdh,08dh,0bfh,086h,037h,0f7h
		db	0f7h,0f7h,0f7h,0f7h,0fbh,063h,0c6h,0c6h,018h,0d8h,0d8h,0dbh,018h,063h,063h,063h,063h,063h,063h,060h,036h,03fh,0efh,0e1h,08dh
		db	0fdh,08dh,0b1h,087h,0f7h,0f7h,0f7h,0f7h,0f7h,0f6h,073h,063h,0fch,07eh,018h,0dfh,0d8h,0dbh,018h,07fh,07fh,07eh,07fh,07eh,07fh
		db	067h,0b6h,03ch,060h,061h,08dh,08ch,0d9h,0b1h,086h,036h,036h,036h,036h,036h,036h,01bh,063h,0c6h,0c6h,018h,0d8h,0cdh,09bh,018h
		db	063h,063h,063h,063h,063h,063h,061h,0b6h,03fh,0efh,0e1h,0fdh,08ch,071h,0bfh,086h,036h,036h,036h,037h,0f6h,037h,0fbh,07fh,0fch
		db	07ch,01fh,098h,0c2h,01bh,0f0h,063h,063h,063h,063h,07eh,063h,03fh,033h,0e0h
title2l	equ	$ - title2i									;length of the image
title2x	dw	320 / 2 - titlew / 2 + titlew - title2w		;x
title2y	dw	35 + titleh + 5								;y
title2w	equ	124											;width
title2h	equ	9											;heigth

;data for the image that says "Press space to start"
title3i	db	0feh,07fh,01fh,0cfh,0c7h,0e0h,03fh,03fh,08fh,0c7h,0e3h,0f8h,03fh,0cfh,0c0h,07eh,07fh,09fh,09fh,0cfh,0ffh,0f7h,0fbh,0fdh,0feh
		db	0ffh,007h,0fbh,0fdh,0feh,0ffh,07fh,083h,0fdh,0feh,00fh,0f7h,0fbh,0fdh,0feh,0ffh,0c3h,061h,0b0h,018h,06ch,030h,061h,0b0h,0d8h
		db	06ch,036h,000h,006h,018h,060h,0c3h,00ch,030h,0d8h,061h,08ch,036h,01bh,001h,080h,0c0h,006h,003h,00dh,086h,0c0h,060h,000h,061h
		db	086h,00ch,000h,0c3h,00dh,086h,018h,0ffh,07fh,0bfh,01fh,0cfh,0e0h,07fh,03fh,0dfh,0ech,007h,0e0h,006h,018h,060h,0feh,00ch,03fh
		db	0dfh,0e1h,08fh,0e7h,0f3h,0f0h,0feh,07fh,003h,0fbh,0f9h,0feh,0c0h,07eh,000h,061h,086h,007h,0f0h,0c3h,0fdh,0fch,018h,0c0h,061h
		db	0b0h,000h,060h,030h,001h,0b0h,018h,06ch,006h,000h,006h,018h,060h,003h,00ch,030h,0d8h,061h,08ch,006h,01bh,000h,006h,003h,000h
		db	01bh,001h,086h,0c0h,060h,000h,061h,086h,000h,030h,0c3h,00dh,086h,018h,0c0h,061h,0b0h,018h,06ch,030h,061h,0b0h,018h,06ch,036h
		db	000h,006h,018h,060h,0c3h,00ch,030h,0d8h,061h,08ch,006h,01bh,0fdh,0feh,0ffh,007h,0fbh,001h,086h,0ffh,07fh,080h,061h,0feh,00fh
		db	0f0h,0c3h,00dh,086h,018h,0c0h,061h,09fh,0cfh,0c7h,0e0h,03fh,030h,018h,067h,0e3h,0f8h,006h,00fh,0c0h,07eh,00ch,030h,0d8h,061h, 080h
title3l	equ	$ - title3i									;length of the image
title3x	dw	320 / 2 - title3w / 2						;x
title3y	dw	150											;y
title3w	equ	164											;width
title3h	equ	11											;heigth
tblinks	db	1											;blink state (on - 1 / off - 0) for the image
tblinkt	dw	0											;time of the last blink state change

;data for the image that says "Player"
title4i	db	0ffh,0ffh,0e1h,0f8h,000h,000h,0ffh,0ffh,087h,0e0h,00fh,0c3h,0ffh,0ffh,09fh,0ffh,0fch,0ffh,0ffh,0e1h,0f8h,000h,000h,0ffh,0ffh
		db	087h,0e0h,00fh,0c3h,0ffh,0ffh,09fh,0ffh,0fch,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0e0h,00fh,0cfh,0ffh,0ffh,09fh,0ffh
		db	0ffh,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0e0h,00fh,0cfh,0ffh,0ffh,09fh,0ffh,0ffh,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh
		db	0ffh,0e7h,0e0h,00fh,0cfh,0ffh,0ffh,09fh,0ffh,0ffh,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0e0h,00fh,0cfh,0ffh,0ffh,09fh
		db	0ffh,0ffh,0fch,001h,0f9h,0f8h,000h,003h,0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,001h,0f9h,0f8h,000h,003h
		db	0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,001h,0f9h,0f8h,000h,003h,0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h
		db	01fh,080h,03fh,0fch,001h,0f9h,0f8h,000h,003h,0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,001h,0f9h,0f8h,000h
		db	003h,0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0ffh,0ffh,0cfh,0ffh
		db	0e0h,01fh,0ffh,0ffh,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0ffh,0ffh,0cfh,0ffh,0e0h,01fh,0ffh,0ffh,0ffh,0ffh,0f9h,0f8h
		db	000h,003h,0ffh,0ffh,0e7h,0ffh,0ffh,0cfh,0ffh,0e0h,01fh,0ffh,0fch,0ffh,0ffh,0f9h,0f8h,000h,003h,0ffh,0ffh,0e7h,0ffh,0ffh,0cfh
		db	0ffh,0e0h,01fh,0ffh,0fch,0ffh,0ffh,0e1h,0f8h,000h,003h,0ffh,0ffh,0e1h,0ffh,0ffh,0cfh,0ffh,0e0h,01fh,0ffh,0ffh,0ffh,0ffh,0e1h
		db	0f8h,000h,003h,0ffh,0ffh,0e1h,0ffh,0ffh,0cfh,0ffh,0e0h,01fh,0ffh,0ffh,0fch,000h,001h,0f8h,000h,003h,0f0h,007h,0e0h,000h,00fh
		db	0cfh,0c0h,000h,01fh,080h,03fh,0fch,000h,001h,0f8h,000h,003h,0f0h,007h,0e0h,000h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,000h
		db	001h,0f8h,000h,003h,0f0h,007h,0e0h,000h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,000h,001h,0f8h,000h,003h,0f0h,007h,0e7h,0e0h
		db	00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch,000h,001h,0f8h,000h,003h,0f0h,007h,0e7h,0e0h,00fh,0cfh,0c0h,000h,01fh,080h,03fh,0fch
		db	000h,001h,0ffh,0ffh,0f3h,0f0h,007h,0e7h,0ffh,0ffh,0cfh,0ffh,0ffh,09fh,080h,03fh,0fch,000h,001h,0ffh,0ffh,0f3h,0f0h,007h,0e7h
		db	0ffh,0ffh,0cfh,0ffh,0ffh,09fh,080h,03fh,0fch,000h,001h,0ffh,0ffh,0f3h,0f0h,007h,0e7h,0ffh,0ffh,0cfh,0ffh,0ffh,09fh,080h,03fh
		db	0fch,000h,001h,0ffh,0ffh,0f3h,0f0h,007h,0e7h,0ffh,0ffh,0cfh,0ffh,0ffh,09fh,080h,03fh,0fch,000h,000h,07fh,0ffh,0f3h,0f0h,007h
		db	0e1h,0ffh,0ffh,003h,0ffh,0ffh,09fh,080h,03fh,0fch,000h,000h,07fh,0ffh,0f3h,0f0h,007h,0e1h,0ffh,0ffh,003h,0ffh,0ffh,09fh,080h, 03fh
title4l	equ	$ - title4i											;length of the image
title4w	equ	136													;width
title4h	equ	28													;heigth
title4x	dw	320 / 2 - (title4w + title6w + title7w + 20) / 2	;x
title4y	dw	200 / 2 - (title4h + title8h + 20) / 2				;y

;data for the image that says "1"
title5i	db	0ffh,0cfh,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h
		db	0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh,003h,0f0h,03fh
title5l	equ	$ - title5i															;length of the image
title5w	equ	12																	;width
title5h	equ	28																	;heigth
title5x	dw	320 / 2 - (title4w + title6w + title7w + 20) / 2 + title4w + 14		;x
title5y	dw	200 / 2 - (title4h + title8h + 20) / 2								;y

;data for the image that says "2"
title6i	db	0ffh,0ffh,0e7h,0ffh,0ffh,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,000h,007h,0e0h,000h,03fh,000h,001h,0f8h,000h
		db	00fh,0c0h,000h,07eh,07fh,0ffh,0f3h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0fch,0ffh,0ffh,0e7h,0e0h,000h,03fh,000h,001h
		db	0f8h,000h,00fh,0c0h,000h,07eh,000h,003h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h
title6l	equ	$ - title6i															;length of the image
title6w	equ	21																	;width
title6h	equ	28																	;heigth
title6x	dw	320 / 2 - (title4w + title6w + title7w + 20) / 2 + title4w + 10		;x
title6y	dw	200 / 2 - (title4h + title8h + 20) / 2								;y

;data for the image that says "wins"
title7i	db	0fch,000h,01fh,09fh,09fh,080h,03fh,00fh,0ffh,0f9h,0f8h,000h,03fh,03fh,03fh,000h,07eh,01fh,0ffh,0f3h,0f0h,000h,07eh,07eh,07fh
		db	080h,0fch,0ffh,0ffh,0ffh,0e0h,000h,0fch,0fch,0ffh,001h,0f9h,0ffh,0ffh,0ffh,0c0h,001h,0f9h,0f9h,0feh,003h,0f3h,0ffh,0ffh,0ffh
		db	080h,003h,0f3h,0f3h,0fch,007h,0e7h,0ffh,0ffh,0ffh,000h,007h,0e7h,0e7h,0feh,00fh,0cfh,0c0h,01fh,0feh,00ch,00fh,0cfh,0cfh,0fch
		db	01fh,09fh,080h,03fh,0fch,018h,01fh,09fh,09fh,0f8h,03fh,03fh,000h,001h,0f8h,0fch,03fh,03fh,03fh,0f8h,07eh,07eh,000h,003h,0f1h
		db	0f8h,07eh,07eh,07fh,0f0h,0fch,0fch,000h,007h,0e3h,0f0h,0fch,0fch,0ffh,0e1h,0f9h,0ffh,0ffh,0cfh,0c7h,0e1h,0f9h,0f9h,0ffh,0c3h
		db	0f3h,0ffh,0ffh,09fh,09fh,0f3h,0f3h,0f3h,0f3h,0e7h,0e7h,0ffh,0ffh,0ffh,03fh,0e7h,0e7h,0e7h,0e7h,0cfh,0cfh,0ffh,0ffh,0ffh,0f3h
		db	0ffh,0cfh,0cfh,0c3h,0ffh,087h,0ffh,0ffh,0ffh,0e7h,0ffh,09fh,09fh,087h,0ffh,00fh,0ffh,0ffh,0ffh,0cfh,0ffh,03fh,03fh,00fh,0feh
		db	000h,000h,0ffh,0ffh,09fh,0feh,07eh,07eh,01fh,0fch,000h,001h,0ffh,0fch,00fh,0fch,0fch,0fch,01fh,0f8h,000h,003h,0ffh,0f8h,01fh
		db	0f9h,0f9h,0f8h,03fh,0f3h,0f0h,007h,0ffh,0f0h,03fh,0f3h,0f3h,0f0h,07fh,0e7h,0e0h,00fh,0ffh,0c0h,01fh,0e7h,0e7h,0e0h,03fh,0cfh
		db	0ffh,0ffh,0ffh,080h,03fh,0cfh,0cfh,0c0h,07fh,09fh,0ffh,0ffh,0ffh,000h,07fh,09fh,09fh,080h,0ffh,03fh,0ffh,0ffh,0feh,000h,0ffh
		db	03fh,03fh,001h,0feh,07fh,0ffh,0ffh,0f0h,000h,07eh,07eh,07eh,000h,0fch,03fh,0ffh,0e7h,0e0h,000h,0fch,0fch,0fch,001h,0f8h,07fh
		db	0ffh,0c0h
title7l	equ	$ - title7i																	;length of the image
title7w	equ	79																			;width
title7h	equ	28																			;heigth
title7x	dw	320 / 2 - (title4w + title6w + title7w + 20) / 2 + title4w + title6w + 20	;x
title7y	dw	200 / 2 - (title4h + title8h + 20) / 2										;y

;data for the image that says "Press space to restart"
title8i	db	0ffh,0e7h,0ffh,01fh,0fch,0ffh,0c7h,0feh,001h,0ffh,09fh,0fch,07fh,0e3h,0ffh,01fh,0fch,00fh,0feh,03fh,0f0h,01fh,0fch,07fh,0f3h
		db	0ffh,03fh,0f8h,0ffh,0cfh,0feh,07fh,0ffh,0ffh,07fh,0fbh,0ffh,0dfh,0feh,0ffh,0f0h,03fh,0fdh,0ffh,0efh,0ffh,07fh,0fbh,0ffh,0c0h
		db	0ffh,0e7h,0ffh,081h,0ffh,0efh,0ffh,07fh,0fbh,0ffh,09fh,0feh,0ffh,0f7h,0ffh,0ffh,0f7h,0ffh,0bfh,0fdh,0ffh,0efh,0ffh,003h,0ffh
		db	0dfh,0feh,0ffh,0f7h,0ffh,0bfh,0fch,00fh,0feh,07fh,0f8h,01fh,0feh,0ffh,0f7h,0ffh,0bfh,0f9h,0ffh,0efh,0ffh,07fh,0feh,007h,070h
		db	03bh,080h,01ch,00eh,0e0h,070h,038h,01dh,0c0h,0eeh,007h,070h,03bh,080h,000h,00eh,007h,003h,081h,0c0h,0eeh,000h,070h,038h,038h
		db	01ch,00eh,0e0h,070h,070h,0e0h,077h,003h,0b8h,001h,0c0h,00eh,000h,003h,080h,01ch,00eh,0e0h,077h,000h,038h,000h,000h,0e0h,070h
		db	038h,01ch,00eh,0e0h,007h,000h,003h,081h,0c0h,0eeh,007h,007h,00eh,007h,070h,03bh,080h,01ch,000h,0e0h,000h,038h,001h,0c0h,0eeh
		db	007h,070h,003h,080h,000h,00eh,007h,003h,081h,0c0h,0eeh,000h,070h,000h,038h,01ch,00eh,0e0h,070h,070h,0e0h,077h,003h,0b8h,001h
		db	0c0h,00eh,000h,003h,080h,01ch,00eh,0e0h,077h,000h,038h,000h,000h,0e0h,070h,038h,01ch,00eh,0e0h,007h,000h,003h,081h,0c0h,0eeh
		db	007h,007h,00fh,0ffh,07fh,0f3h,0fch,01fh,0fch,0ffh,0e0h,03fh,0f9h,0ffh,0efh,0ffh,070h,003h,0fch,000h,00eh,007h,003h,081h,0ffh
		db	0cfh,0f0h,07fh,0f0h,038h,01fh,0feh,0ffh,0e0h,070h,0ffh,0f7h,0ffh,03fh,0c1h,0ffh,0efh,0ffh,003h,0ffh,0dfh,0feh,0ffh,0f7h,000h
		db	03fh,0c0h,000h,0e0h,070h,038h,01fh,0fch,0ffh,007h,0ffh,083h,081h,0ffh,0efh,0feh,007h,00fh,0feh,07fh,0fbh,0fch,00fh,0feh,07fh
		db	0f0h,01fh,0fdh,0ffh,0cfh,0ffh,070h,003h,0fch,000h,00eh,007h,003h,081h,0ffh,0efh,0f0h,03fh,0f8h,038h,01fh,0feh,0ffh,0f0h,070h
		db	0e0h,007h,003h,0b8h,000h,000h,0e0h,007h,000h,001h,0dch,000h,0e0h,077h,000h,038h,000h,000h,0e0h,070h,038h,01ch,00eh,0e0h,000h
		db	003h,083h,081h,0c0h,0eeh,007h,007h,00eh,000h,070h,03bh,080h,000h,00eh,000h,070h,000h,01dh,0c0h,00eh,007h,070h,003h,080h,000h
		db	00eh,007h,003h,081h,0c0h,0eeh,000h,000h,038h,038h,01ch,00eh,0e0h,070h,070h,0e0h,007h,003h,0b8h,001h,0c0h,0eeh,007h,003h,081h
		db	0dch,000h,0e0h,077h,003h,0b8h,000h,000h,0e0h,070h,038h,01ch,00eh,0e0h,007h,003h,083h,081h,0c0h,0eeh,007h,007h,00eh,000h,070h
		db	03bh,0ffh,0dfh,0feh,0ffh,0f0h,03fh,0fdh,0c0h,00eh,007h,07fh,0fbh,0ffh,0c0h,00eh,007h,0ffh,081h,0c0h,0efh,0ffh,07fh,0f8h,038h
		db	01ch,00eh,0e0h,070h,070h,0e0h,007h,003h,0bfh,0fdh,0ffh,0efh,0ffh,003h,0ffh,0dch,000h,0e0h,077h,0ffh,0bfh,0fch,000h,0e0h,07fh
		db	0f8h,01ch,00eh,0ffh,0f7h,0ffh,083h,081h,0c0h,0eeh,007h,007h,00eh,000h,070h,039h,0ffh,0cfh,0fch,07fh,0e0h,01fh,0f9h,0c0h,00eh
		db	007h,03fh,0f1h,0ffh,0c0h,00eh,003h,0ffh,001h,0c0h,0e7h,0ffh,03fh,0f0h,038h,01ch,00eh,0e0h,070h,070h
title8l	equ	$ - title8i												;length of the image
title8w	equ	260														;width
title8h	equ	16														;heigth
title8x	dw	320 / 2 - title8w / 2									;x
title8y	dw	200 / 2 - (title4h + title8h + 20) / 2 + title4h + 20	;y

data	ends

drawm	macro ox, oy, ow, oh, oi, ol
		local imgcopy
;draw object on screen macro
;copies the data of the object in objx, objy, objw, objh, obji, obj then calls the draw procedure
;ox, oy = position of the object on screen (words)
;ow, oh = dimensions of the object (constants)
;oi = array of bytes defining the image to draw
;ol = length of oi (constant)
	;copy the x coordinate
	mov		ax, ox
	mov		objx, ax
	;copy the y coordinate
	mov		ax, oy
	mov		objy, ax
	;copy the width
	mov		objw, ow
	;copy the heigth
	mov		objh, oh
	;copy the length of the image
	mov		objl, ol
	;set some auxiliary parameters for the procedure
	mov		objaux1, 8 - ((ol * 8) - (ow * oh))
	mov		objaux2, (ol * 8) - (ow * oh)
	;copy the image address
	lea		bx, oi
	mov		obji, bx
	
	call	drawobj		;call the drawobject procedure
endm

code	segment para public 'code' use16
	assume cs:code, ds:data, es:data, fs:data, ss:stck

start:
	mov		ax, data
	mov		ds, ax			;initialize data segment
	mov		ax, 13h
	int		10h				;set video mode to 13h
	mov		ax, 0a000h		;initialize extra segment
	mov		es, ax			;the pixels that are stored here are drawn on screen automatically in video mode 13h
	mov		ax, 0b000h		;initialize a second extra segment, used to store the frame while it is prepared
	mov		fs, ax			;the frame is first built here, then copied in es (double buffering)
							;this is done to avoid flickering
gameloop:
	call	getkb			;read from the keyboard
							;needs to be called as many times as possible (multiple times for every frame) to be able to read multiple keys at a time

	mov		ah, 0
	int		1ah				;get system time
	cmp		dx, prevt		;check if enough time has passed since the last update
	jz		gameloop		;if there is no change, wait more
	mov		prevt, dx		;update prevt

	call	clrscr			;clear screen
	
	cmp		byte ptr[kbdbuf + 1], 1		;check if ESC is pressed
	je		exitgame					;exit game
	
update:
	;add game logic here
	
colortest:
	cmp		byte ptr[kbdbuf + 2eh], 1	;check if C is pressed
	jnz		testgamestate
	inc		ccolori						;change the color
	cmp		ccolori, colorsl
	jb		applynewcolor
	mov		ccolori, 0
applynewcolor:
	mov		al, ccolori
	lea		bx, colors
	xlat
	mov		ccolor, al
	
testgamestate:
	cmp		gstate, 0
	jz		updatetitle					;the game state is 0 (title screen)
	cmp		gstate, 2
	jz		updatewinscr				;the game state is 2 (winner screen)

testpad1:
	cmp		byte ptr[kbdbuf + 11h], 1	;check if W is pressed
	jz		movepad1up					;move left paddle up
	cmp		byte ptr[kbdbuf + 1fh], 1	;check if S is pressed
	jz		movepad1down				;move left paddle down
	jmp		testpad2
movepad1up:
	mov		ax, pad1y
	sub		ax, pads
	jc		testpad2					;abort if the paddle would move out of the screen
	mov		pad1y, ax					;apply changes
	jmp		testpad2					;go to next test
movepad1down:
	mov		ax, pad1y
	add		ax, pads
	cmp		ax, 200 - padh				;abort if the paddle would move out of the screen
	ja		testpad2
	mov		pad1y, ax					;apply changes
testpad2:
	cmp		byte ptr[kbdbuf + 48h], 1	;check if up arrow is pressed
	jz		movepad2up					;move right paddle up
	cmp		byte ptr[kbdbuf + 50h], 1	;check if down arrow is pressed
	jz		movepad2down				;move right paddle down
	jmp		ballmovement				;skip to ball movement logic
movepad2up:
	mov		ax, pad2y
	sub		ax, pads
	jc		ballmovement				;abort if the paddle would move out of the screen
	mov		pad2y, ax					;apply changes
	jmp		ballmovement				;skip to ball movement logic
movepad2down:
	mov		ax, pad2y
	add		ax, pads
	cmp		ax, 200 - padh				;abort if the paddle would move out of the screen
	ja		ballmovement
	mov		pad2y, ax					;apply changes
	
ballmovement:
	mov		ax, ballx
	mov		dx, bally
	add		ax, ballvx
	add		dx, ballvy					;calculate the new ball position
	js		reflectbally				;the next ball position is out of the screen (y < 0)
	cmp		dx, 200 - ballh
	ja		reflectbally				;the next ball position is out of the screen (y > screen height)
	jmp		collisiontest1				;skip to collision test (ball with paddles)
reflectbally:
	neg		ballvy						;reflect ball
	mov		dx, bally
	add		dx, ballvy					;calculate new position
collisiontest1:						;collision test with paddle 1
	mov		bx, pad1x
	add		bx, padw
	cmp		ax, bx					;paddle1 test1
	jg		collisiontest2			;test failed
	mov		bx, ax
	add		bx, ballw
	cmp		pad1x, bx				;paddle1 test2
	jg		collisiontest2			;test failed
	mov		bx, dx
	add		bx, ballh
	cmp		pad1y, bx				;paddle1 test3
	jg		collisiontest2			;test failed
	mov		bx, pad1y
	add		bx, padh
	cmp		dx, bx					;paddle1 test4
	jg		collisiontest2			;test failed
	jmp		reflectballx			;all tests passed, reflect ball
collisiontest2:						;collision test with paddle 2
	mov		bx, pad2x
	add		bx, padw
	cmp		ax, bx					;paddle2 test1
	jg		applyballmovement		;test failed
	mov		bx, ax
	add		bx, ballw
	cmp		pad2x, bx				;paddle2 test2
	jg		applyballmovement		;test failed
	mov		bx, dx
	add		bx, ballh
	cmp		pad2y, bx				;paddle2 test3
	jg		applyballmovement		;test failed
	mov		bx, pad2y
	add		bx, padh
	cmp		dx, bx					;paddle2 test4
	jg		applyballmovement		;test failed
reflectballx:						;all tests passed, reflect ball
	neg		ballvx					;reflect
	mov		ax, ballx				;calculate new position
	add		ax, ballvx
applyballmovement:
	mov		ballx, ax				;apply changes
	mov		bally, dx
	
	cmp		ballx, 0				;check if player 2 scores
	js		player2score
	cmp		ballx, 320 - ballw		;check if player 1 scores
	ja		player1score
	jmp		draw					;go to draw
	
player1score:
	inc		score1
	cmp		score1, 10				;winning condition for player 1
	jz		player1wins
	jmp		reset
player2score:
	inc		score2
	cmp		score2, 10				;winning condition for player 2
	jz		player2wins
reset:
	call	resetball				;if either player scores, the ball is reset

	jmp		draw
	
player1wins:
	mov		winner, 1
	mov		gstate, 2				;player 1 wins
	jmp		gameloop

player2wins:
	mov		winner, 2
	mov		gstate, 2				;player 2 wins
	jmp		gameloop
	
updatetitle:							;game state is 0 (title screen)
	cmp		byte ptr[kbdbuf + 39h], 1	;check if SPACE is pressed
	jz		startgame					;start game
	jmp		drawtitle					;go to draw
	
startgame:
	mov		score1, 0					;initialize score
	mov		score2, 0
	call	resetball					;initialize ball
	mov		ballvx, balls
	mov		ballvy, balls
	mov		gstate, 1					;set game state to 1 (in game)
	jmp		gameloop
	
updatewinscr:							;game state is 2 (winner screen)
	cmp		byte ptr[kbdbuf + 39h], 1	;check if SPACE is pressed
	jz		startgame					;start game
	jmp		drawwinscr					;go to draw
	
draw:													;game state is 1 (in game)
	;draw game objects here
	
	drawm	ballx, bally, ballw, ballh, balli, balll	;draw ball
	drawm	pad1x, pad1y, padw, padh, padi, padl		;draw left paddle
	drawm	pad2x, pad2y, padw, padh, padi, padl		;draw right paddle
	
	lea		bx, num0									;get the address of the image of the number for the score of player 1
	mov		ax, numl
	mul		score1
	add		bx, ax
	drawm	num1x, num1y, numw, numh, [bx], numl		;draw score for player 1
	
	lea		bx, num0									;get the address of the image of the number for the score of player 2
	mov		ax, numl
	mul		score2
	add		bx, ax
	drawm	num2x, num2y, numw, numh, [bx], numl		;draw score for player 2
	
	drawm	sepx, sepy, sepw, seph, sepi, sepl			;draw separator
	
	jmp		applydraw
	
drawtitle:															;game state is 0 (title screen)
	drawm	titlex, titley, titlew, titleh, titlei, titlel			;draw "Pong" text
	drawm	title2x, title2y, title2w, title2h, title2i, title2l	;draw the developer name text
	
	;draw "Press space to start" text
	mov		ah, 0
	int		1ah				;get system time
	push	dx
	sub		dx, tblinkt
	cmp		dx, 10			;check if enough time has passed since the last blink state changed
	pop		dx
	jb		nswitchblink	;not enough time has passed
	xor		tblinks, 1		;switch blink state
	mov		tblinkt, dx		;update tblinkt
nswitchblink:
	cmp		tblinks, 0		;check the blink state
	jz		blinkoff
	drawm	title3x, title3y, title3w, title3h, title3i, title3l	;on
blinkoff:					;off
	jmp		applydraw
	
drawwinscr:					;game state is 2 (winner screen)
	drawm	title4x, title4y, title4w, title4h, title4i, title4l	;draw "Player" text
	drawm	title7x, title7y, title7w, title7h, title7i, title7l	;draw "wins" text
	drawm	title8x, title8y, title8w, title8h, title8i, title8l	;draw "Press space to restart" text
	cmp		winner, 2												;check which is the winner
	jz		draw2
	drawm	title5x, title5y, title5w, title5h, title5i, title5l	;draw "1" text
	jmp		applydraw
draw2:
	drawm	title6x, title6y, title6w, title6h, title6i, title6l	;draw "2" text
	jmp		applydraw
	
applydraw:
	call	drawframe		;draw the frame on screen
	jmp		gameloop
	
exitgame:
	mov		ax, 3
	int		10h							;set video mode back to normal
	mov		ah, 4ch
	int		21h							;return to os

putpixel	proc near
	;proceure to set a pixel
	;ax = Y coord
	;bx = X coord
	;dl = color
	push	cx
	push	dx				;save dx before it is altered by the multiplication
	mov		cx, 320			;get the address of pixel
	mul		cx
	add		ax, bx
	mov		di, ax
	pop		dx				;restore dx
	mov		[fs:di], dl		;set the pixel in the frame to be drawn
putpixelret:
	pop		cx
	ret
putpixel	endp

drawframe	proc near
	;procedure to move the frame from fs to es so that is displayed on screen
	mov		cx, 0fa00h
	mov		di, 0
drawframeloop:
	mov		ax, [fs:di]
	mov		[es:di], ax
	inc		di
	loop	drawframeloop
	ret
drawframe	endp

clrscr		proc near
	;set all pixels to black
	mov		cx, 0fa00h
	mov		di, 0
	mov		dl, 0
clrscrloop:
	mov		[fs:di], dl
	inc		di
	loop	clrscrloop
	ret
clrscr		endp

getkb		proc near
	;update keyboard state
    in      al, 60h 			;read keyboard scan code
	xor     bh, bh
    mov     bl, al
    and     bl, 7Fh				;get bits (6-0) representing the keyboard code
    shr     al, 7				;bit 7 represents the key state (0 - pressed, 1 - released)
    xor     al, 1               ;al = 1 if pressed, 0 if released
    mov     [bx+kbdbuf], al
	ret
getkb		endp

drawobj		proc near
	;draw object procedure
	mov		si, objl
	dec		si
	mov		cl, objaux2				;objaux2 = the number of bits that are unused in the last byte of the image
	mov		bx, obji
	mov		al, [bx + si]
	shr		al, cl					;shift the unused bits
	mov		dh, objaux1				;objaux1 = the number of bits that are used in the last byte of the image
	mov		cx, objh
	mov		dl, ccolor
nexty:
	push	cx
	mov		cx, objw
nextx:
	shr		al, 1					;get a bit from the image in CF
	jnc		nextpixel				;if the bit is 1, draw the pixel
	mov		bx, sp					;calculate the coordinates of the pixel
	push	ax
	mov		ax, ss:[bx]
	dec		ax
	add		ax, objy
	mov		bx, cx
	dec		bx
	add		bx, objx
	call	putpixel				;draw the pixel
	pop		ax
nextpixel:
	dec		dh
	or		dh, dh
	jnz		nextpixel2				;all the bits have been shifted, move to the next byte
	mov		dh, 8
	dec		si
	mov		bx, obji
	mov		al, [bx + si]
nextpixel2:
	loop	nextx
	pop		cx
	loop	nexty
	ret
drawobj		endp

resetball	proc near
	mov		ballx, 158		;set the ball on the center (x coordinate)
	mov		bx, 180			
	call	rand
	add		dx, 10			;get a random number between in the range 10 - 189
	mov		bally, dx		;set the y to that random number
	neg		ballvx			;change the ball direction
	ret
resetball	endp

rand		proc near
	;generate random number in randge 0 - (bx-1)
	;restult in dx
	mov		ah, 0
	int		1ah			;get system time
	mov		ax, dx
	xor		dx, dx
	div		bx
	ret
rand		endp
	
code	ends
end		start