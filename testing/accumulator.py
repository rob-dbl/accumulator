from random import random

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
    def __init__(self):
        self.nBits = 32
        self.accumulate = 0
        self.acc_enable = 0
    
    def __reset(self):
        self.register = 0

    def __sum(self,a,b):
        return a+b
    
    def __accumulate(self,a):
        self.register += a
        return self.register
    
    def run(self, a, b, accumulate : bool, acc_enable : bool, rst_n : bool):
        if not rst_n:
            self.__reset()
            return self.register
        else:
            if acc_enable:
                if not accumulate:
                    return self.__sum(a,b)
                else:
                    return self.__accumulate(a)
    



if __name__ == "__main__":
    
    # Now, the test

    pass