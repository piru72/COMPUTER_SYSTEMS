
# Overview of the Solution and Design

![MAIN drawio (2)](https://github.com/piru72/COMPUTER_SYSTEMS/assets/63257806/46cfb73a-5ba9-456d-a258-1d999bee3104)

Just like the diagram above, There are 4 main function 
1. FUNCTION_START_WATCH
2.FUNCTION_SPLIT_TIME
3.FUNCTION_RESET_WATCH
4.FUNCTION_PAUSE_WATCH

Apart from these, the LABEL_INFINITE_LOOP_MAIN plays a vital role in the design. 

At first, the necessary preprocessing is done and some variables are defined for uses. When a key is pressed inside  LABEL_INFINITE_LOOP_MAIN then the key is used to call a function initially.  But in the case of FUNCTION_START_WATCH as its loop, I kept a check inside the loop to find out when another key is pressed and matches the valid keys to take the necessary steps.

The FUNCTION_START_WATCH function does necessary checking and if no other valid key is pressed it increments the current time by one second by calling 

1. FUNCTION_ONE_SECOND_DELAy (to provide real-time 1-second delay)
2. FUNCTION_SHOW_MINUTE_SECOND (to output the current time in minutes and seconds)
3. FUNCTION_UPDATE_WATCH_BY_ONE_SECOND(to add one second to the watch)

Each function does the work of their name and while doing so they also call the necessary function they need.

FUNCTION_START_WATCH This function increases the time by one second and displays it on the screen let's see how it works


![START_WATCH drawio (3)](https://github.com/piru72/COMPUTER_SYSTEMS/assets/63257806/0e922a6a-27d0-4eac-8675-923ac1f9f790)

# Instructions on how to run and use your program

| Key | Basic Function | What Will Happen |
| --- | -------------- | ---------------- |
| A   | Start the watch | 1. If the watch is in pause/off state and A is pressed, the watch will start counting.<br>2. If the watch is already counting, pressing A will not affect the counting and the watch will continue counting. |
| S   | Pause the watch | 1. Pressing S will pause the watch and display a message. To start the watch again, press 'A'. |
| D   | Reset the watch | 1. Pressing D will reset the clock along with the split times. |
| F   | Split the time | 1. If the watch is in a running state, pressing F will display the split time once, and the watch will continue to count time.<br>2. If the watch is in a pause state, pressing F will show the last stored split time in the display. |

# Issues/bugs
The original design of the clock has three buttons only to control the watch but here I am using 4 buttons as I found it difficult to keep track of the watch status and use the same button to start or pause the watch. 

The coding doesn’t follow the ABI and uses all the registers and also uses some of them as global variables which is although not a good practice but does the work for this program.

When the code is submitted to the Armlite simulator it becomes messy with the comment it works just fine with the normal textViewer application. Then the code doesn't look so messy with the comments as I did it for increasing the quality of the solution to make it more understandable about what I was trying to do.
