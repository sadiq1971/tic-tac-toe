.Model Small
.Stack 100h
.Data 
    r dw 60 
    c dw 40
    r1 dw 60
    r2 dw  120
    r3 dw  180
    r4 dw  240
    c1 dw  40
    c2 dw 80
    c3 dw  120
    c4 dw  160
    POS dw 1
    box db ?,-1,-1,-1,-1,-1,-1,-1,-1,-1
    xpos db ?,7,7,7,12,12,12,17,17,17
    ypos db ? ,11,18,25,11,18,25,11,18,25
    upto dw ?
    start  db 'PLAYER 1 "X"   AND   PLAYER 2 "O" $'
    cstart  db 'PLAYER 1 "X"   AND  COMPUTER  "O" $'  
    print1 db 'Turn: Player 1   $' 
    print2 db 'Turn: Player 2   $'
    winner1 db 'Winner: Player 1 $'
    winner2 db 'Winner: Player 2 $'
    cWinner db 'Winner: Computer $'  
    drawp   db 'Match  Draw      $' 
    playagaintext db   'press any button to continue $'
    turn db 1  
    count db 0
    Pw1 db 0
    Pw2 db 0
    Pw1_t db 'P1 won:$'
    Pw2_t db 'P2 won:$'  
    cw_t  db 'C  won:$'
    WD db '      Match Tie!!!!!       $' 
    W1 db 'Player 1 has won the Game! $'
    W2 db 'Player 2 has won the Game! $' 
    cW db 'Computer has won the Game! $'  
    con db '  Press Any Key to exit   $'    
    MODET db '     Press 1 for Single Player,',0DH,0AH,'      Press 2 for double Player$' 
    
    mode db ? 
    i dw 0
    i1 dw 0
    i2 dw 0
    i3 dw 0
    
    cwinf db 0  
    
    level db 0
    level_text db  'level:easy   (Press 1)',0dh,0ah ,'       level:normal (Press 2)',0dh,0ah, '       level:hard   (Press 3)$'
   

