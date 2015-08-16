" Digite :help <node do comando> para saber mais informações sobre as variáveis
" setadas nesse vimrc. As configurações são livres e podem ser usadas por
" qualquer pessoa.
"                                                            "Alisson Linhares"

" -----------------------------------------------------------------------------
" Declarando variáveis locais
let $treeView=1
let $hexMode=0

" -----------------------------------------------------------------------------
" Configurações básicas:
set path+=**    " Procurando dentro de sub pastas.
set tags=tags
set wildmenu
set encoding=utf-8
set nomodeline  " Desativando o suporte para modelines /* vim: tw=60 ts=2: */
set showmode    " Informa o modo de operação do vim no final do arquivo.
set showcmd     " Mostra o último comando executado.
set ttyfast
set mouse=a     " Ativando o mouse.
set number
" set cursorline
" set relativenumber
set tw=79
set nowrap      " Desativa quebra de linha automática.
set fo-=t
set shiftwidth=4
set ts=4
set colorcolumn=80
set ruler
set incsearch
set hlsearch
set noautoindent
set cindent     " Usando o modelo de indentação do C [F2 para desativar]
set foldmethod=syntax
set nofoldenable
set list
set listchars=tab:»\ ,trail:·
set clipboard=unnamed
set showbreak=↪
set splitbelow
set autoread
set scrolloff=1
set sidescroll=1
set sidescrolloff=3
set shiftround
set vb t_vb=
set title
set matchtime=0
set timeout
set timeoutlen=500
set ttimeoutlen=50
set nobackup
set nowritebackup
set noswapfile
set viminfo+=n~/.vim/viminfo     " Movendo o viminfo para dentro da pasta .vim
" set backup                       " Configurando backups
" set undodir=/.vim/temp/undo//    " Arquivos de undo
" set backupdir=~/.vim/temp/bkp//  " Arquivos de backups
" set directory=~/.vim/temp/swp//  " Arquivos swap
set history=1000
set undolevels=1000              " Limite máximo para undo.
set backspace=indent,eol,start
set spelllang=pt,en     " Configurando o corretor ortográfico [pt/en]
set spell!
set t_Co=256k
set formatoptions=qrn1
set exrc
set secure
set foldlevelstart=99
au VimResized * :wincmd =" Redimensiona os splits em caso de resize.

" -----------------------------------------------------------------------------
" Configurando o visual:
syn on
syntax on

let g:jellybeans_overrides = {
\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
\}

colorscheme jellybeans
highlight ColorColumn ctermbg=7

" -----------------------------------------------------------------------------
" Configurando plugins:
filetype plugin on
filetype indent off
filetype on

"YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_add_preview_to_completeopt = 0
set completeopt-=preview

" Autotag
let g:autotagTagsFile="tags" " Nome do arquivo
let g:autotagStopAt="./"     " Cria um arquivo ctags no diretório atual

" CtrlP
let g:ctrlp_max_height = 15
set wildignore+=*.so,*.swp,*.zip,*.pdf,*.tar.gz,*.o,*.bin,*.doc,*.docx
set wildignore+=*.mkv,*.7z,*.rar,*.iso,*.odt,*.bz2,*.mp3,*.mp4,*.m4v
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

" NERDTree
let NERDTreeHighlightCursorline = 1
let NERDTreeMinimalUI = 1

" Easymotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_keys = 'asdfghjklzxcvbnmqwertyuiop'

" Taglist
let Tlist_WinWidth = 30
let Tlist_Auto_Update = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Compact_Format = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Use_Right_Window = 1

" MultiCursor
let g:multi_cursor_exit_from_insert_mode=0
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" GitGutter
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '#'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_max_signs = 1000
set updatetime=250

" Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ [ 'brown'       , 'firebrick3'  ],
    \ [ 'darkred'     , 'DarkOrchid3' ],
    \ [ 'darkcyan'    , 'SeaGreen3'   ],
    \ [ 'darkmagenta' , 'DarkOrchid3' ],
    \ [ 'darkgreen'   , 'RoyalBlue3'  ],
    \ [ 'Darkblue'    , 'firebrick3'  ],
    \ [ 'white'       , 'SeaGreen3'   ],
    \ ]
let g:rbpt_max = 7
let g:rbpt_loadcmd_toggle = 0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
" au Syntax * RainbowParenthesesLoadSquare
" au Syntax * RainbowParenthesesLoadBraces

" -----------------------------------------------------------------------------
" Novas funções:
if has("autocmd")
	" Configurando o vim para cada tipo de arquivo
	autocmd FileType java source ~/.vim/java.vim
	autocmd FileType cpp source ~/.vim/cpp.vim
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS

	" Carregar o .vimrc automaticamente após salvar.
	autocmd! bufwritepost .vimrc source %

	" Abrir a janela de quickfix automaticamente [:copen].
	autocmd QuickFixCmdPost [^l]* nested cwindow
	autocmd QuickFixCmdPost    l* nested lwindow

	inoremap <c-@> <c-x><c-o>
endif

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function! s:Dec2hex(line1, line2, arg) range
	if empty(a:arg)
		if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
			let cmd = 's/\%V\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
		else
			let cmd = 's/\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
		endif

		try
			execute a:line1 . ',' . a:line2 . cmd
		catch
			echo 'Error: No decimal number found'
		endtry
	else
		echo printf('%x', a:arg + 0)
	endif
