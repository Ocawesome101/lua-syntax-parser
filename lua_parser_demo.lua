-- maybe split Lua code into keywords?

local parser = require("parser")

local code = io.open(..., "r"):read("a")

local new = parser.new(code)
new.discard_whitespace = true
-- incomplete Lua syntax
new:addToken("splitter", " \n,\"'.<>&^|~:-/")
new:addToken("bracket", "[](){}")
new:addToken("keyword", "for")
new:addToken("keyword", "if")
new:addToken("keyword", "then")
new:addToken("keyword", "do")
new:addToken("keyword", "in")
new:addToken("keyword", "end")
new:addToken("constant", "true")
new:addToken("constant", "false")
new:addToken("constant", "nil")
new:addToken("match", "^%d[%d%.]+$", "constant")
new:addToken("match", "^0x[0-9a-fA-F%.]+$", "constant")

for word, ttype in function()return new:matchToken()end do
  io.write("|"..word)--print(word, ttype)
end
