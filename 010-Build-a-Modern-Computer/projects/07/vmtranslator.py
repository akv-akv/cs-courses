from sys import argv
from parser import Parser

class CodeWriter:


    def __init__(self, path):
        self.parser = Parser(path)
        self.outputFileName = path[:len(path)-3] + '.asm'
        self.f= open(self.outputFileName, 'w')
    
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
                # Get data from registers
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
                # TODO
                self.f.write('@13\n')
                self.f.write('M=D\n')
                self.copy_from_stack_to_D()
                self.f.write('@13\n')
                self.f.write('A=M\n')
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
        # TODO
        """ Translates arithetic commands and writes it 
        to file"""
        # Get command from parser
        command = self.parser.commandParts[0]
        self.f.write('// {}\n'.format(self.parser.command))
        if command == 'add':
            self.copy_from_stack_to_D()
            self.f.write('A=A-1\n')
            self.f.write('D=D+M\n')
            self.f.write('M=D\n')
        elif command == 'sub':
            self.copy_from_stack_to_D()
            self.f.write('A=A-1\n')
            self.f.write('D=M-D\n')
            self.f.write('M=D\n')
        elif command == 'neg':
            self.f.write('')
        elif command == 'eq':
            self.f.write('')
        elif command == 'gt':
            self.f.write('')
        elif command == 'lt':
            self.f.write('')
        elif command == 'and':
            self.f.write('')
        elif command == 'or':
            self.f.write('')
        elif command == 'not':
            self.f.write('')



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

