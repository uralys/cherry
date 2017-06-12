local analytics = require 'analytics'

describe('[analytics]', function()
  it('> should set _G.analyticsParams', function()
    analytics.init('plop', 'plup', 'plip', 'ploup', 'plep')
    assert.are.equal( _G.analyticsParams.version, 'plop')
    assert.are.equal( _G.analyticsParams.trackingId, 'plup')
    assert.are.equal( _G.analyticsParams.profileId, 'plip')
    assert.are.equal( _G.analyticsParams.AppName, 'ploup')
    assert.are.equal( _G.analyticsParams.AppVersion, 'plep')
  end)

  it('> should post a page view', function()
    stub(_G.http, 'post')

    analytics.init('plop', 'plup', 'plip', 'ploup', 'plep')
    analytics.pageview('page')

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
