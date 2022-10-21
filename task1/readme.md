# Task 1 
## Setting up Waveforms of Counter 

**The Objectives of the task is to:**

- write a basic testbench in C++ to verify the counter is working
- make an executable model of the counter and testbench using 
- use GTKwave to examine the waveforms

- I needed to fork the github repository to my git account, to do this I downloaded git on desktop and cloned the repository 
- I ran the folder on VS Code, and wrote out the System verlilog file 

**How the counter is coded in system verilator file:**
- It counts on the positive edge of clk if enable is ‘1’. It is synchronously reset to 0 if rst is asserted 
<img width="596" alt="Screenshot 2022-10-20 at 15 47 14" src="https://user-images.githubusercontent.com/115703122/196981850-841fd2e3-cf00-4909-a258-740eb70bc07f.png">

Note the following:

- The file name and the module name must be the same.
- The number of bits in the counter is specified with the parameter WIDTH. It is currently set to 8-bit.
- The always_ff @ (posedge clk) is the way that one specifies a clocked circuit.
- ‘<=’ in line 12 and 13 are non-block assignments which should be used within an always_ff block.
- {WIDTH{1’b0}} in line 12 uses the concatenation operator { } to form WIDTH bits of ‘0’. (Can you explain the construct in line 13?)

<img width="850" alt="Screenshot 2022-10-20 at 15 51 11" src="https://user-images.githubusercontent.com/115703122/196982777-0f255573-3b4a-44d3-9632-6640e6ff37e9.png">
*System Verilog vs the counter circuit "synthesized" via Verilator*

<img width="666" alt="Screenshot 2022-10-20 at 16 02 12" src="https://user-images.githubusercontent.com/115703122/196985685-e6ee61cf-5fa7-4faa-becc-646d85d1c44e.png">

**In order to Compile the System Verilog model with the testbench past in terminal:**

1) verilator -Wall --cc --trace counter.sv --exe counter_tb.cpp
2) make -j -C obj_dir/ -f Vcounter.mk Vcounter (Note this won't work if you haven't set your cursor to a new line after end module)
3) obj_dir/Vcounter

--> This produces a Vcounter.vcd folder 

## Output Waveform 
<img width="980" alt="Screenshot 2022-10-20 at 16 13 50" src="https://user-images.githubusercontent.com/115703122/196988521-094c66a3-9144-45d4-9e69-0d935f49b9e1.png">

Select File -> Open New Tab and select Vcounter.vcd file. A GTKwave window will appear. Click Top -> counter, followed by the signals: clk, rst, en and count[7:0].

<img width="673" alt="Screenshot 2022-10-21 at 11 44 52" src="https://user-images.githubusercontent.com/115703122/197178219-6e4ce0e9-6b25-45d4-91d7-df9b474b21b9.png">

## Challenge
1)Modify the testbench so that you stop counting for 3 cycles once the counter reaches 0x9, and then resume counting. You may also need to change the stimulus for rst.

<img width="605" alt="Screenshot 2022-10-21 at 11 45 14" src="https://user-images.githubusercontent.com/115703122/197178282-a1a77a36-0a44-4704-a5cb-d1b4ebe8bd3d.png">

2)The current counter has a synchronous reset. To implement asynchronous reset, you can change line 11 of counter.sv to detect change in rst signal.

# Task 2 
