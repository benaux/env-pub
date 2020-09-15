"vif-out.sh is triggering the vif.sh file
" why not calling/executing vif.sh directly?
" Because I would have to each time change the CWD path of vim 
"
function! Vif()
    silent !clear
"    execute 'silent make! -f vi.mk vif 2>&1 > /dev/null \&' | redraw!
"   silent execute  'make -s -f vi.mk vif > /dev/null 2>&1 &' | execute ':redraw!'
   silent execute  '!(sh ~/tools/utils/vif-out.sh '  . expand("%") . ' ' . getcwd() .  ' &) > /dev/null' | execute ':redraw!'
   "silent execute  '!(sh ~/tools/utils/vif-out.sh '  . expand("%:p") . ' ' . getcwd() .  ' &) > /dev/null' | execute ':redraw!'
endfunction

function! Vit()
    silent !clear
"    execute 'silent make! -f vi.mk vif 2>&1 > /dev/null \&' | redraw!
"   silent execute  'make -s -f vi.mk vif > /dev/null 2>&1 &' | execute ':redraw!'
   silent execute  '!(sh ./vit.sh '  . expand("%:p") .  ' &) > /dev/null' | execute ':redraw!'
endfunction

function! Vit_()
    silent !clear
    silent execute  "make -f vi.mk vit  > /dev/null &" | redraw!
endfunction

nnoremap f :w<cr>:call Vif()<cr>
nnoremap t :w<cr>:call Vit()<cr>

"refresh syntax higlight (specially helpfulll for large multi-syntax files
"like org-mode
nnoremap s :w<cr>:syn sync fromstart<cr>
