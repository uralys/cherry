--------------------------------------------------------------------------------

local analytics = require 'cherry.libs.analytics'

--------------------------------------------------------------------------------

local GoogleShop = {}

--------------------------------------------------------------------------------

function GoogleShop:getProductId(nbGems)
  local id = 'uralys.kodo.gems.' .. nbGems
  return id
end

function GoogleShop:getGemsFromId(id)
  local nbGems = id:split('uralys.kodo.gems.')[2]
  return tonumber(nbGems)
end

local function isConsumable(id)
  return true
end

--------------------------------------------------------------------------------

function GoogleShop:initialize()
  _G.log('[shop][initialize] plugging Google appStore...')
  local function storeTransaction(event)
    local transaction = event.transaction
    _G.log(
      '[shop] --> callback storeTransaction | transaction.state:' ..
        transaction.state
    )
    native.setActivityIndicator(false)

    if (transaction.state == 'initialized') then
      self:loadProducts()
    elseif (transaction.state == 'purchased' or transaction.state == 'restored') then
      local id = transaction.productIdentifier
      self.buying = false
      self.nbGemsToAdd = self:getGemsFromId(id)
      self.yFrom = self.yFrom or self.TOP -- on restore no buy button was pressed

      analytics.event('shop', transaction.state, id)

      if (isConsumable(id)) then
        self.appStore.consumePurchase(id)
      else
        self:addGems()
      end
    elseif (transaction.state == 'cancelled') then
      analytics.event('shop', 'cancelled', App.user:deviceId())
      self:cancelTransaction(transaction)
    elseif (transaction.state == 'failed') then
      local info =
        'gems: ' ..
        self.nbGemsToAdd ..
          ' | error:[' ..
            transaction.errorString .. '] user:' .. App.user:deviceId()

      analytics.event('shop', 'failed', info)
      self:cancelTransaction(transaction)
    elseif (transaction.state == 'consumed') then
      analytics.event('shop', 'consumed', App.user:deviceId())
      self:addGems()
    else
      local unknownType = transaction and transaction.state or 'no-state'
      analytics.event(
        'shop',
        'unknown-transaction-' .. unknownType,
        App.user:deviceId()
      )
    end

    self.appStore.finishTransaction(transaction)
  end

  native.setActivityIndicator(true)
  self.appStore = require('plugin.google.iap.v3')
  self.appStore.init(storeTransaction)
end

--------------------------------------------------------------------------------

function GoogleShop:buy(productId)
  native.setActivityIndicator(true)
  _G.log('[shop][buy] google PURCHASING...[' .. productId .. ']')
  self.appStore.purchase(productId)
end

--------------------------------------------------------------------------------

return GoogleShop
