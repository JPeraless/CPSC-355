/*
Author: Jose Perales
UCID:   30143354
Tut:    02
*/

            .data                                               // global Variables
input:      .word 0                                             // assign 32 bits to input variable

            .text

prompt:     .string "Enter the size of the table (0-9): "       // string prompting the user for the table's size
getInt:     .string "%ld"                                       // string to scan an integer
toSearch:   .string "\n\nEnter a digit to look for (-1 to quit): "// string prompting the user to enter a digit
stats:      .string "\nDigit %d occurrences:"                   // string displaying the digit's stats
statsEnd:   .string "\nDigit %d occurs %d times"                // string displaying the no. of occurrences
location:   .string "\n%d. In (%d, %d)"                         // string displaying a digit's location
newLine:    .string "\n"                                        // string to print two newLine characters
printInt:   .string "%d\t"                                      // string to print each number in the tables
fileName:   .string "assign5.log"                               // log file name
wMode:      .string "w"                                         // write mode
appMode:    .string "a"                                         // append mode
row:        .string "%d\t%d\t%d\t%d\n"                          // string to log a row

testNum:    .string "%d\n"

                                                  // define register x19 as x19
                                            // define register x20 as x20
                                              // define register x21 as x21
                                             // define register x22 as x22
                                                  // define register x23 as x23
                                                  // define register x24 as x24
                                          // define register x25 as x25
                                              // define register x26 as x26

            .balign 4                                           // ensure instructions are aligned
            .global main                                        // make main label global


main:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state
            
            add x21, sp, 16                                   // copy sp to x21

            mov x25, 10                                   // set x25 to 0

            mov x0, 0                                           // set x0 to 0 for the rand seed
            bl time                                             // time for setting the seed
            bl srand                                            // seed for rand

            bl getInput                                         // branch to getInput
            
            mul x28, x19, x19                                       // x28 == x19^2
            mov x27, -8                                         // copy -8 to x27
            mul x28, x28, x27                                   // x28 = x28 * x27

            add sp, sp, x28                                     // sp += x28
            mov x28, sp                                         // copy sp to x28
            and sp, x28, -16                                    // and sp with -16

            bl initialize                                       // branch to initialize

mainLoop:
            bl getDigit                                         // branch to getDigit

            cmp x0, -1                                          // compare x0 with -1
            b.eq end                                            // branch to end if x0 == -1

            mov x26, x0                                       // copy x1 to x26
            
            ldr x0, =stats                                      // load stats into x0
            mov x1, x26
            bl printf                                           // print stats

            bl search                                           // branch to search
            mov x2, x1                                          // copy x1 to x2

            ldr x0, =statsEnd                                   // load statsEnd into x0
            mov x1, x26                                       // copy x26 to x1
            bl printf                                           // print statsEnd

  
            b mainLoop                                          // iterate again

end:            
            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            mul x28, x19, x19                                       // x28 = x19^2
            mov x27, 8                                          // copy 8 to x27
            mul x28, x28, x27                                   // x28 = x28 * x27

            add sp, sp, x28                                     // sp += x28

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

getInput:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            ldr x0, =prompt                                     // load prompt into x0
            bl printf                                           // print prompt

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument
            bl scanf                                            // scan user input
            ldr x19, input                                        // load input into x19

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

checkInput:
            cmp x19, 0                                            // comapre x19 with 0
            b.le getInput                                       // branch to getInput if x19 < 0

            cmp x19, 9                                            // compare x19 with 9
            b.gt getInput                                       // branch to getInput if x19 > 9

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

initialize:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state
                    
            mov x23, 0                                            // set x23 to 0
            mul x24, x19, x19                                         // x24 == x19^2
            mov x22, 0                                       // set x22 to 0

storeValues:                                                    // create random numbers for each row and store them
            cmp x23, x24                                            // compare x23 with x24
            b.eq resetVars                                      // branch to col if x23 == x24

            add x23, x23, 1                                         // update x23

            bl randomNum                                        // create a random number
            mov x20, x0                                     // copy the number into x20

            str x20, [x21, x22]                        // store the random number in x21 + x22
            add x22, x22, 8                               // update x22

            b storeValues                                       // iterate again

resetVars:                                                      // reset certain registers
            mov x23, 0                                            // set x23 to 0
            mov x24, 0                                            // set x24 to 0
            mov x22, 0                                       // set x22 to 0

printRow:                                                       // print a row of the x21
            cmp x23, x19                                            // compare x23 with x19
            b.eq newRow                                         // branch to newRow if x23 == x19

            add x23, x23, 1                                         // update x23

            ldr x20, [x21, x22]                        // load x20 from x21 + x22
            add x22, x22, 8                               // update x22

            ldr x0, =printInt                                   // load printInt into x0
            mov x1, x20                                     // pass x20 as an argument in x1
            bl printf                                           // print printInt

            b printRow                                          // iterate again

newRow:                                                         // start a new row
            mov x23, 0                                            // reset x23
            add x24, x24, 1                                         // update x24

            cmp x24, x19                                            // compare x24 with x19
            b.eq initializeEnd                                  // branch to initializeEnd if x24 == x19

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            b printRow                                          // branch to printRow

