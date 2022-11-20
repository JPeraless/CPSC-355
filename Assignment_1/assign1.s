	.arch armv8-a
	.file	"assign1.c"
	.text
	.align	2
	.global	randumNum
	.type	randumNum, %function
randumNum:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	str	w1, [sp, 24]
	bl	rand
	mov	w1, w0
	ldr	w2, [sp, 24]
	ldr	w0, [sp, 28]
	sub	w0, w2, w0
	add	w0, w0, 1
	sdiv	w2, w1, w0
	mul	w0, w2, w0
	sub	w1, w1, w0
	ldr	w0, [sp, 28]
	add	w0, w1, w0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	randumNum, .-randumNum
	.align	2
	.global	initialize
	.type	initialize, %function
initialize:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -48
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	wzr, [sp, 60]
	b	.L4
.L7:
	ldrsw	x0, [sp, 36]
	lsl	x2, x0, 2
	ldrsw	x0, [sp, 60]
	lsl	x0, x0, 3
	ldr	x1, [sp, 40]
	add	x19, x1, x0
	mov	x0, x2
	bl	malloc
	str	x0, [x19]
	str	wzr, [sp, 56]
	b	.L5
.L6:
	ldrsw	x0, [sp, 60]
	lsl	x0, x0, 3
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [sp, 56]
	lsl	x0, x0, 2
	add	x19, x1, x0
	mov	w1, 9
	mov	w0, 0
	bl	randumNum
	str	w0, [x19]
	ldr	w0, [sp, 56]
	add	w0, w0, 1
	str	w0, [sp, 56]
.L5:
	ldr	w1, [sp, 56]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	blt	.L6
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L4:
	ldr	w1, [sp, 60]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	blt	.L7
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	initialize, .-initialize
	.section	.rodata
	.align	3
.LC0:
	.string	"%d "
	.text
	.align	2
	.global	printMat
	.type	printMat, %function
printMat:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	wzr, [sp, 44]
	b	.L9
.L12:
	str	wzr, [sp, 40]
	b	.L10
.L11:
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [sp, 40]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	mov	w1, w0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L10:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L11
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L9:
	ldr	w1, [sp, 44]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L12
	nop
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	printMat, .-printMat
	.section	.rodata
	.align	3
.LC1:
	.string	"Digit %d occurs %d times\n"
	.align	3
.LC2:
	.string	"%d. In (%d,%d)\n"
	.align	3
.LC3:
	.string	"The digit %d is %d%% of the matrix\n"
	.text
	.align	2
	.global	displayStats
	.type	displayStats, %function
displayStats:
.LFB8:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	w0, [sp, 44]
	str	x1, [sp, 32]
	str	w2, [sp, 40]
	str	w3, [sp, 28]
	ldr	w2, [sp, 40]
	ldr	w1, [sp, 44]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	str	wzr, [sp, 60]
	b	.L14
.L15:
	ldr	w0, [sp, 60]
	add	w4, w0, 1
	ldrsw	x0, [sp, 60]
	lsl	x0, x0, 3
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldr	w2, [x0]
	ldrsw	x0, [sp, 60]
	lsl	x0, x0, 3
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	mov	w3, w0
	mov	w1, w4
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L14:
	ldr	w1, [sp, 60]
	ldr	w0, [sp, 40]
	cmp	w1, w0
	blt	.L15
	ldr	w1, [sp, 28]
	ldr	w0, [sp, 28]
	mul	w0, w1, w0
	ldr	w1, [sp, 40]
	sdiv	w0, w1, w0
	scvtf	s0, w0
	mov	w0, 1120403456
	fmov	s1, w0
	fmul	s0, s0, s1
	fcvtzs	w0, s0
	str	w0, [sp, 56]
	ldr	w2, [sp, 56]
	ldr	w1, [sp, 44]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	nop
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	displayStats, .-displayStats
	.align	2
	.global	search
	.type	search, %function
search:
.LFB9:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	str	x3, [sp, 8]
	str	wzr, [sp, 44]
	str	wzr, [sp, 40]
	b	.L17
.L21:
	str	wzr, [sp, 36]
	b	.L18
.L20:
	ldrsw	x0, [sp, 40]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 16]
	cmp	w1, w0
	bne	.L19
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w1, [sp, 40]
	str	w1, [x0]
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w1, [sp, 36]
	str	w1, [x0, 4]
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L19:
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L18:
	ldr	w1, [sp, 36]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L20
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L17:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L21
	ldr	w0, [sp, 44]
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	search, .-search
	.section	.rodata
	.align	3
.LC4:
	.string	"w"
	.align	3
.LC5:
	.string	"assign1.log"
	.text
	.align	2
	.global	logFile
	.type	logFile, %function
logFile:
.LFB10:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	w2, [sp, 32]
	str	x3, [sp, 24]
	str	w4, [sp, 20]
	adrp	x0, .LC4
	add	x1, x0, :lo12:.LC4
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	fopen
	str	x0, [sp, 56]
	str	wzr, [sp, 76]
	b	.L24
.L27:
	str	wzr, [sp, 72]
	b	.L25
