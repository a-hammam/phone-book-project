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

		; The following code to recieve the number from the user
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
	
jmp again
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	remove:

	


		jmp again
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	search:
	

		jmp again
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	view_all:


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