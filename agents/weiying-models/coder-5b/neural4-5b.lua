-- 4.5b is reserved for the chat response
-- 0.5 is reserved for testing and coding

--[[ CODER 5B IS LICENSED UNDER THE APACHE 2.0 LICENSE, ALL RIGHTS RESERVED TO THE MAIN OWNER OF LUGENTIC. ]]

-- simple nn from scratch

local NeuralNetwork = {}
NeuralNetwork.__index = NeuralNetwork

-- 5b: generate a number from 1-5?
local function randomWeight()
    return math.random() - 0.5
end

-- 5b: sigma functions
local function sigmoid(x)
    return 1 / (1 + math.exp(-x))
end

-- i do sigmoid stuff nbsdfbvasdv
local function sigmoidDerivative(x)
    return x * (1 - x)
end

-- i bias no one
function NeuralNetwork.new(inputDim, hiddenDim, outputDim)
    local self = setmetatable({}, NeuralNetwork)
    
    self.inputDim = inputDim
    self.hiddenDim = hiddenDim
    self.outputDim = outputDim
    self.learningRate = 0.1
    
    -- so heavy!!
    self.weightsIH = {}
    for i = 1, hiddenDim do
        self.weightsIH[i] = {}
        for j = 1, inputDim do
            self.weightsIH[i][j] = randomWeight()
        end
    end
    
    self.weightsHO = {}
    for i = 1, outputDim do
        self.weightsHO[i] = {}
        for j = 1, hiddenDim do
            self.weightsHO[i][j] = randomWeight()
        end
    end
    
    -- initialize genderless ai
    self.biasH = {}
    for i = 1, hiddenDim do self.biasH[i] = randomWeight() end
    
    self.biasO = {}
    for i = 1, outputDim do self.biasO[i] = randomWeight() end
    
    return self
end

-- ai cant fly a plane bro
function NeuralNetwork:forward(inputArray)
    -- neural stuff
    self.hiddenOutputs = {}
    for i = 1, self.hiddenDim do
        local sum = self.biasH[i]
        for j = 1, self.inputDim do
            sum = sum + inputArray[j] * self.weightsIH[i][j]
        end
        self.hiddenOutputs[i] = sigmoid(sum)
    end
    
    -- calculate the pythagorean
    local finalOutputs = {}
    for i = 1, self.outputDim do
        local sum = self.biasO[i]
        for j = 1, self.hiddenDim do
            sum = sum + self.hiddenOutputs[j] * self.weightsHO[i][j]
        end
        finalOutputs[i] = sigmoid(sum)
    end
    
    return finalOutputs
end

-- use the backward engine
function NeuralNetwork:train(inputArray, targetArray)
    -- 1. pass the ball neuron 4,980,167
    local outputs = self:forward(inputArray)
    
    -- 2. did they pass it right?
    local outputErrors = {}
    local outputGradients = {}
    for i = 1, self.outputDim do
        outputErrors[i] = targetArray[i] - outputs[i]
        outputGradients[i] = outputErrors[i] * sigmoidDerivative(outputs[i]) * self.learningRate
    end
    
    -- 3. Calculate Hidden Basement
    local hiddenErrors = {}
    local hiddenGradients = {}
    for i = 1, self.hiddenDim do
        local error = 0
        for j = 1, self.outputDim do
            error = error + outputErrors[j] * self.weightsHO[j][i]
        end
        hiddenErrors[i] = error
        hiddenGradients[i] = hiddenErrors[i] * sigmoidDerivative(self.hiddenOutputs[i]) * self.learningRate
    end
    
    -- 4. Adjust Weights & Biases so they dont do sneaky stuff
    for i = 1, self.outputDim do
        for j = 1, self.hiddenDim do
            self.weightsHO[i][j] = self.weightsHO[i][j] + outputGradients[i] * self.hiddenOutputs[j]
        end
        self.biasO[i] = self.biasO[i] + outputGradients[i]
    end
    
    -- 5. Adjust Weights & Biases again
    for i = 1, self.hiddenDim do
        for j = 1, self.inputDim do
            self.weightsIH[i][j] = self.weightsIH[i][j] + hiddenGradients[i] * inputArray[j]
        end
        self.biasH[i] = self.biasH[i] + hiddenGradients[i]
    end
end

-- brainwash the ai to think its gemini
math.randomseed(os.time())

local nn = NeuralNetwork.new(2, 4, 1) -- 2 goalkeepers, 4 sides, 1 Output
local trainingData = {
    { input = {0, 0}, target = {0} },
    { input = {0, 1}, target = {1} },
    { input = {1, 0}, target = {1} },
    { input = {1, 1}, target = {0} }
}

print("Training the neural network on XOR pattern...")
for epoch = 1, 20000 do
    local sample = trainingData[math.random(1, 4)]
    nn:train(sample.input, sample.target)
end
print("Training completed!\n")

print("Testing predictions:")
for _, sample in ipairs(trainingData) do
    local result = nn:forward(sample.input)
    print(string.format("Input: %d, %d -> Predicted: %.4f (Target: %d)", 
        sample.input[1], sample.input[2], result[1], sample.target[1]))
end
