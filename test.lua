-- Unit tests for the mathematical expression parser

local Parser = require("parser")

local function test(description, expression, expected)
    local success, result = pcall(Parser.evaluate, expression)
    
    if not success then
        print("X " .. description)
        print("  Expression: " .. expression)
        print("  Error: " .. tostring(result))
        return false
    end
    
    -- Compare with small epsilon for floating point
    local epsilon = 1e-10
    if math.abs(result - expected) < epsilon then
        print("OK " .. description)
        return true
    else
        print("X " .. description)
        print("  Expression: " .. expression)
        print("  Expected: " .. expected)
        print("  Got: " .. result)
        return false
    end
end

print("Running Parser Tests...\n")

local passed = 0
local total = 0

local function runTest(desc, expr, expected)
    total = total + 1
    if test(desc, expr, expected) then
        passed = passed + 1
    end
end

-- Basic arithmetic
runTest("Simple addition", "2 + 3", 5)
runTest("Simple subtraction", "10 - 3", 7)
runTest("Simple multiplication", "4 * 5", 20)
runTest("Simple division", "20 / 4", 5)
runTest("Simple power", "2 ^ 3", 8)

-- Operator precedence
runTest("Multiplication before addition", "2 + 3 * 4", 14)
runTest("Division before subtraction", "10 - 8 / 2", 6)
runTest("Power before multiplication", "2 * 3 ^ 2", 18)
runTest("Left-to-right addition", "1 + 2 + 3 + 4", 10)
runTest("Left-to-right multiplication", "2 * 3 * 4", 24)

-- Parentheses
runTest("Parentheses override precedence", "(2 + 3) * 4", 20)
runTest("Nested parentheses", "((2 + 3) * 4) + 5", 25)
runTest("Multiple parentheses groups", "(2 + 3) * (4 + 5)", 45)

-- Unary operators
runTest("Unary minus", "-5", -5)
runTest("Unary minus with addition", "-5 + 3", -2)
runTest("Unary minus with parentheses", "-(5 + 3)", -8)
runTest("Unary plus", "+5", 5)

-- Decimals
runTest("Decimal addition", "2.5 + 3.5", 6)
runTest("Decimal multiplication", "2.5 * 4", 10)
runTest("Decimal division", "7.5 / 2.5", 3)

-- Complex expressions
runTest("Complex expression 1", "2 * 3 + 4 * 5 - 6 / 2", 23)
runTest("Complex expression 2", "100 / (2 + 3) * 4", 80)
runTest("Complex expression 3", "((2 + 3) * 4) ^ 2", 400)
runTest("Complex expression 4", "2 ^ 3 + 4 ^ 2 - 5", 19)

-- Whitespace handling
runTest("No whitespace", "2+3*4", 14)
runTest("Extra whitespace", "  2  +  3  *  4  ", 14)

print("\n" .. string.rep("=", 50))
print(string.format("Results: %d/%d tests passed", passed, total))

if passed == total then
    print("All tests passed!")
    os.exit(0)
else
    print(string.format("%d tests failed", total - passed))
    os.exit(1)
end
