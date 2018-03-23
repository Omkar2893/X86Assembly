
include emu8086.inc
ORG 100h

		GOTOXY 1,0

		CALL Disp

		GOTOXY 1,1

		CALL PTHIS

		db 'Initial weights !',0

	;--------------------------- SRC POINT A
		L1 AB,AC                   					;COMPARISON OF WT AB AND AC

	;--------------------------- SRC POINT B
		L2 BC,BD									;COMPARISON OF WT BC AND BD
		L5 BD,BE									;COMPARISON OF WT BD AND BE
		2NDPOINT BC,WT[1]          					;DECESION OF SECOND POINT IN PATH

	;--------------------------- SRC POINT C
		L3 0,CE                   					;COMPARISON OF 0 AND CE(SINCE CE HAS ONLY ONE PATH COMPARING WITH 0)

	;--------------------------- SRC POINT E
	    L4 ED,EF									;COMPARISON OF WT ED AND EF

	;--------------------------- SRC POINT D
	    L6 0,DF										;COMPARISON OF 0 AND DF

	;--------------------------- FINAL PATH DISLPLAY
		CALL DISPF

RET

	WT db 00h,00h,00h,00h,00h,00h      				;INTIAL WT ARRAY

	;SRC db
	;PATH db
	    VTAF db 'A','A','A','A','A','A',0			;FINAL OUTPUT ARRYAY
		VTA db 'A','B','C','D','E','F',0       		;
		VTB db 'C','D',0           					; NEAR BY ELEMENT ARRAY
		VTC db 'D',0               					;

		AB db 2                    					;
		AC db 5                    					;
		BC db 3                    					;
		BD db 4                    					;
		BE db 5                    					;WEIGHTS OF IMMEDIATE ELEMENT FROM TEMP SOURCE
		CE db 3   									;
	    EF db 3   									;
	    ED db 1   									;
	    DF db 1   									;

	DEFINE_PRINT_NUM 								;
	DEFINE_PRINT_NUM_UNS   							;DEFINED FUNCTIONS IN emu8086
	DEFINE_PRINT_STRING								;
	DEFINE_PTHIS									;

;---------------------------------------------------------------------------------------------------------
	L1 MACRO P1,P2

			GOTOXY 1,3								;FUNCTION USED FOR CURSOR LOCATION ON SCREEN

			CALL PTHIS
			db 'CONSIDER SOURCE A .',0

			MOV BL,BYTE PTR[P1]     				;AB
			MOV DL,BYTE PTR[P2]     				;AC
			CMP BL,DL               				;(AB-AC)

			JL SHIFT1								;COMPARISON OF WEIGHTS

			SHIFT1:
			MOV WT[1],BL							;STORE LEAST WT PATH

			GOTOXY 1,4
	;------------------------
			CALL Disp								;PROCEDURE CALL FOR DISLPLAYING CURRENT WEIGHTS IN WT ARRAY

			GOTOXY 1,5
			CALL PTHIS
			db 'NOW CONSIDERING SOURCE B :',0
	;-------------------------
	        MOV DL,VTA[1]           				;BUILDING UP FINAL ARRAY ELEMENT(FIRST ELEMENT)
	        MOV VTAF[1],DL

	ENDM

;----------------------------------------------------------------------------------------------------------
	L2 MACRO P1,P2

	        MOV BL,BYTE PTR[P1]      				;BC
			MOV DL,BYTE PTR[P2]      				;BD
			CMP BL,DL                				;(BC-BD)

			JL SHIFT2								;COMPARISON OF WEIGHTS

			SHIFT2:

			MOV WT[2],BL             				;STORE LEAST WT PATH IN CURRENT WT ARRAY

			GOTOXY 1,6
	;--------------------------
			CALL Disp

	ENDM

;-----------------------------------------------------------------------------------------------------------
	L5 MACRO P1,P2

	        MOV BL,BYTE PTR[P1]      				;BD
			MOV DL,BYTE PTR[P2]      				;BE
			CMP BL,DL                				;(BD-BE)

			JL SHIFT5

			SHIFT5:

			MOV WT[2],BL             				;STORE LEAST WT PATH IN CURRENT WT ARRAY

			GOTOXY 1,6
	;--------------------------
			CALL Disp

	ENDM

