import sys
s = int(sys.argv[1])


ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
 
def convertToBase58(num):
    sb = ''
    while (num > 0):
        r = num % 58
        sb = sb + ALPHABET[r]
        num = num / 58;
    return sb[::-1]
 
b = convertToBase58(s)
print( "%-56d -> %s" % (s, b))
