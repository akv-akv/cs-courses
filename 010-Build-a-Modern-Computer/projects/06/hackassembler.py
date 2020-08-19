"""Hack assembler main file"""

from parser import prepare, code 
from sys import argv

def main():
    """Main function"""
    # Read lines from asm file
    lines = openasm(filename)
    # Parse lines to commands
    commands = prepare(lines)
    # Convert commands to binary
    binarycommands = code(commands)
    # Write to the output file
    writehack(binarycommands)

def openasm(filename):
    """Opens given asm file and returns lines from it"""
    hackfile=open(filename, 'r')
    return hackfile.readlines()


def writehack(commands):
    """Writes commands to the hack file"""
    outputfilename = filename[:(len(filename)-3)] + 'hack'
    with open(outputfilename, 'w') as f:
        for command in commands:
            f.write('{}\n'.format(command))


#When running as a script
if __name__ == "__main__":
    #Check for proper number of arguments and send usage message if wrong
    if len(argv) != 2:
        print("Usage: python3 hackassembler.py filename")
    else:
        script, filename = argv
        main()
        