;------------------------------------------------------------------------------------------------
	2NDPOINT MACRO P1,P2

			GOTOXY 1,7
			CALL PTHIS
			db 'SECOND POINT DECESION :',0

			MOV BL,BYTE PTR[P1]       				;CURRENT SMALLEST WT i.e BC
			MOV DL,BYTE PTR[P2]       				;BD
			CMP BL,DL

			JL SHIFT1ST

			SHIFT1ST:

			MOV WT[2],BL              				;SMALLEST WT OF ALL i.e BC

			GOTOXY 1,8
	;---------------------------
			CALL Disp

			GOTOXY 1,10
			CALL PTHIS
			db 'NOW CONSIDERING SOURCE C :',0

	        MOV DL,VTA[2]           				;BUILDING UP FINAL ARRAY ELEMENT(SECOND ELEMENT)
	        MOV VTAF[2],DL

	ENDM

;-----------------------------------------------------------------------------------------------
	L3 MACRO P1,P2

			MOV BL,BYTE PTR[P1] 					;CE
			MOV DL,BYTE PTR[P2]						;CD
			CMP BL,DL								;(CE-CD)

			JL SHIFT3

			SHIFT3:

			MOV WT[4],DL							;MOVING SMALLER WT TO WT ARRAY

			GOTOXY 1,11
	;------------------------
			CALL Disp

			GOTOXY 1,13
			CALL PTHIS
			db 'NOW CONSIDERING SOURCE E :',0
	;--------------------------

			MOV DL,VTA[4]                       	;BUILDING UP FINAL ARRAY ELEMENT(THIRD ELEMENT)
			MOV VTAF[3],DL

	ENDM

;------------------------------------------------------------------------------------------------
	L4 MACRO P1,P2


			MOV BL,BYTE PTR[P1]         			;ED
			MOV DL,BYTE PTR[P2]         			;EF
			CMP BL,DL                   			;(ED-EF)

			JL SHIFT4

			SHIFT4:

			MOV WT[3],BL                			;STORE LEAST WT PATH

			GOTOXY 1,14

	;--------------------------
			CALL Disp

	;--------------------------
            GOTOXY 1,16
			CALL PTHIS
			db 'NOW CONSIDERING SOURCE D :',0



			MOV DL,VTA[3]                       	;BUILDING UP FINAL ARRAY ELEMENT(FOURTH ELEMENT)
			MOV VTAF[4],DL


	ENDM

;------------------------------------------------------------------------------------------------
	L6 MACRO P1,P2

			MOV BL,BYTE PTR[P1]         			;0
			MOV DL,BYTE PTR[P2]         			;DF
			CMP BL,DL                   			;(0-DF)

			JL SHIFT6

			SHIFT6:

			MOV WT[5],DL                			;STORE LEAST WT PATH

			GOTOXY 1,18
	;--------------------------
			CALL Disp

	;--------------------------

			MOV DL,VTA[5]              				;BUILDING UP FINAL ARRAY ELEMENT(FIFTH ELEMENT)
			MOV VTAF[5],DL

	ENDM

;------------------------------------------------------------------------------------------------
		Disp PROC									;PROCEDURE FOR DISPLAYING THE CHANGING ARRAY ACCORDING TO THE COMPARISON

			MOV CX,6								;SETTING UP COUNTER FOR VERTEX LOOP
			MOV DL,65								;INITIALIZING DL FOR CHARACTERS FROM A
			LEA BX,WT								;LOADING ADDRESS OF THE STARTING POINT OF WT ARRAY

			VERTEX:									;DISPLAYING VERTEX NAME

				PUTC DL
				CALL PRINT_STRING       			; FIRST VTX NOTn
				ADD DL,1
													;DISPLAYING CORRESPONDING WEIGHTS:

				MOV AL,BYTE PTR[BX]
				CALL PRINT_NUM          			; FIRST VTX WT
				ADD BX,1

			;------------------------------------------
				CMP CX,1							;CHECKING COUNTER VALUE
				JNE V
				JE F

			V:
				PUTC ','
				;CMP CX,1
				JMP G

			F:
				PUTC '.'

				PUSH CX
				POP CX
			G:

			LOOP VERTEX

			RET


		Disp ENDP

;------------------------------------------------------------------------------------------------
       DISPF PROC

			GOTOXY 1,20
			CALL PTHIS
			DB 'AVAILABLE PATHS : ABDF ABEF ABEDF ABCEF ABCEDF ACEF ACEDF ',0

			GOTOXY 1,22
			CALL PTHIS
			DB 'FINAL SINGLE SOURCE SHORTEST PATH :',0

			GOTOXY 1,23
			LEA SI,VTAF								;LOADING OFFSET OF FINAL PATH ARRAY i.e VTAF
			CALL PRINT_STRING

        RET

       DISPF ENDP

;--------------------------------------------------------------------------------------------------                ]
END
