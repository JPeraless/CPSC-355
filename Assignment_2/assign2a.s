/*
Author: Jose Perales
UCID:   30143354
Tut:    02
*/

                .data                                                   // .data section
n:              .word 0                                                 // declaring n

                .text                                                   // code section

prompt:         .string "Enter N (must be a positive number): "         // string to prompt the user for N
printNum:       .string "%d"                                            // string to scan or print a single number
output:         .string "The sum of the numbers is %d"                  // output string
arrayStart:     .string "Random array: {"                               // array output start
arrayEnd:       .string "}\n"                                           // array output end
sep:            .string ", "                                            // separation for array elements
sum:            .string "The sum of the numbers is: %d\n"               // sum of numbers output
sortedStr:      .string "The array is sorted.\n"                        // string in case N = 0 or N = 1
sortedAscStr:   .string "The array is sorted in ascending order.\n"     // sorted ascending order string
sortedDescStr:  .string "The array is sorted in descending order.\n"    // sorted descending order string
unsortedStr:    .string "The array is not sorted.\n"                    // unsorted string
invalid:        .string "Invalid input.\n"                              // invalid input string
rePrompt:       .string "Please enter a valid N: "                      // reprompting the user for input

                .balign 4                                               // ensure instructions are aligned
                .global main                                            // make the main label global

main:                                                                   // main function

                stp x29, x30, [sp, -16]!                                // save state
                mov x29, sp                                             // save state

                add sp, sp, -120 & -16                                  // allocate memory

                mov x21, sp                                             // array creation

                mov x0, 0                                               // put 0 in x0 for the seed for rand
                bl time                                                 // time for the seed for rand
                bl srand                                                // seed for rand

                mov x19, 0                                              // loop counter
                mov x20, 0                                              // sum of numbers
                mov x22, 0                                              // offset for the array

                ldr x0, =prompt                                         // load prompt string to x0
                bl printf                                               // prompt user for N
            
                ldr x0, =printNum                                       // load printNum string to x0
                ldr x1, =n                                              // load n as the first argument
                bl scanf                                                // get N from user
    
                ldr x23, n                                              // load user input in x23

                cmp x23, 1                                              // compare N with 1
                b.le sortedOutput                                       // go to sortedOutput to print the corresponding string

                cmp x23, 0                                              // compare user input with 0
                b.lt invalidInput                                       // check for invalid input

                ldr x0, =arrayStart                                     // load arrayStart string to x0
                bl printf                                               // print the start of the array 



storeValues:                                                            // store the random values generated

                cmp x19, x23                                            // compare counter with user input
                b.eq resetVars                                          // check condition

                bl rand
                mov x24, x0                                             // create a random number

                mov x25, 16                                             // set x25 to 16 for the random numbers range
                udiv x26, x24, x25                                      // quotient of x24 / x25
                mul x27, x26, x25                                       // multiply quotient * x25
                sub x24, x24, x27                                       // get the remainder

                str x24, [x21, x22]                                     // save the random number
                add x22, x22, 8                                         // increase offset

                add x19, x19, 1                                         // increase loopCounter
                add x20, x20, x24                                       // add to total sum

                b storeValues                                           // iterate again

resetVars:                                                              // reset counter and offset

                mov x19, 1                                              // set counter to 1 to print the array
                mov x22, 0                                              // reset offset

loadValues:                                                             // load random values generated for output

                cmp x19, x23                                            // compare counter with user input
                b.eq loadLast                                           // check condition

                ldr x24, [x21, x22]                                     // load number
                add x22, x22, 8                                         // increase offset

                ldr x0, =printNum
		        mov x1, x24
		        bl printf						                        // print number
		
		        ldr x0, =sep
		        bl printf						                        // print ", "

                add x19, x19, 1                                         // increase counter
        
                b loadValues                                            // iterate again

loadLast:                                                               // load last value generated

                ldr x24, [x21, x22]                                     // load last number
		
                ldr x0, =printNum               
		        mov x1, x24
		        bl printf                                               // print last number

		        ldr x0, =arrayEnd
		        bl printf                                               // print the end of the array

                ldr x0, =sum                                            // sum of the numbers
                mov x1, x20                                             // put the sum into x1
                bl printf                                               // print the sum

sortedAscStart:                                                         // reset counter and offset

                mov x19, 1                                              // set counter to 1 to compare N - 1 times
                mov x22, 0                                              // reset offset

sortedAsc:                                                              // check if array is sorted in ascending order

                cmp x19, x23                                            // compare counter with number of elements
                b.eq sortedAscOutput                                    // end loop when x19 and x23 are equal

                ldr x24, [x21, x22]                                     // load the first number
                add x22, x22, 8                                         // increase offset

                ldr x25, [x21, x22]                                     // load the second number

                add x19, x19, 1                                         // increase counter 

                cmp x24, x25                                            // compare the first and second numbers
                b.le sortedAsc                                          // iterate again if condition is met

sortedDescStart:                                                        // reset counter and offset

                mov x19, 1                                              // set counter to 1 to compare N - 1 times
                mov x22, 0                                              // reset offset

sortedDesc:                                                             // check if array is sorted in descending order

                cmp x19, x23                                            // compare counter with number of elements
                b.eq sortedDescOutput                                   // end loop when x19 and x23 are equal

                ldr x24, [x21, x22]                                     // load the first number
                add x22, x22, 8                                         // increase offset

                ldr x25, [x21, x22]                                     // load the second number

                add x19, x19, 1                                         // increase counter

                cmp x24, x25                                            // compare the first and second numbers
                b.ge sortedDesc                                         // iterate again if condition is met

                b unsorted                                              // go to unsorted if no order could be found

sortedOutput:                                                           // output for sorted array
                
                ldr x0, =arrayStart                                     // load the start of the array to x0
                bl printf                                               // print arrayStart

                ldr x0, =printNum                                       // load a number to x0
                mov x1, x23                                             // put user input in x1
                bl printf                                               // print the user input

                ldr x0, =arrayEnd                                       // load the array end to x0
                bl printf                                               // print arrayEnd

                ldr x0, =sortedStr                                      // load the sorted string to x0
                bl printf                                               // print sortedStr

                b end                                                   // go to end to finish the program

sortedAscOutput:                                                        // output for array sorted in ascending order

                ldr x0, =sortedAscStr                                   // load the ascending sorted string to x0
                bl printf                                               // print sortedAsc

                b end                                                   // go to end to finish the program

sortedDescOutput:                                                       // output for array sorted in descending order

                ldr x0, =sortedDescStr                                  // load the descending sorted string to x0
                bl printf                                               // print sortedDesc

                b end                                                   // go to end to finish the program

unsorted:                                                               // output for unsorted array

                ldr x0, =unsortedStr                                    // load the unsorted string to x0
                bl printf                                               // print unsortedStr

invalidInput:                                                           // output for invalid input

                ldr x0, =invalid                                        // load invalid input string to x0
                bl printf                                               // print invalid

end:                                                                    // deallocate memory and restore state

                sub sp, sp, -120 & -16                                  // deallocate stack memory

                ldp x29, x30, [sp], 16                                  // restore state
                ret                                                     // restore state

