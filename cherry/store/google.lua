--------------------------------------------------------------------------------

local analytics = require 'cherry.libs.analytics'

--------------------------------------------------------------------------------

local GoogleStore = {}

--------------------------------------------------------------------------------

function GoogleStore:getProductId(nbGems)
  local id = 'uralys.kodo.gems.' .. nbGems
  return id
end

function GoogleStore:getGemsFromId(id)
  local nbGems = id:split('uralys.kodo.gems.')[2]
  return tonumber(nbGems)
end

local function isConsumable(id)
  return true
end

--------------------------------------------------------------------------------

function GoogleStore:initialize()
  _G.log('[store][initialize] plugging google appStore...')
  local function storeTransaction(event)
    local transaction = event.transaction
    _G.log(
      '--> callback storeTransaction | transaction.state:' .. transaction.state
    )
    native.setActivityIndicator(false)

    if (transaction.state == 'initialized') then
      self:loadProducts()
    elseif (transaction.state == 'purchased' or transaction.state == 'restored') then
      local id = transaction.productIdentifier
      self.buying = false
      self.nbGemsToAdd = self:getGemsFromId(id)
      self.yFrom = self.yFrom or self.TOP -- on restore no buy button was pressed

      analytics.event('store', transaction.state, id)

      if (isConsumable(id)) then
        self.appStore.consumePurchase(id)
      else
        self:addGems()
      end
    elseif (transaction.state == 'cancelled') then
      analytics.event('store', 'cancelled', App.user:deviceId())
      self:cancelTransaction(transaction)
    elseif (transaction.state == 'failed') then
      local info =
        'gems: ' ..
        self.nbGemsToAdd ..
          ' | error:[' ..
            transaction.errorString .. '] user:' .. App.user:deviceId()

      analytics.event('store', 'failed', info)
      self:cancelTransaction(transaction)
    elseif (transaction.state == 'consumed') then
      analytics.event('store', 'consumed', App.user:deviceId())
      self:addGems()
    else
      local unknownType = transaction and transaction.state or 'no-state'
      analytics.event(
        'store',
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

function GoogleStore:buy(productId)
  native.setActivityIndicator(true)
  _G.log('[store][buy] google PURCHASING...[' .. productId .. ']')
  self.appStore.purchase(productId)
end

--------------------------------------------------------------------------------

return GoogleStore
