/*
Author: Jose Perales
UCID:   30143354
Tut:    02
*/

            .data                                               // global Variables
input:      .word 0                                             // assign 32 bits to input

            .text                                               // .text section of the code

prompt:     .string "Enter the size of the table (1-9): "       // string prompting user for the table size
getInt:     .string "%ld"                                       // string to scan an integer
toSearch:   .string "\n\nEnter a digit to look for (-1 to quit): "// string prompting user to enter a digit
stats:      .string "\nDigit %d occurrences: %d"                // string displaying the digit's stats
location:   .string "\n%d. In (%d,%d)"                          // string displaying a digit's location
newLine:    .string "\n"                                        // string to print two newLine characters
printInt:   .string "%d\t"                                      // string to print each number in the tables

define(N, x19)                                                  // define register x19 as N
define(randInt, x20)                                            // define register x20 as randInt
define(array, x21)                                              // define register x21 as array
define(offset, x22)                                             // define register x22 as offset
define(i, x23)                                                  // define register x23 as i
define(j, x24)                                                  // define register x24 as j
define(randRange, x25)                                          // define register x25 as randRange
define(digit, x26)                                              // define register x29 as digit


alloc = -(648 + 16) & -16
dealloc = -alloc

            .balign 4                                           // ensure instructions are aligned
            .global main                                        // make main label global

main:                                                           // save state, set registers, initialize srand

            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            add sp, sp, -16                                     // add 16 bytes in case not enough memory is allocated
            add sp, sp, -648 & -16                              // allocate memory for an array

            mov array, sp                                       // copy the sp value to the array

            mov i, 0                                            // set i to 0
            mov j, 0                                            // set j to 0
            mov offset, 0                                       // set offset to 0
            mov randRange, 10                                   // set randRange to 10

            mov x0, 0                                           // set x0 to 0 for the rand seed
            bl time                                             // time for the seed for rand
            bl srand                                            // seed for rand

getInput:                                                       // get input from the user

            ldr x0, =prompt                                     // load prompt into x0
            bl printf                                           // print prompt

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr N, input                                        // load input into N

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

checkInput:                                                     // check if the input is valid

            cmp N, 0                                            // compare N with 0
            b.le getInput                                       // branch to getInput if N < 0

            cmp N, 9                                            // compare N with 9
            b.gt getInput                                       // branch to getInput if N > 9

            mul j, N, N                                         // j now equals N^2

storeValues:                                                    // create random numbers for each row and store them

            cmp i, j                                            // compare i with j
            b.eq resetVars                                      // branch to col if i == j

            add i, i, 1                                         // update i

            bl rand                                             // create a random number
            mov randInt, x0                                     // copy the number into randInt

            udiv x27, randInt, randRange                        // quotient of randInt / randRange
            mul x28, x27, randRange                             // multiply quotient * randRange
            sub randInt, randInt, x28                           // get the remainder 

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
            b.eq getDigit                                       // branch to getDigit if j == N

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            b printRow                                          // branch to printRow

getDigit:                                                       // get a digit from the user

            ldr x0, =toSearch                                   // load toSearch into x0
            bl printf                                           // print toSearch

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr digit, input                                    // load input into digit

            cmp digit, -1                                       // compare digit with -1
            b.eq end                                            // branch to end if digit == 1

checkDigit:                                                     // check that the digit is valid

            cmp digit, 0                                        // compare digit with 0
            b.lt getDigit                                       // branch to getDigit if digit < 0

            cmp digit, 9                                        // compare digit with 9
            b.gt getDigit                                       // branch to getDigit if digit > 9

            mov i, 0                                            // set i to 0
            mov x28, 0                                          // set x28 to 0
            mov offset, 0                                       // set offset to 0
            mul j, N, N                                         // j == N^2

occurrencesNo:                                                  // count the occurrences of digit

            cmp i, j                                            // compare i with j
            b.eq preStats                                       // branch to preStats if i == j

            add i, i, 1                                         // update i

            ldr randInt, [array, offset]                        // load randInt from memory
            add offset, offset, 8                               // update offset

            cmp randInt, digit                                  // compare randInt with digit
            b.ne occurrencesNo                                  // iterate again if randInt != digit

            add x28, x28, 1                                     // update count

            b occurrencesNo                                     // iterate again
            
preStats:                                                       // reset certain registers, print stats string

            mov i, 0                                            // set i to 0
            mov j, 0                                            // set j to 0
            mov offset, 0                                       // set offset to 0
            mov x27, 1                                          // set x27 to 0

            ldr x0, =stats                                      // load stats into x0
            mov x1, digit                                       // pass digit as the first argument
            mov x2, x28                                         // pass x28 as the second argument
            bl printf                                           // print stats string

innerLoop:                                                      // inner loop to get the occurrences

            cmp j, N                                            // compare i with N
            b.eq outerLoop                                      // branch to outerLoop if i == N

            add j, j, 1                                         // update i

            ldr randInt, [array, offset]                        // load randInt from array + offset
            add offset, offset, 8                               // update offset

            cmp randInt, digit                                  // compare randInt with digit
            b.eq occurrence                                     // branch to occurrence if randInt == digit

            b innerLoop                                         // iterate again

outerLoop:                                                      // outer loop to get the occurrences
            
            mov j, 0                                            // set i to 0
            add i, i, 1                                         // update j

            cmp i, N                                            // compare j with N
            b.eq getDigit                                       // branch to end if j == N

            b innerLoop                                         // branch to innerLoop

occurrence:                                                     // print each occurrence

            sub j, j, 1                                         // subtract 1 to print correctly
            
            ldr x0, =location                                   // load location into x0
            mov x1, x27                                         // pass x27 as the first argument
            mov x2, i                                           // pass i as the second argument
            mov x3, j                                           // pass j as the third argument
            bl printf                                           // print location

            add j, j, 1                                         // restore the value of i
            add x27, x27, 1                                     // update x27
            
            b innerLoop                                         // branch to innerLoop

end:                                                            // deallocate memory and restore state

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            sub sp, sp, -16                                     // deallocate 16 extra bytes assigned
            sub sp, sp, -648 & -16                              // deallocate array memory

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

