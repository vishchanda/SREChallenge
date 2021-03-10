# Enter your code here. Read input from STDIN. Print output to STDOUT
import re, sys

def check_consecutive_occurance(string):
    scrubbed_str=(string.replace('-', ''))
    if re.search(r'(.)\1\1\1', scrubbed_str):
        return False
    else: return True
    
def validating_credit_card_number(argv):
    if (0 < int(argv[0]) < 100):
        ptrn = re.compile(r'^(([4-6]{1}[0-9]{3}-?[0-9]{4}-?[0-9]{4}-?[0-9]{4}))$')
        for i in (argv[1:]):
            if ptrn.match(i): 
              if not check_consecutive_occurance(i): 
                print("Invalid")
            
              else: print("Valid")
            else: print("Invalid") 
if __name__ == '__main__':
    input = sys.stdin.read().splitlines()
    validating_credit_card_number(input)
