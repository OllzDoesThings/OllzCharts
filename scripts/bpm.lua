-- Psych Engine Lua Script: Dynamic BPM Counter with Scalable Glitching

local baseBPM = 0  -- Stores the starting BPM
local glitchChars = {'#', '?', '%', '&', '@', '*', '!'}  -- Characters for glitching

function onCreatePost()
    -- Capture the song's starting BPM as the baseline.
    baseBPM = bpm
    
    -- Position (Centered horizontally, 300 pixels above the screen center).
    local centerX = math.floor(screenWidth / 2) - 150  -- Adjusted for text width
    local centerY = math.floor(screenHeight / 2) - 300
    
    -- Create the BPM counter.
    makeLuaText('bpmCounter', 'BPM: ' .. tostring(songBpm), 300, centerX, centerY)
    setTextSize('bpmCounter', 24)  -- Large text for visibility
    addLuaText('bpmCounter')
end

function onUpdatePost(elapsed)
    local currentBPM = curBpm
    local displayBPM = tostring(currentBPM)

    setTextString('bpmCounter', 'BPM: ' .. displayBPM)
    
    -- Recalculate positions (in case screen size changes).
    local centerX = math.floor(screenWidth / 2) - 150
    local centerY = math.floor(screenHeight / 2) - 300
end

-- Function to glitch the BPM display text
function glitchText(bpm, glitchCount)
    for i = 2, #bpm do  -- Never glitch the first digit for clarity
        if math.random() < (glitchCount / 10) then
            local randomChar = glitchChars[math.random(#glitchChars)]
            bpm = bpm:sub(1, i - 1) .. randomChar .. bpm:sub(i + 1)
        end
    end
    return bpm
end

-- Generates a random RGB color (more intense with higher BPM differences)
function getRandomColor(intensity)
    local function randColor(value)
        return string.format('%02X', math.min(255, math.random(150 + value, 255)))
    end
    return randColor(intensity) .. randColor(math.floor(intensity / 2)) .. randColor(math.floor(intensity / 3))
end
