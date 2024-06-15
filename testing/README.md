# Software model of the accumulator

A Python model of the accumulator was designed to ease the testing process of the unit. The file `accumulator.py` includes:
1. The model of the unit, defined as the class `accumulator`;
2. A class for easily generate and collect test vector, called `TestVector`;
3. The `main()` definining the test procedure, where vectors are generated and applied to the `accumulator` object.

Stimuli and responses are translated into hexadecimal vector and saved into two `.txtv files, in this case `acc_stimulu.txt` and `acc_py_results.txt`.

<p align="center">
  <img src="https://github.com/rob-dbl/accumulator/blob/main/others/software_model.png" width="480">
</p>

The two generated files are used by the complete testbench to automate the simulation process, comparing the outputs of the two models and analysing discrepancies between them.
