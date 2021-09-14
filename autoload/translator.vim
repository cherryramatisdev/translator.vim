function! translator#Testando() abort
	let l:from_language = input("From language? ", "en")
	redraw

	if l:from_language == ''
		return
	endif

	let l:to_language = input("To language? ", "it")
	redraw

	if l:to_language == ''
		return
	endif

	let l:target_text = input("Target text? ")
	redraw

	if l:target_text == ''
		return
	endif

	let l:result = webapi#http#post("https://translate.sysctl.io/translate", {
				\ "q": l:target_text,
				\ "source": l:from_language,
				\ "target": l:to_language,
				\ })

	let l:status = get(l:result, 'status')
	let l:content = get(l:result, 'content')

	if l:status != 200
		return echo 'Some error occurred when trying to translate'
	endif

	let l:decoded_content = json_decode(l:content)

	execute 'new' fnameescape("translate_result")
	setlocal modifiable
	setlocal filetype=translator
	silent %delete
	nmap <buffer> q :q!<cr>
	call setline(1, get(l:decoded_content, 'translatedText'))
endfunction
