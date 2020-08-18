// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.
(RESET) // Restart tag
@SCREEN
D=A
@R0
M=D	//Screen start location to ram0

//
(KEYBOARDCHECK)

@KBD
D=M
// if any key is pressed go to black
@BLACK
D;JGT
// else goto white
@WHITE
D;JEQ	

@KEYBOARDCHECK
0;JMP
//
(BLACK)
@1
M=-1	//Setting black color (-1=11111111111111)
@CHANGE
0;JMP

(WHITE)
@1
M=0	//Setting white color
@CHANGE
0;JMP
//
(CHANGE)
@1
D=M // Put color into D-register	

@0
A=M	//Get first screen address from RAM0
M=D	//Fill screen with color from D-register

@0
D=M+1	//Increment screen pixel
@KBD
D=A-D

@R0
M=M+1	//Increment screen pixel
A=M

@CHANGE
D;JGT

@RESET // Cycle to beginning of a program
0;JMP
