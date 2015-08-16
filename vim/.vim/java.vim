" Ativando o autocomplete para arquivos java.	
setlocal omnifunc=javacomplete#Complete
setlocal completefunc=javacomplete#CompleteParamsInfo
inoremap <c-@> <c-x><c-o>

" Compilar programas em Java
function! Compile()
	:wa
	:silent !clear

	if filereadable("makefile")
		:make
		:make run
	else	
		:silent !javac *.java

		if filereadable("Main.class")
			:!java Main
		endif
	endif
endfunction
