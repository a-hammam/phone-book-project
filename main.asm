INCLUDE Irvine32.inc

.386
.model small

.data

		filename BYTE  "contacts.txt", 0		; File containing contacts
		elem BYTE  "elem.txt", 0				; File containing num of elements
		outfile1  dword ?
		outfile2  dword ?
		msg   BYTE   "               Please, Enter your choice number", 0
		msg1  BYTE   "1-add contact", 0
		msg2  BYTE   "2-remove contact", 0
		msg3  BYTE   "3-search", 0
		msg4  BYTE    "4-view all contacts", 0
		msg5  BYTE    "no element to view", 0
		deleted BYTE   "delete is done", 0
		not_found   BYTE  "name not found", 0
		space BYTE    "   ", 0
		line  BYTE    "___________________________________________________________________________", 0

		wrong  BYTE "wrong choice !!!!! please choose from 1 to 4", 0
		another_option BYTE "if you need another option press 1 if press any number", 0

		enter_name BYTE "please enter your name", 0
		enter_number BYTE "please enter your number ", 0

		nameSize = 12
		name1 DB nameSize DUP(0)		; String holdes contact name

		str1 DB nameSize DUP(0)			; Another string used for comparingand search

		numSize = 12
		number DB numSize DUP(? )		; Array holdes number


		emptyarr DB nameSize DUP(0)


		arrSize = 1200
		arr DB arrSize DUP(0)		; Array holds whole contact''s names and numbers

		nelement dd 0