.L26:
	ldrsw	x0, [sp, 76]
	lsl	x0, x0, 3
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [sp, 72]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	mov	w2, w0
	adrp	x0, .LC0
	add	x1, x0, :lo12:.LC0
	ldr	x0, [sp, 56]
	bl	fprintf
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L25:
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	blt	.L26
	ldr	x1, [sp, 56]
	mov	w0, 10
	bl	fputc
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L24:
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	blt	.L27
	ldr	w3, [sp, 20]
	ldr	w2, [sp, 32]
	adrp	x0, .LC1
	add	x1, x0, :lo12:.LC1
	ldr	x0, [sp, 56]
	bl	fprintf
	str	wzr, [sp, 68]
	b	.L28
.L29:
	ldr	w0, [sp, 68]
	add	w2, w0, 1
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	w3, [x0]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	mov	w4, w0
	adrp	x0, .LC2
	add	x1, x0, :lo12:.LC2
	ldr	x0, [sp, 56]
	bl	fprintf
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L28:
	ldr	w1, [sp, 68]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L29
	ldr	x0, [sp, 56]
	bl	fclose
	nop
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE10:
	.size	logFile, .-logFile
	.section	.rodata
	.align	3
.LC6:
	.string	"Please provide the table size as the argument"
	.align	3
.LC7:
	.string	"Enter a digit to search for: "
	.align	3
.LC8:
	.string	"%d"
	.align	3
.LC9:
	.string	"Do you want to [q]uit the program or [c]ontinue?"
	.align	3
.LC10:
	.string	" %c"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB11:
	.cfi_startproc
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	mov	x29, sp
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	str	w0, [x29, 172]
	str	x1, [x29, 160]
	ldr	w0, [x29, 172]
	cmp	w0, 2
	beq	.L31
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	puts
	mov	w0, 0
	bl	exit
.L31:
	ldr	x0, [x29, 160]
	add	x0, x0, 8
	ldr	x0, [x0]
	bl	atoi
	str	w0, [x29, 236]
	mov	x0, 0
	bl	time
	bl	srand
	b	.L32
.L34:
	mov	x0, sp
	str	x0, [x29, 104]
	ldr	w0, [x29, 236]
	uxtw	x1, w0
	sub	x1, x1, #1
	str	x1, [x29, 224]
	uxtw	x1, w0
	mov	x27, x1
	mov	x28, 0
	lsr	x1, x27, 58
	lsl	x20, x28, 6
	orr	x20, x1, x20
	lsl	x19, x27, 6
	uxtw	x1, w0
	str	x1, [x29, 144]
	str	xzr, [x29, 152]
	ldp	x2, x3, [x29, 144]
	mov	x1, x2
	lsr	x1, x1, 58
	mov	x4, x3
	lsl	x22, x4, 6
	orr	x22, x1, x22
	mov	x1, x2
	lsl	x21, x1, 6
	uxtw	x0, w0
	lsl	x0, x0, 3
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	sub	sp, sp, x0
	mov	x0, sp
	add	x0, x0, 7
	lsr	x0, x0, 3
	lsl	x0, x0, 3
	str	x0, [x29, 216]
	ldr	x0, [x29, 216]
	ldr	w1, [x29, 236]
	bl	initialize
	ldr	x0, [x29, 216]
	ldr	w1, [x29, 236]
	bl	printMat
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	add	x0, x29, 188
	mov	x1, x0
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	__isoc99_scanf
	ldr	w1, [x29, 236]
	ldr	w0, [x29, 236]
	mul	w0, w1, w0
	uxtw	x1, w0
	sub	x1, x1, #1
	str	x1, [x29, 208]
	uxtw	x1, w0
	str	x1, [x29, 128]
	str	xzr, [x29, 136]
	ldp	x2, x3, [x29, 128]
	mov	x1, x2
	lsr	x1, x1, 58
	mov	x4, x3
	lsl	x24, x4, 6
	orr	x24, x1, x24
	mov	x1, x2
	lsl	x23, x1, 6
	uxtw	x1, w0
	str	x1, [x29, 112]
	str	xzr, [x29, 120]
	ldp	x2, x3, [x29, 112]
	mov	x1, x2
	lsr	x1, x1, 58
	mov	x4, x3
	lsl	x26, x4, 6
	orr	x26, x1, x26
	mov	x1, x2
	lsl	x25, x1, 6
	uxtw	x0, w0
	lsl	x0, x0, 3
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	sub	sp, sp, x0
	mov	x0, sp
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, 200]
	ldr	x0, [x29, 216]
	ldr	w1, [x29, 236]
	ldr	w2, [x29, 188]
	ldr	x3, [x29, 200]
	bl	search
	str	w0, [x29, 196]
	ldr	w0, [x29, 188]
	ldr	x1, [x29, 200]
	ldr	w2, [x29, 236]
	mov	w3, w2
	ldr	w2, [x29, 196]
	bl	displayStats
	ldr	x0, [x29, 216]
	ldr	w1, [x29, 236]
	ldr	w2, [x29, 188]
	ldr	x3, [x29, 200]
	ldr	w4, [x29, 196]
	bl	logFile
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	add	x0, x29, 195
	mov	x1, x0
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	__isoc99_scanf
	ldr	x0, [x29, 104]
	mov	sp, x0
.L32:
	ldrb	w0, [x29, 195]
	cmp	w0, 113
	beq	.L33
	ldrb	w0, [x29, 195]
	cmp	w0, 81
	bne	.L34
.L33:
	mov	w0, 0
	mov	sp, x29
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.ident	"GCC: (GNU) 8.3.1 20190223 (Red Hat 8.3.1-2)"
	.section	.note.GNU-stack,"",@progbits
