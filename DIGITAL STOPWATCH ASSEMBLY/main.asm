; A --> TO START THE WATCH
; S --> TO PAUSE THE WATCH
; D --> TO RESET THE WATCH
; F --> TO SPLIT THE TIME
;DEFINING THE REGISTERS THAT WILL BE USED TO HANDLE GLOBAL STATES
;
; CLOCK STATUS HOLDER = R12 , MINUTE HOLDER = R10 , SECOND HOLDER = R9 , BLINKING STATUS = R11 
; SPLIT TIME SECOND =R7 , SPLIT TIME MINUTE = R8  is INITIALIZED THESE VARIABLES WITH 0
      MOV R12 ,  #0  
      MOV R11 ,  #0                                           
      MOV R10 ,  #0                                          
      MOV R9 ,  #0                                           
      MOV R8 , #0                                     
      MOV R7 , #0                                          
                                               
; WELCOMING THE USER
      MOV R1 , #LINE_WELCOME_USER                           ; ADDRESS OF THE LINE TO BE PRINTED
      STR R1 , .WriteString                                 ; PRINT A LINE
      BL FUNCTION_SHOW_MINUTE_SECOND                        ; CALLING THE FUNCTION TO SHOW THE CURRENT MINUTE AND SECOND


LABEL_INFINITE_LOOP_MAIN:                                   ; INFINITE LOOP TO KEEP THE PROGRAM RUNNING

      PUSH {R1}                                         
      LDR R1, .LastKeyAndReset                                      ; MOVING THE VALUE OF LAST KEY TO R1

      CMP R1, #65                                           ; CHEKING IF IT IS THE DESIGNATED KEY FOR STARTING THE STOP WATCH
      BNE LABEL_NOT_START_CHECK_OTHER                       ; IF THE KEY IS NOT FOR START THEN GO TO CHECK OTHER COMMANDS
      BL FUNCTION_START_WATCH                               ; CALLING THE FUNCTION TO START THE WATCH
      B INTERRUPT_ROUTINE_PRESSED_KEY_HANDLER_DONE          ; CHECKING DONE ,GOING TO THE END OF THE ROUTINE 

LABEL_NOT_START_CHECK_OTHER:
      CMP R1, #68                                           ; CHEKING IF IT IS THE DESIGNATED KEY FOR RESETTING THE STOP WATCH
      BNE LABEL_NOT_RESET_CHECK_OTHER                       
      BL FUNCTION_RESET_WATCH                               ; CALLING THE FUNCTION TO RESET THE WATCH
      B INTERRUPT_ROUTINE_PRESSED_KEY_HANDLER_DONE     ; JUMP TO THE END OF THE INTERRUPT HANDLER

LABEL_NOT_RESET_CHECK_OTHER:
      CMP R1, #83                                           ; CHEKING IF IT IS THE DESIGNATED KEY FOR PAUSING THE STOP WATCH
      BNE LABEL_NOT_PAUSE_CHECK_OTHER                       
      BL FUNCTION_PAUSE_WATCH                               ; CALL FUNCTION_PAUSE_WATCH  
      B INTERRUPT_ROUTINE_PRESSED_KEY_HANDLER_DONE          ; JUMP TO THE END OF THE INTERRUPT HANDLER

LABEL_NOT_PAUSE_CHECK_OTHER:
      CMP R1, #70                                           ;CHEKING IF IT IS THE DESIGNATED KEY FOR SPLIT THE STOP WATCH
      BNE INTERRUPT_ROUTINE_PRESSED_KEY_HANDLER_DONE                       
      BL FUNCTION_SPLIT_TIME  ; CALL FUNCTION_SPLIT_TIME    ; PERFORM WATCH SPLIT TIME FUNCTION


INTERRUPT_ROUTINE_PRESSED_KEY_HANDLER_DONE:
      POP {R1}                                          ; RESTORE SAVED REGISTERS

      B LABEL_INFINITE_LOOP_MAIN





FUNCTION_START_WATCH:
      PUSH {R1, LR}                                         ; SAVE R1 AND LR ON THE STACK
      MOV R1, #LINE_START_STATE                             ; MOVE THE VALUE LINE_START_STATE INTO R1  
      STR R1, .WriteString                                  ; OUTPUT THE STRING
      MOV R12, #1                                            ; SET R12 TO 1  MEANING WATCH IS IN START STATE

