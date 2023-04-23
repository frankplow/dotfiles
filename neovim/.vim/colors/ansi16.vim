" vi:syntax=vim
"
" ansi16-vim
" by frank plowman
"hi                          cterm=NONE      ctermfg=NONE    ctermbg=NONE

" editor
hi Normal                   cterm=NONE      ctermfg=NONE    ctermbg=NONE
hi Cursor                   cterm=NONE      ctermfg=NONE    ctermbg=black
hi CursorLine               cterm=NONE      ctermfg=NONE    ctermbg=black
hi LineNr                   cterm=NONE      ctermfg=8       ctermbg=NONE
hi CursorLineNr             cterm=bold      ctermfg=8       ctermbg=NONE

hi VertSplit                cterm=NONE      ctermfg=8       ctermbg=NONE

hi TabLine                  cterm=underline ctermfg=8       ctermbg=NONE
hi TabLineFill              cterm=underline ctermfg=8       ctermbg=NONE
hi TabLineSel               cterm=bold      ctermfg=7       ctermbg=NONE

hi Pmenu                    cterm=NONE      ctermfg=NONE    ctermbg=NONE
hi PmenuSel                 cterm=reverse   ctermfg=NONE    ctermbg=NONE

" column
hi CursorColumn             cterm=NONE      ctermfg=NONE    ctermbg=8
hi FoldColumn               cterm=NONE      ctermfg=NONE    ctermbg=NONE
hi SignColumn               cterm=NONE      ctermfg=NONE    ctermbg=NONE
hi Folded                   cterm=NONE      ctermfg=NONE    ctermbg=NONE

" file navigation
hi Directory                cterm=bold      ctermfg=13      ctermbg=NONE
hi Search                   cterm=reverse   ctermfg=11      ctermbg=NONE
hi IncSearch                cterm=reverse   ctermfg=13      ctermbg=NONE

" prompt / statusline
hi StatusLine               cterm=bold      ctermfg=8       ctermbg=NONE
hi! link StatusLineTerm StatusLine
hi StatusLineNC             cterm=NONE      ctermfg=8       ctermbg=NONE
hi! link StatusLineTermNC StatusLineNC
hi Question                 cterm=NONE      ctermfg=12      ctermbg=NONE
hi MoreMsg                  cterm=NONE      ctermfg=6       ctermbg=NONE
hi ModeMsg                  cterm=bold      ctermfg=6       ctermbg=NONE

" visual aids
hi MatchParen               cterm=underline ctermfg=NONE    ctermbg=NONE
hi Visual                   cterm=reverse   ctermfg=7       ctermbg=NONE
hi VisualNOS                cterm=NONE      ctermfg=9       ctermbg=NONE
hi NonText                  cterm=NONE      ctermfg=7       ctermbg=NONE
hi Todo                     cterm=reverse   ctermfg=6       ctermbg=NONE
hi Underlined               cterm=underline ctermfg=NONE    ctermbg=NONE
hi Error                    cterm=bold      ctermfg=1       ctermbg=NONE
hi ErrorMsg                 cterm=bold      ctermfg=1       ctermbg=NONE
hi Warning                  cterm=NONE      ctermfg=1       ctermbg=NONE
hi WarningMsg               cterm=NONE      ctermfg=1       ctermbg=NONE
hi Ignore                   cterm=NONE      ctermfg=8       ctermbg=NONE
hi SpecialKey               cterm=NONE      ctermfg=7       ctermbg=NONE
hi Conceal                  cterm=NONE      ctermfg=NONE    ctermbg=NONE

" vimdiff
hi DiffText                 cterm=bold      ctermfg=NONE    ctermbg=NONE

" variable types
hi Constant                 cterm=NONE      ctermfg=11      ctermbg=NONE
hi Identifier               cterm=NONE      ctermfg=9       ctermbg=NONE

" literals
hi Number                   cterm=NONE      ctermfg=10      ctermbg=NONE
hi link Float Number
hi link Boolean Number
hi link Char Number
hi link SpecialChar Number
hi link String Number
hi link StringDelimiter String

