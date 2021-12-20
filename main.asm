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
