--------------------------------------------------------------------------------

local User = {
    savedData = nil,
    profile   = nil
}

--------------------------------------------------------------------------------

function User:load()
    self.savedData = utils.loadUserData('savedData.json');

    -- preparing data
    if(not self.savedData) then
        self:resetSavedData()
    end

    -- loading last profile
    self:switchProfile(self.savedData.selectedProfile)
end

--------------------------------------------------------------------------------

function User:resetSavedData()
    self.savedData = {
        version = App.VERSION,
        selectedProfile = 1,
        profiles = {
            initPlayer(1),
            initPlayer(2),
            initPlayer(3)
        }
    }

    self:save()
end

--------------------------------------------------------------------------------

function User:switchProfile(num)
    self.profile = self.savedData.profiles[num]
    self.savedData.selectedProfile = num
    self:save()
end

--------------------------------------------------------------------------------

function User:resetLevelSelection()
    self.levelSelection = nil
end

function User:setChapter(chapter)
    self.levelSelection = {
        chapter = chapter
    }
end

function User:selectedChapter()
    return self.levelSelection.chapter
end

function User:selectedLevel()
    return self.levelSelection.level
end

function User:setLevel(level)
    self.levelSelection.level = level
end

function User:currentGame()
    return self.levelSelection.chapter, self.levelSelection.level
end

--------------------------------------------------------------------------------

function User:recordLevel(chapter, level, score)
    -- just finished tutorial
    if(chapter == 0) then
        self.profile.tutorial = true
        self:save()
        return
    end

    ---- score recording
    if(not self.profile.chapters[chapter]) then
        self.profile.chapters[chapter] = {}
    end

    self.profile.chapters[chapter][level] = score

    -------- analytics
    local gems = score.gems
    local value = chapter .. ':' .. level .. ':' .. gems
    analytics.event('game', 'score', value)

    -----------
    self:save()
end

--------------------------------------------------------------------------------

function User:save()
    utils.saveTable(self.savedData, 'savedData.json')
end

--------------------------------------------------------------------------------
--  Profile crawling
--------------------------------------------------------------------------------

function User:isNew()
    return not self.profile.tutorial
end

function User:previousScore(chapter, level)
    local chapterJson = self.profile.chapters[chapter]
    local record = nil

    if(chapterJson) then
        record = chapterJson[level]
    end

    if(record) then
        return record
    else
        return Score:worst()
    end
end

--------------------------------------------------------------------------------

function User:chapterData(chapter)
    return self:chapterStatus(self.profile, chapter)
end

--------------------------------------------------------------------------------

function User:chapterStatus(profile, chapter)
    if (self:isOpen(chapter)) then
        return {
            chapter = chapter,
            status  = 'on'
        }
    else
        return {
            chapter     = chapter,
            status      = 'off',
            percentGems = 12
        }
    end
end

function User:isOpen(chapter)
    if(chapter == 1) then
        return self.profile.tutorial
    end

    return false
end

function User:justFinishedTutorial()
    return #self.profile.chapters == 1
end

--------------------------------------------------------------------------------

function User:isLevelAvailable(chapterNum, level)
    local chapter = self:chapterJson(self.profile, chapterNum)
    if(not chapter) then
        return level == 1
    else
        return level <= #chapter+1
    end
end

function User:isLevelDone(chapterNum, level)
    local chapter = self:chapterJson(self.profile, chapterNum)
    if(not chapter) then
        return false
    else
        return level <= #chapter
    end
end

function User:items(profile, chapterNum, level, item)
    local chapter = self:chapterJson(profile, chapterNum)
    if(chapter and chapter[level]) then
        return chapter[level][item]
    else
        return 0
    end
end

function User:gems(profile, chapterNum, level)
    return self:items(profile, chapterNum, level, 'gems')
end

--------------------------------------------------------------------------------

function User:chapterJson(profile, chapterNum)
    return profile.chapters[chapterNum]
end

function User:totalPercentage(profile)
    local nbGems  = 12
    local maxGems = 28
    local percent = math.min(100, round ( nbGems / maxGems  * 100))

    return  {
        value = percent,
        text = nbGems .. '/' .. maxGems
    }
end

--------------------------------------------------------------------------------
-- PRIVATE
--------------------------------------------------------------------------------

function initPlayer(num)
    return {
        name      = 'Player ' .. num,
        avatar    = 'profile.' .. num .. '.png',
        chapters  = {},
        analytics = {},
        options   = {}
    }
end

--------------------------------------------------------------------------------

return User
