/*
Author: Jose Perales
UCID:   30143354
Tut:    02
*/

            .data
input:      .word 0

            .text

prompt:     .string "Please enter N: "
getHex:     .string "%s"
programEnd: .string "\n\n"
bin0:       .string "0"
bin1:       .string "1"


define(pos_N, w19)
define(N, w20)
define(i, w21)
define(j, w22)
define(decimal, w23)
define(binary, w24)
define(char, w25)

            .balign 4
            .global main

/*-----------------------------------*/

main:

            stp x29, x30, [sp, -16]!                    // store state
            mov x29, sp                                 // store state

            ldr x0, =prompt                             // load prompt into x0
            bl printf                                   // prompt the user for a digit

            ldr x0, =getHex                             // load getHex into x0
            ldr w1, =input                              // use input as an argument
            bl scanf                                    // scan user input
            ldr N, input                                // load input into N

            mov i, 0

hex2Bin:

            mov j, 3                                    // set i to 3

            bfxil char, N, 0, 8
            lsr N, N, 8

            cmp char, 'a'
            b.ge hexLower

            cmp char, 'A'
            b.ge hexUpper            

            b end

hexNumber:
            sub decimal, char, '0'

            b dec2Bin

hexUpper:
            sub decimal, char, 'A'
            add decimal, decimal, 10

            b dec2Bin

hexLower:
            sub decimal, char, 'a'
            add decimal, decimal, 10

            b dec2Bin


dec2Bin:                                        // convert to binary



            mov w28, 1
            lsl w28, w28, j

            cmp w28, decimal
            b.le bit1

            ldr x0, =bin0
            bl printf            

            b other

bit1:                                           // print 1
            ldr x0, =bin1
            bl printf

other:                                          // second case

            sub j, j, 1

            cmp j, 0
            b.ge dec2Bin

            add i, i, 1
            cmp i, 4
            b.lt hex2Bin

end:                                            // terminate the program
            ldr x0, =programEnd
            bl printf

            ldp x29, x30, [sp], 16
            ret

