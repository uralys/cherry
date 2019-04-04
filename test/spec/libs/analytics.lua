local analytics = require 'cherry.libs.analytics'

describe('[analytics]', function()
  it('> should set _G.analyticsParams', function()
    analytics.init('plop', 'plup', 'plip', 'ploup', 'plep')
    local params = analytics.getParams()
    assert.are.equal( params.version, 'plop')
    assert.are.equal( params.trackingId, 'plup')
    assert.are.equal( params.clientId, 'plip')
    assert.are.equal( params.gameName, 'ploup')
    assert.are.equal( params.gameVersion, 'plep')
  end)

  it('> should post a page view', function()
    stub(_G.http, 'post')

    analytics.init('plop', 'plup', 'plip', 'ploup', 'plep')
    analytics.screenview('page')

    assert.stub(_G.http.post).was.called(1)
    assert.stub(_G.http.post).was.called_with(
      'http://www.google-analytics.com/collect',
      'v=plop&tid=plup&cid=plip&t=Appview&an=ploup&av=plep&cd=page',
      nil,
      'urlencoded'
    )
  end)

  it('> should post an event', function()
    stub(_G.http, 'post')

    analytics.init('plop', 'plup', 'plip', 'ploup', 'plep')
    analytics.event('cat', 'act', 'lab')

    assert.stub(_G.http.post).was.called(1)
    assert.stub(_G.http.post).was.called_with(
      'http://www.google-analytics.com/collect',
      'v=plop&tid=plup&cid=plip&t=event&an=ploup&ec=cat&ea=act&el=lab',
      nil,
      'urlencoded'
    )
  end)
end)
