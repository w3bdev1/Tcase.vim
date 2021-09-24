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

function! s:isItUppercase(string) abort
	return a:string ==# toupper(a:string)
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
	let l:sentence = trim(getline('.'))
	let l:words = split(l:sentence)
	let l:modifiedWords = []

	" Is the sentence in uppercase
	let l:sentenceIsUppercase = s:isItUppercase(l:sentence)

	" While loop
	let l:index = 0
	while index < len(l:words)
		let l:word = l:words[l:index]
		let l:lowerCaseWord = tolower(l:word)
		let l:firstCharAscii = strgetchar(l:lowerCaseWord, 0)
		
		" If first character of the word is a-zA-Z
		if l:firstCharAscii >= 97 && l:firstCharAscii <= 122

			" If sentence is not uppercase but word is in uppercase (APPLE), do not change
			if (!l:sentenceIsUppercase && s:isItUppercase(l:word))
				call add(l:modifiedWords, l:word)
				let l:index = l:index + 1
				continue
			endif

			" As per AP Stylebook 'Capitalize the first and last words.'
			if (index == 0 || index == len(l:words)-1)
				call add(l:modifiedWords, s:MakeItTitle(l:word))
				let l:index = l:index + 1
				continue
			endif

			if s:WouldItBeInLowerCase(l:word)
				call add(l:modifiedWords, l:lowerCaseWord)
			else 
				call add(l:modifiedWords, s:MakeItTitle(l:word))
			endif
		else
			call add(l:modifiedWords, l:word)
		endif

		let l:index = l:index + 1
	endwhile

	call setline('.', join(l:modifiedWords, ' '))
endfunction

command! Tcase :call Tcase()