LABEL_TIME_UPDATE:
      LDR R1, .LastKeyAndReset                              ; READ THE LAST PRESSED KEY

      CMP R1, #83                                           ; CHECK IF PRESSED KEY IS 'S'
      BEQ LABEL_FUNCTION_START_WATCH_PAUSE_DONE             ; IF EQUAL, EXIT THE FUNCTION

      CMP R1, #68                                          ; CHECK IF PRESSED KEY IS 'D'
      BEQ LABEL_FUNCTION_START_WATCH_RESET_DONE               ; IF EQUAL, EXIT THE FUNCTION  
      CMP R1, #70                                           ; CHECK IF PRESSED KEY IS 'F'
      BEQ FUNCTION_SPLIT_TIME                               ; IF EQUAL, JUMP TO FUNCTION_SPLIT_TIME
      BL FUNCTION_ONE_SECOND_DELAY                          ; CREATE A ONE SECOND DELAY
      BL FUNCTION_SHOW_MINUTE_SECOND                        ; DISPLAY THE MINUTE AND SECOND  
      BL FUNCTION_UPDATE_WATCH_BY_ONE_SECOND                ; UPDATE THE WATCH BY ONE SECOND
      
      
      B LABEL_TIME_UPDATE                                   ; LOOP BACK TO UPDATE TIME

LABEL_FUNCTION_START_WATCH_PAUSE_DONE:
      BL FUNCTION_PAUSE_WATCH
      B LABEL_FUNCTION_START_WATCH_DONE
LABEL_FUNCTION_START_WATCH_RESET_DONE:
      BL FUNCTION_RESET_WATCH
      B LABEL_FUNCTION_START_WATCH_DONE
LABEL_FUNCTION_START_WATCH_DONE:
      POP {R1, LR}                                          ; RESTORE SAVED REGISTERS
      RET                                                   ; RETURN FROM THE FUNCTION

FUNCTION_RESET_WATCH:
      PUSH {R1, lr}                                         
      MOV R1, #LINE_RESET_STATE                             ; SET THE MESSAGE FOR RESET STATE
      STR R1, .WriteString                                  ; OUTPUT THE RESET STATE MESSAGE
      MOV R12, #0                                            ; SET THE WATCH STATE TO RESET
      MOV R10, #0                                            ; RESET THE VARIABLE
      MOV R9, #0  
      MOV R8, #0   
      MOV R7, #0  
      Bl FUNCTION_SHOW_MINUTE_SECOND                        ; DISPLAY THE RESET TIME
      MOV R1 , #.white
      STR R1, .Pixel207
      STR R1, .Pixel238
      STR R1, .Pixel239
      STR R1, .Pixel269
      STR R1, .Pixel271
      STR R1, .Pixel300
      STR R1, .Pixel303
      STR R1, .Pixel335
      STR R1, .Pixel367
      STR R1, .Pixel397
      STR R1, .Pixel398
      STR R1, .Pixel399
      STR R1, .Pixel400
      STR R1, .Pixel401
      POP {R1, lr}                                          
      RET 


FUNCTION_SPLIT_TIME: 
      PUSH {R1, LR}                                         
      MOV R1, #LINE_SPLIT_STATE                             ; MOVE THE VALUE LINE_SPLIT_STATE INTO R1
      STR R1, .WriteString                                  ; OUTPUT THE SPLIT STATE MESSAGE
      CMP R12, #0                                            ; CHECK IF WATCH STATE IS NOT STARTED
      BEQ LABEL_AVOID_SPLITTING_TIME                        ; IF EQUAL, AVOID SPLITTING TIME
      MOV R8, R10                                           ; MOVE THE VALUE OF MINUTE TO R8
      MOV R7, R9                                           ; MOVE THE VALUE OF SECOND TO R7
LABEL_AVOID_SPLITTING_TIME:
      PUSH {R10, R9, LR}                                     ; SAVE R10, R9, LR ON THE STACK
      MOV R10, R8                                           ; MOVE THE VALUE OF R8 (MINUTE) TO R10
      MOV R9, R7                                           ; MOVE THE VALUE OF R7 (SECOND) TO R9
      BL FUNCTION_SHOW_MINUTE_SECOND                        ; DISPLAY THE TIME (MINUTE:SECOND)
      POP {R10, R9, LR}                                      
      POP {R1, LR}
      RET     


FUNCTION_PAUSE_WATCH:
      PUSH {R1}                                            
      MOV R1, #LINE_PAUSE_STATE                             ; SET THE MESSAGE FOR PAUSE STATE
      STR R1, .WriteString                                  ; OUTPUT THE PAUSE STATE MESSAGE
      MOV R12, #0                                            ; SET THE WATCH STATE TO PAUSED
      POP {R1}                                           
      RET                                                  
                                                  
FUNCTION_UPDATE_WATCH_BY_ONE_SECOND:
      ADD R9, R9, #1                                        ; INCREMENT THE SECONDS
      CMP R9, #60                                            ; CHECK IF SECONDS HAVE REACHED 60
      BNE LABEL_UPDATE_WATCH_BY_ONE_SECOND_DONE             ; IF NOT EQUAL, SKIP MINUTE INCREMENT
      ADD R10, R10, #1                                        ; INCREMENT THE MINUTE
      MOV R9, #0                                            ; RESET SECONDS TO 0
LABEL_UPDATE_WATCH_BY_ONE_SECOND_DONE:
      RET                                                   



