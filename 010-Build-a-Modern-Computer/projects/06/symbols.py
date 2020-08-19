import tables
import parser

global symbols
def addSymbols(commands):
    """Looks through all commands and inserts Symbols to the symbols table"""
    global symbols
    symbols = tables.symbols
    print(symbols)
    linenumber = 0
    for command in commands:
        if parser.definecommandtype(command) == 'L':
            symbols[command.strip('()')] = str(linenumber)
        else:
            linenumber += 1
    print(symbols)

def findSymbolValues(commands):
    """Looks for symbols in symbols table and replaces command with its values
    if Symbol is not found in table then add it to symbol table and assign next value starting from 16"""
    ramaddress = 16
    for i, command in enumerate(commands):
        if parser.definecommandtype(command) == 'A' and command[1].isalpha():
            try:
                commands[i] = '@' + symbols[command[1:]]
            except KeyError:
                symbols[command[1:]] = str(ramaddress)
		ramaddress += 1
    		commands[i] = '@' + symbols[command[1:]]

    return commands


