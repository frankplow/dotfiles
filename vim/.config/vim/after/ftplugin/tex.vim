setlocal makeprg=latexmk\ -pdflatex\ -interaction=nonstopmode\ %
let b:start='zathura %:r.pdf'
