if exists('g:loaded_translator')
	finish
endif
let g:loaded_translator = 1

command! Translate :call translator#Translate()
