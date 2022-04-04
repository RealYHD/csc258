#####################################################################
#
# CSC258H5S Winter 2022 Assembly Final Project
# University of Toronto, St. George
#
# Student: Harrison Deng, 1005845285
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 512
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. none yet.
#
# Any additional information that the TA needs to know:
# - Spent some time figuring out a good, general method for creating functions. These function creating procedure should be reusable without special tailoring to function.
# - Entites are currently static, frog has variables set up, but logs and vehicles don't yet. I want to be able to generate random intervals of logs which will require more boilerplate.
#####################################################################

.data
    dispAddr: .word 0x10008000 # Display address set in tools > bitmap display
    dispHeight: .byte 64 # Display height in virtual pixels origin at 0
    dispWidth: .byte 64 # Display width in virtual pixels origin at 0
    
    
    # TODO: perhaps look into any form of constants or pre-processing? These values technically don't change. May change for future levels?
    # GAME ENV. VARIABLES
    frogColour: .word 0x0042f557 # variable for the colour of the frog; light green # first 4 bytes ignored? starts interpretting from right?
    landColour: .word 0x00084d10 # variable for colour of land areas; dark green
    roadColour: .word 0x00959696 # variable for colour of road areas; gray
    riverColour: .word 0x000098d4 # variable for the colour of river areas; blue
    endColour: .word 0x00e5ff00 # variable for colour of end area; yellow-green
    vehicleColour: .word 0x00ff2e17 # variable for colour of vehicles; shade of red
    logColour : .word 0x00663300 # variable for colour of logs; shade of brown
    
    # GAME STATE
    # We can use this to track what state the game is in.
    # -1 will be exit state.
    # 0 will be designated the running state.
    # 1 will be designated the win state.
    state: .byte 0 # state tracker.
    
    # ENTITY VARIABLES
    frogX: .byte 28 # start frog x position at 0 # byte for 127 to -128 values and display is technically 32 virtual pixels wide;
    frogY: .byte 59 # start frog y position at 0
    
    # DRAW STATE
    colour: .word 0 # a pen colour for drawing.
