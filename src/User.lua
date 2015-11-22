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
    if(not self.levelSelection) then
        if(self:justFinishedTutorial()) then
            self:setChapter(1)
            self:setLevel(1)
        else
            self:setChapter(#self.profile.chapters - 1)
            self:setLevel(self:latestLevel() + 1)
        end
    end

    return self.levelSelection.chapter, self.levelSelection.level
end

--------------------------------------------------------------------------------

function User:recordLevel(chapter, level, score)
    ---- score recording
    if(not self.profile.chapters[chapter+1]) then
        self.profile.chapters[chapter+1] = {}
    end

    self.profile.chapters[chapter+1][level] = score

    -------- analytics
    if(not self.profile.analytics[chapter+1]) then
        self.profile.analytics[chapter+1] = {}
    end

    if(not self.profile.analytics[chapter+1][level]) then
        self.profile.analytics[chapter+1][level] = {}
        self.profile.analytics[chapter+1][level] = {
            tries = 0
        }
    end

    self.profile.analytics[chapter+1][level].tries = self.profile.analytics[chapter+1][level].tries + 1

    local tries = self.profile.analytics[chapter+1][level].tries
    local gems = score.gems
    local value = chapter .. ':' .. level .. ':' .. tries .. ':' .. gems
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
    return #self.profile.chapters == 0
end

function User:previousScore(chapter, level)
    local chapterJson = self.profile.chapters[chapter+1]
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
    local nbLevelPlayedForPreviousChapter = self.profile.chapters[chapter] and #self.profile.chapters[chapter]
    local maxLevelForPreviousChapter = NB_LEVELS[chapter-1]
    local levelsCompleted = nbLevelPlayedForPreviousChapter == maxLevelForPreviousChapter

    return levelsCompleted
end

function User:justFinishedTutorial()
    return #self.profile.chapters == 1
end

-- getting the number of scores recorded for the latest chapter recorded
function User:latestLevel()
    return #self.profile.chapters[#self.profile.chapters]
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

function User:gems(profile, chapterNum, level)
    local chapter = self:chapterJson(profile, chapterNum)
    if(chapter and chapter[level]) then
        return chapter[level].gems
    else
        return 0
    end
end

--------------------------------------------------------------------------------

function User:chapterJson(profile, chapterNum)
    return profile.chapters[chapterNum+1]
end

function User:totalPercentage(profile)
    return 45
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
