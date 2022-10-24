import re

token_pattern = r"""
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
# declare all the pattern for matching


token_re = re.compile(token_pattern, re.VERBOSE)

class TokenizerException(Exception): pass

def tokenize(text):
    pos = 0
    isString = False
    isString1 = False
    inString = ''
    isComment = False
    while True:
        m = token_re.match(text, pos)
        # tokenize the input

        if not m:
            break
        # break the infinite loop when finish tokenizing

        pos = m.end()
        tokname = m.lastgroup
        tokvalue = m.group(tokname)
        # change the location of the end of the token for next round use
        #get the name of the token and get the value using the name

        if tokvalue == '#' and isComment == False:
            isComment = True
            continue
        if isComment and tokvalue != '\n':
            continue
        if tokvalue == '\n' and isComment == True:
            isComment = False
            continue
        if (isString or isString1) and (tokvalue != '"' and tokvalue != "'"):
            inString = inString + tokvalue
            continue
        if tokvalue == '"' and isString == False:
            isString = True
            continue
        if tokvalue == '"' and isString == True:
            isString = False
            isString1 = False
            yield 'string', inString
            inString = ''
            continue
        if tokvalue == "'" and isString1 == False:
            isString1 = True
            continue
        if tokvalue == "'" and isString1 == True:
            isString = False
            isString1 = False
            yield 'string', inString
            inString = ''
            continue
        # if else statement to check for whether the input is a string and comment and ways to handle them

        if tokname != 'whitespace' and tokname != 'newline':
            yield tokname, tokvalue
        else:
            continue
        #  output the result

    if pos != len(text):
        raise TokenizerException(f"tokenizer stopped at pos {pos} {tokname} {tokvalue}")

filename = input('Enter filename: ')
# get filename from user

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
# open the file and scan it, if file is not found output the above msg
