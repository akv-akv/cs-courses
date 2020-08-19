"""Parser for the Hack Assembler"""
import tables
from symbols import addSymbols, findSymbolValues


def prepare(lines):
    """Parses givel lines of asm file"""
    # Clear lines from \r,\n and whitespaces
    lines = triplines(lines)
    # Remove blank lines
    lines = removeblanks(lines)
    # Remove comments
    lines = removecomments(lines)
    return lines

def code(commands):
    # Define type of a command and convert command to binary
    binarycommands = []
    # Working with symbols
    addSymbols(commands)
    commands = findSymbolValues(commands)
    for command in commands:
        commandtype=definecommandtype(command)
        if commandtype == 'A':
            binarycommands.append(aToBinary(command))
        if commandtype == 'C':
            binarycommands.append(cToBinary(command))
        if commandtype == 'L':
            pass
    return binarycommands

def definecommandtype(command):
    """Define type of command based on special characters and returns corresponding letter"""
    if command.startswith('@'):
        return 'A'
    elif '=' in command or ';' in command:
        return 'C'
    else:
        return 'L'

def aToBinary(command):
    """ Converts number from A-type instruction to 16-bit long binary number"""
    return "{:016b}".format(int(command[1:]))

def cToBinary(command):
    if '=' in command and ';' in command:
        dest = command[0:command.find('=')]
    	comp = command[command.find('=')+1:command.find(';')]
        jump = command[command.find(';')+1:]
    elif '=' in command and not(';' in command):
    	dest = command[0:command.find('=')]
        comp = command[command.find('=')+1:]
    	jump = 'null'
    elif ';' in command and not('=' in command):
        dest = 'null'
    	comp = command[0:command.find(';')]
        jump = command[command.find(';')+1:]
    return '111' + tables.comp[comp] + tables.dest[dest] + tables.jump[jump]

def triplines(lines):
    """Trips and trims each line """
    lines = [line.strip() for line in lines]
    lines = [line.replace(' ','') for line in lines]
    return lines

def removeblanks(lines):
    """Remove all blank lines from list of lines"""
    lines = list(filter(lambda x: x!='', lines))
    return lines

def removecomments(lines):
    """Removes all comments from given list of lines
    If line starts with //, removes line
    If line contains //, returns line before comment"""
    # filter all lines that start with '//'
    lines = list(filter(lambda x: not x.startswith('//'), lines))
    # Trim all lines to remove comments
    lines = list(map(lambda x: x[:x.find("//")] if x.find('//')!=-1 else x, lines))
    return lines

