from collections import OrderedDict
def merge_the_tools(string, k):

    # your code goes here
    if ((1<=len(string)<=(10**4)) and (1<=k<=len(string)) and ((len(string)%k)==0)):
        for i in range(0, len(string), k):
            print(''.join(list(OrderedDict.fromkeys(string[i:i+k]))))
    else:  print("Constraints voilated !!")     

if __name__ == '__main__':
    string, k = raw_input(), int(raw_input())
    merge_the_tools(string, k)
