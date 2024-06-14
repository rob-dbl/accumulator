import random
import math

"""
entity accumulator is
    generic(
        Nbits   : integer := 32
    );
    port(
        a, b        : in std_logic_vector(Nbits-1 downto 0);
        accumulate  : in std_logic;
        acc_enable  : in std_logic;
        clk, rst_n  : in std_logic;
        y           : out std_logic_vector(Nbits-1 downto 0)
    );
end accumulator;
"""

class accumulator():
    def __init__(self,nBits):
        self.nBits = nBits 
        self.accumulate = 0
        self.acc_enable = 0
        self.overflow = 0
        self.y = None
        self.register = None
        self.overflow = 0

    
    def __reset(self):
        self.register = 0
        self.y = self.register

    def __sum(self,a : int,b : int):
        sum = a+b

        mask = (1 << self.nBits)-1
        masked_sum = sum & mask

        if (sum < (-2**(nBits-1)) or sum > (2**(nBits-1)-1)):
            self.overflow = 1
        else:
            self.overflow = 0
        return masked_sum, self.overflow


    def single_run(self, a, b, accumulate : bool, acc_enable : bool, rst_n : bool):
        
        print("------------------------------")
        if not rst_n:
            print("RESET")
            self.register, self.overflow = 0,0
        else:

            if not accumulate: # Normal sum
                print("SUM")
                internal_sum, overflow_i = self.__sum(a,b)
            else: # Accumulate
                print("ACCUMULATE")
                internal_sum, overflow_i = self.__sum(a,self.register)

            if(acc_enable): # Register is updated
                print("ENABLED")
                self.register, self.overflow = internal_sum, overflow_i
            else:
                print("DISABLED")
        
        print(f"A = {a}")
        print(f"B = {b}")

        hex_value = f"{int_to_hex(self.overflow,1)}{ int_to_ca2_hex(self.register,math.ceil(nBits/4))}"
        print(f"A+B = {self.register}\tOF = {self.overflow}\t{hex_value}")
        
        return hex_value
        return self.register, self.overflow
        
class testVector():
    def __init__(self, nBits, rndm = False, ai = 0, bi = 0, rsti = 1, acc_en =1, acc = 0):
        self.nBits = nBits
        self.reset_i = rsti
        self.accumulate = acc
        self.acc_enable = acc_en 
        if(not rndm):
            self.a_i = ai
            self.b_i = bi
            return        
        self.a_i, self.b_i = self.generateRandomInputs(nBits)
        print(f"{nBits},{self.a_i},{self.b_i}")
        self.hex_vector = self.printHex()
        #return self.getValues()

    def generateRandomNumber(self,nBits):
        num = random.randint(-(2**(nBits-1)),(2**(nBits-1))-1)
        return num
    
    def generateRandomInputs(self,nBits):
        min = -(2**(nBits-1))
        max = (2**(nBits-1))-1
        self.a_i = random.randint(min,max)
        self.b_i = random.randint(min,max)
        return self.a_i, self.b_i
    
    def printHex(self):
        control_vector = f"{self.reset_i}{self.accumulate}{self.acc_enable}"
        vector = int_to_hex(int(control_vector,2),1)
        #print(control_vector + '\t' + str(int(control_vector)) + '\t' + vector)

        print(f"{self.a_i},{self.b_i}\t\t{int_to_ca2_hex(self.a_i,math.ceil(nBits/4))},{int_to_ca2_hex(self.b_i,math.ceil(nBits/4))}")
        
        vector += f"{int_to_ca2_hex(self.a_i,math.ceil(nBits/4))}{int_to_ca2_hex(self.b_i,math.ceil(nBits/4))}"
        return vector
    
    def getValues(self):
        return self.reset_i, self.acc_enable, self.accumulate, self.a_i, self.b_i, self.hex_vector

def bit_not(num, nBits):
    return (1 << nBits) - 1 - num

def int_to_hex(num : int, nDigits : int):
    convert_string = '0' + str(nDigits) + 'x'
    return format(num, convert_string )

def int_to_ca2(num: int, nDigits : int):
    if(num < 0):
        num = abs(num)
        return bit_not(num,nDigits*4)+1
    return num

def int_to_ca2_hex(num : int, nDigits : int):
    num = int_to_ca2(num, nDigits)
    return int_to_hex(num, nDigits)

def int_to_bin(num, nBits):
    return format(num, f'0{nBits}b')



if __name__ == "__main__":
    
    nBits = 8
    UUT = accumulator(nBits)
    tv = testVector(nBits)

    # Now, the test

    ###### TEST PROCEDURE ########
    test_vector = list()

    # Vector 1: reset
    test_vector.append(testVector(nBits, rndm=True, rsti=0).getValues())

    # Vector 2: test with acc_enable disabled
    test_vector.append(testVector(nBits, rndm=True, acc_en=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=0).getValues())

    # Vector 3: test with acc_enable enabled, no accumulation
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())

    # Test 4: acc_enabled, accumulate
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())

    # Test 5: everything enabled, reset
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1, rsti= 0).getValues())

    # Test 6: Accumulate
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=1).getValues())

    # Test 7: add
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())
    test_vector.append(testVector(nBits, rndm=True, acc_en=1, acc=0).getValues())

    # Now: TEST

    fin = open("acc_stimuli.txt","w")
    fout = open("acc_py_result.txt","w")

    for vector in test_vector:
        fin.writelines(vector[5]+'\n')
        response = UUT.single_run(
            rst_n=int(vector[0]),
            acc_enable=int(vector[1]),
            accumulate=int(vector[2]),
            a=int(vector[3]),
            b=int(vector[4])
        )
        print(vector[5] + '\t' + response)
        fout.writelines(response+'\n')


    

    