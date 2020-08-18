// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
@2	
M=0 // Set result RAM to 0

@0
D=M
@FINAL
D;JEQ	// If one of values is zero then answer is zero

@1
D=M
@FINAL
D;JEQ	// If one of values is zero then answer is zero

(LOOP)
@1	
D=M	//put 2nd value to D-register

@2	
M=D+M	//add 2nd value to result (RAM[2])

@0
M=M-1	//reduce 1st value by 1
D=M

@LOOP   // if first value >0 then go to loop
D;JGT   

(FINAL)
@FINAL
0;JMP	//endless loop
