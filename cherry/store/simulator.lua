--------------------------------------------------------------------------------

local _ = require 'cherry.libs.underscore'
local group = require 'cherry.libs.group'
local Panel = require 'cherry.components.panel'
local Text = require 'cherry.components.text'

--------------------------------------------------------------------------------

local SimulatorShop = {}

--------------------------------------------------------------------------------

function SimulatorShop:initialize()
  _G.log('[store][initialize] simulator fake store.')
  self.initialized = true
  self.products = {
    {
      productIdentifier = self:getProductId(100),
      localizedPrice = '1.11€'
    },
    {
      productIdentifier = self:getProductId(1000),
      localizedPrice = '2.11€'
    },
    {
      productIdentifier = self:getProductId(10000),
      localizedPrice = '3.11€'
    }
  }

  self:drawShop()
end

--------------------------------------------------------------------------------

function SimulatorShop:getProductId(nbGems)
  local id = 'uralys.kodo.gems.' .. nbGems
  return id
end

--------------------------------------------------------------------------------

function SimulatorShop:buy(productId)
  native.setActivityIndicator(true)
  timer.performWithDelay(
    500,
    function()
      self:showTestStore(productId)
    end
  )
end

--------------------------------------------------------------------------------

function SimulatorShop:showTestStore(id)
  native.setActivityIndicator(false)
  self.display.alpha = 0

  local testScore = display.newGroup()
  App.hud:insert(testScore)
  testScore.x = display.contentWidth * 0.5
  testScore.y = display.contentHeight * 0.5

  local _close = function()
    self.display.alpha = 1
    self.buying = false
    group.destroy(testScore)
  end

  Panel:vertical(
    {
      parent = testScore,
      width = display.contentWidth * 0.7,
      height = display.contentHeight * 0.7,
      x = 0,
      y = 0
    }
  )

  Text:create(
    {
      parent = testScore,
      value = id,
      fontSize = 40,
      color = App.colors.textEnabled,
      x = 0,
      y = -display.contentHeight * 0.3
    }
  )

  -----------------
  -- dummy buy

  Text:create(
    {
      parent = testScore,
      value = 'simulate buy',
      fontSize = 50,
      color = App.colors.textEnabled,
      x = 0,
      y = -display.contentHeight * 0.15,
      onTap = function()
        _close()
        self:addGems()
      end
    }
  )

  -----------------
  -- dummy cancel

  Text:create(
    {
      parent = testScore,
      value = '         simulate \ncancelled transaction',
      fontSize = 50,
      color = App.colors.textEnabled,
      x = 0,
      y = 0,
      onTap = function()
        _close()
        self:cancelTransaction('dummy-cancel')
      end
    }
  )

  -----------------
  -- dummy failed

  Text:create(
    {
      parent = testScore,
      value = '       simulate \nfailed transaction',
      fontSize = 50,
      color = App.colors.textEnabled,
      x = 0,
      y = display.contentHeight * 0.15,
      onTap = function()
        _close()
        self:cancelTransaction('dummy-failed')
      end
    }
  )
end

--------------------------------------------------------------------------------

return SimulatorShop
