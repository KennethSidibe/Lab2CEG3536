;----------------------------------------------------------------------
; File: Keypad.asm
; Author:

; Description:
;  This contains the code for reading the
;  16-key keypad attached to Port A
;  See the schematic of the connection in the
;  design document.
;
;  The following subroutines are provided by the module
;
; char pollReadKey(): to poll keypad for a keypress
;                 Checks keypad for 2 ms for a keypress, and
;                 returns NOKEY if no keypress is found, otherwise
;                 the value returned will correspond to the
;                 ASCII code for the key, i.e. 0-9, *, # and A-D
; void initkey(): Initialises Port A for the keypad
;
; char readKey(): to read the key on the keypad
;                 The value returned will correspond to the
;                 ASCII code for the key, i.e. 0-9, *, # and A-D
;---------------------------------------------------------------------

; Include header files
 include "sections.inc"
 include "reg9s12.inc"  ; Defines EQU's for Peripheral Ports

**************EQUATES**********


;-----Conversion table
NUMKEYS		EQU	16	; Number of keys on the keypad
BADCODE 	EQU	$FF 	; returned of translation is unsuccessful
NOKEY		EQU $00   ; No key pressed during poll period
POLLCOUNT	EQU	1     ; Number of loops to create 1 ms poll time

 SWITCH globalConst  ; Constant data



 SWITCH code_section  ; place in code section
;-----------------------------------------------------------	
; Subroutine: initKeyPad
;
; Description: 
; 	Initiliases PORT A
;-----------------------------------------------------------	
initKeyPad:
	rts

;-----------------------------------------------------------    
; Subroutine: ch <- pollReadKey
; Parameters: none
; Local variable:
; Returns
;       ch: NOKEY when no key pressed,
;       otherwise, ASCII Code in accumulator B

; Description:
;  Loops for a period of 2ms, checking to see if
;  key is pressed. Calls readKey to read key if keypress 
;  detected (and debounced) on Port A and get ASCII code for
;  key pressed.
;-----------------------------------------------------------
; Stack Usage
	OFFSET 0  ; to setup offset into stack

pollReadKey: 

   rts

;-----------------------------------------------------------	
; Subroutine: ch <- readKey
; Arguments: none
; Local variable: 
;	ch - ASCII Code in accumulator B

; Description:
;  Main subroutine that reads a code from the
;  keyboard using the subroutine readKeybrd.  The
;  code is then translated with the subroutine
;  translate to get the corresponding ASCII code.
;-----------------------------------------------------------	
; Stack Usage
	OFFSET 0  ; to setup offset into stack

readKey:

    rts		           ;  return(ch); 

;-----------------------------------------------------------
; Subroutine: ch <- translate
; Parameters: BYTE
; Returns
;       ch: the character representing the byte code
;
; Description:
; returns the character represented by the byte code provided 
;-----------------------------------------------------------
; Stack Usage

translate:

	convTable: SECTION	; table holding the representing char for the byte code
	key_code_address 	EQU $1000
	charac_address	 	EQU $2000

	org key_code_address
	keyCode DC.B 11101110, 11101101, 11101011, 11100111, 11011110, 11011101, 11011011, 11010111, 10111110, 10111101, 10111011, 10110111, 01111110, 01111101, 01111011, 01110111
	
	org charac_address
	charac	DC.B      '1',       '2',       '3',       'A',             '4',       '5',       '6',     'B',     '7',     '8',       '9',       'C',       '*',    '0',       '#',       'D'
	; keyCode are the byte code that should represent the characters  
	; charac are the actual characters 

	i SET 0
	
	; WHILE i < COUNT
	WHILE_START:
		ldaa NUMKEYS ; Load count in acc a
		cmpa i ; A - i
		ble END_WHILE ; end the loop if count - i <= 0
	; DO

	; Load the ith element in accummulator B
	ldab i ; load i in B
	ldx #key_code_address ; load adress 0 of keyCode adress arr
	abx ; X = B + X (avec B = i), that is the adress of the ith element 
	ldab 0, X ;  load ith elem of arr keyCodeAdress in acc B

	;Compare if the code is the same with the params provided 

	; TODO

	; end_do

	END_WHILE:
	;end_while we found the corresponding character or they provided byte is not considered 

	rts   	; returns the character 


