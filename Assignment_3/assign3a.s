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

                  // could get rid of this


              // could get rid of this



            .balign 4                                   // ensure instructions are aligned
            .global main                                // make the main label global

main:                                                   // save state, set registers, get user input

            stp x29, x30, [sp, -16]!                    // save state
            mov x29, sp                                 // save state

            mov x21, 0                                    // set x21 to 0
            mov x22, 0                            // set x22 to 0
            mov x23, 0                             // set x23 to 0

            ldr x0, =prompt                             // load prompt into x0
            bl printf                                   // prompt the user for x20

            ldr x0, =printInt                           // load getNum into x0
            ldr x1, =input                              // load input as an argument
            bl scanf                                    // should read it as a long integer
            ldr x20, input                                // load input into x20 (x20 is a decimal number)

checkSign:                                              // determine if x20 is negative or not

            cmp x20, 0                                    // compare x20 with 0
            b.gt posValue                               // branch to posValue if x20 > 0

negValue:                                               // if x20 is negative

            mvn x19, x20                                // negate x20 and put it into x19
            add x19, x19, 1                         // get the 2's complement

            b signOutput                                // branch to signOutput

posValue:                                               // if x20 is positive

            mov x19, x20                                // copy x20 into x19

signOutput:                                             // determine if the the output is positive or negative

            cmp x20, 0                                    // compare x20 with 0
            b.gt posSign                                // branch to posSign if x20 > 0

            ldr x0, =negPrefix                          // load negPrefix into x0
            bl printf                                   // print negPrefix, the output printed is negative

            b dec2Hex                                   // branch to dec2Hex

posSign:                                                // the output printed is positive

            ldr x0, =posPrefix                          // load hexPrefix into x0
            bl printf                                   // print hexPrefix

dec2Hex:                                                // done

            cmp x21, 16                                   // compare x21 with 16
            b.eq end                                    // if x21 == 16 branch to end

            add x21, x21, 1                                 // update x21

            bfxil x23, x19, 60, 4                // most significant nibble
            lsl x19, x19, 4                         // shift 4 bits out to the left

            cmp x23, 1                             // compare the nibble with 1
            b.lt hex0                                   // branch to hex0 if < 1
            b.eq hex1                                   

            cmp x23, 3                             // compare the nibble with 3
            b.lt hex2                                   // branch to hex2 if < 3
            b.eq hex3

            cmp x23, 5                             // compare the nibble with 5
            b.lt hex4                                   // branch to hex4 if < 5
            b.eq hex5

            cmp x23, 7                             // compare the nibble with 7
            b.lt hex6                                   // branch to hex6 if < 7
            b.eq hex7

            cmp x23, 9                             // compare the nibble with 9
            b.lt hex8                                   // branch to hex8 if < 9
            b.eq hex9

            cmp x23, 11                            // compare the nibble with 11
            b.lt hex10                                  // branch to hex10 if < 11
            b.eq hex11

            cmp x23, 13                            // compare the nibble with 13
            b.lt hex12                                  // branch to hex12 if < 13
            b.eq hex13

            cmp x23, 15                            // compare the nibble with 1
            b.lt hex14                                  // branch to hex14 if < 15
            b.eq hex15
            
hex0:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex1:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 1
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex2:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 2
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex3:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 3
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex4:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 4
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex5:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 5
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex6:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 6
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex7:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 7
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex8:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 8
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex9:
            ldr x0, =printInt                           // load printInt into x0
            mov x1, 9
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex10:
            ldr x0, =printA                             // load printA into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex11:
            ldr x0, =printB                             // load printB into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex12:
            ldr x0, =printC                             // load printC into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex13:
            ldr x0, =printD                             // load printD into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex14:
            ldr x0, =printE                             // load printE into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

hex15:
            ldr x0, =printF                             // load printF into x0
            bl printf

            b dec2Hex                                   // branch back to dec2Hex

end:                                                    // deallocate memory and restore state

            ldr x0, =programEnd                            // load newLine into x0
            bl printf                                   // print newLine

            ldp x29, x30, [sp], 16                      // restore state
            ret                                         // restore state
