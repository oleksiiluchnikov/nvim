---@diagnostic disable
-- Instructions for Lua Language Server Annotations:
--
-- Important Note:
-- LuaCATS annotations are [no longer cross-compatible](https://github.com/LuaLS/lua-language-server/issues/980) with [EmmyLua annotations](https://emmylua.github.io/annotation.html) as of `v3`.
--
-- ## Annotation Formatting
-- Annotations support various [Markdown syntax](https://www.markdownguide.org/cheat-sheet/), including headings, bold text, italic text, struckthrough text, ordered list, unordered list, blockquote, code, code block, horizontal rule, link, and image. Newlines can be added using HTML `<br>` tags, `\n` newline escape character, two trailing spaces, or Markdown backslash `\` (not recommended).
--
-- Tips:
---` one line above a function suggests a snippet with [`@param`](#param) and [`@return`](#return) annotations for each parameter and return value.
--   ![Snippet being used in VS Code](/images/wiki/annotation-snippet.png)
--
-- ## Documenting Types
-- Properly documenting types is crucial for leveraging the language server's features. Recognized Lua types (regardless of [version in use](/wiki/settings/#runtimeversion)) include:
-- - `nil`
-- - `any`
-- - `boolean`
-- - `string`
-- - `number`
-- - `integer`
-- - `function`
-- - `table`
-- - `thread`
-- - `userdata`
-- - `lightuserdata`
--
-- Custom types, including [classes](#class) and [fields](#field), can be documented, and even [custom types](#alias) can be created.
--
-- Adding a question mark (`?`) after a type (e.g., `boolean?` or `number?`) indicates it can be the specified type or `nil`, useful for functions that may return a value or `nil`.
-- ### Documenting Advanced Types
-- - Union Type: `TYPE_1 | TYPE_2`
-- - Array: `VALUE_TYPE[]`
-- - Dictionary: `{ [string]: VALUE_TYPE }`
-- - Key-Value Table: `table<KEY_TYPE, VALUE_TYPE>`
-- - Table Literal: `{ key1: VALUE_TYPE, key2: VALUE_TYPE }`
-- - Function: `fun(PARAM: TYPE): RETURN_TYPE`
--
-- Unions may need parentheses in certain situations, like defining an array with multiple value types:
---@type (string | integer)[]
local myArray = {}

--
-- ## Understanding This Page
-- To interpret the annotations described on this page, understanding the `Syntax` sections of each annotation is crucial.
--
-- Symbol Key:
-- - `<value_name>`: A required value you provide
-- - `[value_name]`: Everything inside is optional
-- - `[value_name...]`: This value is repeatable
-- - `value_name | value_name`: The left or right side is valid
--
-- Any other symbols are syntactically required and should be copied verbatim. Examples under each annotation should provide clarity.
--
-- ## Annotations List
-- Below is a list of all annotations recognized by the language server:
-- ### @alias
-- An alias can be used to create your own type. It can also create an enum or custom type.
--
-- Syntax
-- - Simple:
---@alias <name> <type>

-- - Enum:
---@alias <name>
---| '<value>' [# description]

--
-- Examples
-- - Simple alias:
---@alias userID integer The ID of a user

-- - Custom Type:
---@alias modes "r" | "w"

-- - Custom Type with Descriptions:
---@alias DeviceSide
---| '"left"' # The left side of the device
---| '"right"' # The right side of the device
---| '"top"' # The top side of the device
---| '"bottom"' # The bottom side of the device
---| '"front"' # The front side of the device
---| '"back"' # The back side of the device
---@param side DeviceSide
local function checkSide(side) end

-- ### @as
-- Force a type onto an expression.
--
-- Syntax

--[[@as <type>]]

--
-- Examples
-- - Override Type:
---@param key string Must be a string
local function doSomething(key) end
local x = nil
doSomething(x --[[@as string]])

-- ### @async
-- Mark a function as asynchronous.
--
-- Syntax
--
---@async

--
-- Examples
-- - Basic Usage:
---@async
---@param data string
---@return boolean
local function processDataAsync(data) end

-- ### @class
-- Document a class.
--
-- Syntax
-- - Simple:
---@class <name>

-- - Inheritance:
---@class <name> : <parent_class>

--
-- Examples
-- - Basic Class:
---@class Animal

-- - Class with Inheritance:
---@class Dog : Animal

-- ### @deprecated
-- Mark a function, class, or field as deprecated.
--
-- Syntax
-- - Simple:
---@deprecated

-- - With a message:
---@deprecated [<message>]

--
-- Examples
-- - Basic Deprecated:
---@deprecated
local function oldFunction() end

-- - Deprecated with Message:
---@deprecated Use newFunction instead
local function oldFunction() end

-- ### @field
-- Document a field in a class or module.
--
-- Syntax
-- - Simple:
---@field <name>

-- - With Type:
---@field <name> <type>

-- - With Description:
---@field <name> # Description of the field

-- - With Type and Description:
---@field <name> <type> # Description of the field

--
-- Examples
-- - Basic Field:
---@class MyClass
---@field myField

-- - Field with Type:
---@class MyClass
---@field myField string

-- - Field with Description:
---@class MyClass
---@field myField # Description of myField

-- - Field with Type and Description:
---@class MyClass
---@field myField string # Description of myField

-- ### @generic
-- Document a generic function.
--
-- Syntax
-- - Simple:
---@generic <T>
---@param x T

-- - With Multiple Generics:
---@generic <T, U>
---@param x T
---@param y U

--
-- Examples
-- - Simple Generic:
---@generic <T>
---@param x T
local function myGenericFunction(x) end

-- ### @param
-- Document a parameter in a function.
--
-- Syntax
-- - Simple:
---@param <name>

-- - With Type:
---@param <name> <type>

-- - With Description:
---@param <name> # Description of the parameter

-- - With Type and Description:
---@param <name> <type> # Description of the parameter

-- Examples
-- - Basic Parameter:
---@param value

-- - Parameter with Type:
---@param value string

-- - Parameter with Description:
---@param value # Description of the value

-- - Parameter with Type and Description:
---@param value string # Description of the value

-- ### @return
-- Document the return value of a function.
--
-- Syntax
-- - Simple:
---@return

-- - With Type:
---@return <type>

-- - With Description:
---@return # Description of the return value

-- - With Type and Description:
---@return <type> # Description of the return value

-- Examples
-- - Basic Return:
---@return

-- - Return with Type:
---@return string

-- - Return with Description:
---@return # Description of the return value

-- - Return with Type and Description:
---@return string # Description of the return value

-- ### @see
-- Create a hyperlink reference to another symbol.
--
-- Syntax
-- - Simple:
---@see <symbol>

-- - With Description:
---@see <symbol> # Additional description

-- Examples
-- - Basic See:
---@see myFunction

-- - See with Description:
---@see myFunction # Link to myFunction with additional description

-- ### @type
-- Document a type.
--
-- Syntax
-- - Simple:
---@type <name>

-- - With Description:
---@type <name> # Description of the type

-- Examples
-- - Basic Type:
---@type Point

-- - Type with Description:
---@type Point # Represents a 2D point in space

-- ### @vararg
-- Mark a parameter as a variable number of arguments.
--
-- Syntax

---@vararg <type>

-- Examples
-- - Basic Usage:
---@param ... number
local function sum(...) end
