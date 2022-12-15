# Riya Chard Personal Statement

## Summary of Contribution

For my contribution to the coursework, I contributed in 5 ways to the final RISC-V cpu:

1) During Lab 4 I was tasked with implementing the programme counter and next pc blocks.
2) For the Lab 5 brief I was tasked with implementing the Data memory in order to implement the reference programme.
3) I also implemented the artitecture for a shift slli instructure.
4) I worked with Bhavya to understand and implementing the changes indeeded to execute the reference programme. This included the changes indeed to implement load byte and store, implementing adding registers and load upper immidient. 
5) In order to debgug the pipelined cpu created by Isabel and Ethan, Bhavya and I redesigned parts of the CPU artictecture so that it was more in line with the pipeline diagram. 

### Lab 4 - Programme Counter and Control Unit/Sign Extend Debugging

In order to create a working single cycle RISC-V, the tasks were split into 4 for Lab 4. We randomly allocated the tasks and I was allocated task 1, which consisted of changing the PC counter to either increment by 4 or be the addition of the immOP and PC depending on the PCsrc from the control unit.I implemented this using a separate countmux.sv modules which represented the multiplexer switching between the jump and branch. Finally i created a top module called toppc.sv which would combine both modules to take in the current pc and ImmOp and output the new PC depending on PCsrc.

<img width="269" alt="Screenshot 2022-12-15 at 14 02 04" src="https://user-images.githubusercontent.com/115703122/207880649-84a1fce2-fc5a-4fc1-a381-cdecb43f95fd.png">

Changes made:

- When completing the coursework I made the decision to move the mux from a separate module into the top level pc module, as if was more clear and having a module for only a mux was unnecessary. 
- Additionally, when adding jump logic it was required to change the mux from choosing branch pc if PCSrc was high and would instead choose PCTarget for Jump and Branch instructions.
- Finally, in order to pipeline the PC, the PC was moved into a fetch module where it could connect to the instruction module. Inisde the Pipelinefetch module was the PCIncr or PCTarget mux and a flip flop to change PCF to PCD. 

Below is the final design used for the toppc.sv module:

Non-Pipelined:

<img width="418" alt="Screenshot 2022-12-15 at 14 14 18" src="https://user-images.githubusercontent.com/115703122/207883287-d4ed7611-b9a8-43d5-ad15-cda16028997c.png">

What I'd do differently:

- I made many small naive errors, such as not setting PC to 32 bits or not adding connecting wires inside top modules, this couldn't been avoided and was due to the fact this was my first task working on the RISC-V CPU.
- At the beginning the design was confusing and not clean as I made additional mux's which was not needed and later changed.

### Data Memory 

When splitting the tasks for F1 we decided that 2 of the team would make the machine code, while the other two would implement it by adding the needed changes to the RISC-V Single Cycle. The new instructions needed were, data memory (load and store word) as we had not done it in Lab4, Shift and Jump. I was in charge of implementing load and store word, as well as logical shift left. When trying to implement it the I began by looking at the RISC-V diagram given in lectures to see the input and output signals driving the Data Memory Module:

<img width="702" alt="Screenshot 2022-12-10 at 11 41 44" src="https://user-images.githubusercontent.com/115703122/206853241-c259f26b-9809-438e-953f-8243c735c360.png">

I began by first understanding how the data memmory module worked, understanding that the address was the addition of the value in RD1 and ImmOp which represented the value within RD1 + Offset. Additionally, tracing the signals ResultSrc and Memwrite from the control unit to enable writing and loading from the data memory. Finally, using the diagram, I knew I'd need to add a Mux to the ALU.sv top level module to switch between load and other operations. 

<img width="957" alt="Screenshot 2022-12-11 at 12 36 28" src="https://user-images.githubusercontent.com/115703122/206903936-efe057d0-ee8c-4eb2-89d9-1cedbbcad260.png">

Next, I made sure to understand the instructon format. As load and store are register addressed, in order to test I would first have to load values into registers using addi instructions. Additionally, the store instruction introduced the S type instruction, which would require changes to the sign extend module.

