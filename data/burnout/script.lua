notecount = 0
local shakeCap = 120  -- Cap the shake at 120 notes

function onUpdate(elapsed)
    -- Ensure curSection is not nil
    curSection = curSection or 0  -- If curSection is nil, set it to 0

    -- Check the current section and adjust shaking accordingly
    -- Stop shaking entirely between sections 160 and 168
    if curSection >= 160 and curSection <= 168 then
        -- Do nothing here, no shake
    -- Reduce shaking between sections 168 and 176
    elseif curSection >= 168 and curSection <= 176 then
        -- Apply reduced shake
        cameraShake("game", 0.002, 0.03)
        cameraShake("hud", 0.0015, 0.03)

    elseif curSection >= 176 and curSection <= 184 then
        --stop the shaking yet again
    elseif curSection >= 184 then
        -- Normal shake
        cameraShake("game", 0.003, 0.03)
        cameraShake("hud", 0.002, 0.03)
    else
        -- Default behavior for sections not in the above ranges
        cameraShake("game", 0.003, 0.03)
        cameraShake("hud", 0.002, 0.03)
    end

    notecount = 0
end

function onCreatePost()
    --lmao
end

function camShake(char)
    -- Ensure notecount is never nil and limit it to the shake cap
    local cappedNotecount = math.min(notecount or 0, shakeCap)

    if char == "op" then
        cameraShake("game", cappedNotecount / 4000, 0.03)
        cameraShake("hud", cappedNotecount / 4500, 0.03)
    else
        cameraShake("game", cappedNotecount / 4500, 0.03)
        cameraShake("hud", cappedNotecount / 6200, 0.03)
    end

    clearEffects('camHUD')
    clearEffects('camGame')

    addChromaticAbberationEffect('camHUD', cappedNotecount / 6000)
	addChromaticAbberationEffect('camGame', cappedNotecount / 8000)

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
