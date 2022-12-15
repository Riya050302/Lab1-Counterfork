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


### Shift Instruction

### Reference Programme 

lbu and stu instructions 

### Pipeline Debugging and Adding Reference Programme

## Conclusion

reflection about what you have learned in this project, mistakes you made, special design decisons, and what you might do differently if you were to do it again or have more time
