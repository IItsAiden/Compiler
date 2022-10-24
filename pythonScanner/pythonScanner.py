import re

Patterns = r"""
(?P<reserved>False|break|for|not|None|class|from|or|True|continue|global|pass|(_peg_parser_)|def|if|
raise|and|del|import|return|as|elif|in|try|assert|else|is|while|async|except|lambda|
with|await|finally|nonlocal|yield)
|(?P<identifier>[a-zA-Z_][a-zA-Z0-9_]*)
|(?P<number>[0-9.]*[0-9]+)
|(?P<symbol>\(|\)|:|"|'|,|!|"|'|\\.)
|(?P<operator>-|\+|\*|\/|%|>=|<=|==|!=|&&|\|\||=|>|<)
|(?P<newline>\n)
|(?P<whitespace>\s+)
|(?P<comment>\#)
|(?P<unknown>.)
"""
# declare all the patterns for matching


tokenRe = re.compile(Patterns, re.VERBOSE)

class TokenizerException(Exception): pass

def tokenize(text):
    pos = 0
    isString = False
    isString1 = False
    inString = ''
    isComment = False
    while True:
        m = tokenRe.match(text, pos)
        if not m:
            break
        pos = m.end()
        tokenName = m.lastgroup
        tokenValue = m.group(tokenName)

        # Line 30 matches our input to the pattern we declared in line 3.
        # Lines 31 through 32 break the infinite loop after the match is complete
        # Line 33 records where we stopped while perform matching
        # Lines 34 and 35 will get the name of the token and use that name to get the value

        if tokenValue == '#' and isComment == False:
            isComment = True
            continue
        if isComment and tokenValue != '\n':
            continue
        if tokenValue == '\n' and isComment == True:
            isComment = False
            continue
        if (isString or isString1) and (tokenValue != '"' and tokenValue != "'"):
            inString = inString + tokenValue
            continue
        if tokenValue == '"' and isString == False:
            isString = True
            continue
        if tokenValue == '"' and isString == True:
            isString = False
            isString1 = False
            yield 'string', inString
            inString = ''
            continue
        if tokenValue == "'" and isString1 == False:
            isString1 = True
            continue
        if tokenValue == "'" and isString1 == True:
            isString = False
            isString1 = False
            yield 'string', inString
            inString = ''
            continue

        # Lines 41 to 69 are if else statements that check if the input is a string or a comment, and the way to handle them.
        # Lines 74 to 77 will output the results if it is not whitespace or newline

        if tokenName != 'whitespace' and tokenName != 'newline':
            yield tokenName, tokenValue
        else:
            continue

    if pos != len(text):
        raise TokenizerException(f"tokenizer stopped at pos {pos} {tokenName} {tokenValue}")

filename = input('Enter filename: ')

#file1 = '../test/test1.py'

try:
    with open(filename) as f:
        contents = f.read()
        for tok in tokenize(contents):
            if tok[1] != None:
                print(f"({tok[0]}, '{tok[1]}')")
except FileNotFoundError:
    msg = "Sorry, the file "+ filename + " does not exist."
    print(msg)

# Line 82 will get the filename from the user
# We will then open the file and scan it, and if no file is found, output the file not exist message.
