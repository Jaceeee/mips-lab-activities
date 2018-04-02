##############################################################################
#
#  KURS: 1DT016 2014.  Computer Architecture
#	
# DATUM:
#
#  NAMN:			
#
#  NAMN:
#
##############################################################################

	.data
	
ARRAY_SIZE:
	.word	10	# Change here to try other values (less than 10)
FIBONACCI_ARRAY:
	.word	1, 1, 2, 3, 5, 8, 13, 21, 34, 55
STR_str:
	.asciiz "a nut for a jar of tuna"

	.globl DBG
	.text

##############################################################################
#
# DESCRIPTION:  For an array of integers, returns the total sum of all
#		elements in the array.
#
# INPUT:        $a0 - address to first integer in array.
#		$a1 - size of array, i.e., numbers of integers in the array.
#
# OUTPUT:       $v0 - the total sum of all integers in the array.
#
##############################################################################
integer_array_sum:
  

DBG:	##### DEBUGG BREAKPOINT ######

        addi    $v0, $zero, 0           # Initialize Sum to zero.
	add	$t0, $zero, $zero	# Initialize array index i to zero.
	
for_all_in_array:

	#### Append a MIPS-instruktion before each of these comments
	
	   #a0 has the first memory index
	   #a1 has the size of the array
	beq $t0, $a1, end_for_all
	# Done if i == N
	sll $t1, $t0, 2
	# 4*i
	add $t2, $a0, $t1
	# address = ARRAY + 4*i
	lw $t3, 0($t2)
	# n = A[i]
		add $v0, $v0, $t3
       	# Sum = Sum + n
       	addi $t0, $t0, 1
        # i++ 
    j for_all_in_array       
  	# next element
	
end_for_all:
	
	jr	$ra			# Return to caller.
	
##############################################################################
#
# DESCRIPTION: Gives the length of a string.
#
#       INPUT: $a0 - address to a NUL terminated string.
#
#      OUTPUT: $v0 - length of the string (NUL excluded).
#
#    EXAMPLE:  string_length("abcdef") == 6.
#
##############################################################################	
string_length:

	#### Write your solution here ####

	addi $v0, $zero, 0
	# set counter register 	
	lb $t0, 0($a0)
	#loads first character into $t0
	add $t1, $zero, 0
	#sets $t1 as comparison string (as NULL)

character_check:
	beq $t0, $t1, string_length_end
	#check if character loaded is a null terminator	
	addi $v0, $v0, 1
	# adding of 1 to length
	add $t2, $v0, $a0
	# set $t2 to be at the offset of the next character
	lb $t0, 0($t2)
	# loads character at current position, $v0	
	j character_check

string_length_end:

	jr	$ra
	
##############################################################################
#
#  DESCRIPTION: For each of the characters in a string (from left to right),
#		call a callback subroutine.
#
#		The callback suboutine will be called with the address of
#	        the character as the input parameter ($a0).
#	
#        INPUT: $a0 - address to a NUL terminated string.
#
#		$a1 - address to a callback subroutine.
#
##############################################################################	
string_for_each:

	addi	$sp, $sp, -4		# PUSH return address to caller
	sw	$ra, 0($sp)

	#### Write your solution here ####	
	addi $t1, $zero, 0
	#sets the NULL comparison
	lb $t0, 0($a0)
	#sets $t0 as the first character of string at $a0	

	string_for_each_innerloop:
		beq $t0, $t1, return_string
		# if null string is seen at $t0, jump to return_string
		addi $sp, $sp, -12
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $a0, 8($sp)		
		jal $a1
		# calls function

		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $a0, 8($sp)
		addi $sp, $sp, 12

		addi $a0, $a0, 1
		# moves the $a0 address by an offset of 1
		lb $t0, 0($a0)		
		# sets the $t0 to the current address of $a0
		j string_for_each_innerloop

	return_string:
	
	lw	$ra, 0($sp)		# Pop return address to caller
	addi	$sp, $sp, 4		

	jr	$ra

##############################################################################
#
#  DESCRIPTION: Transforms a lower case character [a-z] to upper case [A-Z].
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################		
to_upper:

	#### Write your solution here ####    
	lb $t2, 0($a0)
    addi $t1, $zero, 0	

    slti $t0, $t2, 97
    bne $t0, $t1, exit_from_to_upper

    start_inner_check:
	slti $t0, $t2, 123

	bne $t0, $t1, change_char
	j exit_from_to_upper

    change_char:
    	addi $t2, $t2, -32
    	sb $t2, 0($a0)

    exit_from_to_upper:
	jr	$ra

