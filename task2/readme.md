
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

1) The output is inputed into 4 vbdHex functions, this produces four counter displays which will visually represent the counter in hexidecimal form.

2)The first input represents the index of each display.

3)The input top ->count represents the output value from the counter.

4)Top count is a 32 bit number. By setting the conditon >> 16 this represents a 16 bit shift this drops will drop the least significant bits. The same is done with each display so that once you pass a certain number the counter moves to the next display index.

5)Finally we have a bitwise and with 0xFF to remove additional 0's, produced from shifting. In a nutshell, “& 0xff” effectively masks the variable so it leaves only the value in the last 4 bits, and ignores all the rest of the bits. 

Example:

<img width="476" alt="Screenshot 2022-10-31 at 19 31 20" src="https://user-images.githubusercontent.com/115703122/199093692-28425403-7175-4380-8b87-ffed99dd283e.png">


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

New function meanings:

// Report the cycle count on bottom right of TFT screen
- void vbdCycle(int cycle);

// Plot y value scaled between min and max on TFT screen on next x coord.
//    ... When x reaches 240, screen is cleare and x starts from 0 again.
- void vbdPlot(int y, int min, int max);


// Display 4-bit binary value in v on a 7 segment display
//     ...  digit is from 1 (right-most) to 5 (left most)
- void vbdHex(int digit, int v);