Once, I had done initial planning. In order to implement load and store word instructions, I did the following:
1)**Creating the Data Memory module** - The data memory required the following inputs: data memory address (ALUout), the write data, write enable, clock, ALUout and read data. The width of the data coming into the data memory was 32 bits, as its the addition of RD1 and Immidient Extended. I decided to set the address width as 2^17-1:0 as in the Project brief we were told Data Memory could only use registers 0x0001FFFF to 0x00001000.

<img width="897" alt="Screenshot 2022-12-11 at 12 48 44" src="https://user-images.githubusercontent.com/115703122/206904483-a5761a04-2590-47fc-8ed6-1772a30dd1ad.png">

2)**Changing the Control Unit**- I added load and store word to our control unit case block, making sure to set Resultsrc and Memwrite high when store and load used.

<img width="230" alt="Screenshot 2022-12-11 at 12 49 05" src="https://user-images.githubusercontent.com/115703122/206904500-1d37ea1b-20be-4251-a516-f166fcc75784.png">

3) Finally, I **Added additional mux after data memory for load instruction** - This was implemented in the ALU.sv top level module,  this will load the read data into the register file if a load instruction is detected (ResultSrc is high), else it will simply output ALUout. 

<img width="471" alt="Screenshot 2022-12-11 at 12 49 28" src="https://user-images.githubusercontent.com/115703122/206904515-cada2c3e-320b-4e9c-85c3-462deaaee4ee.png">

Design Decisions and Changes:

**Control Unit changes to remove Combinational loop** 

<img width="829" alt="Screenshot 2022-12-12 at 16 36 22" src="https://user-images.githubusercontent.com/115703122/207101510-95409f50-b201-404f-8d7c-8752aa1a0576.png">

The biggest issue with debugging was a combinational loop occuring in the control unit, because EQ depended on additional signals such as ALUsrc or Immsrc but this sigals also depended on EQ. Our first attempt to resolve this was to put EQ in a separate case statement however this meant that the default values set to zero would conflict with the signals in the second case block. In the end I resolved the warning by creating a separate combinational block for EQ which only depended on PCsrc. I also encountered other simple errors, such as syntax and not leaving a line after endmodule and the machine code. Most errors were debugged by reviewing the signals in GTKwave and establishing which outputs were incorrect and then reviewing the code to see why that occured and how to correct it. Additionally, I had machine code errors not realising the right format for a load store instruction which was fixed by reviewing the instructions and understanding how they were written below:

<img width="778" alt="Screenshot 2022-12-11 at 12 33 46" src="https://user-images.githubusercontent.com/115703122/206903806-44b003a9-796e-47ed-85c2-a78859dd1e46.png">

**Changing ResultSrc from 1 to 2 bits**



Testing:

In order to test the load and store word instructions, I first had to understand the instruction format. As load and store are register addressed I had to load values into a register using an addi instruction. Then I stored that value into a data memory location, sw t1 0(t2). This stored the value with register t1 (0x001 from previous addi instruction) into the data memory address 0(t2), this means the value in register t2+0 offset so that would store in data memory location 0x1000 from previous addi instruction. In was important that i only accessed memory from the allowed range of data memory addresses from the project brief. 

<img width="957" alt="Screenshot 2022-12-11 at 12 36 28" src="https://user-images.githubusercontent.com/115703122/206903936-efe057d0-ee8c-4eb2-89d9-1cedbbcad260.png">

**Creating Test Machine Code**- 

<img width="310" alt="Screenshot 2022-12-11 at 12 36 58" src="https://user-images.githubusercontent.com/115703122/206903955-2511d995-40f7-4358-8edf-4eab3ec93772.png">

**Output**- 

The output was 0x001 into a0 which was as expected proving the lw and sw instruction worked.

<img width="526" alt="Screenshot 2022-12-11 at 12 37 16" src="https://user-images.githubusercontent.com/115703122/206903968-30cd4bf0-a8a6-4c4b-aa8c-ae1ee53187ce.png">

What I'd do differently: 

1)

### Shift Instruction

In addition to implementing the data memory, I also implemented the changed needed for the slli instruction used within our machine code. 


Design Decisions and Changes:


What I'd do differently:


### Reference Programme 

lbu and stu instructions 

### Pipeline Debugging and Adding Reference Programme

## Conclusion

reflection about what you have learned in this project, mistakes you made, special design decisons, and what you might do differently if you were to do it again or have more time