##############################################################################
#
#  DESCRIPTION: Takes the reverse of a string
#	
#        INPUT: $a0 - address of a string
#
##############################################################################		
reverse_string:
	addi $sp, $sp, -4
	sw $ra, 0($sp)	

	jal string_length
	#call procedure for string length
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	addi $t2, $a0, 0
	#$t2 will get pos 0
	add $t3, $a0, $v0	
    addi $t3, $t3, -1
    #$t3 will get pos at length-1
	
	addi $t5, $zero, 2	
	div $v0, $v0, $t5
	# divide v0 by 2 to get the midpoint of string
	addi $t7, $zero, 0
	#set comparison string
	mfhi $t6
	#get remainder from lo to $t6
	beq $t6, $t7, proceed
	#compare if the remainder of division is 0, meaning even
	#jump to pre-loop if even
	addi $v0, $v0, 1
	#else move the midpoint to the right of the quotient

	proceed:

    addi $t5, $zero, 0
    # set left hand counter to 0
    
    reverse_string_loop:
    	beq $v0, $t5, exit_from_reverse_string
    	addi $t5, $t5, 1
    	lb $t0, 0($t2)
    	lb $t1, 0($t3)
    	sb $t0, 0($t3)
    	sb $t1, 0($t2)
    	addi $t2, $t2, 1
    	addi $t3, $t3, -1
    	j reverse_string_loop

    exit_from_reverse_string:
	jr $ra
    

##############################################################################
##############################################################################
##
##	  You don't have to change anyghing below this line.
##	
##############################################################################
##############################################################################

	
##############################################################################
#
# Strings used by main:
#
##############################################################################

	.data

NLNL:	.asciiz "\n\n"
	
STR_sum_of_fibonacci_a:	
	.asciiz "The sum of the " 
STR_sum_of_fibonacci_b:
	.asciiz " first Fibonacci numbers is " 

STR_string_length:
	.asciiz	"\n\nstring_length(str) = "

STR_for_each_ascii:	
	.asciiz "\n\nstring_for_each(str, ascii)\n"

STR_for_each_to_upper:
	.asciiz "\n\nstring_for_each(str, to_upper)\n\n"	

STR_for_reverse_string:
	.asciiz "\n\nreverse_string(str)"

	.text
	.globl main

##############################################################################
#
# MAIN: Main calls various subroutines and print out results.
#
##############################################################################	
main:
	addi	$sp, $sp, -4	# PUSH return address
	sw	$ra, 0($sp)

	##
	### integer_array_sum
	##
	
	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_a
	syscall

	lw 	$a0, ARRAY_SIZE
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, STR_sum_of_fibonacci_b
	syscall
	
	la	$a0, FIBONACCI_ARRAY
	lw	$a1, ARRAY_SIZE
	jal 	integer_array_sum

	# Print sum
	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	li	$v0, 4
	la	$a0, NLNL
	syscall
	
	la	$a0, STR_str
	jal	print_test_string

	##
	### string_length 
	##
	
	li	$v0, 4
	la	$a0, STR_string_length
	syscall

	la	$a0, STR_str
	jal 	string_length

	add	$a0, $v0, $zero
	li	$v0, 1
	syscall

	##
	### string_for_each(string, ascii)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_ascii
	syscall
	
	la	$a0, STR_str
	la	$a1, ascii
	jal	string_for_each

	##
	### string_for_each(string, to_upper)
	##
	
	li	$v0, 4
	la	$a0, STR_for_each_to_upper
	syscall

	la	$a0, STR_str
	la	$a1, to_upper
	jal	string_for_each
	
	la	$a0, STR_str
	jal	print_test_string


	##
	### reverse_string(string)
	##

	li $v0, 4
	la $a0, STR_for_reverse_string
	syscall

	la $a0, STR_str
	jal reverse_string

	la $a0, STR_str
	jal print_test_string

	lw	$ra, 0($sp)	# POP return address
	addi $sp, $sp, 4	

	jr	$ra

##############################################################################
#
#  DESCRIPTION : Prints out 'str = ' followed by the input string surronded
#		 by double quotes to the console. 
#
#        INPUT: $a0 - address to a NUL terminated string.
#
##############################################################################
print_test_string:	

	.data
STR_str_is:
	.asciiz "str = \""
STR_quote:
	.asciiz "\""	

	.text

	add	$t0, $a0, $zero
	
	li	$v0, 4
	la	$a0, STR_str_is
	syscall

	add	$a0, $t0, $zero
	syscall

	li	$v0, 4	
	la	$a0, STR_quote
	syscall
	
	jr	$ra
	

##############################################################################
#
#  DESCRIPTION: Prints out the Ascii value of a character.
#	
#        INPUT: $a0 - address of a character 
#
##############################################################################
ascii:	
	.data
STR_the_ascii_value_is:
	.asciiz "\nAscii('X') = "

	.text

	la	$t0, STR_the_ascii_value_is

	# Replace X with the input character
	
	add	$t1, $t0, 8	# Position of X
	lb	$t2, 0($a0)	# Get the Ascii value
	sb	$t2, 0($t1)

	# Print "The Ascii value of..."
	
	add	$a0, $t0, $zero 
	li	$v0, 4
	syscall

	# Append the Ascii value
	
	add	$a0, $t2, $zero
	li	$v0, 1
	syscall


	jr	$ra
	