FUNCTION_SHOW_MINUTE_SECOND:
      PUSH {R1}                                            
      MOV R1, #WORD_LEFT_ARROW                              ; MOVE THE VALUE OF WORD_LEFT_ARROW INTO R1
      STR R1, .WriteString                                  ; OUTPUT THE LEFT ARROW SYMBOL
      MOV R1, R10                                            ; MOVE THE VALUE OF R10 (MINUTE) INTO R1
      STR R1, .WriteSignedNum                               ; OUTPUT THE MINUTE VALUE
      MOV R1, #WORD_COLON                                  ; MOVE THE VALUE OF WORD_COLON INTO R1
      STR R1, .WriteString                                  ; OUTPUT THE WORD "MINUTE"

      MOV R1, R9                                            ; MOVE THE VALUE OF R9 (SECOND) INTO R1
      STR R1, .WriteSignedNum                               ; OUTPUT THE SECOND VALUE
      MOV R1, #WORD_RIGHT_ARROW                             ; MOVE THE VALUE OF WORD_RIGHT_ARROW INTO R1
      STR R1, .WriteString                                  ; OUTPUT THE RIGHT ARROW SYMBOL
     
      POP {R1}                                              
      RET                                                



FUNCTION_ONE_SECOND_DELAY:
      PUSH {R3, R4, R5, R6, LR}                          
      MOV R3, #1                                            ; SET R3 TO 1 (DELAY TIME)

      LDR R4, .Time                                         ; LOAD THE VALUE OF .Time INTO R4

LABEL_ONE_SECOND_TIMER:
      LDR R5, .Time                                         ; LOAD THE CURRENT VALUE OF .Time INTO R5
      SUB R6, R5, R4                                        ; CALCULATE THE DIFFERENCE BETWEEN CURRENT TIME AND INITIAL TIME
      CMP R6, R3                                            ; COMPARE THE DIFFERENCE WITH DELAY TIME
      BLT LABEL_ONE_SECOND_TIMER                            ; IF DIFFERENCE < DELAY TIME, LOOP BACK TO WAIT FOR ONE SECOND

      BL FUNCTION_TOGGLE_PIXEL                              ; CALL FUNCTION TO TOGGLE PIXEL (PERFORM SOME ACTION)

      POP {R3, R4, R5, R6, LR}                             
      RET                                                   



FUNCTION_TOGGLE_PIXEL:
      PUSH {R1, LR}                                         

      CMP R11, #0                                            ; COMPARE R11 WITH 0
      BNE TURN_OFF_PIXEL                                    ; IF NOT EQUAL, JUMP TO TURN_OFF_PIXEL

      MOV R11, #1                                            ; SET R11 TO 1 (TOGGLE PIXEL STATE)
      MOV R1, #.blue                                        ; SET R1 TO THE VALUE .blue
      B LABEL_DRAW_PIXEL                                    ; JUMP TO LABEL_DRAW_PIXEL

TURN_OFF_PIXEL:
      MOV R11, #0                                            ; SET R11 TO 0 (TOGGLE PIXEL STATE)
      MOV R1, #.white                                       ; SET R1 TO THE VALUE .white

LABEL_DRAW_PIXEL:
      ; STORE R1 VALUE INTO PIXEL LOCATIONS DRAWING A 1

      STR R1, .Pixel207
      STR R1, .Pixel238
      STR R1, .Pixel239
      STR R1, .Pixel269
      STR R1, .Pixel271
      STR R1, .Pixel300
      STR R1, .Pixel303
      STR R1, .Pixel335
      STR R1, .Pixel367
      STR R1, .Pixel397
      STR R1, .Pixel398
      STR R1, .Pixel399
      STR R1, .Pixel400
      STR R1, .Pixel401

      POP {R1, LR}                                      
      RET 

; LABELS FOR STRINGS TO BE PRINTED IN THE PROGRAM
LINE_WELCOME_USER: .ASCIZ "---->>\t\t WELCOME TO LURAS STOP WATCH \t\t<<-----\n"
LINE_INSTRUCTIONS: .ASCIZ " \n i.A --> START THE WATCH \nii.S --> PAUSE THE WATCH \niii.D --> RESET THE WATCH \niv.F -->SPLIT THE WATCH\n"
LINE_START_STATE: .ASCIZ "\n----->>   WATCH START   <<------\n"
LINE_RESET_STATE: .ASCIZ "\n---->>   WATCH RESET   <<-----\n"
LINE_PAUSE_STATE: .ASCIZ "\n----->>   WATCH PAUSE   <<------\n"
LINE_SPLIT_STATE: .ASCIZ "\n--->>   WATCH SPLIT   <<----\n"


WORD_COLON: .ASCIZ ":"
WORD_LEFT_ARROW: .ASCIZ "---->>    "
WORD_RIGHT_ARROW: .ASCIZ "   <<----\n"