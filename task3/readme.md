# Task 3 

# STEP 1

For this task we modified the clock displays so that we could start the counter at a specific point VbdValue() set using the rotary function of the switch. Then when the flag was pressed the counter would count up, then when pressed again would return to VdbValue().

original counter:

<img width="528" alt="Screenshot 2022-10-28 at 15 16 01" src="https://user-images.githubusercontent.com/115703122/198638286-7184bea0-1dbb-4804-bc7f-5898e9493bd3.png">

The code works by setting lb value as a multiplexer select, when high changes the value of the counter to VbdValue() and when low increments the counter up by 1. 

<img width="913" alt="Screenshot 2022-10-28 at 21 08 25" src="https://user-images.githubusercontent.com/115703122/198723257-37189999-624f-4702-a063-cb6085e1f6a6.png">

Modified counter:

<img width="625" alt="Screenshot 2022-10-28 at 15 17 13" src="https://user-images.githubusercontent.com/115703122/198638983-d6a50297-828c-4e1d-95d3-6f2b0212e9c0.png">

Modified testbench:

<img width="685" alt="Screenshot 2022-10-28 at 20 43 09" src="https://user-images.githubusercontent.com/115703122/198719363-eca1b45a-6520-476e-83f0-cbef97ff14c5.png">

The modified testbench removes enable and replaces it with v->VdbValue() and lb->flag so that when the button is pressed the flag and therefore lb is high instianting the VdbValue to be set in place of the counter, using the vbdSetMode(1) function within the for loop this allows the counter to keep counting after the button has been preesed and value is set. 

With VbdSetMode(1), you can set the mode to ONE-SHOT behaviour. Whenever the switch is pressed, the flag register is set to ‘1’ as before – now the flag is “ARMED” ready to fire. However, when the flag register is read, it immediate resets to ‘0’, this acts as a reset back to zero so it counts as though lb= 0.

# STEP 2 
