" custom keywords
syn match myTodo contained "\v\@\w+"
" V needed due to: https://github.com/vim/vim/issues/1265 V
syntax cluster cCommentGroup add=myTodo 
hi def link myTodo Todo

call matchadd('ColorColumn', '\%>80v', 1)
