-- THIS ONLY CODES LUA, BUT PYTHON AND OTHER LANGUAGES WILL BE RELEASED LATER
--[[ CODER 5B IS LICENSED UNDER THE APACHE 2.0 LICENSE, ALL RIGHTS RESERVED TO THE MAIN OWNER OF LUGENTIC. ]]

local Agent = {}
Agent.__index = Agent

-- Initialize the Agentic Model
function Agent.new()
    local self = setmetatable({}, Agent)
    self.model = "agentic:coder-5b"
    self.memory = {}
    
    -- Register available tools the agent can autonomously call
    self.tools = {
        read_code = function(filename)
            print("[Tool: Read] Reading " .. filename)
            return "local x = say( Hello ) -- Buggy code"
        end,
        write_code = function(filename, content)
            print("[Tool: Write] Deploying fix to " .. filename)
            return "Success: File written."
        end,
        run_tests = function(filename)
            print("[Tool: Test] Running compilation tests on " .. filename)
            return "Fail: Syntax error near 'Hello'"
        end
    }
    return self
end

-- Simulates internal reasoning/LLM processing
function Agent:think(prompt)
    if string.find(prompt, "fix") and not self.memory.tested then
        return "THOUGHT: The user wants me to fix code. First, I need to test the current file to see what is broken.", "run_tests", "main.lua"
    elseif self.memory.last_observation == "Fail: Syntax error near 'Hello'" then
        return "THOUGHT: The test failed due to string syntax. I will rewrite the file with proper quotes.", "write_code", "main.lua", "local x = say(\"Hello\")"
    else
        return "THOUGHT: Code is fixed and verified. Task complete.", "complete"
    end
end

-- The core Agentic execution loop (Autonomous workflow)
function Agent:execute_task(task_prompt)
    print("--- [Agent Initialized: " .. self.model .. "] ---")
    print("Objective: " .. task_prompt .. "\n")
    
    local running = true
    local steps = 0
    
    while running and steps < 5 do
        steps = steps + 1
        print("--- Step " .. steps .. " ---")
        
        -- 1. Think and choose action
        local thought, action, arg1, arg2 = self:think(task_prompt)
        print(thought)
        
        -- 2. Act
        if action == "complete" then
            print("\n[Status] Objective successfully achieved by " .. self.model)
            running = false
        elseif self.tools[action] then
            local observation = self.tools[action](arg1, arg2)
            print("OBSERVATION: " .. observation .. "\n")
            
            -- Update agent memory state
            if action == "run_tests" then self.memory.tested = true end
            self.memory.last_observation = observation
        else
            print("Error: Unknown tool.")
            running = false
        end
    end
end

-- ============================================================================
-- Execution Example
-- ============================================================================
local coder = Agent.new()
coder:execute_task("Please inspect and fix the syntax errors in main.lua")
