notecount = 0
local shakeCap = 120  -- Cap the shake at 120 notes

local spinStrums = true -- Enable or disable spinning
local spinRadius = 20   -- How far the strums move
local spinSpeed = 1     -- Adjust this to control how fast they spin
local defaultStrumPos = {} -- Table to store default positions

function onCreatePost()
    -- Store the default positions of strum notes
    for i = 0, 7 do
        defaultStrumPos[i] = {
            x = getPropertyFromGroup('strumLineNotes', i, 'x'),
            y = getPropertyFromGroup('strumLineNotes', i, 'y')
        }
    end
end

function onUpdate(elapsed)
    -- Ensure curSection is not nil
    curSection = curSection or 0  -- If curSection is nil, set it to 0
    
    notecount = 0
    
    clearEffects('camHUD')
    clearEffects('camGame')

    -- Get the current beat based on song position
    beat = (getSongPosition() / 1000) * (curBpm / 60)
    
    if spinStrums then
        for i = 0, 7 do
            local baseX = defaultStrumPos[i].x -- Get stored default X
            local baseY = defaultStrumPos[i].y -- Get stored default Y
            
            -- Calculate the angle for each note to make it spin smoothly (rotation every 4 beats)
            local angle = beat * spinSpeed * 90  -- 90 degrees per beat * spinSpeed
            local angleRadians = math.rad(angle)  -- Convert to radians
            
            -- Circular motion based on the angle
            local offsetX = math.cos(angleRadians + (i * math.pi / 4)) * spinRadius
            local offsetY = math.sin(angleRadians + (i * math.pi / 4)) * spinRadius
            
            -- Apply movement relative to the original position
            setPropertyFromGroup('strumLineNotes', i, 'x', baseX + offsetX)
            setPropertyFromGroup('strumLineNotes', i, 'y', baseY + offsetY)
        end
    end
end

function camShake(char)
    -- Ensure notecount is never nil and limit it to the shake cap
    local cappedNotecount = math.min(notecount or 0, shakeCap)

    if char == "op" then
        cameraShake("game", cappedNotecount / 1200, 0.03)
        cameraShake("hud", cappedNotecount / 1550, 0.03)
    else
        cameraShake("game", cappedNotecount / 1550, 0.03)
        cameraShake("hud", cappedNotecount / 2000, 0.03)
    end

    clearEffects('camHUD')
    clearEffects('camGame')

    addChromaticAbberationEffect('camHUD', cappedNotecount / 900)
    addChromaticAbberationEffect('camGame', cappedNotecount / 1200)
end

function opponentNoteHit(index, noteDir, noteType, isSustainNote)
    if not isSustainNote then
        notecount = notecount + 1
    end
    camShake("op")
end

function goodNoteHit(index, noteDir, noteType, isSustainNote)
    if not isSustainNote then
        notecount = notecount + 1
    end
    camShake("bf")
end

function onBeatHit()
    if curBeat % 2 == 0 then
        if (curBeat / 2) % 2 == 0 then
            setProperty('camHUD.y', 30) -- Move HUD up
        else
            setProperty('camHUD.y', -30) -- Move HUD down
        end
        -- Tween HUD back to its original position smoothly
        doTweenY('hudReturn', 'camHUD', 0, crochet / 500, 'quadOut')
    end
end
