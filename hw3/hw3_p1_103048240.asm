.data
Ask_a:  .asciiz  "input a: "
Ask_b:  .asciiz  "input b: "
Ask_c:  .asciiz  "input c: "
Result:  .asciiz  "result = "
.text

Main:
  la $a0, Ask_a	  #print message of input a
  li $v0, 4
  syscall
  li $v0, 5	  #do scanf
  syscall      
  move $s0, $v0   #store a in $s0
  la $a0, Ask_b	  #print message of input b
  li $v0, 4
  syscall
  li $v0, 5 	  #do scanf
  syscall      
  move $s1, $v0	  #store b in $s1
  la $a0, Ask_c	  #print message of input c
  li $v0, 4	
  syscall
  li $v0, 5       #do scanf
  syscall      
  move $s2, $v0   #store c in $s2
  jal Power_Square1
  jal Add
  move $s3,$v1
  
  la $a0, Result  #print result message
  li $v0, 4
  syscall
  li $v0, 1       #show result
  move $a0,$s3
  syscall
  j Exit
  
 Add:
  move $a0,$s1
  move $a1,$v0
  add $t7,$a0,$a1  #x+y   
  add $v1,$0,$t7   #save return value  
  jr $ra           #return
 
Power_Square1:     
  add $a2,$0,$s0
  add $a3,$0,$s2
  addi $a3,$a3,1
  slt  $t0,$a2,$a3 #x<=y?
  subi $a3,$a3,1
  beq  $t0,1,Set1
  move $t1,$a3     #a = y
  addi $a2,$a2,1
  slt  $t2,$a3,$a2 #x>=y?
  subi $a2,$a2,1
  beq  $t2,1,Set2
  move $t3,$a3     #b = y
  add  $t4,$0,$t1  #$t4 is a counter of computing pow
  add  $t6,$0,$t1 
  j    Power_Square2

Set1:
  move $t1,$a2     #a = x
  addi $a2,$a2,1
  slt  $t2,$a3,$a2 #x>=y?
  subi $a2,$a2,1
  beq  $t2,1,Set2 
  move $t3,$a3     #b = y
  add  $t4,$0,$t1  #$t4 is a counter of computing pow
  add  $t6,$0,$t1  #need origin value to do pow
  j    Power_Square2

Set2:
  move $t3,$a2    #b = x
  add  $t4,$0,$t1 #$t4 is a counter of computing pow
  add  $t6,$0,$t1 
  j    Power_Square2

Power_Square2:      
  mul  $t1,$t1,$t6         #pow
  beq  $t4,2,Power_Square3
  subi $t4,$t4,1           #pow(a,a) means a need to mul itself for a-1 times
  j    Power_Square2
    
Power_Square3:    
    mul  $t5,$t3,$t3       #square
    add  $v0,$t1,$t5
    jr $ra                 #return

Exit:
  li   $v0, 10
  syscall
