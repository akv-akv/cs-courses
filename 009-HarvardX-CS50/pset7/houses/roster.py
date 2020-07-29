import sys
from cs50 import SQL

if __name__ == "__main__":
    # Check arguments
    if len(sys.argv) != 2:
        print("Usage: ./roster.py house")
    else:
        # Get path from argument
        house = sys.argv[1]
    
    # Open database
    db = SQL("sqlite:///students.db")
    # Execute query
    query = (db.execute("SELECT first, middle, last, birth FROM students WHERE house = ? \
    ORDER BY last", house))
    # Prepare and print output
    for item in query:
        if item['middle'] == None:
            middle = ""
        else:
            middle = item['middle'] + " "
        print("{}{}{}, born {}".format(item['first'] + " ", middle, item['last'], item['birth']))