endfunction

command! -nargs=? -range Hex2dec call s:Hex2dec(<line1>, <line2>, '<args>')
function! s:Hex2dec(line1, line2, arg) range
	if empty(a:arg)
		if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
			let cmd = 's/\%V0x\x\+/\=submatch(0)+0/g'
		else
			let cmd = 's/0x\x\+/\=submatch(0)+0/g'
		endif

		try
			execute a:line1 . ',' . a:line2 . cmd
		catch
			echo 'Error: No hex number starting "0x" found'
		endtry
	else
		echo (a:arg =~? '^0x') ? a:arg + 0 : ('0x'.a:arg) + 0
	endif
endfunction

function! ToggleTreeView()
	if $treeView
		let $treeView=0
		NERDTree
	else
		NERDTreeClose
		let $treeView=1
	endif
endfunction

function! ToggleNumber()
	if &relativenumber
		set number
		" set nocursorline
	else
		" set cursorline
		set relativenumber
	endif
endfunc

function! TogglePaste()
	set paste!

	if &paste
		echo "toggle paste: on"
	else
		echo "toggle paste: off"
	endif
endfunc

function! ToggleSpell()
	if &spell
		if &spelllang == "pt"
			set spelllang=pt,en
		elseif &spelllang == "pt,en"
			set spelllang=en
		else
			set spell!
			set spelllang=off
		endif
	else
		set spelllang=pt
		set spell!
	endif

	echo "toggle spell:" &spelllang
endfunction

function! ToggleHexmode()
	set binary
	set noeol

	if $hexMode
		:%!xxd -r
		let $hexMode=0
	else
		:%!xxd
		let $hexMode=1
	endif
endfunction

" -----------------------------------------------------------------------------
" Configurando teclas de atalhos:
map <f2> :call TogglePaste()<cr>
map <f3> :call ToggleSpell()<cr>
map <f4> :call ToggleNumber()<cr>
map <f5> :tabnew ~/.vimrc<cr>
map <f6> :call ToggleHexmode()<cr>
map <f7> :CCGenerateConfig<CR>
map <c-k> <c-w>k
map <c-j> <c-w>j
map <c-h> <c-w>h
map <c-l> <c-w>l
map Q q
map sf <Plug>(easymotion-bd-f)
map sl <Plug>(easymotion-bd-jk)
map sw <Plug>(easymotion-bd-jk)
map sw <Plug>(easymotion-bd-w)

nmap <left> <esc>:previous<cr>
nmap <right> <esc>:next<cr>
nmap sf <Plug>(easymotion-overwin-f)
nmap sl <Plug>(easymotion-overwin-line)
nmap sw <Plug>(easymotion-overwin-line)
nmap sw <Plug>(easymotion-overwin-w)

nnoremap \/ :nohlsearch<cr>
vnoremap ss :!sort<cr>
nnoremap ss vip:!sort<cr>
nnoremap su :GitGutterUndoHunk<cr>
nnoremap sa :GitGutterStageHunk<cr>
nnoremap s, :GitGutterPrevHunk<cr>
nnoremap s; :GitGutterNextHunk<cr>
nnoremap sp :GitGutterPreviewHunk<cr>
nnoremap st :Tabularize<space>/
vnoremap st :Tabularize<space>/

" Replace para variáveis locais no vim.
" <C-R>" retorna o último valor deletado.
" \<palavra\> procura pela palavra inteira.
" gr para replace de variável local { }
" gR para replace de variável local com pedido de confirmação.
nnoremap gr diwP[{V%:s/\<<C-R>"\>//g<left><left>
nnoremap gR diwPggVG:s/\<<C-R>"\>//g<left><left>
nnoremap gn :cnext<cr>
nnoremap gN :cprevious<cr>

" Busca em arquivos usando o grepvim
nnoremap // :vimgrep<space>/\<\>/gj<space>**/*<left><left><left><left><left><left><left><left><left><left>
vnoremap // "yy:vimgrep<space>/\<<C-R>y\>/gj<space>**/*

nnoremap \\ :CtrlPTag<cr>
nnoremap \ :TlistToggle<cr><c-w>l
nnoremap vv [{V%
nnoremap gt <C-w><C-]><C-w>T
nnoremap gf <C-w>gf
nnoremap gl g]
nnoremap dgh d^^
nnoremap ygh y^^
nnoremap cgh c^^
nnoremap <s-k> :call Compile()<cr>
nnoremap <c-o> :call ToggleTreeView()<cr>
nnoremap <c-o> :call ToggleTreeView()<cr>
nnoremap <bs> <left><del>
nnoremap Y y$
nnoremap <space> i<space><esc><right>
nnoremap <tab> :tabnext<cr>
nnoremap <s-tab> :tabprevious<cr>
nnoremap :W :w
nnoremap :Q :q
nnoremap Q q

" Copiando para o clipboard e evitando swap
nnoremap gy "+y
nnoremap gY "+Y
vnoremap gy "+y
nnoremap gp "+p
nnoremap gP "+P
vnoremap gp d"+P
vnoremap gP d"+P

" Limitando pesquisa.
vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
vnoremap gh ^^
vnoremap gl $
vnoremap < <gv
vnoremap > >gv
vnoremap vv <esc>%[{V%

" Autocomplete
inoremap {<cr> {<cr>}<esc>O
