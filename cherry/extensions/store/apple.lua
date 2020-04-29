--------------------------------------------------------------------------------

local analytics = require 'cherry.libs.analytics'

--------------------------------------------------------------------------------

local AppleShop = {}

--------------------------------------------------------------------------------

function AppleShop:getProductId(nbGems)
  if (App.iap.ios) then
    return App.iap.ios[nbGems]
  else
    return App.iap[nbGems]
  end
end

function AppleShop:getGemsFromId(id)
  local t
  if (App.iap.ios) then
    t = App.iap.ios
  else
    t = App.iap
  end

  for nbGems, _id in pairs(t) do
    if (_id == id) then
      return nbGems
    end
  end
end

--------------------------------------------------------------------------------

function AppleShop:initialize()
  _G.log('[shop][initialize] plugging Apple appStore...')

  local function storeTransaction(event)
    local transaction = event.transaction
    _G.log(
      '[shop] --> callback storeTransaction | transaction.state:' ..
        transaction.state
    )
    native.setActivityIndicator(false)

    if (transaction.state == 'purchased' or transaction.state == 'restored') then
      local id = transaction.productIdentifier
      _G.log('--->>> purchased: ' .. id)
      self.buying = false
      self.nbGemsToAdd = self:getGemsFromId(id)
      self.yFrom = self.yFrom or self.TOP -- on restore no buy button was pressed

      analytics.event('shop', transaction.state, id)
      self:addGems()
    elseif (transaction.state == 'cancelled') then
      _G.log('--->>> cancelled')
      analytics.event('shop', 'cancelled', App.user:deviceId())
      self:cancelTransaction(transaction)
    elseif (transaction.state == 'failed') then
      _G.log('--->>> failed')
      local info =
        'gems: ' ..
        self.nbGemsToAdd ..
          ' | error:[' ..
            transaction.errorString .. '] user:' .. App.user:deviceId()

      _G.log({info})
      analytics.event('shop', 'failed', info)
      self:cancelTransaction(transaction)
    else
      local unknownType = transaction and transaction.state or 'no-state'
      _G.log('--->>> unknownType:' .. unknownType)
      analytics.event(
        'shop',
        'unknown-transaction-' .. unknownType,
        App.user:deviceId()
      )
    end

    self.appStore.finishTransaction(transaction)
  end

  self.appStore = require('store')
  self.appStore.init(storeTransaction)
  self:loadProducts()
end

--------------------------------------------------------------------------------

function AppleShop:buy(productId)
  native.setActivityIndicator(true)
  _G.log('[shop][buy] apple PURCHASING...[' .. productId .. ']')
  self.appStore.purchase(productId)
end

--------------------------------------------------------------------------------

return AppleShop
