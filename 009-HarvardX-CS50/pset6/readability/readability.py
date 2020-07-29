# gett input from user
text = input("Text: ")

# count letters, words and sentences
letters = 0
words = 1
sentences = 0
for letter in text:
    if letter == " ":
        words += 1
    elif letter in [".", "!", "?"]:
        sentences += 1
    elif letter.isalpha():
        letters += 1

# calculate readability index
L = letters * 100 / words
S = sentences * 100 / words
index = int(round(0.0588 * L - 0.296 * S - 15.8))

if (index > 16):
    print("Grade 16+")
elif (index < 1):
    print("Before Grade 1")
else:
    print("Grade {}".format(index))
        