initializeEnd:
            bl logTable

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

display:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            ldr x0, =location                                   // load location into x0
            bl printf                                           // print location

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state


/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

getDigit:                                                       // get a x26 from the user
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov x0, 0                                           // set x0 to 0

digitInput:
            ldr x0, =toSearch                                   // load toSearch into x0
            bl printf                                           // print toSearch

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr x26, input                                    // load input into x26

            cmp x26, -1                                       // compare x26 with -1
            b.eq getDigitEnd                                    // branch to end if x26 == 1

checkDigit:                                                     // check that the x26 is valid
            cmp x26, 0                                        // compare x26 with 0
            b.lt digitInput                                     // branch to getDigit if x26 < 0

            cmp x26, 9                                        // compare x26 with 9
            b.gt digitInput                                     // branch to getDigit if x26 > 9

getDigitEnd:
            mov x0, x26                                       // copy x26 to x1

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

randomNum:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            bl rand                                             // create a random number
            mov x20, x0                                     // copy the number into x20

            udiv x27, x20, x25                        // quotient of x20 / x25
            mul x28, x27, x25                             // multiply quotient * x25
            sub x20, x20, x28                           // get the remainder

            mov x0, x20                                     // return x20 through x0

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

search:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov x23, 0                                            // set x23 to 0
            mov x24, 0                                            // set x24 to 0
            mov x27, 1                                          // set x27 to 0
            mov x22, 0                                       // set x22 to 0

innerLoop:                                                      // inner loop to get the occurrences

            cmp x24, x19                                            // compare x23 with x19
            b.eq outerLoop                                      // branch to outerLoop if x23 == x19

            add x24, x24, 1                                         // update x24

            ldr x20, [x21, x22]                        // load x20 from x21 + x22
            add x22, x22, 8                               // update x22

            cmp x20, x26                                  // compare x20 with x26
            b.eq occurrence                                     // branch to occurrence if x20 == x26

            b innerLoop                                         // iterate again

outerLoop:                                                      // outer loop to get the occurrences
            
            mov x24, 0                                            // set x23 to 0
            add x23, x23, 1                                         // update x23

            cmp x23, x19                                            // compare x24 with x19
            b.eq searchEnd                                      // branch to searchEnd if x24 == x19

            b innerLoop                                         // branch to innerLoop

occurrence:                                                     // print each occurrence

            sub x24, x24, 1                                         // subtract 1 to print correctly

            mov x1, x27                                         // copy x27 to x1
            mov x2, x23                                           // copy x23 to x2
            mov x3, x24                                           // copy x24 to x3

            bl display                                          // branch to display

            add x24, x24, 1                                         // restore the value of x24
            add x27, x27, 1                                     // update x27
            
            b innerLoop                                         // branch to innerLoop

searchEnd:
            sub x27, x27, 1                                     // subtract 1 to x27
            mov x1, x27                                         // copy x27 to x1

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

logFile:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov x26, x0

            /*
            str x1, [x27]                                       // store x1 into x27
            str x2, [x27, 8]                                    // store x2 into x27 + 8
            str x3, [x27, 16]                                   // store x3 into x27 + 16
            */

            ldr x0, =fileName                                   // load fileName into x0
            ldr x1, =appMode                                    // load appMode into x1
            bl fopen                                            // open file

            mov x28, x0                                         // set x28 to 0
            cmp x28, 0                                          // compare x28 with 0
            b.lt logFileEnd                                     // branch to logFileEnd if x28 < 0

logStats:
            mov x0, x28

            ldr x1, =toSearch                                   // load toSearch into x1
            bl fprintf

            ldr x1, =getInt                                     // load getInput into x1
            ldr x2, 0
            bl fprintf

            ldr x1, =stats                                      // load stats into x1
            ldr x2, 0
            bl fprintf

            ldr x1, =location                                   // load location into x1
            ldr x2, 0
            ldr x3, 0
            ldr x4, 0
            bl fprintf

            ldr x1, =statsEnd                                   // load statsEnd into x1
            ldr x2, 0
            ldr x3, 0       // wrong 
            bl fprintf
            
logFileEnd:
            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */


logTable:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov x27, 0                                          // set x28 to 0
            mov x22, 0                                       // set x22 to 0

            ldr x0, =fileName                                   // load fileName into x0
            ldr x1, =wMode                                      // load wMode into x1
            bl fopen                                            // open file

            mov x28, x0                                         // set x28 to 0
            cmp x28, 0                                          // compare x28 with 0
            b.lt logFileEnd                                     // branch to logFileEnd if x28 < 0

tableLoop:
            cmp x27, 4
            b.eq logFileEnd

            add x27, x27, 1

            mov x0, x28         // should be done each iteration?

            ldr x1, =row                                        // load row into x1
            ldr x2, [x21, x22]
            add x22, x22, 8
            ldr x3, [x21, x22]
            add x22, x22, 8
            ldr x4, [x21, x22]
            add x22, x22, 8
            ldr x5, [x21, x22]
            add x22, x22, 8
            bl fprintf

            b tableLoop 
            
logTableEnd:
            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state
