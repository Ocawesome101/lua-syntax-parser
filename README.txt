// syntax parser written in Lua

this is very good at splitting things into keywords exactly the way you tell it to, and bad at everything else.  i might add an AST builder later.

matches are matched and keywords are compared in exactly the order they are added.  so, things should be added in order of precedence.

this is not intended for use in syntax highlighting but could probably be used there anyway..

call `parser.new("your_source_code")' to create a new `parser' object.  you may alternatively set the source code by setting `parserobject.text' directly.

the parser tracks its position in the source code with `parserobject.i'.  reset this value to `0' to restart from the beginning of the code.

call `parserobject:addToken("keyword"|"match", "token"[, "tokentype"])' to add tokens.  call `parserobject:matchToken()' to return the next token and its type.  If the token does not match any types, its type will be `"word"'.
