; extends

("text" @text
 (#match? @text "^[@][^ ]+$")
 (#set! "priority" 110)) @comment.todo.comment
