class Parser:

    def __init__(self,path):
        # open file and read lines
        self.file = open(path, 'r')
        self.lines = self.file.readlines()
        # clean comments and blank lines
        self.triplines()
        self.removeblanks()
        self.removecomments()
        # init command cursor
        self.cursor = -1
        # init current command
        self.command = None
        self.commandParts = []
        # count lines
        self.commands = len(self.lines)


    def triplines(self):
       """Trips and trims each line """
       self.lines = [line.strip() for line in self.lines]
       #self.lines = [line.replace(' ','') for line in self.lines]

    def removeblanks(self):
        """Remove all blank lines from list of lines"""
        self.lines = list(filter(lambda x: x!='', self.lines))

    def removecomments(self):
        """Removes all comments from given list of lines
        If line starts with //, removes line
        If line contains //, returns line before comment"""
        # filter all lines that start with '//'
        self.lines = list(filter(lambda x: not x.startswith('//'), self.lines))
        # Trim all lines to remove comments
        self.lines = list(map(lambda x: x[:x.find("//")] if x.find('//')!=-1 else x, self.lines))
 
    def hasMoreCommands(self):
        # returns true if number of current command
        # is less then number of commands
        return self.cursor < self.commands - 1

    def advance(self):
        """ Goes to next command if not last one"""
        if self.hasMoreCommands():
            self.cursor += 1
            self.command = self.lines[self.cursor]
            self.commandParts = self.command.split(' ')
    

    def commandType(self):
        """ Returns type of the current command """
        # Check if command is arithmetic
        arithmeticCommands = ['add', 'sub', 'neg', 'eq', 'gt', 'lt', 'and', 'or', 'not']
        if self.command in arithmeticCommands:
            return 'C_ARITHMETIC'
        # Check for push or pop commands
        elif 'pop' in self.commandParts:
            return 'C_POP'
        elif 'push' in self.commandParts:
            return 'C_PUSH'
        # TODO add more types (project 08)
        else:
            raise ValueError('Command type not supported')

    

    