.code
    main Proc  
       
           
    playAgain:    
    mov ax,@data
    mov ds,ax 
    
   
        
   
    MOV AX,13h
    INT 10h    
     
    
    cmp count,0
    je HERE
    cmp count,0
    jne GO_Start
    HERE:
    MOV DX,0101H ; showing string 
    CALL MOVE 
    lea dx,MODET
    call show 
    mov ah,1
    int 21h 
    mov mode,al 
    sub mode,30h
    MOV AX,13h
    INT 10h  
    cmp mode,2
    je p2:
    mov dl,7
    mov dh,10
    call move
    lea dx,level_text
    call show 
    mov ah,1
    int 21h
    mov level,al
    sub level,30h
    
    MOV AX,13h
    INT 10h  
    p2: 
    Go_Start: 
    MOV DX,0101H ; showing string 
    CALL MOVE    
    
    
    
    
    
    ;;;;;;;;;;;;
    MOV AL,0ch  
    cmp mode,1 
    je  startText 
    cmp mode,2  
    je endStartText 
      
    startText:  
    LEA DX,cSTART 
    jmp e1:
    endStartText: 
    LEA DX,START 
    
    e1:
    CALL SHOW
    ;;;;;;;;;;;;;
    
    call displayPlayerWin
    
    call outerbox
     
    CALL PrintTurn  
   
    
 
    MOV AH, 0CH
    MOV AL, 7
    call innerbox
    call game
    
    lea si,box    
    

    
    MOV AX, 3
    INT 10h
    MOV AH, 4CH
    INT 21h
    RET
    MAIN ENDP
    
    game PROC 
     begin:
     mov ah,0
     int 16h
     
     cmp ah,72
     je up
     cmp ah,45
     JE xpress
     cmp ah,24
     JE ypress 
     cmp ah,77
     je right
     cmp ah,75
     je left
     cmp ah,80
     JE beforedown
     JMP begin
     
    RIGHT:
    CMP r,180
    JE begin
    ADD POS,1
    MOV AH,0CH
    MOV AL,4
    CALL innerbox
    ADD r,60
    MOV AH,0CH
    MOV AL,7
    CALL innerbox  
    JMP begin
    LEFT:
    CMP r,60
    JE begin 
    SUB POS,1
    MOV AH,0CH
    MOV AL,4
    CALL innerbox
    sub r,60
    MOV AH,0CH
    MOV AL,7
    CALL innerbox
    JMP begin
    
    xpress:
    JMP xx
    ypress:
    JMP oo
    beforedown:
    jmp down
    
    UP:
    CMP c,40
    JE last
    SUB POS,3
    MOV AH,0CH
    MOV AL,4
    CALL innerbox
    sub c,40
    MOV AH,0CH
    MOV AL,7
    CALL innerbox 
    JMP last
    
    down:
    cmp c,120
    je last
    ADD POS,3
    MOV AH,0CH
    MOV AL,4
    CALL innerbox
    ADD c,40
    MOV AH,0CH
    MOV AL,7
    CALL innerbox
    JMP last 
    
    
    xx:   
    cmp mode,1
    je  computer
    cmp mode,2
    je  player
    
    computer:
    CALL cSETX 
    jmp go_down
    player:
    call SETX 
    jmp go_down
     
    go_down: 
    mov turn,2 
    call PrintTurn
          
    call  CheackWinner
    JMP begin
    oo:  
    
    CALL SET0  
    mov turn,1   
    call PrintTurn  
    call  CheackWinner
    JMP begin
    last:
    JMP begin
    RET
    game ENDP
   
    
    
    ;;;;; hjfvhfvhbvhjfbjrj
    

          
          
          
    cSETX PROC
     
    mov si,pos
    cmp box[si],-1
    jne step3
    mov box[si],1 
    
    MOV DH,xpos[si]
    
    MOV DL,ypos[si]
    lea si,box
    
    MOV AH, 02
    MOV BH, 0
    INT 10H    
    MOV AH, 9
    MOV AL, 'X'
    MOV BL,13  
    MOV CX, 1
    INT 10h  
    
    call  CheackWinner
    
    push pos
    
    mov bx,0
    cmp level,1
    je whilec
    
      
    call ComWin
    cmp cwinf,1
    je ComWinCase  
     
    cmp cwinf,1
    jne ComdefCase
    ComWinCase:
    mov bx,i
    mov pos,bx   
    call set0
    
    jmp cSTEP3 
    
    ComdefCase:
    call Comdef
    cmp cwinf,1
    jne Whilecase
    
    mov bx,i
    mov pos,bx   
    call set0
    
    jmp cSTEP3
    
    
    Whilecase: 
    mov bx,0
    cmp level,2
    je whilec
    
    level_3:
    cmp box[5],-1
    je  input5
    cmp box[1],-1
    je  input1
    cmp box[3],-1
    je  input3
    cmp box[7],-1
    je  input7
    cmp box[9],-1
    je  input9
    jmp whilec
    
    input5:
        mov pos,5
        call set0
        jmp cSTEP3
    input1:
    mov pos,1
        call set0
        jmp cSTEP3
    input3: 
        mov pos,3
        call set0
        jmp cSTEP3
    input7:
    mov pos,7
        call set0
        jmp cSTEP3
    input9: 
    mov pos,9
        call set0
        jmp cSTEP3
    
     
    whilec:   
    
        inc bx
        cmp bx,10
        je cstep3
        cmp box[bx],-1 
        jne whilec
        mov pos,bx
        call set0
        
        
        
    
    cSTEP3:
    pop pos
    RET
    cSETX ENDP
    
    ;;;;kknfrfbfrbvbhtbhffhb
    
    
    
    
    
    
    SETX PROC
     
    mov si,pos
    cmp box[si],-1
    jne step3
    mov box[si],1 
    
    MOV DH,xpos[si]
    
    MOV DL,ypos[si]
    lea si,box
    
    MOV AH, 02
    MOV BH, 0
    INT 10H    
    MOV AH, 9
    MOV AL, 'X'
    MOV BL,13  
    MOV CX, 1
    INT 10h
      
    STEP3:
    RET
    SETX ENDP
   
    SET0 PROC
    mov si,pos
    cmp box[si],-1
    jne step6
    mov box[si],4 
    
    MOV DH,xpos[si]
    
    MOV DL,ypos[si]
    lea si,box
    
    MOV AH, 02
    MOV BH, 0
    INT 10H    
    MOV AH, 9
    MOV AL, 'O'
    MOV BL,39  
    MOV CX, 1
    INT 10h
    STEP6:
    RET
    SET0 ENDP
     
        drawh proc
        MOV AH, 0CH
        ;MOV AL, 4 ; colour code
        
        L: INT 10h
        INC CX
        CMP CX, upto
        JLE L
        ret
        drawh endp
        
        
         
        drawv proc
        
        MOV AH, 0CH 
        LL: INT 10h
        INC DX
        CMP DX, upto
        JLE LL
        
        ret
        drawv endp  
        
        
        ;;;; function to show string  on 
        move proc
            MOV AH, 2   ; move cursor functio
                      
            XOR BH, BH  ; page 0
            INT 10h
             
            ret
            move endp
        
        
        show proc
                        
            MOV AH,9
            INT 21H 
            ret
            show endp 
        
        
         ; ; box akano function 
        outerbox proc
        mov al,4H  ; coloure for big box    
            
        MOV CX, r1      ;60 
        MOV DX, c1      ;40 
        mov upto,240
        call drawh
        MOV CX, r1      ;60
        MOV DX, c2      ;80 
        call drawh
        MOV CX, r1      ;60 
        MOV DX, c3      ;120 
        call drawh
        MOV CX, r1      ;60 
        MOV DX, c4      ;160 
        call drawh
        MOV CX, r1      ;60 
        MOV DX, c1      ;40 
        mov upto,160
        call drawv        
        MOV CX, r2      ;120 
        MOV DX, c1      ;40 
        call drawv            
        MOV CX, r3      ;180 
        MOV DX, c1      ;40 
        call drawv    
        MOV CX, r4;240 
        MOV DX, c1;40 
        call drawv
        ret
        outerbox ENDP
        
        
        innerbox proc
        MOV CX, r 
        MOV DX, c 
        mov bX,r
        add bX,60
        mov upto,bx
        call drawh
        MOV CX, r 
        MOV DX, c 
        ADD DX,40
        call drawh 
        MOV CX, r 
        MOV DX, c 
        mov bX,c
        add bX,40
        mov upto,bx
        call drawv     
        MOV DX, c
        MOV CX, r 
        add cx,60
        call drawv
        ret
        innerbox ENDP  
       
       
      
                
                
                
                
        
        PrintTurn proc
        
        cmp turn,1
        je  print_turn1
        cmp turn,2
        je  print_turn2
        
        print_turn1: 
                    
        mov dl,12
        mov dh, 22
        call move      
      
        lea DX,print1
        call show
         
        jmp endprint
        print_turn2:  
        
        mov dl,12
        mov dh, 22
        call move      
      
        lea dx,print2
        call show
        jmp  endprint
        endprint:
            ret
            PrintTurn ENDP  
        
        CheackWinner proc  
         sum1:  
             mov al,box[1]
             add al,box[2]
             add al,box[3]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum2: 
             mov al,box[4]
             add al,box[5]
             add al,box[6]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum3:
             mov al,box[7]
             add al,box[8]
             add al,box[9]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum4:
             mov al,box[1]
             add al,box[4]
             add al,box[7]
             cmp al,3
             je win1
             cmp al,12
             je win2 
             
         sum5:   
             mov al,box[2]
             add al,box[5]
             add al,box[8]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum6:   
             mov al,box[3]
             add al,box[6]
             add al,box[9]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum7: 
             mov al,box[1]
             add al,box[5]
             add al,box[9]
             cmp al,3
             je win1
             cmp al,12
             je win2
         sum8: 
             mov al,box[3]
             add al,box[5]
             add al,box[7]
             cmp al,3
             je win1
             cmp al,12
             je win2
             
             mov bx,1 
          draw:
             cmp box[bx],-1
             je continue 
             
             cmp bx,9
             je drawmatch   
             inc bx
             jmp draw
             
             
         continue:  
         jmp endcheack
         win1:      
             mov dl,12
             mov dh, 22
             call move      
      
             lea DX,winner1  
             
             inc Pw1
             
             call show  
             call setdata  
              jmp playAgain
             ;jmp endcheack
         
         win2:   
             mov dl,12
             mov dh, 22
             call move      
             
             cmp mode,2
             je cw1
             cmp mode,1
             je cw2 
             
             cw1:
             lea DX,winner2
             jmp ew  
             cw2:
             lea dx,cwinner
             ew:
             
             inc Pw2
             call show   
             call setdata  
             jmp playAgain
             
          drawmatch:
             mov dl,12
             mov dh, 22
             call move      
      
             lea DX,drawp
             call show
             call setdata 
             jmp playAgain  
           
                        
          
         endcheack:
                     
            ret
        CheackWinner    ENDP   
        
            
         
                
        setdata proc    
            
        inc count
        cmp count,3 
        je CallGameOver  
        cmp count,3
        jne b:
        
        CallGameOver: 
        mov ah,1
        int 21h
        call GameOver
         b:
            
         mov dl,6
         mov dh,24
         call move
         lea dx, playagaintext
         call show  
            
            
         mov ah,0
         int 16h  
            
            
            
        mov turn,1  
        mov bx,1  
        
        setboxdata:
        mov box[bx],-1 
        
        inc bx
        cmp bx,10
        jne  setboxdata   
        
        
        mov POS,1  
        mov r,60
        mov c,40
                
            ret
        setdata ENDP  
              
              
         show1 proc
             mov  ah, 9
             mov  bh, 0
             mov  cx, 1  ;HOW MANY TIMES TO DISPLAY CHAR.
             int  10h
        
            ret
            show1 ENDP      
        
        displayPlayerWin proc  
            mov dl, 1
            mov dh, 3
            call move
            lea dx,Pw1_t 
            mov bl,11
            call show 
                     
                      
             mov dl,8
             mov dh,3      
             call move     
             
             mov al,Pw1
             add al,30h
             mov bl,14  
             call show1       
            
        
            
            mov dl,  30
            mov dh,  3
            call move 
            
            cmp mode,2
            je  go1
            cmp mode,1
            je  go2
            
            go1:
            lea dx,Pw2_t 
            jmp ego
            
            go2:
            lea dx,cw_t   
            
            ego:
            call show  
            
            
            
             mov dl,37
             mov dh,3      
             call move     
             
             mov al,Pw2
             add al,30h
             mov bl,14  
             call show1   
            
           
            
            
            
            ret
            displayPlayerWin ENDP  
             
             
             
              ComWin proc  
                
         wsum1:  
             mov al,box[1]
             add al,box[2]
             add al,box[3] 
             
             mov i1,1
             mov i2,2
             mov i3,3
             cmp al,7
             je do_cwin
         wsum2: 
             mov al,box[4]
             add al,box[5]
             add al,box[6] 
             mov i1,4
             mov i2,5
             mov i3,6
             cmp al,7
             je do_cwin
         wsum3:
             mov al,box[7]
             add al,box[8]
             add al,box[9] 
             mov i1,7
             mov i2,8
             mov i3,9
             cmp al,7
             je do_cwin
            
         wsum4:
             mov al,box[1]
             add al,box[4]
             add al,box[7] 
             mov i1,1
             mov i2,4
             mov i3,7
             cmp al,7
             je do_cwin
         wsum5:   
             mov al,box[2]
             add al,box[5]
             add al,box[8]
             mov i1,2
             mov i2,5
             mov i3,8
             
             cmp al,7
             je do_cwin
         wsum6:   
             mov al,box[3]
             add al,box[6]
             add al,box[9] 
             mov i1,3
             mov i2,6
             mov i3,9
             
             cmp al,7
             je do_cwin
             
         wsum7: 
             mov al,box[1]
             add al,box[5]
             add al,box[9]
             
             mov i1,1
             mov i2,5
             mov i3,9
             
             cmp al,7
             je do_cwin
         wsum8: 
             mov al,box[3]
             add al,box[5]
             add al,box[7]
             mov i1,3
             mov i2,5
             mov i3,7
      
             cmp al,7
             je do_cwin  
             
         no_match: 
            mov cwinf,0 
            mov i1,0
            mov i2,0
            mov i3,0
            mov i,0 
            jmp endComWin
         
         do_cwin: 
             mov cwinf,1  
             
             mov si,i1
             cmp box[si],-1 
             je  for_i1   
             mov si,i2
             cmp box[si],-1
             je  for_i2:
             mov si,i3
             cmp box[si],-1
             je  for_i3 
             jmp endfor
             
             for_i1: 
                mov ax,i1
                mov i,ax  
                jmp endfor
             for_i2: 
                mov ax,i2
                mov i,ax  
                jmp endfor
             for_i3: 
                mov ax,i3
                mov i,ax 
                jmp endfor
                
             endfor:
         
             endComWin:
                                      
            ret
        ComWin    ENDP   
             
             
             
               Comdef proc  
                
         dwsum1:  
             mov al,box[1]
             add al,box[2]
             add al,box[3] 
             
             mov i1,1
             mov i2,2
             mov i3,3
             cmp al,1
             je ddo_cwin
         dwsum2: 
             mov al,box[4]
             add al,box[5]
             add al,box[6] 
             mov i1,4
             mov i2,5
             mov i3,6
             cmp al,1
             je ddo_cwin
         dwsum3:
             mov al,box[7]
             add al,box[8]
             add al,box[9] 
             mov i1,7
             mov i2,8
             mov i3,9
             cmp al,1
             je ddo_cwin
            
         dwsum4:
             mov al,box[1]
             add al,box[4]
             add al,box[7] 
             mov i1,1
             mov i2,4
             mov i3,7
             cmp al,1
             je ddo_cwin
         dwsum5:   
             mov al,box[2]
             add al,box[5]
             add al,box[8]
             mov i1,2
             mov i2,5
             mov i3,8
             
             cmp al,1
             je ddo_cwin
         dwsum6:   
             mov al,box[3]
             add al,box[6]
             add al,box[9] 
             mov i1,3
             mov i2,6
             mov i3,9
             
             cmp al,1
             je ddo_cwin
             
         dwsum7: 
             mov al,box[1]
             add al,box[5]
             add al,box[9]
             
             mov i1,1
             mov i2,5
             mov i3,9
             
             cmp al,1
             je ddo_cwin
         dwsum8: 
             mov al,box[3]
             add al,box[5]
             add al,box[7]
             mov i1,3
             mov i2,5
             mov i3,7
      
             cmp al,1
             je ddo_cwin  
             
         dno_match: 
            mov cwinf,0 
            mov i1,0
            mov i2,0
            mov i3,0
            mov i,0 
            jmp endComdef
         
         ddo_cwin:
             mov cwinf,1  
             
             mov si,i1
             cmp box[si],-1 
             je  dfor_i1   
             mov si,i2
             cmp box[si],-1
             je  dfor_i2:
             mov si,i3
             cmp box[si],-1
             je  dfor_i3 
             jmp dendfor
             
             dfor_i1: 
                mov ax,i1
                mov i,ax  
                jmp dendfor
             dfor_i2: 
                mov ax,i2
                mov i,ax  
                jmp dendfor
             dfor_i3: 
                mov ax,i3
                mov i,ax 
                jmp dendfor
                
             dendfor:
         
             endComdef:
                                      
            ret
        Comdef    ENDP 
             
             
             
        
            GameOver proc
                        
             MOV AX,13h
             INT 10h
             
             call displayPlayerWin
             
             result:
           
             mov al,Pw1
             cmp al,Pw2
             je Display_Draw
             cmp al,Pw2
             jg  Display_1
             cmp al,Pw2
             jl  Display_2
             
            Display_Draw:
            
            mov dl,7
            mov dh,11
            call move
            
            lea dx,WD
            call show 
            jmp endGame
            
             Display_1:
            
            mov dl,7
            mov dh,11
            call move
            
            lea dx,W1
            call show  
            jmp endGame
             Display_2:
            
            mov dl,7
            mov dh,11
            call move
                     
            cmp mode,1
            je lst1
            cmp mode,2
            je lst2
            
            lst1:       
            lea dx,cW  
            jmp elst:
            lst2:
            lea dx,W2
            
            elst:
            call show 
            jmp endGame
              
              
            endGame: 
            
            mov dl ,6
            mov dh  ,15
            call move
            lea dx,con
            call show
            
            mov ah,0
            int 16h  
            
             MOV AX,13h
             INT 10h 
            
            mov ah,4ch
            int 21h  
            
            ret
          GameOver ENDP
                
             
         
        end main      