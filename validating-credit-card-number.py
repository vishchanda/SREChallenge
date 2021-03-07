# Enter your code here. Read input from STDIN. Print output to STDOUT
import re, sys
def check_consecutive_occurance(string):
    scrubbed_str=(string.replace('-', ''))
    counter=0
    u=""
    for i in range(len(scrubbed_str)):
        if (counter == 0) and not u:
            u=str(scrubbed_str[i])
            counter += 1
        elif (scrubbed_str[i] in u) and (counter <= 3):
             counter += 1
        elif counter >= 4:
            return False
        else:    
            u=""
            counter=0
    return True       
def validating_credit_card_number(argv):
     if (0 < int(argv[0]) < 100):
        ptrn = re.compile(r'^(([4-6]{1}[0-9]{3}-?[0-9]{4}-?[0-9]{4}-?[0-9]{4}))$')
        for i in (argv[1:]):
            if ptrn.match(i) and check_consecutive_occurance(i):
                   print("Valid")
            else: print("Invalid")
if __name__ == '__main__':
    input = sys.stdin.read().splitlines()
    validating_credit_card_number(input)
