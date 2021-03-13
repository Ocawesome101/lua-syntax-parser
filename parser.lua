-- some sort of parser library

local lib = {}

local function esc(c)
  return c:gsub("[%[%]%(%)%.%+%-%*%%%^%$%?]", "%%%1")
end

function lib:matchToken()
  local tok = ""
  if self.i >= #self.text then return nil end
  for i=self.i, #self.text, 1 do
    self.i = i + 1
    local c = self.text:sub(i,i)
    if #self.splitters > 0 and c:match("["..self.splitters.."]")
        and #tok == 0 then
      if (not self.discard_whitespace) or (c ~= " " and c ~= "\n") then
        if #self.brackets > 0 and c:match("["..self.brackets.."]") then
          return c, "bracket"
        elseif self.text:sub(i+1,i+1):match("["..self.splitters.."]") then
          tok = c
        else
          return c, "splitter"
        end
      end
    elseif #self.splitters > 0 and c:match("["..self.splitters.."]")
        and #tok > 0 then
      if (not self.discard_whitespace) or (c ~= " " and c ~= "\n") then
        if tok:match("^["..self.splitters.."]+$") then
          tok = tok .. c
        else
          self.i = self.i - 1
        end
      end
      return tok, "word"
    else
      tok = tok .. c
      for n, v in ipairs(self.types) do
        if (v.pattern and tok:match(v.pattern)) or tok == v.word then
          return tok, v.type
        end
      end
    end
  end
  return ((#tok > 0 and tok) or nil), #tok > 0 and "word" or nil
end

function lib:addToken(ttype, pow, ptype)
  if ttype == "match" then
    self.types[#self.types + 1] = {
      pattern = pow,
      type = ptype or ttype
    }
  elseif ttype == "bracket" then
    self.brackets = self.brackets .. esc(pow)
    self.splitters = self.splitters .. esc(pow)
  elseif ttype == "splitter" then
    self.splitters = self.splitters .. esc(pow)
  else
    self.types[#self.types + 1] = {
      word = pow,
      type = ttype
    }
  end
end

function lib.new(text)
  return setmetatable({
    types={},
    i=0,
    text=text or"",
    splitters="",
    brackets=""},{__index=lib})
end

return lib
