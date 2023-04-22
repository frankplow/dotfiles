" custom keywords
syn match myTodo contained "\v\@\w+"
hi def link myTodo Todo
syn region rustCommentLine start="//" end="$" contains=rustTodo,myTodo,@Spell
syn region rustCommentLineDoc start="//\%(//\@!\|!\)" end="$" contains=rustTodo,myTodo,@Spell
syn region rustCommentLineDocError start="//\%(//\@!\|!\)" end="$" contains=rustTodo,myTodo,@Spell contained
syn region rustCommentBlock matchgroup=rustCommentBlock start="/\*\%(!\|\*[*/]\@!\)\@!" end="\*/" contains=rustTodo,myTodo,rustCommentBlockNest,@Spell
syn region rustCommentBlockDoc matchgroup=rustCommentBlockDoc start="/\*\%(!\|\*[*/]\@!\)" end="\*/" contains=rustTodo,myTodo,rustCommentBlockDocNest,rustCommentBlockDocRustCode,@Spell
syn region rustCommentBlockDocError matchgroup=rustCommentBlockDocError start="/\*\%(!\|\*[*/]\@!\)" end="\*/" contains=rustTodo,myTodo,rustCommentBlockDocNestError,@Spell contained
syn region rustCommentBlockNest matchgroup=rustCommentBlock start="/\*" end="\*/" contains=rustTodo,myTodo,rustCommentBlockNest,@Spell contained transparent
syn region rustCommentBlockDocNest matchgroup=rustCommentBlockDoc start="/\*" end="\*/" contains=rustTodo,myTodo,rustCommentBlockDocNest,@Spell contained transparent
syn region rustCommentBlockDocNestError matchgroup=rustCommentBlockDocError start="/\*" end="\*/" contains=rustTodo,myTodo,rustCommentBlockDocNestError,@Spell contained transparent

call matchadd('ColorColumn', '\%>100v', 1)
