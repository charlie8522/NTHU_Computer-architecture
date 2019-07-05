.data

# Define some string data
Pprompt:      .asciiz  "Please enter a 2-digit number (10~99): "
Pt0:          .asciiz  "$t0 = "
PisNot2Digit: .asciiz  " is NOT a 2-digit number!\n"
Pboom:        .asciiz  " is BOOMED!\n"
PnoBoom:      .asciiz  " is not boomed.\n"

.text
_Start:
  # Prompt the user to enter int
  la $a0, Pprompt	  
  li $v0, 4
  syscall
  # Get the int and store in $t0
  li $v0, 5 
  syscall      
  move $t0, $v0
  # If $t0 == 0, goto _Exit
  beq  $t0,$zero,_Exit
  # If $t0 < 10 || $t0 > 99, goto _Not2Digit
  #because t0~t4 have been used,so counters starts from t5 
  slti $t5,$t0,10
  beq  $t5,1,_Not2Digit
  slti $t6,$t0,100
  beq  $t6,$zero,_Not2Digit
  add $t4,$t4,$0 # $t4 = 0
  addi $t3,$zero,3# $t3 = 3
  addi $t8,$zero,10 # $t1 = $t0 % 10  && t2 = $t0 / 10  && Use div +
  div  $t0,$t8
  mfhi $t1 # mflo to find a/b
  mflo $t2 # mfhi to find a%b
  
_WhileInner:
  # If $t3 <= 0, goto _Result
  slti $t7,$t3,1
  beq  $t7,1,_Result
  # $t4 = $t1 + $t2
  add $t4,$t1,$t2
  # If $t4 > 10, goto _Result
  slti $s1,$t4,10
  beq  $s1,$zero,_Result
  sll  $t1,$t1,1    #$t1 = $t1 << 1
  addi $s5,$zero,10 #$t1 = $t1 % 10
  div  $t1,$s5 
  mfhi $t1
  srl  $t2,$t2,1   #$t2 = $t2 >> 1,
  addi $t3,$t3,-1  #$t3 = $3 - 1
  j    _WhileInner #go back _WhileInner
  
_Result:
  # If $t4 > 10, goto _IsBoom
  slti $t9,$t4,11
  beq  $t9,$zero,_IsBoom
  # Else show the msg that $t0 is not boom state and goto _Start
  la $a0, Pt0	  
  li $v0, 4
  syscall
  li $v0, 1 
  move $a0, $t0 
  syscall
  la $a0, PnoBoom	  
  li $v0, 4
  syscall
  j _Start
 
_Not2Digit:
  # Show the msg that $t0 is NOT 2-digit and goto _Start
  la $a0, Pt0	  
  li $v0, 4
  syscall
  li $v0, 1 
  move $a0, $t0 
  syscall
  la $a0, PisNot2Digit	  
  li $v0, 4
  syscall
  j _Start

_IsBoom:
  # Show the msg that $t0 is boom and goto _Start
  la $a0, Pt0	  
  li $v0, 4
  syscall
  li $v0, 1 
  move $a0, $t0 
  syscall
  la $a0, Pboom	  
  li $v0, 4
  syscall
  j _Start

_Exit:
  li   $v0, 10
  syscall
