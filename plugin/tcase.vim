" https://en.wikipedia.org/wiki/Title_case#AP_Stylebook
" According to the Associated Press Stylebook and Briefing on Media Law (2011 edition), the following rules should be applied:
"    Capitalize the first and last words.
"    Capitalize the principal words.
"    Capitalize prepositions and conjunctions of four letters or more.
"    Lowercase the articles the, a, and an.

function! s:MakeItTitle(word) abort
	" apPLe → Apple
	return toupper(strpart(a:word, 0, 1)) .. tolower(strpart(a:word, 1))
endfunction

function! s:WouldItBeInLowerCase(word) abort
	" As per AP Stylebook, 'Capitalize prepositions and conjunctions of four letters or more.'
	" So check only for max length of 3
	let l:artPrepConj = [
				\ 'a', 'an', 'the',
				\ 'as', 'at', 'by', 'for', 'in', 'of', 'off', 'on', 'per', 'to', 'up',
				\ 'and', 'but', 'nor', 'or']

	" false == 0
	if (len(a:word) >= 4)
		return 0
	elseif (match(l:artPrepConj, a:word) != -1)
		return 1
	else
		return 0
	endif
endfunction

function! Tcase() abort
	let l:words = split(trim(getline('.')))
	let l:modifiedWords = []

	" While loop
	let l:index = 0
	while index < len(l:words)
		let word = l:words[l:index]
		let l:lowerCaseWord = tolower(word)
		let l:firstCharAscii = strgetchar(l:lowerCaseWord, 0)

		" As per AP Stylebook 'Capitalize the first and last words.'
		if (index == 0 || index == len(l:words)-1)
			call add(l:modifiedWords, s:MakeItTitle(word))
			let l:index = l:index + 1
			continue
		endif

		" If first character of the word is a-zA-Z
		if l:firstCharAscii >= 97 && l:firstCharAscii <= 122
			if s:WouldItBeInLowerCase(word)
				call add(l:modifiedWords, l:lowerCaseWord)
			else 
				call add(l:modifiedWords, s:MakeItTitle(word))
			endif
		else
			call add(l:modifiedWords, word)
		endif

		let l:index = l:index + 1
	endwhile

	call setline('.', join(l:modifiedWords, ' '))
endfunction

command! Tcase :call Tcase()
