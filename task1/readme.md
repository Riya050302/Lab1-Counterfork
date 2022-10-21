# Task 1 
## Setting up Waveforms of Counter 

## Background 

System Verlog - is a hardware description and verification language (HDL) mostly for designing digital hardware, based in verilog.

Verilator - is software package to simulate Verilog/System Verilog designs.Verilator is a **cycle-accurate simulator**, which means that circuits states are only evaluated once in a clock cycle. It does not evaluate time within a clock cycle and is therefore only suitable for functional verification without timing information. Verilator verified design is almost guaranteed to be synthesizable by modern logic synthesis tools. 
For example, Verilator cannot evaluate glitches in a circuit. Furthermore, Verilator signals can only be true (1) or false (0). It cannot be unknown, high impedance, floating or in other signal states.

The reason why Verilator is so fast is fundamentally because it translates Verilog/System Verilog into C++ (or System C) code. Then it uses standard, highly efficient C++ compiler to produce natively executable “model” or program of the design (known as Device-Under-Test or DUT). In order to produce the executable model of the counter, it must include the DUT as well as the testbench code.

Vbuddy - was created to provide a bridge between the Verilator simulator and actual physical electronics such as microphone signal and 7-segment displays.

## The Objectives of the task is to:

- write a basic testbench in C++ to verify the counter is working
- make an executable model of the counter and testbench using 
- use GTKwave to examine the waveforms

- I needed to fork the github repository to my git account, to do this I downloaded git on desktop and cloned the repository 
- I ran the folder on VS Code, and wrote out the System verlilog file 

## How the counter is coded in system verilator file:
- It counts on the positive edge of clk if enable is ‘1’. It is synchronously reset to 0 if rst is asserted 
<img width="596" alt="Screenshot 2022-10-20 at 15 47 14" src="https://user-images.githubusercontent.com/115703122/196981850-841fd2e3-cf00-4909-a258-740eb70bc07f.png">

**Note the following:**

- The file name and the module name must be the same. Instiate the module. That means that each time you use a module in SV, you “clone” a separate entity – the clone has a totally separate existence (SV is entirely hierarchical. Modules can instantiate other modules. All modules have inputs and outputs as shown on the slide).
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

<img width="759" alt="Screenshot 2022-10-21 at 14 16 53" src="https://user-images.githubusercontent.com/115703122/197204822-f2a98c58-d128-4745-91a9-c4b4a013e602.png">


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


# Task 2 

In this task, you will learn how to modify the testbench to interface with the Vbuddy board. 

## STEP 1

1) Move counter.sv and counter_tb.cpp into task 2 folder 
2) Make a copy of the files Vbuddy.cpp and Vbuddy.cfg from your Lab 1 folder to put into task 1 folder.
3) Enter ls /dev/tty.u* in terminal
4) Get outpit: /dev/tty.usbserial-110

## STEP 2
Add additinal code:   

<img width="610" alt="Screenshot 2022-10-21 at 14 28 16" src="https://user-images.githubusercontent.com/115703122/197207157-34a35141-6bda-4618-a7ca-94198d8d1784.png">

Code for 7-seg display expained:

## STEP 3

**How the Vbuddy button can be used to toggle counter start/stop:** Vbuddy’s rotary encode has a push-button switch. Vbuddy keeps an internal flag which, by default, will toggle between ‘0’ and ‘1’ each time the button is pressed. 

1) Interrogate this toggle switch state with vbdFlag();, which will return its current state and then toggle. A little postbox showing the flag state is drawn in the footer of the TFT display.

Previously:

<img width="297" alt="Screenshot 2022-10-21 at 14 32 14" src="https://user-images.githubusercontent.com/115703122/197208049-2434006e-e413-4c90-9099-f9a44c93d1b1.png">

Now:

<img width="185" alt="Screenshot 2022-10-21 at 14 32 47" src="https://user-images.githubusercontent.com/115703122/197208148-1cb4221c-7e0d-4a83-b3de-26b9c4f3e811.png">

OUTPUT:

<img width="219" alt="Screenshot 2022-10-21 at 14 45 13" src="https://user-images.githubusercontent.com/115703122/197210645-3b77a9c6-44a3-4dcf-ae48-0ffa531a64db.png">

2) Replacing the vdbHex() section with the command vbdPlot(). You may want to increase the number of clock cycles to simulate because plotting a dot is much faster than outputting to the 7-segment display. You can start/stop the counter with the flag.

Code:

<img width="300" alt="Screenshot 2022-10-21 at 14 47 15" src="https://user-images.githubusercontent.com/115703122/197211102-02948bfc-d305-4057-a9ae-c5044a39c78f.png">

OUTPUT:

<img width="331" alt="Screenshot 2022-10-21 at 14 47 53" src="https://user-images.githubusercontent.com/115703122/197211245-d7d7cba9-5d69-4a35-b967-6e0064690781.png">

## CHALLENGE 

Task: Modify your counter and testbench files so that the en signal controls the direction of counting: ‘1’ for up and ‘0’ for down, via the vbdFlag() function.

In order to get the order to count up and down for every button press we edited the logic for enable with the counter.sv file. Now is enable is high the counter will add 1 bit and if the enable is low the counter will subtract one bit, each clock cycle.

CODE:

<img width="428" alt="Screenshot 2022-10-21 at 15 33 03" src="https://user-images.githubusercontent.com/115703122/197221047-38d3229a-84c8-4c1c-8380-f9ef584e644f.png">