.text
    main:
        j game_loop # jump to start of game loop. # only for convention purposes.
    
    game_loop:
        lb $t0, state # load state into $t0.
        addi $t1, $zero, -1 # load -1 to $t1.
        beq $t0, $t1, game_loop_e # exit the program if state is -1, otherwise, loop. WHILE LOOP BEGIN
    
        # TODO: keyboard input
        # TODO: entity updates
    
        # Draw background
        lw $t0, dispAddr # stores the display address at $t0

        lb $t8, dispWidth # load display width to $t8 (for use as constant) (128).
        addi $t9, $zero, 1 # load 1 to $t9
        addi $t7, $zero, 4 # load 4 to $t7
        
        lb $t2, dispHeight # load display height to $t1.
        sub $t2, $t2, $t9 # $t2=$t2-1 (127)
        
        lw $t4, landColour # set initial colour to land.
        bg_loop_y: 
            bltz $t2, bg_loop_y_e # exits y loop if $t2 is less than 0; WHILE LOOP BEGIN
            add $t1, $t8, $zero # load display width to $t1 from register
            sub $t1, $t1, $t9 # $t1=$t1-1 (127)
            
            addi $t5, $zero, 51 # load 51
            beq $t5, $t2, road # Change colour to road colour if at 51th pixel row 
            addi $t5, $zero, 35 # load 35
            beq $t5, $t2, land # Change colour to land colour if at 35th pixel row 
            addi $t5, $zero, 31 # load 31
            beq $t5, $t2, river # Change colour to river colour if at 31th pixel row 
            addi $t5, $zero, 11 # load 11
            beq $t5, $t2, land # Change colour to land colour if at 11th pixel row
            
            j bg_loop_x # otherwise, jump to looping, preserve previous colour.
            
            road: 
                lw $t4, roadColour # load road colour
                j bg_loop_x # exit
            river: 
                lw $t4, riverColour # load river colour
                j bg_loop_x # exit
            land: 
                lw $t4, landColour # load land colour
                j bg_loop_x # exit
                
            bg_loop_x:
                sw $t4, colour 
                bltz $t1, bg_loop_x_e # exits x loop if $t1 is less than 0; WHILE LOOP BEGIN
                add $a0, $zero, $t1 # x parameter.
                add $a1, $zero, $t2 # y parameter
                jal draw_pixel 
                
                sub $t1, $t1, $t9 # subtract 1 from current width;
                j bg_loop_x # jump back to loop start.
            bg_loop_x_e: 
                sub $t2, $t2, $t9 # subtract 1 from current height; starts from bottom. # WHILE LOOP END
                j bg_loop_y # jump back to loop start.
        bg_loop_y_e:
            
            # Draw frog
            lb $t1, frogX # load frog x
            lb $t2, frogY # load frog y
            lw $t4, frogColour # load frog colour
            sw $t4, colour # set colour.
            
            add $a0, $zero, $t1 # set parameter x to frog x.
            add $a1, $zero, $t2 # set parameter y to frog y.
            addi $a2, $zero, 4 # set paramter width to 4.
            addi $a3, $zero, 4 # set paramter height to 4.
            jal draw_rect
            
            # Draw vehicle 1 and 2 row 1
            lw $t4, vehicleColour # load vehicle colour
            sw $t4, colour # set colour.
            
            addi $a0, $zero, 1 # set parameter x to log x.
            addi $a1, $zero, 45 # set parameter y to y y.
            addi $a2, $zero, 6 # set paramter width to 6.
            addi $a3, $zero, 3 # set paramter height to 3.
            jal draw_rect
            
            addi $a0, $zero, 24 # set parameter x to log x.
            addi $a1, $zero, 45 # set parameter y to y y.
            addi $a2, $zero, 6 # set paramter width to 6.
            addi $a3, $zero, 3 # set paramter height to 3.
            jal draw_rect

            # Draw vehicle 1 and 2 row 2
            lw $t4, vehicleColour # load vehicle colour
            sw $t4, colour # set colour.
            
            addi $a0, $zero, 8 # set parameter x
            addi $a1, $zero, 39 # set parameter y
            addi $a2, $zero, 6 # set paramter width
            addi $a3, $zero, 3 # set paramter height
            jal draw_rect
            
            addi $a0, $zero, 31 # set parameter x
            addi $a1, $zero, 39 # set parameter y
            addi $a2, $zero, 6 # set paramter width
            addi $a3, $zero, 3 # set paramter height
            jal draw_rect
            
            # Draw log 1 and log 2 row 1
            lw $t4, logColour # load vehicle colour
            sw $t4, colour # set colour.
            
            addi $a0, $zero, 10 # set parameter x
            addi $a1, $zero, 14 # set parameter y
            addi $a2, $zero, 8 # set paramter width
            addi $a3, $zero, 2 # set paramter height
            jal draw_rect
            
            addi $a0, $zero, 32 # set parameter x
            addi $a1, $zero, 14 # set parameter y
            addi $a2, $zero, 8 # set paramter width
            addi $a3, $zero, 2 # set paramter height
            jal draw_rect
            
            # Draw log 1 and log 2 row 2
            lw $t4, logColour # load vehicle colour
            sw $t4, colour # set colour.
            
            addi $a0, $zero, 20 # set parameter x
            addi $a1, $zero, 18 # set parameter y
            addi $a2, $zero, 8 # set paramter width
            addi $a3, $zero, 2 # set paramter height
            jal draw_rect
            
            addi $a0, $zero, 42 # set parameter x
            addi $a1, $zero, 18 # set parameter y
            addi $a2, $zero, 8 # set paramter width
            addi $a3, $zero, 2 # set paramter height
            jal draw_rect
            
            # Sleep, refresh 60hz
            li $v0, 32
            li $a0, 10
            syscall
            
            j game_loop # restarts the game loop. # WHILE LOOP END
    game_loop_e: 
        li $v0, 10 # exits the program. WHILE LOOP END
    
    # functions
    draw_pixel:  # $a0 = x, $a1 = y
        # Load everything onto stack. (FUNC HEADER)
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    	addi $sp, $sp, -4
    	sw $t1, 0($sp)
    	addi $sp, $sp, -4
    	sw $t2, 0($sp)
    	addi $sp, $sp, -4
    	sw $t3, 0($sp)
    	addi $sp, $sp, -4
    	sw $t4, 0($sp)
    	addi $sp, $sp, -4
    	sw $t5, 0($sp)
    	addi $sp, $sp, -4
    	sw $t6, 0($sp)
    	addi $sp, $sp, -4
    	sw $t7, 0($sp)
    	addi $sp, $sp, -4
    	sw $t8, 0($sp)
    	addi $sp, $sp, -4
    	sw $t9, 0($sp)
    	add $t0, $zero, $a0 # Load parameters into temporaries.
    	add $t1, $zero, $a1
    	add $t2, $zero, $a2
    	add $t3, $zero, $a3
    	
    	# Initialize values
        addi $t4, $zero, 4 # set $t4 = 4
        lb $t5, dispWidth # load display width to $t8 (for use as constant) (128).
        lw $t6, dispAddr # stores the display address at $t0
        lw $t8, colour # load colour
        
        mult $t1, $t5 # (y * width)
        mflo $t7 # store (y * width) in $t3
        add $t7, $t7, $t0 # $t3 = (y * width) + x; $t3 should now store current offset for pixel.
        mult $t7, $t4 # lo = 4((y * width) + x) to account for pixel depth.
        mflo $t7 # t3 = 4((y * width) + x)
        add $t7, $t7, $t6 # t3 = t3 + dispAddr; t3 is now the memory location for the current pixel.
        
        sw $t8, 0($t7)
        
        # Load previous temporaries and $ra. (FUNC FOOTER)
    	lw $t9, 0($sp)
    	addi $sp, $sp, 4
    	lw $t8, 0($sp)
    	addi $sp, $sp, 4
    	lw $t7, 0($sp)
    	addi $sp, $sp, 4
    	lw $t6, 0($sp)
    	addi $sp, $sp, 4
    	lw $t5, 0($sp)
    	addi $sp, $sp, 4
    	lw $t4, 0($sp)
    	addi $sp, $sp, 4
    	lw $t3, 0($sp)
    	addi $sp, $sp, 4
    	lw $t2, 0($sp)
    	addi $sp, $sp, 4
    	lw $t1, 0($sp)
    	addi $sp, $sp, 4
    	lw $t0, 0($sp)
    	addi $sp, $sp, 4
    	lw $ra, 0($sp)
        addi $sp, $sp, 4
        jr $ra # return to call position.
    
    draw_rect: # $a0 = x $a1 = y $a2 = width $a3 = height
        # Load everything onto stack. (FUNC HEADER)
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	addi $sp, $sp, -4
    	sw $t0, 0($sp)
    	addi $sp, $sp, -4
    	sw $t1, 0($sp)
    	addi $sp, $sp, -4
    	sw $t2, 0($sp)
    	addi $sp, $sp, -4
    	sw $t3, 0($sp)
    	addi $sp, $sp, -4
    	sw $t4, 0($sp)
    	addi $sp, $sp, -4
    	sw $t5, 0($sp)
    	addi $sp, $sp, -4
    	sw $t6, 0($sp)
    	addi $sp, $sp, -4
    	sw $t7, 0($sp)
    	addi $sp, $sp, -4
    	sw $t8, 0($sp)
    	addi $sp, $sp, -4
    	sw $t9, 0($sp)
    	add $t0, $zero, $a0 # Load parameters into temporaries.
    	add $t1, $zero, $a1
    	add $t2, $zero, $a2
    	add $t3, $zero, $a3
    	
    	# Initialize values
    	addi $t4, $zero, 1 # initialize 1 value.
    	add $t5, $t1, $t3 # $t5 = current y position
    	
    	# work
    	draw_rect_y: # WHILE LOOP BEGIN
    	    blt $t5, $t1 draw_rect_y_e 
    	    add $t6, $t0, $t2 # $t6 = current x position
    	    draw_rect_x: # WHILE LOOP BEGIN
    	        blt $t6, $t0, draw_rect_x_e 
                add $a0, $zero, $t6 # x parameter.
                add $a1, $zero, $t5 # y parameter
                jal draw_pixel 
    	        sub $t6, $t6, $t4 # reduce y
    	        j draw_rect_x # restart x loop.
    	    draw_rect_x_e: # WHILE LOOP END
    	        sub $t5, $t5, $t4 # reduce y
    	        j draw_rect_y # restart y loop.
    	draw_rect_y_e: # WHILE LOOP END
    	# Load previous temporaries and $ra. (FUNC FOOTER)
            lw $t9, 0($sp)
            addi $sp, $sp, 4
            lw $t8, 0($sp)
            addi $sp, $sp, 4
            lw $t7, 0($sp)
            addi $sp, $sp, 4
            lw $t6, 0($sp)
            addi $sp, $sp, 4
            lw $t5, 0($sp)
            addi $sp, $sp, 4
            lw $t4, 0($sp)
            addi $sp, $sp, 4
            lw $t3, 0($sp)
            addi $sp, $sp, 4
            lw $t2, 0($sp)
            addi $sp, $sp, 4
            lw $t1, 0($sp)
            addi $sp, $sp, 4
            lw $t0, 0($sp)
            addi $sp, $sp, 4
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra # return to call position.
        