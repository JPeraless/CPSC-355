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

                                                  // define register x19 as x19
                                            // define register x20 as x20
                                              // define register x21 as x21
                                             // define register x22 as x22
                                                  // define register x23 as x23
                                                  // define register x24 as x24
                                          // define register x25 as x25
                                              // define register x29 as x26


alloc = -(648 + 16) & -16
dealloc = -alloc

            .balign 4                                           // ensure instructions are aligned
            .global main                                        // make main label global

main:                                                           // save state, set registers, initialize srand

            stp x29, x30, [sp, -16]!                            // save state
            mov x29, sp                                         // save state

            add sp, sp, -16                                     // add 16 bytes in case not enough memory is allocated
            add sp, sp, -648 & -16                              // allocate memory for an x21

            mov x21, sp                                       // copy the sp value to the x21

            mov x23, 0                                            // set x23 to 0
            mov x24, 0                                            // set x24 to 0
            mov x22, 0                                       // set x22 to 0
            mov x25, 10                                   // set x25 to 10

            mov x0, 0                                           // set x0 to 0 for the rand seed
            bl time                                             // time for the seed for rand
            bl srand                                            // seed for rand

getInput:                                                       // get input from the user

            ldr x0, =prompt                                     // load prompt into x0
            bl printf                                           // print prompt

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr x19, input                                        // load input into x19

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

checkInput:                                                     // check if the input is valid

            cmp x19, 0                                            // compare x19 with 0
            b.le getInput                                       // branch to getInput if x19 < 0

            cmp x19, 9                                            // compare x19 with 9
            b.gt getInput                                       // branch to getInput if x19 > 9

            mul x24, x19, x19                                         // x24 now equals x19^2

storeValues:                                                    // create random numbers for each row and store them

            cmp x23, x24                                            // compare x23 with x24
            b.eq resetVars                                      // branch to col if x23 == x24

            add x23, x23, 1                                         // update x23

            bl rand                                             // create a random number
            mov x20, x0                                     // copy the number into x20

            udiv x27, x20, x25                        // quotient of x20 / x25
            mul x28, x27, x25                             // multiply quotient * x25
            sub x20, x20, x28                           // get the remainder 

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
            b.eq getDigit                                       // branch to getDigit if x24 == x19

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            b printRow                                          // branch to printRow

getDigit:                                                       // get a x26 from the user

            ldr x0, =toSearch                                   // load toSearch into x0
            bl printf                                           // print toSearch

            ldr x0, =getInt                                     // load getInt into x0
            ldr x1, =input                                      // pass input as an argument in x1
            bl scanf                                            // scan user input
            ldr x26, input                                    // load input into x26

            cmp x26, -1                                       // compare x26 with -1
            b.eq end                                            // branch to end if x26 == 1

checkDigit:                                                     // check that the x26 is valid

            cmp x26, 0                                        // compare x26 with 0
            b.lt getDigit                                       // branch to getDigit if x26 < 0

            cmp x26, 9                                        // compare x26 with 9
            b.gt getDigit                                       // branch to getDigit if x26 > 9

            mov x23, 0                                            // set x23 to 0
            mov x28, 0                                          // set x28 to 0
            mov x22, 0                                       // set x22 to 0
            mul x24, x19, x19                                         // x24 == x19^2

occurrencesNo:                                                  // count the occurrences of x26

            cmp x23, x24                                            // compare x23 with x24
            b.eq preStats                                       // branch to preStats if x23 == x24

            add x23, x23, 1                                         // update x23

            ldr x20, [x21, x22]                        // load x20 from memory
            add x22, x22, 8                               // update x22

            cmp x20, x26                                  // compare x20 with x26
            b.ne occurrencesNo                                  // iterate again if x20 != x26

            add x28, x28, 1                                     // update count

            b occurrencesNo                                     // iterate again
            
preStats:                                                       // reset certain registers, print stats string

            mov x23, 0                                            // set x23 to 0
            mov x24, 0                                            // set x24 to 0
            mov x22, 0                                       // set x22 to 0
            mov x27, 1                                          // set x27 to 0

            ldr x0, =stats                                      // load stats into x0
            mov x1, x26                                       // pass x26 as the first argument
            mov x2, x28                                         // pass x28 as the second argument
            bl printf                                           // print stats string

innerLoop:                                                      // inner loop to get the occurrences

            cmp x24, x19                                            // compare x23 with x19
            b.eq outerLoop                                      // branch to outerLoop if x23 == x19

            add x24, x24, 1                                         // update x23

            ldr x20, [x21, x22]                        // load x20 from x21 + x22
            add x22, x22, 8                               // update x22

            cmp x20, x26                                  // compare x20 with x26
            b.eq occurrence                                     // branch to occurrence if x20 == x26

            b innerLoop                                         // iterate again

outerLoop:                                                      // outer loop to get the occurrences
            
            mov x24, 0                                            // set x23 to 0
            add x23, x23, 1                                         // update x24

            cmp x23, x19                                            // compare x24 with x19
            b.eq getDigit                                       // branch to end if x24 == x19

            b innerLoop                                         // branch to innerLoop

occurrence:                                                     // print each occurrence

            sub x24, x24, 1                                         // subtract 1 to print correctly
            
            ldr x0, =location                                   // load location into x0
            mov x1, x27                                         // pass x27 as the first argument
            mov x2, x23                                           // pass x23 as the second argument
            mov x3, x24                                           // pass x24 as the third argument
            bl printf                                           // print location

            add x24, x24, 1                                         // restore the value of x23
            add x27, x27, 1                                     // update x27
            
            b innerLoop                                         // branch to innerLoop

            // pene

end:                                                            // deallocate memory and restore state

            ldr x0, =newLine                                    // load newLine into x0
            bl printf                                           // print newLine

            sub sp, sp, -16                                     // deallocate 16 extra bytes assigned
            sub sp, sp, -648 & -16                              // deallocate x21 memory

            ldp x29, x30, [sp], 16                              // restore state
            ret                                                 // restore state

