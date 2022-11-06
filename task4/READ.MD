# Task 4 

## STEP 1 

In this task, I created a top-level module (top.sv), which has the counter module, and a second module that converts the 8-bit binary number into three BCD digits. 

We were given the bin2bdc.sv code from the file:

<img width="401" alt="Screenshot 2022-10-29 at 00 59 25" src="https://user-images.githubusercontent.com/115703122/198752016-f1eeff4c-392e-4654-99fe-7019348782ca.png">

This file takes in an 8 bit input, from the counter converting the output of the counter into a binary coded decimal value from the following steps:
- Add input of your 8 bit counter ouput as x, and add 12 bit ouput which is the bcd conversion.
- Add the concatination of of input and out with a width of 20 bits, this is due to the shifts which mean that the last 8 bits of the result are 0 after the shift and can be discarded.
- Create a for loop that contines for every bit of x that will shift.
- Set the least significant 8 bits of result as x and the rest set to 0 prior to the shifts.
- Check each for bit from least significant to most that there are no values above 5, if there are there is overflow to the next set of 4 bits.
- Output the most significant 12 bits as you BCD value.

**Note the always comb Blocl** There is a form of always block which allows the specification of combinational circuits.  However, there is no advantage in this form of specification as compare to multiple assign statements.

<img width="636" alt="Screenshot 2022-10-29 at 01 07 10" src="https://user-images.githubusercontent.com/115703122/198752434-2c468ebd-0b28-4416-aa45-a9302e3e0517.png">

We were also given the top.sv code:

<img width="631" alt="Screenshot 2022-10-29 at 01 17 24" src="https://user-images.githubusercontent.com/115703122/198752962-3c5a3011-f10e-4c0b-86c5-017118a3c082.png">

**Note: Wire is an internal signal, which are neither inputs nor outputs. These signals are not “visible” outside the module and are declared as local signals (similar to local variables in C++ functions).**

Top.sv is a top level module that takes the counter module, and feed the set inputs through it . The interconnecting wire "count" is then connected to the input of the ROM gate.

Next, I created the top_tb.cpp testbench using previous code. I changed headers and edited the code to change Vcounter to Vtop within the testbench. I then set the values of enable and reset to 1 and 0 respectivily. 
Finally, I changed the value displayed on the Vbuddy as bcd not dout.

<img width="346" alt="Screenshot 2022-10-29 at 01 23 07" src="https://user-images.githubusercontent.com/115703122/198753212-5e5f9c18-f650-4a46-adbd-0a8ace4950f2.png">

Finally, I changed the doit.sh function by replacing counter as top so that files named with top would compile.

<img width="487" alt="Screenshot 2022-10-29 at 01 24 37" src="https://user-images.githubusercontent.com/115703122/198753265-066b4fcc-5e61-4509-a9bc-18889983bf55.png">


