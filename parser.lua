-- Mathematical Expression Parser in Lua
-- Supports: +, -, *, /, ^, parentheses, and unary minus
-- Uses recursive descent parsing with proper operator precedence

local Parser = {}

-- Token types
local TOKEN = {
    NUMBER = "NUMBER",
    PLUS = "PLUS",
    MINUS = "MINUS",
    MULTIPLY = "MULTIPLY",
    DIVIDE = "DIVIDE",
    POWER = "POWER",
    LPAREN = "LPAREN",
    RPAREN = "RPAREN",
    EOF = "EOF"
}

-- Tokenizer (Lexer)
local function tokenize(expression)
    local tokens = {}
    local i = 1
    local len = #expression
    
    while i <= len do
        local char = expression:sub(i, i)
        
        -- Skip whitespace
        if char:match("%s") then
            i = i + 1
        
        -- Numbers (including decimals)
        elseif char:match("%d") then
            local num = ""
            while i <= len and (expression:sub(i, i):match("%d") or expression:sub(i, i) == ".") do
                num = num .. expression:sub(i, i)
                i = i + 1
            end
            table.insert(tokens, {type = TOKEN.NUMBER, value = tonumber(num)})
        
        -- Operators and parentheses
        elseif char == "+" then
            table.insert(tokens, {type = TOKEN.PLUS})
            i = i + 1
        elseif char == "-" then
            table.insert(tokens, {type = TOKEN.MINUS})
            i = i + 1
        elseif char == "*" then
            table.insert(tokens, {type = TOKEN.MULTIPLY})
            i = i + 1
        elseif char == "/" then
            table.insert(tokens, {type = TOKEN.DIVIDE})
            i = i + 1
        elseif char == "^" then
            table.insert(tokens, {type = TOKEN.POWER})
            i = i + 1
        elseif char == "(" then
            table.insert(tokens, {type = TOKEN.LPAREN})
            i = i + 1
        elseif char == ")" then
            table.insert(tokens, {type = TOKEN.RPAREN})
            i = i + 1
        else
            error("Unexpected character: " .. char)
        end
    end
    
    table.insert(tokens, {type = TOKEN.EOF})
    return tokens
end

-- Parser class
local function createParser(tokens)
    local parser = {
        tokens = tokens,
        position = 1
    }
    
    function parser:current()
        return self.tokens[self.position]
    end
    
    function parser:advance()
        self.position = self.position + 1
        return self.tokens[self.position - 1]
    end
    
    function parser:expect(tokenType)
        local token = self:current()
        if token.type ~= tokenType then
            error("Expected " .. tokenType .. " but got " .. token.type)
        end
        return self:advance()
    end
    
    -- Grammar:
    -- expression  : term ((PLUS | MINUS) term)*
    -- term        : factor ((MULTIPLY | DIVIDE) factor)*
    -- factor      : power (POWER power)*
    -- power       : (PLUS | MINUS)? atom
    -- atom        : NUMBER | LPAREN expression RPAREN
    
    function parser:parseAtom()
        local token = self:current()
        
        if token.type == TOKEN.NUMBER then
            self:advance()
            return token.value
        elseif token.type == TOKEN.LPAREN then
            self:advance() -- consume '('
            local result = self:parseExpression()
            self:expect(TOKEN.RPAREN) -- consume ')'
            return result
        else
            error("Unexpected token: " .. token.type)
        end
    end
    
    function parser:parsePower()
        local token = self:current()
        
        -- Handle unary plus/minus
        if token.type == TOKEN.PLUS then
            self:advance()
            return self:parseAtom()
        elseif token.type == TOKEN.MINUS then
            self:advance()
            return -self:parseAtom()
        else
            return self:parseAtom()
        end
    end
    
    function parser:parseFactor()
        local result = self:parsePower()
        
        while self:current().type == TOKEN.POWER do
            self:advance()
            result = result ^ self:parsePower()
        end
        
        return result
    end
    
    function parser:parseTerm()
        local result = self:parseFactor()
        
        while self:current().type == TOKEN.MULTIPLY or self:current().type == TOKEN.DIVIDE do
            local op = self:advance()
            if op.type == TOKEN.MULTIPLY then
                result = result * self:parseFactor()
            else
                local divisor = self:parseFactor()
                if divisor == 0 then
                    error("Division by zero")
                end
                result = result / divisor
            end
        end
        
        return result
    end
    
    function parser:parseExpression()
        local result = self:parseTerm()
        
        while self:current().type == TOKEN.PLUS or self:current().type == TOKEN.MINUS do
            local op = self:advance()
            if op.type == TOKEN.PLUS then
                result = result + self:parseTerm()
            else
                result = result - self:parseTerm()
            end
        end
        
        return result
    end
    
    function parser:parse()
        local result = self:parseExpression()
        if self:current().type ~= TOKEN.EOF then
            error("Unexpected tokens after expression")
        end
        return result
    end
    
    return parser
end

-- Main evaluation function
function Parser.evaluate(expression)
    local tokens = tokenize(expression)
    local parser = createParser(tokens)
    return parser:parse()
end

return Parser
