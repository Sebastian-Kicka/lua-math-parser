-- Example usage of the mathematical expression parser

local Parser = require("parser")

-- Test expressions
local expressions = {
    "2 + 3",
    "10 - 5 + 3",
    "2 * 3 + 4",
    "2 + 3 * 4",
    "(2 + 3) * 4",
    "10 / 2",
    "2 ^ 3",
    "2 ^ 3 ^ 2",
    "(2 + 3) * (4 + 5)",
    "-5 + 3",
    "-(5 + 3)",
    "2.5 * 4",
    "100 / (2 + 3) * 4",
    "2 * 3 + 4 * 5 - 6 / 2",
    "((2 + 3) * 4) ^ 2",
}

print("Mathematical Expression Parser - Test Cases\n")
print(string.rep("=", 50))

for _, expr in ipairs(expressions) do
    local success, result = pcall(Parser.evaluate, expr)
    if success then
        print(string.format("%-30s = %g", expr, result))
    else
        print(string.format("%-30s ERROR: %s", expr, result))
    end
end

print(string.rep("=", 50))
print("\nInteractive mode (Ctrl+C to exit):")
print("Enter mathematical expressions to evaluate\n")

while true do
    io.write(">> ")
    local input = io.read()
    
    if not input or input == "" then
        break
    end
    
    local success, result = pcall(Parser.evaluate, input)
    if success then
        print("   = " .. result)
    else
        print("   ERROR: " .. result)
    end
    print()
end
