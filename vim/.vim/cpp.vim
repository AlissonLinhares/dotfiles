" Ativando o autocomplete para arquivos cpp.
let g:clang_user_options='|| exit 0'

" Compilar programas em C++
function! Compile()
	:wa
	:silent !clear

	if filereadable("makefile")
		:!make
		:!make run
	else
		:silent !g++ *.cpp

		if filereadable("a.out")
			:!./a.out
		endif
	endif
endfunction
