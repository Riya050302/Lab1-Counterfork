# Task 1 - Setting up Waveforms of Counter 

## Background 

**System Verlog** - is a hardware description and verification language (HDL) mostly for designing digital hardware, based in verilog.

**Verilator** - is software package to simulate Verilog/System Verilog designs.Verilator is a **cycle-accurate simulator**, which means that circuits states are only evaluated once in a clock cycle. It does not evaluate time within a clock cycle and is therefore only suitable for functional verification without timing information. Verilator verified design is almost guaranteed to be synthesizable by modern logic synthesis tools. 
For example, Verilator cannot evaluate glitches in a circuit. Furthermore, Verilator signals can only be true (1) or false (0). It cannot be unknown, high impedance, floating or in other signal states.

The reason why Verilator is so fast is fundamentally because it translates Verilog/System Verilog into C++ (or System C) code. Then it uses standard, highly efficient C++ compiler to produce natively executable “model” or program of the design (known as Device-Under-Test or DUT). 

**Vbuddy** - was created to provide a bridge between the Verilator simulator and actual physical electronics such as microphone signal and 7-segment displays.

**RTL** For this module, you will learn a particular level of  abstraction of the processor hardware known as Register Transfer Level (RTL).  In RTL specifications, all combinational logic are sandwiched between registers controlled by one or more clock signal.

**HDL** Hardware description langauge, spefics logic functions and programmes based around hardware. 

**Types of Modules:** 
* Behavioural - Describes what the module does.
* Structural - describes how it is built.

## The Objectives of the task is to:

- write a basic testbench in C++ to verify the counter is working
- make an executable model of the counter and testbench using 
- use GTKwave to examine the waveforms

- I needed to fork the github repository to my git account, to do this I downloaded git on desktop and cloned the repository 
- I ran the folder on VS Code, and wrote out the System verlilog file 

## STEP 3: System Verilog File

<img width="850" alt="Screenshot 2022-10-20 at 15 51 11" src="https://user-images.githubusercontent.com/115703122/196982777-0f255573-3b4a-44d3-9632-6640e6ff37e9.png">

- It counts on the positive edge of clk if enable is ‘1’. It is synchronously reset to 0 if rst is asserted.
- The code works by assigning the name counter to module. This is a **behavioural module** allows you to describe the abstract functional behaviour rather than physical structure of the hardware. 
- The file name and the module name must be the same. Instiate the module. That means that each time you use a module in SV, you “clone” a separate entity – the clone has a totally separate existence (SV is entirely hierarchical. Modules can instantiate other modules. All modules have inputs and outputs as shown on the slide).
- The parameter of WIDTH is defined as 8 bits wide.
- It takes in various input values, such as clock, reset and enable. With an output counter of 8 bits [7:0]
- The always_ff @ (posedge clk) flipflop command used, without posedge reset, therefore the flipflop was sychronous (only reset on pos clock edge)
- System Verilator uses idioms to describe flip flops. The “always” followed by @(posedge clk) means that when any signal in the posedge of the clock is asserted, “count” is executed.

- ‘<=’ in line 12 and 13 are non-block assignments which should be used within an always_ff block.
- {WIDTH{1’b0}} in line 12 uses the concatenation operator { } to form WIDTH bits of ‘0’, which will then form a 7 bit output of value 0. 
- The 8 bit number is is formed by carrying out bitwise manipulation and concatenation: {WIDTH-1{1'b0}, en}. The WIDTH - 1 means the most significant 7 bits is set to 0. The LSB = enable value. When enable value is high (1) the counter increments, otherwise (0) the counter is unchanged.

<img width="596" alt="Screenshot 2022-10-20 at 15 47 14" src="https://user-images.githubusercontent.com/115703122/196981850-841fd2e3-cf00-4909-a258-740eb70bc07f.png">

The Bits are assigned and concatinated as follows:

<img width="694" alt="Screenshot 2022-10-21 at 21 51 37" src="https://user-images.githubusercontent.com/115703122/197286591-183d2093-fa65-4a72-84d3-f05cb251710c.png"> <img width="683" alt="Screenshot 2022-10-21 at 21 52 21" src="https://user-images.githubusercontent.com/115703122/197286696-13df614b-d26a-4653-a0ae-bf9742bafcc3.png">

## STEP 4: Creating testbench 

*System Verilog vs the counter circuit "synthesized" via Verilator*

<img width="666" alt="Screenshot 2022-10-20 at 16 02 12" src="https://user-images.githubusercontent.com/115703122/196985685-e6ee61cf-5fa7-4faa-becc-646d85d1c44e.png">

1) Add headers
2) Instiate i (counts clock cycles) and clk (clock signal of module)
4) Instantiate Verilator counter module in C++ code, this is the DUT.
5)  Dumps waveform data to counter.vcd, which will then be viewed on GTKWave
6)  Set signal values (Top represents top level entry, only these are visible)
7)  For loop for running the clock cycles, this toggles clock cycles. This outputs trace every half cycle and evaluates both edges of clock.
8)  Changes rst and en signals.

