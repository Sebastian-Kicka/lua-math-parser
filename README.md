# Lua Mathematical Expression Parser

A basic but robust mathematical expression parser written in pure Lua. This parser uses recursive descent parsing with proper operator precedence to evaluate mathematical expressions.

## Features

- **Basic arithmetic operations**: `+`, `-`, `*`, `/`, `^` (power)
- **Parentheses support**: Control evaluation order
- **Unary operators**: Unary plus and minus (`+5`, `-3`)
- **Decimal numbers**: Full floating-point support
- **Proper operator precedence**: Follows standard mathematical order
- **Error handling**: Clear error messages for invalid expressions
- **Zero dependencies**: Pure Lua implementation

## Operator Precedence

From highest to lowest:

1. **Parentheses**: `()`
2. **Unary operators**: `+`, `-`
3. **Exponentiation**: `^` (right-associative)
4. **Multiplication/Division**: `*`, `/` (left-associative)
5. **Addition/Subtraction**: `+`, `-` (left-associative)

## Installation

Simply copy `parser.lua` to your project directory, or clone this repository:

```bash
git clone https://github.com/Sebastian-Kicka/lua-math-parser.git
cd lua-math-parser
```

## Usage

### Basic Usage

```lua
local Parser = require("parser")

-- Evaluate an expression
local result = Parser.evaluate("2 + 3 * 4")
print(result)  -- Output: 14

-- More complex expressions
print(Parser.evaluate("(2 + 3) * 4"))        -- 20
print(Parser.evaluate("-5 + 3"))             -- -2
print(Parser.evaluate("2 ^ 3 ^ 2"))          -- 512 (right-associative)
print(Parser.evaluate("100 / (2 + 3) * 4"))  -- 80
```

### Error Handling

```lua
local Parser = require("parser")

-- Use pcall for safe evaluation
local success, result = pcall(Parser.evaluate, "2 + (3 * 4")
if success then
    print("Result: " .. result)
else
    print("Error: " .. result)
end
```

### Running Examples

```bash
# Run the example file with test cases
lua example.lua

# Run unit tests
lua test.lua
```

## Example Output

```
Mathematical Expression Parser - Test Cases

==================================================
2 + 3                          = 5
10 - 5 + 3                     = 8
2 * 3 + 4                      = 10
2 + 3 * 4                      = 14
(2 + 3) * 4                    = 20
10 / 2                         = 5
2 ^ 3                          = 8
2 ^ 3 ^ 2                      = 512
(2 + 3) * (4 + 5)              = 45
-5 + 3                         = -2
-(5 + 3)                       = -8
2.5 * 4                        = 10
100 / (2 + 3) * 4              = 80
2 * 3 + 4 * 5 - 6 / 2          = 23
((2 + 3) * 4) ^ 2              = 400
==================================================
```

## Architecture

The parser consists of two main components:

### 1. Tokenizer (Lexer)

Converts the input string into a series of tokens:
- `NUMBER`: Numeric literals (integers and decimals)
- `PLUS`, `MINUS`, `MULTIPLY`, `DIVIDE`, `POWER`: Operators
- `LPAREN`, `RPAREN`: Parentheses
- `EOF`: End of input

### 2. Recursive Descent Parser

Uses a grammar-based approach to parse expressions:

```
expression  : term ((PLUS | MINUS) term)*
term        : factor ((MULTIPLY | DIVIDE) factor)*
factor      : power (POWER power)*
power       : (PLUS | MINUS)? atom
atom        : NUMBER | LPAREN expression RPAREN
```

## Extending the Parser

### Adding New Operators

1. Add token type in `TOKEN` table
2. Update `tokenize()` to recognize the operator
3. Add parsing logic in appropriate precedence function

### Adding Functions

To add support for functions like `sin()`, `cos()`, etc.:

1. Add `IDENTIFIER` token type
2. Modify tokenizer to recognize function names
3. Update `parseAtom()` to handle function calls
4. Implement function evaluation logic

### Adding Variables

To support variables:

1. Add `IDENTIFIER` token type
2. Pass a variable table to `evaluate()`
3. Look up variable values during parsing

## Testing

The project includes comprehensive unit tests covering:

- Basic arithmetic operations
- Operator precedence
- Parentheses handling
- Unary operators
- Decimal numbers
- Complex nested expressions
- Whitespace handling
- Error cases

Run tests with:
```bash
lua test.lua
```

## Limitations

- No built-in functions (sin, cos, sqrt, etc.)
- No variable support
- No implicit multiplication (e.g., `2(3)` must be written as `2*(3)`)
- Division by zero throws an error

## API Reference

### `Parser.evaluate(expression)`

Evaluates a mathematical expression string and returns the result.

**Parameters:**
- `expression` (string): The mathematical expression to evaluate

**Returns:**
- (number): The result of the evaluation

**Throws:**
- Error if the expression is invalid or contains syntax errors

**Example:**
```lua
local result = Parser.evaluate("2 + 3 * 4")  -- returns 14
```

## License

MIT License - feel free to use this in your projects!

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## Repository

[https://github.com/Sebastian-Kicka/lua-math-parser](https://github.com/Sebastian-Kicka/lua-math-parser)
