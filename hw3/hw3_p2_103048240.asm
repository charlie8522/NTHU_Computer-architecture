.data
Ask_a:  .asciiz  "input a: "
Ask_b:  .asciiz  "input b: "
Ans:    .asciiz  "ans: "
Pnewline: .asciiz "\n"
.text

Main:
  la   $a0, Ask_a #print message of input a
  li   $v0, 4
  syscall
  li   $v0, 5	  #do scanf
  syscall      
  move $s0, $v0   #store a in $s0
  la   $a0, Ask_b #print message of input b
  li   $v0, 4
  syscall
  li   $v0, 5 	  #do scanf
  syscall      
  move $s1, $v0	  #store b in $s1
  
  move $a0,$s0
  move $a1,$s1
  jal  Fn_Fact
  move $s3,$v0
  la   $a0, Ans   #print result message
  li   $v0, 4
  syscall
  li   $v0, 1     #show result
  move $a0, $s3
  syscall
  
  jal PrintNewline
  
  move $a2,$s0
  jal  Re_Fact
  add  $s3,$s3,$v0
  la   $a0, Ans   #print result message
  li   $v0, 4
  syscall
  li   $v0, 1     #show result
  move $a0, $s3
  syscall
  j    Exit
  
Fn_Fact:   
  addi $sp,$sp,-12  #adjust stack and store 3 items
  sw   $a0,8($sp)
  sw   $a1,4($sp)
  sw   $ra,0($sp)
  slti $t0,$a0,1   #x<=0
  beq  $t0,1,Re0
  slti $t1,$a1,1   #y<=0
  beq  $t1,1,Re0  
  slt  $t2,$a0,$a1 #x<y
  beq  $t2,1,Re1
  j    Fn_L1
  
Fn_L1: 
  subi $a0,$a0,1  #x=x-1
  jal  Fn_Fact
  add  $t4,$v0,$0 #save return value =  fn(x-1, y)
  lw   $ra,0($sp) #restore value and address
  lw   $a1,4($sp)
  lw   $a0,8($sp)  
  
  addi $a1,$a1,2  #y=y+2
  jal  Fn_Fact
  add  $t5,$v0,$0 #save return value = fn(x, y+2)
  sll  $t5,$t5,1  #2*fn(x,y+2)
  lw   $ra,0($sp) #restore
  lw   $a1,4($sp)
  lw   $a0,8($sp) 
  addi $sp,$sp,12 #pop 3 items
 
  add  $t5,$t5,$a1 #+y
  add  $v0,$t4,$t5 #total = fn(x-1, y) + 2 * fn(x, y+2) + y
  jr   $ra         #return
    
Re0:  
  move $v0,$0      #return 0
  lw   $ra,0($sp)  #restore saved calue and adress
  lw   $a1,4($sp)
  lw   $a0,8($sp)  
  addi $sp,$sp,12  #pop 2 items
  jr   $ra         #return

Re1:
  addi $v0,$0,1    #return 1
  lw   $ra,0($sp)  #restore saved calue and adress
  lw   $a1,4($sp)
  lw   $a0,8($sp)  
  addi $sp,$sp,12  #pop 2 items
  jr   $ra         #return
  
Re_Fact:
  addi $sp,$sp,-8  #adjust stack and store 2 items
  sw   $a2,4($sp)
  sw   $ra,0($sp)
  slti $t3,$a2,1  #x>0?
  beq  $t3,0,Re_L1 
  move $v0,$0     #return 0
  addi $sp,$sp,8  #pop 2 items
  jr   $ra        #return
  
Re_L1: 
  subi $a2,$a2,1  #x=x-1
  jal  Re_Fact
  move $t4,$v0    #save return value
  addi $v0,$t4,1  #+1
  lw   $ra,0($sp) #restore value and address
  lw   $a2,4($sp)
  addi $sp,$sp,8  #pop 2 items
  jr   $ra        #return

PrintNewline:
  la $a0, Pnewline 
  li $v0, 4	 
  syscall	        
  jr $ra           

Exit:
  li   $v0, 10
  syscall