## STEP 5: Compiling 

**In order to Compile the System Verilog model with the testbench past in terminal:**

1) verilator -Wall --cc --trace counter.sv --exe counter_tb.cpp
2) make -j -C obj_dir/ -f Vcounter.mk Vcounter (Note this won't work if you haven't set your cursor to a new line after end module)
3) obj_dir/Vcounter

--> This produces a Vcounter.vcd folder which can be displayed on GTKWave

## STEP 6: Output Waveform 
<img width="980" alt="Screenshot 2022-10-20 at 16 13 50" src="https://user-images.githubusercontent.com/115703122/196988521-094c66a3-9144-45d4-9e69-0d935f49b9e1.png">

Select File -> Open New Tab and select Vcounter.vcd file. A GTKwave window will appear. Click Top -> counter, followed by the signals: clk, rst, en and count[7:0].

We can see that the eval() function comes after the clk line. This means all the evaluations occur "during the clock cycle" but that does not show up until the positive edge of the next clock cycle in the waveform on GTK. So if rst is to be 0 when i == 2. This means at positive edge of clock cycle 2, rst is still 1. During this clock cycle the eval function occurs and rst changes. However this change is displayed at the positive edge of clock cycle 3.

<img width="759" alt="Screenshot 2022-10-21 at 14 16 53" src="https://user-images.githubusercontent.com/115703122/197204822-f2a98c58-d128-4745-91a9-c4b4a013e602.png">

CLK: The clock cycles
Count: The output of modules, goes back to 0 at reset, when enable is high at each postive edge will increment by 1 until it goes over 8 bit value.
Enable: When high activates clock, when low pauses counter.
Reset: When high, in next cycle the clock will go back to 0.


## Challenge
1) Modify the testbench so that you stop counting for 3 cycles once the counter reaches 0x9, and then resume counting. You may also need to change the stimulus for rst.

Code used:

<img width="298" alt="Screenshot 2022-10-21 at 14 09 32" src="https://user-images.githubusercontent.com/115703122/197203410-bae34021-b823-4f81-9553-7774754b9fc3.png">

Output Wave Observed:

<img width="766" alt="Screenshot 2022-10-21 at 14 12 19" src="https://user-images.githubusercontent.com/115703122/197203984-3e86b90a-5593-4e7c-8d41-8a4454b45b30.png">


2)The current counter has a synchronous reset. To implement asynchronous reset, you can change line 11 of counter.sv to detect change in rst signal.

Theory:

<img width="451" alt="Screenshot 2022-10-21 at 14 15 19" src="https://user-images.githubusercontent.com/115703122/197204553-ed5a6164-8ddf-4d27-bab6-1ab1c9018bca.png">

Reset can be implemented as synchronous or asynchronous.  Synchronous reset means that reset happens only on the active edge of the clock signal. Asynchronous reset can happen anytime whenevert the reset signal is asserted and is independent of the clock.

Code:
<img width="194" alt="Screenshot 2022-10-21 at 14 18 39" src="https://user-images.githubusercontent.com/115703122/197205139-36a4066a-2be8-45b3-80db-0e752828b453.png">

Output:

<img width="321" alt="Screenshot 2022-10-21 at 14 22 28" src="https://user-images.githubusercontent.com/115703122/197205918-f1a02f67-5a9b-4cd8-9cf7-c1903d16f99f.png">









