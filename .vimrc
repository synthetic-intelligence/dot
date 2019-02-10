syn on
set	background=dark
set	ru nocp sc wmnu bg=light
set	ai autowrite ignorecase nowarn nowrapscan
set	redraw sm wm=5
" set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
:setlocal foldmethod=marker

set comments+=s:/*,m:**,ex:*/

map	@A	yWPa Bi<a href="Ea">
map	@co	:! co -l %
map	@ci	:w! |! ci -u %
map	@C	I/* A */
map	@D	o!! date '+\%y\%m\%d'
map	@edit	:! sccs edit %
map	@ftp	i:! ftp bb"a3dWu@a
map	@let	:r ! ~/bin/TeX/letter1G
map	@fax	:r ! ~/bin/TeX/fax1G
map	@uu	:1,$w !uudecode
map	@n	:se noignorecase
map	@s	:r ~/.signature
map	@>	:%s/^> //
map	@J	:%s/ ->//
map	@R	:%s/\([.?!]\)  */\1/g|1G!Gfmt|:%s/^/> /
map	&	!}fmt -c
map	*	gq}
map	K	I:. ! agrep -B A /usr/share/dict/words"ayy@a
" map	E	y p~ha]hhi[
map	Q	:q!
map	V	:1,$w !sed -e 's/\\//g' | aspell list | sort -u > ~/.spellistGo----Spellist----:r ~/.spellist
map	Y	yy
map	\	>%<<$%<<%
map		<%>>$%>>%
map	_	:%s/.//g
map	q	:q
map	v	i?\<A\>"add@a
map U   :set ff=unix|update
map  1G!Gxmllint --format -
abb	gua	guarantee
abb sop System.out.println
" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
