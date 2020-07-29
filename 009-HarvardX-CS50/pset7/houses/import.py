import sys
from cs50 import SQL
import csv

if __name__ == "__main__":
    # Check arguments
    if len(sys.argv) != 2:
        print("Usage: ./import.py csvFilePath")
    else:
        # Get path from argument
        csvPath = sys.argv[1]
    # Open database
    db = SQL("sqlite:///students.db")

    # Open csv source
    source = open(csvPath, "r")
    students = csv.DictReader(source)

    # Iterate rows in students dict
    for row in students:
        name = row['name'].split()
        # Defining name parts
        if len(name) == 3:
            first = name[0]
            middle = name[1]
            last = name[2]
        else:
            first = name[0]
            middle = None
            last = name[1]
        # Insert row to the database
        db.execute("INSERT INTO students ('first', 'middle', 'last', 'house', 'birth') \
        VALUES (?,?,?,?,?);", first, middle, last, row['house'], row['birth'])
