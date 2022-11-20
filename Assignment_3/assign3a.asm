/*
Author: Jose Perales
UCID:   30143354
Tut:    02
*/

            .data                                       // .data section of the code
input:      .dword 0                                    // declare input as a long integer

            .text

prompt:     .string "Please enter N: "                  // string to prompt the user to enter N
printInt:   .string "%ld"                               // string to print an integer
posPrefix:  .string "\nThe hex value is:\n0x"           // positive string to print the hex value
negPrefix:  .string "\nThe hex value is:\n-0x"          // negative string to print the hex value
printA:     .string "A"                                 // string to print A
printB:     .string "B"                                 // string to print B
printC:     .string "C"                                 // string to print C
printD:     .string "D"                                 // string to print D
printE:     .string "E"                                 // string to print E
printF:     .string "F"                                 // string to print F
programEnd: .string "\n\n"                              // string to print a newLine char

define(pos_N, x19)                                      // define register x19 as pos_N
define(N, x20)                                          // define register x20 as N
define(i, x21)                                          // define register x21 as i
define(nibble_N, x22)                                   // define register x22 as nibble_N

            .balign 4                                   // ensure instructions are aligned
            .global main                                // make the main label global

main:                                                   // save state, set registers, get user input

            stp x29, x30, [sp, -16]!                    // save state
            mov x29, sp                                 // save state

            mov i, 0                                    // set i to 0
            mov nibble_N, 0                             // set nibble_N to 0

            ldr x0, =prompt                             // load prompt into x0
            bl printf                                   // prompt the user for N

            ldr x0, =printInt                           // load getNum into x0
            ldr x1, =input                              // load input as an argument
            bl scanf                                    // should read it as a long integer
            ldr N, input                                // load input into N (N is a decimal number)

checkSign:                                              // determine if N is negative or not

            cmp N, 0                                    // compare N with 0
            b.gt posValue                               // branch to posValue if N > 0

negValue:                                               // if N is negative

            mvn pos_N, N                                // negate N and put it into pos_N
            add pos_N, pos_N, 1                         // get the 2's complement

            b signOutput                                // branch to signOutput

posValue:                                               // if N is positive

            mov pos_N, N                                // copy N into pos_N

signOutput:                                             // determine if the the output is positive or negative

            cmp N, 0                                    // compare N with 0
            b.gt posSign                                // branch to posSign if N > 0

            ldr x0, =negPrefix                          // load negPrefix into x0
            bl printf                                   // print negPrefix, the output printed is negative

            b dec2Hex                                   // branch to dec2Hex

posSign:                                                // the output printed is positive

            ldr x0, =posPrefix                          // load hexPrefix into x0
            bl printf                                   // print hexPrefix

dec2Hex:                                                // convert each nibble in N to its hex representation

            cmp i, 16                                   // compare i with 16
            b.eq end                                    // if i == 16 branch to end

            add i, i, 1                                 // update i

            bfxil nibble_N, pos_N, 60, 4                // most significant nibble
            lsl pos_N, pos_N, 4                         // shift 4 bits out to the left

            cmp nibble_N, 1                             // compare the nibble with 1
            b.lt hex0                                   // branch to hex0 if nibble_N < 1
            b.eq hex1                                   // branch to hex1 if nibble_N == 1   

            cmp nibble_N, 3                             // compare the nibble with 3
            b.lt hex2                                   // branch to hex2 if nibble_N < 3
            b.eq hex3                                   // branch to hex3 if nibble_N == 3

            cmp nibble_N, 5                             // compare the nibble with 5
            b.lt hex4                                   // branch to hex4 if nibble_N < 5
            b.eq hex5                                   // branch to hex5 if nibble_N == 5

            cmp nibble_N, 7                             // compare the nibble with 7
            b.lt hex6                                   // branch to hex6 if nibble_N < 7
            b.eq hex7                                   // branch to hex7 if nibble_N == 7

            cmp nibble_N, 9                             // compare the nibble with 9
            b.lt hex8                                   // branch to hex8 if nibble_N < 9
            b.eq hex9                                   // branch to hex9 if nibble_N == 9

            cmp nibble_N, 11                            // compare the nibble with 11
            b.lt hex10                                  // branch to hex10 if nibble_N < 11
            b.eq hex11                                  // branch to hex11 if nibble_N == 11

            cmp nibble_N, 13                            // compare the nibble with 13
            b.lt hex12                                  // branch to hex12 if nibble_N < 13
            b.eq hex13                                  // branch to hex13 if nibble_N == 13

            cmp nibble_N, 15                            // compare the nibble with 1
            b.lt hex14                                  // branch to hex14 if nibble_N < 15
            b.eq hex15                                  // branch to hex15 if nibble_N == 15
            
hex0:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 0                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex1:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 1                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex2:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 2                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex3:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 3                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex4:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 4                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex5:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 5                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex6:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 6                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex7:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 7                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex8:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 8                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex9:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 9                                   // pass an int as an argument
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex10:
            ldr x0, =printA                             // load printA into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex11:
            ldr x0, =printB                             // load printB into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex12:
            ldr x0, =printC                             // load printC into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex13:
            ldr x0, =printD                             // load printD into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex14:
            ldr x0, =printE                             // load printE into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

hex15:
            ldr x0, =printF                             // load printF into x0
            bl printf                                   // print the string

            b dec2Hex                                   // branch back to dec2Hex

end:                                                    // deallocate memory and restore state

            ldr x0, =programEnd                         // load newLine into x0
            bl printf                                   // print newLine

            ldp x29, x30, [sp], 16                      // restore state
            ret                                         // restore state
