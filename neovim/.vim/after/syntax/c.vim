syn match myTodo contained "\v\@\w+"
hi def link myTodo Todo
" syn region cComment matchgroup=cCommentStart start=+/\*+ end=+\*/+ extend fold contains=@cCommentGroup,cCommentStartError,cSpaceError,@Spell,myTodo
" syn region cCommentL start=+//+ skip=/\\$/ end=/$/ keepend contains=@cCommentGroup,cSpaceError,@Spell,myTodo
syn cluster cCommentGroup contains=cTodo,myTodo,cBadContinuation
call HighlightLongLines(80)