.code

	main proc

		mov	edx, OFFSET filename		; register'EDX'holds offset of file name
		call	OpenInputFile; procedure that open file
		mov	outfile1, eax

		mov	edx, OFFSET arr				; register 'EDX' holds offset of the array
		mov	ecx, 1200
		call	ReadFromFile			; procedure for reading from file

		mov eax, outfile1
		call CloseFile;procedure for closing the file
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		mov	edx, OFFSET elem 
		call	OpenInputFile			; procedure for opening a file
		mov	outfile2, eax

		mov	edx, offset nelement		; register'edx' holds the offeset of num of elements
		mov	ecx,1
		call	ReadFromFile
		mov eax, outfile2
		call CloseFile

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
home:

		; The following code will show elements of the menu
		mov edx, OFFSET msg; register 'edx' holds msg offset
		call WriteString
		call Crlf

		mov edx, OFFSET msg1		; register 'edx' holds msg1 offset
		call WriteString
		call Crlf
		mov edx, OFFSET msg2		; register 'edx' holds msg2 offset
		call WriteString
		call Crlf

		mov edx, OFFSET msg3		; register 'edx' holds msg3 offset
		call WriteString
		call Crlf

		mov edx, OFFSET msg4		; register 'edx' holds msg4 offset
		call WriteString
		call Crlf


		call ReadInt
		; The following code to compare user`s input to jump to the correct procedure
		cmp eax,1
		je  Add_contact
		cmp eax,2
		je  remove
		cmp eax,3
		je  search
		cmp eax,4
		je  view_all
		jne Wrong_choise

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Add_contact:


		mov edx, OFFSET enter_name		; register 'edx' holds ''enter_name' offset
		call WriteString				; procedur will print the content of the string 'enter_name'
		call Crlf

		; The following code to recieve the name from the user
		mov edx, OFFSET name1			; register 'edx' holds 'name1' offset
		mov ecx, 12						; register 'ecx' holds the size of 'name1'
		call ReadString					; procedure will take input string from user
		call Crlf

		mov ebx, nelement				; register 'edx' holds 'nelements' offset
		mov eax, 24						; register 'ecx' holds the size of 'nelements'
		mul ebx
		add eax, offset arr

		INVOKE Str_copy,				; procedure for copying the string to a specifc destination
		ADDR name1, ; source
		ADDR[eax]; destination


			mov edx, OFFSET enter_number	; register 'edx' holds the offset of 'enter_number'
		call WriteString
		call Crlf
		; The following code to recieve the number from the user
		mov edx, OFFSET number
		mov ecx, 12
		call ReadString
		call Crlf
		; The following code to place the number after the name
		mov ebx, nelement
		mov eax, 24
		mul ebx
		add eax, 12
		add eax, offset arr


		INVOKE Str_copy,				; This procedure to copy the number to the destination
		ADDR number, ; source
		ADDR[eax]; destination

		
		;the following code to increase number of elements
		mov eax,nelement
		inc eax
		mov nelement,eax

		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;The following code to write the date to the file
		mov edx,offset filename
		call CreateOutputFile
		mov outfile1, eax

		mov eax, outfile1				 ; just for illustration - here, eax already contains the handle
		mov edx,offset arr
		mov ecx, 1200
		call WriteToFile

		mov eax, outfile1
		call CloseFile
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		; The following code to write num of elements to another file
		mov edx,offset elem
		call CreateOutputFile
		mov outfile2, eax

		mov eax, outfile2				 ; just for illustration - here, eax already contains the handle
		mov edx,offset nelement
		mov ecx,1
		call WriteToFile

		mov eax, outfile2
		call CloseFile



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
jmp again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	remove:
			mov edx,OFFSET enter_name						 ;print out a message that asks for the name that the user want to delete 
		call WriteString
		call Crlf
	
		mov edx,OFFSET name1						 ;read the name that the user wants to remove
		mov ecx,12
		call ReadString
		call Crlf

		mov ecx,nelement					;copies the number of currently registered names to the counter regiser ecx
		cmp ecx,0					; compares if we have  registered names =0
		je notfound2					;jump to label notfound2 if nelemenets=0
		mov ebx,0
	    	loop3: 
		mov eax,24                       ; the 24 bits holds 12 bits for name and 12 bits for number so we want to jump 24bits each time we achieve that by multiplying 0,1.. which is stored in ebx till we reach our nelements(ecx)
		mul ebx
		add eax,offset arr                     ; we add the offset of the array that we stored our names/numbers in to our counter

		INVOKE Str_copy,                      ;copies what the eax register points to to str1 which we will use to compare
		ADDR [eax],
		ADDR str1

		INVOKE Str_compare,                     ;compare the name that user has entered and the string that we saved and if the both is correct we jump to equal2 label which further removes the number and name the user wants
		ADDR name1,
		ADDR str1

		je  equal2                  ;jump if string1 = string2
		inc ebx                  ;increment the counter to jump 0x24 then 1x24 etc
		loop loop3
		notfound2:
		mov edx,OFFSET not_found                ;if nelements=0 we print out this message(not_found)which we initialized in the .data section  or the loop3 has finished and didnt jump to label equal2
		call WriteString
		call Crlf ; print new line

		jmp again; 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	search:
		mov edx,OFFSET enter_name		;ask the user to enter the name he wants to search for his number
		call WriteString
		call Crlf
	
		mov edx,OFFSET name1		;read the name the user wants to search for in a string called name1
		mov ecx,12				
		call ReadString
		call Crlf

		mov ecx,nelement		;loop for the nelements for the entire array and store in ecx register the counter
		cmp ecx,0
		je notfound				;if nelements=0 jump to label notfound
		mov ebx,0

		loop1:
		mov eax,24					;loop the array with a counter of (24 bits) number of ecx times
		mul ebx
		add eax,offset arr

		INVOKE Str_copy,				;copies what the eax register points to into str1 label
		ADDR [eax],
		ADDR str1

		INVOKE Str_compare,				;compare if the string the user entered which is in name1 and the counter string str1
		ADDR name1,
		ADDR str1

		je  equal      ;jump if string1 = string2
		inc ebx
		loop loop1
		notfound:
		mov edx,OFFSET not_found		;prints out a message to tell searched name was not found
		call WriteString
		call Crlf

		jmp again
		equal:

		add eax,12			
		INVOKE Str_copy,
		ADDR [eax],
		ADDR number

		mov edx,OFFSET str1			;prints out the name of the searched user
		call WriteString
		call Crlf

	
 
		mov edx,OFFSET number	;prints out the number of the searched user
		call WriteString
		call Crlf


		jmp again
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	view_all:
					;this function is used to display all numbers/names that is stored in the array
	
		mov ecx,nelement						;copies the current number of elements to ecx register
		cmp ecx,0
		je no_elm								;if there is no elements jump to label no_elm

		mov ebx,0			
		theloop2:
		mov eax,24
		mul ebx
		add eax,offset arr		;copies the offset of the array to eax register and add the counter to it which is the  mul of ebx and 24



		INVOKE Str_copy,                      ;copies what the eax register points to to str1 which we will use to compare
		ADDR [eax],
		ADDR str1

		INVOKE Str_compare,                     ;compare the empty array with what is stored inside the array when we removed it so we dont copy empty array
		ADDR emptyarr,
		ADDR str1
		je emptyarray
		
		mov edx,eax
		call WriteString							;prints out the current name to the screen
		mov edx,OFFSET space						;prints out the space to the screen	
		call WriteString


		add eax,12										;prints out the number of that name to the screen
		mov edx,eax
		call WriteString
		call Crlf

		mov edx,OFFSET line								;prints out the a line to the screen
		call WriteString
		call Crlf

		inc ebx						;increment the counter
		loop theloop2
        
		jmp again			;jump to label again
		emptyarray:
			inc ebx			;if the element is empty array so we pass 24 bit by eax thats by increasing the counter that we multiply it by 
			loop theloop2		;we use loop to decrement the ecx by 1 because ecx already contains the number of elements in the array with the removed element 
		no_elm:

		mov edx,OFFSET msg5					;print out a message to screen no element to view
		call WriteString
		call Crlf

		jmp again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	Wrong_choise:
		mov edx,OFFSET wrong		;print out a message to tell the user he entered a wrong choice
		call WriteString
		call crlf
		call crlf
		jmp home

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	again:
		mov edx,OFFSET another_option; copies the offset of the label another_option to edx register
		call WriteString;write the string which has the saved offset in edx register
		call crlf;print new line

		call ReadInt;read integer from user
		cmp eax,1;if the user entered 1 go back to label home 
		je home 
		
		je close;if not jump to label close
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	close:
	INVOKE ExitProcess,0 ;close the program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exit
main ENDP
end main