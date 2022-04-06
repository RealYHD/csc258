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
    frogX: .byte 3 # start frog x position at 0 # byte for 127 to -128 values and display is technically 32 virtual pixels wide;
    frogY: .byte 15 # start frog y position at 0
    frogDirection: .byte 3 # start frog direction up.
    
    framebuffer: .word 0:4096 # 64 * 64
    
    # DRAW STATE
    draw_colour: .word 0x00ffffff # a pen colour for drawing.
    draw_x: .byte 0
    draw_y: .byte 0
.text
    main:
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
    	
    	game_loop:
   	    lb $t4, state
    	    bltz $t4, game_loop_e
    	    
    	    li $a0, 0
    	    li $a1, 0
    	    li $a2, 64
    	    li $a3, 64
    	    jal draw_rect
    	    
    	    jal draw_frame # call draw frame
        j game_loop # jump to start of game loop.
        
        
    

    	

    game_loop_e:
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
        li $v0, 10 # exits the program.
    
    draw_frame:
        # Draws the current framebuffer.
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
        
        li $t4, 0 # t4 = 0 for initialization
        lw $t9, dispAddr # loads display address to t9
        framebuffer_loop:
            add $t5, $zero, 16384 # load upper bound to t5 (= t6 = area of display)
            bge $t4, $t5, framebuffer_loop_e 
            
            la $t5, framebuffer # address of framebuffer
            add $t5, $t5, $t4 # t5 = framebuffer address + $t4 (t4 is the current index in the buffer)
            lw $t5, 0($t5) # load colour at t5
            add $t6, $t4, $t9 # t6 = $t4 + dispAddr
            sw $t5, 0($t6)
            addi $t4, $t4, 4  # $t4 = $t4 + 1
            j framebuffer_loop
        
        framebuffer_loop_e:
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
    	lb $t0, draw_x # t0 is supposed to be x pixel
    	lb $t1, draw_y # t1 is supposed to be y pixel
        lw $t2, draw_colour # load colour
        li $t4, 64 # load display width to $t4 (for use as constant) (64).
        la $t5, framebuffer # stores the display address at $t5

        
        mult $t1, $t4 # (y * width)
        mflo $t6 # store (y * width) in $t3
        add $t6, $t6, $t0 # $t6 = (y * width) + x; $t6 should now store current offset for pixel.
        sll $t6, $t6, 2 # t6 = 4((y * width) + x) to account for pixel depth.
        add $t6, $t6, $t5 # t6 = t6 + framebuffer address; t6 is now the memory location for the current pixel.
        
        sw $t2, 0($t6)
        
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
    
    draw_rect: # $a0 = width $a1 = height
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
    	add $t0, $zero, $a0 # Load parameters into temporaries. x
    	add $t1, $zero, $a1 # y
    	add $t2, $zero, $a2 # width
    	add $t3, $zero, $a3 # height
    	
    	# Initialize values
    	lb $t9, draw_colour
    	
    	# work
    	add $t5, $zero, $t1
    	draw_rect_y: # WHILE LOOP BEGIN
    	    add $t6, $t3, $t1 # t6 = height + initial y
    	    bge $t5, $t6 draw_rect_y_e 
    	    add $t4, $zero, $t0 # the current position
    	    draw_rect_x: # WHILE LOOP BEGIN
    	        add $t6, $t2, $t0 # t6 = width + initial x
    	        bge $t4, $t6, draw_rect_x_e 
                sb $t4, draw_x # x parameter.
                sb $t5, draw_y # y parameter
                jal draw_pixel 
    	        addi $t4, $t4, 1 # add 1
    	        j draw_rect_x # restart x loop.
    	    draw_rect_x_e: # WHILE LOOP END
    	        addi $t5, $t5, 1 # reduce y
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

    draw_frog:
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
        add $t0, $zero, $a0 # Load parameters into temporaries. # top left x
        add $t1, $zero, $a1 # top left position y
        add $t2, $zero, $a2 # rotation
        add $t3, $zero, $a3 # undefined
        
        lw $t9, frogColour
        sw $t9, draw_colour
        
        lb $t0, frogX
        lb $t1, frogY
        lb $t2, frogDirection
        
        
        
        sb $t0, draw_x # top left corner
        sb $t1, draw_y
        jal draw_pixel
            
        addi $t9, $t0, 3 # top right corner
        sb $t9, draw_x
        jal draw_pixel
        
        addi $t9, $t1, 3 # bottom right corner
        sb $t9, draw_y
        jal draw_pixel
        
        sb $t0, draw_x # bottom left corner
        jal draw_pixel
        
        beq $t2, 0, draw_frog_left
        beq $t2, 1, draw_frog_up
        beq $t2, 2, draw_frog_right
        beq $t2, 3, draw_frog_down
        
        draw_frog_left:
            
            addi $t9, $t0, 1 # bottom left +1 to right
            sb $t9, draw_x
            jal draw_pixel
            
            sb $t1, draw_y # top left +1 to right
            jal draw_pixel
            
            addi $a0, $t0, 1 # x
            addi $a1, $t1, 1 # y
            li $a2, 3 # width
            li $a3, 2 # height
            jal draw_rect
            
            j draw_frog_ret
            
        draw_frog_up:
            addi $t9, $t1, 1 # top left +1 down
            sb $t9, draw_y
            jal draw_pixel
            
            addi $t9, $t0, 3
            sb $t9, draw_x # top right +1 down
            jal draw_pixel
            
            addi $a0, $t0, 1 # x
            addi $a1, $t1, 1 # y
            li $a2, 2 # width
            li $a3, 3 # height
            jal draw_rect
            
            j draw_frog_ret
        draw_frog_right:
            addi $t9, $t0, 2 # bottom right +1 to left
            sb $t9, draw_x
            jal draw_pixel
            
            sb $t1, draw_y # top right +1 to left
            jal draw_pixel
            
            addi $a0, $t0, 0 # x
            addi $a1, $t1, 1 # y
            li $a2, 3 # width
            li $a3, 2 # height
            jal draw_rect
            
            j draw_frog_ret
        draw_frog_down:
            addi $t9, $t1, 2 # bottom left +1 up
            sb $t9, draw_y
            jal draw_pixel
            
            addi $t9, $t0, 3
            sb $t9, draw_x # bottom right +1 up
            jal draw_pixel
            
            addi $a0, $t0, 1 # x
            addi $a1, $t1, 0 # y
            li $a2, 2 # width
            li $a3, 3 # height
            jal draw_rect
            
            j draw_frog_ret
        
        draw_frog_ret: # Load previous temporaries and $ra. (FUNC FOOTER)
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
