from sys import argv
from parser import Parser

class CodeWriter:


    def __init__(self, path):
        self.parser = Parser(path)
        self.outputFileName = path[:len(path)-3] + '.asm'
        self.f= open(self.outputFileName, 'w')
        self.counter = 0
    
    def translatePushPop(self):
        """ Translates push and pop commands and writes
        it to file"""
        
        # Get segment and value from command
        segment = self.parser.commandParts[1]
        value = self.parser.commandParts[2]

        # Write initial command in comment with // in the beginning
        self.f.write('// {}\n'.format(self.parser.command))
        
        # Translate push command
        if self.parser.commandType() == 'C_PUSH':
            if segment == 'constant':
                # Put value from command value argument to D
                self.value_to_D()
            elif segment in ['temp', 'pointer', 'local', 'argument', 'this', 'that']:
                # Put value from command value argument to D
                self.value_to_D()
                if segment == 'temp':
                    self.f.write('@5\n')
                    self.f.write('A=D+A\n')
                elif segment == 'pointer':
                    self.f.write('@3\n')
                    self.f.write('A=D+A\n')
                elif segment == 'local':
                    self.f.write('@LCL\n')
                    self.f.write('A=D+M\n')
                elif segment == 'argument':
                    self.f.write('@ARG\n')
                    self.f.write('A=D+M\n')
                elif segment == 'this':
                    self.f.write('@THIS\n')
                    self.f.write('A=D+M\n')
                elif segment == 'that':
                    self.f.write('@THAT\n')
                    self.f.write('A=D+M\n')
                else:
                    pass
                self.f.write('D=M\n')
            else:
                raise ValueError('Segment type not supported')
            # Write value from D to Stack
            self.put_D_to_stack()
            # Increment stack pointer
            self.increment_SP()
        
        # Translate pop command
        if self.parser.commandType() == 'C_POP':
            if segment in ['temp', 'pointer', 'local', 'argument', 'this', 'that']:
                # Put value from command value argument to D
                self.value_to_D()
                # Get address of register cell 
                if segment == 'temp':
                    self.f.write('@5\n')
                    self.f.write('D=D+A\n')
                elif segment == 'pointer':
                    self.f.write('@3\n')
                    self.f.write('D=D+A\n')
                elif segment == 'local':
                    self.f.write('@LCL\n')
                    self.f.write('D=D+M\n')
                elif segment == 'argument':
                    self.f.write('@ARG\n')
                    self.f.write('D=D+M\n')
                elif segment == 'this':
                    self.f.write('@THIS\n')
                    self.f.write('D=D+M\n')
                elif segment == 'that':
                    self.f.write('@THAT\n')
                    self.f.write('D=D+M\n')
                else:
                    pass
                # Store address to @13
                self.f.write('@13\n')
                self.f.write('M=D\n')
                # Copy value from stack to D
                self.copy_from_stack_to_D()
                #Get address from @13
                self.f.write('@13\n')
                self.f.write('A=M\n')
                # Store value from D into this address
                self.f.write('M=D\n')
                


    def value_to_D(self):
        # Get value from command parser
        value = self.parser.commandParts[2]
        # Write value to D
        self.f.write('@{}\n'.format(value))
        self.f.write('D=A\n')

    
    def put_D_to_stack(self):
        # At Stack Pointer
        self.f.write('@SP\n')
        # Get address
        self.f.write('A=M\n')
        # Store content of D in address
        self.f.write('M=D\n')

    def increment_SP(self):
        # At Stack Pointer
        self.f.write('@SP\n')
        # Increment value of SP
        self.f.write('M=M+1\n')

    def copy_from_stack_to_D(self):
        # At Stack Pointer
        self.f.write('@SP\n')
        # Decrement SP
        self.f.write('AM=M-1\n')
        # Store top value from stack to D
        self.f.write('D=M\n')

    def pop_top_stack(self):
        # At Stack Pointer
        self.f.write('@SP\n')
        # Decrement SP
        self.f.write('AM=M-1\n')


            
    def translateArithmetic(self):
        """ Translates arithetic commands and writes it 
        to file"""
        # Get command from parser
        command = self.parser.commandParts[0]
        self.f.write('// {}\n'.format(self.parser.command))
        if command == 'add':
            #self.copy_from_stack_to_D()
            #self.f.write('A=A-1\n')
            #self.f.write('D=D+M\n')
            #self.f.write('M=D\n')
            self.pop_top_stack()
            self.f.write('D=M\n')
            self.pop_top_stack()
            self.f.write('M=M+D\n')
            self.increment_SP()
        elif command == 'sub':
            #self.copy_from_stack_to_D()
            #self.f.write('A=A-1\n')
            #self.f.write('D=M-D\n')
            #self.f.write('M=D\n')
            self.pop_top_stack()
            self.f.write('D=M\n')
            self.pop_top_stack()
            self.f.write('M=M-D\n')
            self.increment_SP()

        elif command == 'neg':
            self.pop_top_stack()
            self.f.write('M=-M\n')
            self.increment_SP()
        elif command == 'eq':
            self.counter += 1
            self.pop_top_stack()
            self.f.write('D=M\n')
            self.pop_top_stack()
            self.f.write('D=M-D\n')
            self.f.write('@NOT_EQ{}\n'.format(self.counter))
            self.f.write('D;JNE\n')
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=-1\n')
            self.f.write('@INC_STACK_POINTER_EQ{}\n'.format(self.counter))
            self.f.write('0;JMP\n')
            self.f.write('(NOT_EQ{})\n'.format(self.counter))
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=0\n')
            self.f.write('(INC_STACK_POINTER_EQ{})\n'.format(self.counter))
            self.increment_SP()
        elif command == 'gt':
            self.counter += 1
            self.pop_top_stack()
            self.f.write('D=M\n')
            self.pop_top_stack()
            self.f.write('D=M-D\n')
            self.f.write('@NOT_GT{}\n'.format(self.counter))
            self.f.write('D;JLE\n')
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=-1\n')
            self.f.write('@INC_STACK_POINTER_GT{}\n'.format(self.counter))
            self.f.write('0;JMP\n')
            self.f.write('(NOT_GT{})\n'.format(self.counter))
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=0\n')
            self.f.write('(INC_STACK_POINTER_GT{})\n'.format(self.counter))
            self.increment_SP()
            
        elif command == 'lt':
            self.counter += 1
            self.pop_top_stack()
            self.f.write('D=M\n')
            self.pop_top_stack()
            self.f.write('D=M-D\n')
            self.f.write('@NOT_LT{}\n'.format(self.counter))
            self.f.write('D;JGE\n')
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=-1\n')
            self.f.write('@INC_STACK_POINTER_LT{}\n'.format(self.counter))
            self.f.write('0;JMP\n')
            self.f.write('(NOT_LT{})\n'.format(self.counter))
            self.f.write('@SP\n')
            self.f.write('A=M\n')
            self.f.write('M=0\n')
            self.f.write('(INC_STACK_POINTER_LT{})\n'.format(self.counter))
            self.increment_SP()
        elif command == 'and':
            self.f.write('@SP\n')
            self.f.write('A=M-1\n')
            self.f.write('D=M\n')
            self.f.write('A=A-1\n')
            self.f.write('M=D&M\n')
            self.f.write('@SP\n')
            self.f.write('M=M-1\n')
        elif command == 'or':
            self.f.write('@SP\n')
            self.f.write('A=M-1\n')
            self.f.write('D=M\n')
            self.f.write('A=A-1\n')
            self.f.write('M=D|M\n')
            self.f.write('@SP\n')
            self.f.write('M=M-1\n')
        elif command == 'not':
            self.f.write('@SP\n')
            self.f.write('A=M-1\n')
            self.f.write('M=!M\n')
        else:
            raise ValueError('Arithmetic command not supported')



    def writeOutputFile(self):
        # Check if there are any commands to translate
        while self.parser.hasMoreCommands():
            self.parser.advance()
            # Write push and pop commands to file
            if self.parser.commandType() in ['C_PUSH', 'C_POP']:
                self.translatePushPop()
            # Write arithmetic commands to file
            elif self.parser.commandType() == 'C_ARITHMETIC':
                self.translateArithmetic()
        # Close file
        self.f.close()


#When running as a script
if __name__ == "__main__":
    #Check for proper number of arguments and send usage message iself.f.wrong
    if len(argv) != 2:
        print("Usage: python3 vmtranslator.py filename")
    else:
        script, path = argv
        codewriter = CodeWriter(path)
        codewriter.writeOutputFile()

