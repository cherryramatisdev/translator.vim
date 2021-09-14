function! s:CreateBuffer(name, content) abort
	execute 'new' fnameescape(a:name)
	setlocal modifiable
	setlocal filetype=translator
	silent %delete
	nmap <buffer> q :q!<cr>
	call setline(1, a:content)
endfunction

function! s:TranslateText(target_text, from_language, to_language) abort
	let l:result = webapi#http#post("https://translate.sysctl.io/translate", {
				\ "q": a:target_text,
				\ "source": a:from_language,
				\ "target": a:to_language,
				\ })

	return {
				\ 'status': get(l:result, 'status'),
				\ 'data': json_decode(get(l:result, 'content')),
				\ }
endfunction

function! translator#GetLanguages(...) abort
	return [
				\ 'en:English',
				\ 'it:Italian',
				\ 'es:Spanish',
				\ 'ar:Arabic' ,
				\ 'zh:Chinese',
				\ 'nl:Dutch',
				\ 'fr:French',
				\ 'de:German',
				\ 'hi:Hindi',
				\ 'hu:Hungarian',
				\ 'id:Indonesian',
				\ 'ga:Irish',
				\	'ja:Japanese',
				\ 'ko:Korean',
				\ 'pl:Polish',
				\ 'ru:Russian',
				\ 'tr:Turkish',
				\ 'uk:Ukranian',
				\ 'vi:Vietnamese'
				\ ]
endfunction

function! translator#Translate() abort
	let l:from_language = input("From language? ", translator#GetLanguages()[0], "customlist,translator#GetLanguages")
	redraw

	if l:from_language == ''
		return
	endif

	let l:from_language = split(l:from_language, ":")[0]

	let l:to_language = input("To language? ", translator#GetLanguages()[1], "customlist,translator#GetLanguages")
	redraw

	if l:to_language == ''
		return
	endif

	let l:to_language = split(l:to_language, ":")[0]

	let l:target_text = input("Target text? ")
	redraw

	if l:target_text == ''
		return
	endif

	let l:result = s:TranslateText(l:target_text, l:from_language, l:to_language)

	let l:status = get(l:result, 'status')
	let l:data = get(l:result, 'data')

	if l:status != 200
		echoerr get(l:data, 'error')
	else
		call s:CreateBuffer("translate_result", get(l:data, 'translatedText'))
	endif
endfunction
