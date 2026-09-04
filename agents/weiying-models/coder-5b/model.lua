--[[ CODER 5B IS LICENSED UNDER THE APACHE 2.0 LICENSE, ALL RIGHTS RESERVED TO THE MAIN OWNER OF LUGENTIC. ]] 

local greet = "Hi! I am: "
local model = "weiying:coder-5b"

local function say(text) 
    print(text) 
end

-- Simulating a user input string for demonstration
local user = "Model" 

-- Fixed the conditions to compare strings correctly
if user == "Hello, world!" then 
    say(greet .. model) -- Use '..' to combine strings in Lua
elseif user == "Model" then 
    say(model)
end
