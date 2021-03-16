-- maybe split Lua code into keywords?

local parser = require("parser")

local code = io.open(..., "r"):read("a")

local new = parser.new(code)
--new.discard_whitespace = true
--incomplete Lua syntax
new:addToken("splitter", " \n,\"'.<>&^|~:-+%=/*")
new:addToken("bracket", "[](){}")
new:addToken("keyword", "local")
new:addToken("keyword", "function")
new:addToken("keyword", "for")
new:addToken("keyword", "in")
new:addToken("keyword", "do")
new:addToken("keyword", "if")
new:addToken("keyword", "then")
new:addToken("keyword", "elseif")
new:addToken("keyword", "repeat")
new:addToken("keyword", "until")
new:addToken("keyword", "end")
new:addToken("keyword", "not")
new:addToken("keyword", "and")
new:addToken("keyword", "or")
new:addToken("constant", "true")
new:addToken("constant", "false")
new:addToken("constant", "nil")
new:addToken("match", "^%d[%d%.]+$", "constant")
new:addToken("match", "^0x[0-9a-fA-F%.]+$", "constant")

-- prints sort-of-highlighted code
-- does not parse comments or strings
for word, ttype in function()return new:matchToken()end do
  local esc = "\27[39m"
  if ttype == "keyword" then
    esc = "\27[91m"
  elseif ttype == "constant" then
    esc = "\27[95m"
  elseif ttype == "splitter" then
    esc = "\27[93m"
  elseif ttype == "bracket" then
    esc = "\27[92m"
  end
  io.write(esc..word)--print(word, ttype)
end
