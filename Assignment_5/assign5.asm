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

define(N, x19)                                                  // define register x19 as N
define(randInt, x20)                                            // define register x20 as randInt
define(array, x21)                                              // define register x21 as array
define(offset, x22)                                             // define register x22 as offset
define(i, x23)                                                  // define register x23 as i
define(j, x24)                                                  // define register x24 as j
define(randRange, x25)                                          // define register x25 as randRange
define(digit, x26)                                              // define register x26 as digit

            .balign 4                                           // ensure instructions are aligned
            .global main                                        // make main label global


main:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state
            
            add array, sp, 16                                   // copy sp to array

            mov randRange, 10                                   // set randRange to 0

            mov x0, 0                                           // set x0 to 0 for the rand seed
            bl time                                             // time for setting the seed
            bl srand                                            // seed for rand

            bl getInput                                         // branch to getInput
            
            mul x28, N, N                                       // x28 == N^2
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

            mov digit, x0                                       // copy x1 to digit
            
            ldr x0, =stats                                      // load stats into x0
            mov x1, digit
            bl printf                                           // print stats

            bl search                                           // branch to search
            mov x2, x1                                          // copy x1 to x2

            ldr x0, =statsEnd                                   // load statsEnd into x0
            mov x1, digit                                       // copy digit to x1
            bl printf                                           // print statsEnd

  
            b mainLoop                                          // iterate again

end:            
            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            mul x28, N, N                                       // x28 = N^2
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
            ldr N, input                                        // load input into N

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

checkInput:
            cmp N, 0                                            // comapre N with 0
            b.le getInput                                       // branch to getInput if N < 0

            cmp N, 9                                            // compare N with 9
            b.gt getInput                                       // branch to getInput if N > 9

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

initialize:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state
                    
            mov i, 0                                            // set i to 0
            mul j, N, N                                         // j == N^2
            mov offset, 0                                       // set offset to 0

storeValues:                                                    // create random numbers for each row and store them
            cmp i, j                                            // compare i with j
            b.eq resetVars                                      // branch to col if i == j

            add i, i, 1                                         // update i

            bl randomNum                                        // create a random number
            mov randInt, x0                                     // copy the number into randInt

            str randInt, [array, offset]                        // store the random number in array + offset
            add offset, offset, 8                               // update offset

            b storeValues                                       // iterate again

resetVars:                                                      // reset certain registers
            mov i, 0                                            // set i to 0
            mov j, 0                                            // set j to 0
            mov offset, 0                                       // set offset to 0

printRow:                                                       // print a row of the array
            cmp i, N                                            // compare i with N
            b.eq newRow                                         // branch to newRow if i == N

            add i, i, 1                                         // update i

            ldr randInt, [array, offset]                        // load randInt from array + offset
            add offset, offset, 8                               // update offset

            ldr x0, =printInt                                   // load printInt into x0
            mov x1, randInt                                     // pass randInt as an argument in x1
            bl printf                                           // print printInt

            b printRow                                          // iterate again

newRow:                                                         // start a new row
            mov i, 0                                            // reset i
            add j, j, 1                                         // update j

            cmp j, N                                            // compare j with N
            b.eq initializeEnd                                  // branch to initializeEnd if j == N

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

getDigit:                                                       // get a digit from the user
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov x0, 0                                           // set x0 to 0

digitInput:
            ldr x0, =toSearch                                   // load toSearch into x0
            bl printf                                           // print toSearch

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr digit, input                                    // load input into digit

            cmp digit, -1                                       // compare digit with -1
            b.eq getDigitEnd                                    // branch to end if digit == 1

checkDigit:                                                     // check that the digit is valid
            cmp digit, 0                                        // compare digit with 0
            b.lt digitInput                                     // branch to getDigit if digit < 0

            cmp digit, 9                                        // compare digit with 9
            b.gt digitInput                                     // branch to getDigit if digit > 9

getDigitEnd:
            mov x0, digit                                       // copy digit to x1

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

randomNum:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            bl rand                                             // create a random number
            mov randInt, x0                                     // copy the number into randInt

            udiv x27, randInt, randRange                        // quotient of randInt / randRange
            mul x28, x27, randRange                             // multiply quotient * randRange
            sub randInt, randInt, x28                           // get the remainder

            mov x0, randInt                                     // return randInt through x0

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

/* ---------------------------------------------------------------------- */
/* ---------------------------------------------------------------------- */

search:
            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            mov i, 0                                            // set i to 0
            mov j, 0                                            // set j to 0
            mov x27, 1                                          // set x27 to 0
            mov offset, 0                                       // set offset to 0

innerLoop:                                                      // inner loop to get the occurrences

            cmp j, N                                            // compare i with N
            b.eq outerLoop                                      // branch to outerLoop if i == N

            add j, j, 1                                         // update j

            ldr randInt, [array, offset]                        // load randInt from array + offset
            add offset, offset, 8                               // update offset

            cmp randInt, digit                                  // compare randInt with digit
            b.eq occurrence                                     // branch to occurrence if randInt == digit

            b innerLoop                                         // iterate again

outerLoop:                                                      // outer loop to get the occurrences
            
            mov j, 0                                            // set i to 0
            add i, i, 1                                         // update i

            cmp i, N                                            // compare j with N
            b.eq searchEnd                                      // branch to searchEnd if j == N

            b innerLoop                                         // branch to innerLoop

occurrence:                                                     // print each occurrence

            sub j, j, 1                                         // subtract 1 to print correctly

            mov x1, x27                                         // copy x27 to x1
            mov x2, i                                           // copy i to x2
            mov x3, j                                           // copy j to x3

            bl display                                          // branch to display

            add j, j, 1                                         // restore the value of j
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

            mov digit, x0

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
            mov offset, 0                                       // set offset to 0

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
            ldr x2, [array, offset]
            add offset, offset, 8
            ldr x3, [array, offset]
            add offset, offset, 8
            ldr x4, [array, offset]
            add offset, offset, 8
            ldr x5, [array, offset]
            add offset, offset, 8
            bl fprintf

            b tableLoop 
            
logTableEnd:
            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state
