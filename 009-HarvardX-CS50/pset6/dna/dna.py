import csv
import sys

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: ./dna.py databasePath sequencePath")
    else:
        # Get paths from arguments
        dbPath = sys.argv[1]
        seqPath = sys.argv[2]

        # Open database csv
        database = csv.DictReader(open(dbPath, newline=''))
        seqNames = database.fieldnames[1:]
        
        # Open sequence file
        sequencefile = open(seqPath, "r")
        sequence = sequencefile.read()
        
        sequenceCount = {}
        # Count number of consequent substring appearances
        for i in range(0, len(sequence)):
            for seq in seqNames:
                if (sequence.count(seq*i)) > 0:
                    sequenceCount[seq] = i
        
        # Comparing results of sequence check with DNA database
        match = 'No match'
        for row in database:
            valid = 0
            for seq in seqNames:
                if int(row[seq]) == sequenceCount[seq]:
                    valid += 1
            if valid == len(seqNames):
                match = row['name']
        print(match)