" language constructs
hi Function                 cterm=NONE      ctermfg=12      ctermbg=NONE
hi Statement                cterm=NONE      ctermfg=13      ctermbg=NONE
hi Repeat                   cterm=NONE      ctermfg=11      ctermbg=NONE
hi Label                    cterm=NONE      ctermfg=11      ctermbg=NONE
hi Operator                 cterm=NONE      ctermfg=NONE    ctermbg=NONE
hi Keyword                  cterm=NONE      ctermfg=13      ctermbg=NONE
hi Exception                cterm=NONE      ctermfg=9       ctermbg=NONE
hi Comment                  cterm=NONE      ctermfg=8       ctermbg=NONE
hi Special                  cterm=NONE      ctermfg=14      ctermbg=NONE
hi SpecialChar              cterm=NONE      ctermfg=14      ctermbg=NONE
hi Tag                      cterm=NONE      ctermfg=9       ctermbg=NONE
hi Delimiter                cterm=NONE      ctermfg=13      ctermbg=NONE
hi SpecialComment           cterm=NONE      ctermfg=14      ctermbg=NONE
hi Debug                    cterm=NONE      ctermfg=9       ctermbg=NONE
hi link Decorator Macro
hi Interface                cterm=NONE      ctermfg=14      ctermbg=NONE

" c-likes
hi PreProc                  cterm=NONE      ctermfg=11      ctermbg=NONE
hi Include                  cterm=NONE      ctermfg=12      ctermbg=NONE
hi Define                   cterm=NONE      ctermfg=14      ctermbg=NONE
hi Macro                    cterm=NONE      ctermfg=14      ctermbg=NONE
hi PreCondit                cterm=NONE      ctermfg=13      ctermbg=NONE
hi Type                     cterm=NONE      ctermfg=11      ctermbg=NONE
hi StorageClass             cterm=NONE      ctermfg=14      ctermbg=NONE
hi Structure                cterm=NONE      ctermfg=13      ctermbg=NONE
hi Typedef                  cterm=NONE      ctermfg=11      ctermbg=NONE

" tex-specific
hi texEmphStyle             cterm=bold

" c-specific
hi link cppModifier cStorageClass
hi link cppCast Function

" haskell-specific
hi link ConId Type
hi link VarId Identifier

" coc
hi link CocHighlightText MatchParen

" semantic tokens standard set
hi link CocSemNamespace Include
hi link CocSemType Type
hi link CocSemClass Type
hi link CocSemEnum Type
hi link CocSemInterface Interface
hi link CocSemStruct Type
hi link CocSemTypeParameter Type
hi link CocSemParameter Identifier
hi link CocSemVariable Identifier
hi link CocSemProperty Identifier
hi link CocSemEnumMember Constant
hi link CocSemEvent Keyword
hi link CocSemFunction Function
hi link CocSemMethod Function
hi link CocSemMacro Macro
hi link CocSemKeyword Keyword
hi link CocSemModifier StorageClass
hi link CocSemComment Comment
hi link CocSemString String
hi link CocSemNumber Number
hi link CocSemRegexp String
hi link CocSemOperator Operator
hi link CocSemDecorator Decorator

" semantic tokens rust-analyzer
hi link CocSemAngle CocSemPunctuation
hi link CocSemArithmetic CocSemOperator
hi link CocSemAttribute CocSemDecorator
hi link CocSemAttributeBracket CocSemDecorator
hi link CocSemBitwise CocSemOperator
hi link CocSemBoolean Boolean
hi link CocSemBrace CocSemPunctuation
hi link CocSemBracket CocSemPunctuation
hi link CocSemBuiltinAttribute CocSemAttribute
hi link CocSemBuiltinType CocSemType
hi link CocSemCharacter CocSemString
hi link CocSemColon CocSemPunctuation
hi link CocSemComma CocSemPunctuation
hi link CocSemComparison CocSemOperator
hi link CocSemConstParameter CocSemParameter
hi link CocSemDerive CocSemAttribute
hi link CocSemDeriveHelper CocSemAttribute
hi link CocSemDot CocSemPunctuation
hi link CocSemEscapeSequence CocSemString
hi link CocSemFormatSpecifier CocSemString
hi link CocSemGeneric CocSemUnknown
hi link CocSemLabel CocSemMacro
hi link CocSemLifetime CocSemTypeParameter
hi link CocSemLogical CocSemOperator
hi link CocSemMacroBang CocSemMacro
hi link CocSemParenthesis CocSemPunctuation
hi clear CocSemPunctuation
hi link CocSemSelfKeyword CocSemParameter
hi link CocSemSelfTypeKeyword CocSemType
hi link CocSemSemicolon CocSemPunctuation
hi link CocSemTypeAlias CocSemType
hi link CocSemToolModule CocSemNamespace
hi link CocSemUnion CocSemStruct
hi link CocSemUnresolvedReference Warning

hi GitGutterAdd             cterm=NONE      ctermfg=2       ctermbg=NONE
hi GitGutterChange          cterm=NONE      ctermfg=4       ctermbg=NONE
hi GitGutterDelete          cterm=NONE      ctermfg=1       ctermbg=NONE
