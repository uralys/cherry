--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local analytics = require 'cherry.libs.analytics'
local animation = require 'cherry.libs.animation'
local Text = require 'cherry.libs.text'
local gesture = require 'cherry.libs.gesture'
local Screen = require 'cherry.components.screen'
local Scroller = require 'cherry.components.scroller'
local Panel = require 'cherry.components.panel'
local Multiplier = require 'cherry.components.multiplier'
local Button = require 'cherry.components.button'
local Profile = require 'cherry.components.profile'
local Banner = require 'cherry.components.banner'

--------------------------------------------------------------------------------

local Chapters = {}

--------------------------------------------------------------------------------

function Chapters:draw(options)
  self.options = options
  self:reset()
  self:setup(options)
  self:prepareBoard(options)
  self:fillContent(options)
  self:displayBanner(options)

  self:onShow()
  return self
end

function Chapters:onShow()
  animation.pop(self.banner)
end

function Chapters:reset()
  if (self.scroller) then
    display.remove(self.banner)
    self.scroller:destroy()
  end
end

--------------------------------------------------------------------------------

function Chapters:buy(num)
  local id = 'uralys.phantoms.chapter' .. num
  local store

  -- Product listener function
  local function productListener(event)
    _G.log('Valid products:', #event.products)
    _G.log(_G.inspect(event.products))
    _G.log('Invalid products:', #event.invalidProducts)
    _G.log(_G.inspect(event.invalidProducts))
  end

  local function storeTransaction(event)
    _G.log('--> callback storeTransaction')
    native.setActivityIndicator(false)
    local transaction = event.transaction
    _G.log('transaction.state: ', transaction.state)

    if (transaction.state == 'purchased') then
      App.user:bought(num)
    elseif (transaction.state == 'cancelled') then
      _G.log(_G.inspect(transaction))
    elseif (transaction.state == 'failed') then
      _G.log(_G.inspect(transaction))
    end

    store.finishTransaction(transaction)
    self:draw(self.options)
  end

  if (_G.SIMULATOR or App.env.name == 'development') then
    App.user:bought(num)
    self:draw(self.options)
    return
  elseif (_G.IOS) then
    native.setActivityIndicator(true)
    store = require('store')
    store.init(storeTransaction)
    store.purchase(id)
  elseif (_G.ANDROID) then
    native.setActivityIndicator(true)
    store = require('plugin.google.iap.v3')
    timer.performWithDelay(
      1000,
      function()
        _G.log('init store...')
        store.init('google', storeTransaction)
        timer.performWithDelay(
          1000,
          function()
            _G.log('trying to loadProducts')
            if (store.canLoadProducts) then
              _G.log('trying to loadProducts')
              local productIdentifiers = {
                id,
                'uralys.phantoms.chapter_3'
              }
              store.loadProducts(productIdentifiers, productListener)
            end

            _G.log('PURCHASING...[' .. id .. ']')
            store.purchase(id)
          end
        )
      end
    )
  end
end

--------------------------------------------------------------------------------

function Chapters:setup(options)
  self.parent = options.parent
  self.x = display.contentWidth * 0.5
  self.y = display.contentHeight * 0.5
  self.width = display.contentWidth * 0.8
  self.height = display.contentHeight * 0.9
  self.top = self.y - display.contentHeight * 0.42
end

function Chapters:prepareBoard(options)
  self.scroller =
    Scroller:new(
    {
      parent = self.parent,
      top = self.top + 7,
      left = self.x - self.width * 0.45,
      width = self.width * 0.9,
      height = self.height - 22,
      gap = display.contentHeight * 0.05,
      handleHeight = display.contentHeight * 0.07,
      horizontalScrollDisabled = true,
      hideBackground = true
    }
  )

  self.scroller.onBottomReached = function()
    analytics.event('game', 'chapter-scroll-end')
  end
end

function Chapters:displayBanner(options)
  self.banner =
    Banner:large(
    {
      parent = self.parent,
      text = 'Chapters',
      fontSize = 57,
      width = display.contentWidth * 0.25,
      height = display.contentHeight * 0.13,
      x = self.x,
      y = self.top
    }
  )
end

--------------------------------------------------------------------------------

function Chapters:fillContent(options)
  for i = 1, #options.chapters do
    local chapter = self:summary(App.user:chapterData(i))
    self.scroller:insert(chapter)
  end
end

function Chapters:hellBarEntrance(options)
  local hellbar = display.newGroup()

  local panel =
    Panel:chapter(
    {
      parent = hellbar,
      width = self.width * 0.83,
      height = display.contentHeight * 0.35,
      status = 'off'
    }
  )

  display.newImage(
    hellbar,
    'cherry/assets/images/gui/houses/hell.png',
    panel.width * 0.2,
    0
  )

  local contentX = -panel.width * 0.2

  Text.embossed(
    {
      parent = hellbar,
      value = 'Reach 10k likes on FB to open this secret door...',
      x = contentX,
      -- y     = - App:adaptToRatio(15), -- with progress bar
      y = 0,
      width = panel.width * 0.4,
      height = panel.height * 0.45,
      font = _G.FONTS.default,
      fontSize = App:adaptToRatio(10)
    }
  )

  Button:icon(
    {
      parent = hellbar,
      type = 'facebook',
      x = contentX,
      y = panel.height * 0.35,
      action = function()
        Screen:openFacebook()
      end
    }
  )

  self:lockChapter(
    {
      parent = hellbar,
      x = -panel.width * 0.47,
      y = -panel.height * 0.47
    }
  )

  return hellbar
end

--------------------------------------------------------------------------------

function Chapters:isDisabled(options)
  return options.status == 'off' or options.paying and not options.payed
end

--------------------------------------------------------------------------------

function Chapters:drawCustomImage(options, panel, parent)
  local house =
    display.newImage(parent, options.customImage, -panel.width * 0.31, 0)

  if (self:isDisabled(options)) then
    house.fill.effect = 'filter.desaturate'
    house.fill.effect.intensity = 0.8
  end
end

--------------------------------------------------------------------------------

function Chapters:drawClosedChapter(options, panel, parent)
  local y1 = -panel.height * 0.15
  local y2 = panel.height * 0.13

  Profile:status(
    {
      parent = parent,
      x = panel.width * 0.15,
      y = y1,
      width = panel.width * 0.4,
      height = panel.height * 0.15,
      iconImage = 'assets/images/gui/items/mini-phantom.icon.png',
      step = options.percentLevels,
      disabled = true
    }
  )

  Profile:status(
    {
      parent = parent,
      x = panel.width * 0.15,
      y = y2,
      width = panel.width * 0.4,
      height = panel.height * 0.15,
      iconImage = 'cherry/assets/images/gui/items/gem.icon.png',
      step = options.percentGems,
      disabled = true
    }
  )

  local enabled = options.status == 'on'

  if (enabled and options.paying) then
    local button =
      self:buyButton(
      {
        parent = parent,
        x = panel.width * 0.42,
        y = 0,
        payed = options.payed
      }
    )

    gesture.onTap(
      button,
      function()
        self:buy(options.chapter)
      end
    )
  end
end

--------------------------------------------------------------------------------

function Chapters:drawOpenChapter(options, panel, parent)
  Multiplier:draw(
    {
      item = 'gem',
      parent = parent,
      x = panel.width * 0.04,
      y = -panel.height * 0.21,
      scale = 0.75,
      value = App.user:chapterGems(App.user.profile, options.chapter)
    }
  )

  Multiplier:draw(
    {
      item = 'star',
      parent = parent,
      x = panel.width * 0.04,
      y = panel.height * 0.2,
      scale = 0.75,
      value = App.score:chapterStars(options.chapter)
    }
  )

  local play =
    Button:icon(
    {
      parent = parent,
      type = 'play',
      x = panel.width * 0.35,
      y = 0,
      scale = 1.2,
      action = function()
        analytics.event('game', 'chapter-selection', options.chapter)
        App.user:setChapter(options.chapter)
        Router:open('level-selection')
      end
    }
  )

  animation.pop(play)
end

--------------------------------------------------------------------------------

function Chapters:summary(options)
  local summary = display.newGroup()

  local status = 'on'
  if (self:isDisabled(options)) then
    status = 'off'
  end

  local panel =
    Panel:chapter(
    {
      parent = summary,
      width = self.width * 0.83,
      height = display.contentHeight * 0.4,
      status = status
    }
  )

  if (options.customImage) then
    self:drawCustomImage(options, panel, summary)
  end

  if (options.condition) then
    local contentX = panel.x + panel.width * 0.22
    local textY

    if (options.type == 'hidden') then
      textY = panel.y - panel.height * 0.2
      local buttonsY = panel.height * 0.2

      Button:icon(
        {
          parent = summary,
          type = 'facebook',
          x = contentX,
          y = buttonsY,
          action = function()
            Screen:openFacebook()
          end
        }
      )

      Button:icon(
        {
          parent = summary,
          type = 'rate',
          x = contentX + panel.width * 0.15,
          y = buttonsY,
          action = function()
            native.showPopup(
              'appStore',
              {
                iOSAppId = App.IOS_ID,
                supportedAndroidStores = {'google'}
              }
            )
          end
        }
      )
    else
      textY = panel.y
    end

    Text:embossed(
      {
        parent = summary,
        value = options.condition.text,
        x = contentX,
        y = textY,
        width = panel.width * 0.5,
        height = panel.height * 0.38,
        font = _G.FONTS.default,
        fontSize = App:adaptToRatio(12)
      }
    )
  else
    if (options.status == 'on' and options.payed) then
      self:drawOpenChapter(options, panel, summary)
    else
      self:drawClosedChapter(options, panel, summary)
    end
  end

  if (options.status == 'off') then
    self:lockChapter(
      {
        parent = summary,
        x = panel.width * 0.45,
        y = -panel.height * 0.33
      }
    )
  end

  return summary
end

--------------------------------------------------------------------------------

function Chapters:lockChapter(options)
  self:lock(
    _.defaults(
      {
        parent = options.parent,
        x = options.x,
        y = options.y
      },
      options
    )
  )
end

function Chapters:buyButton(options)
  local button =
    display.newImage(options.parent, 'cherry/assets/images/gui/buttons/buy.png')

  button.x = options.x
  button.y = options.y

  return button
end

--------------------------------------------------------------------------------

function Chapters:lock(options)
  if (options.status == 'on') then
    return
  end

  local lock =
    display.newImage(options.parent, 'cherry/assets/images/gui/items/lock.png')

  lock.x = options.x
  lock.y = options.y
  return lock
end

--------------------------------------------------------------------------------

return Chapters
