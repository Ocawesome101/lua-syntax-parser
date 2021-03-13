// syntax parser written in Lua

this is very good at splitting things into keywords exactly the way you tell it to, and bad at everything else.  i might add an AST builder later.

matches are matched and keywords are compared in exactly the order they are added.  so, things should be added in order of precedence.
