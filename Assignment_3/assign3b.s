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
            ldr w20, input                                // load input into w20

            mov w21, 0

hex2Bin:

            mov w22, 3                                    // set w21 to 3

            bfxil w25, w20, 0, 8
            lsr w20, w20, 8

            cmp w25, 'a'
            b.ge hexLower

            cmp w25, 'A'
            b.ge hexUpper            

            b end

hexNumber:
            sub w23, w25, '0'

            b dec2Bin

hexUpper:
            sub w23, w25, 'A'
            add w23, w23, 10

            b dec2Bin

hexLower:
            sub w23, w25, 'a'
            add w23, w23, 10

            b dec2Bin


dec2Bin:                                        // convert to w24



            mov w28, 1
            lsl w28, w28, w22

            cmp w28, w23
            b.le bit1

            ldr x0, =bin0
            bl printf            

            b other

bit1:                                           // print 1
            ldr x0, =bin1
            bl printf

other:                                          // second case

            sub w22, w22, 1

            cmp w22, 0
            b.ge dec2Bin

            add w21, w21, 1
            cmp w21, 4
            b.lt hex2Bin

end:                                            // terminate the program
            ldr x0, =programEnd
            bl printf

            ldp x29, x30, [sp], 16
            ret

