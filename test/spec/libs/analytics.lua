local analytics = require 'cherry.libs.analytics'

describe(
  '[analytics]',
  function()
    it(
      '> should set _G.analyticsParams',
      function()
        analytics.init('plup', 'plip', 'ploup', 'plep')
        local params = analytics.getParams()
        assert.are.equal(params.trackingId, 'plup')
        assert.are.equal(params.clientId, 'plip')
        assert.are.equal(params.gameName, 'ploup')
        assert.are.equal(params.gameVersion, 'plep')
      end
    )

    it(
      '> should post a screenview',
      function()
        stub(_G.http, 'post')

        analytics.init('plup', 'plip', 'ploup', 'plep')
        analytics.screenview('screen')

        assert.stub(_G.http.post).was.called(1)
        assert.stub(_G.http.post).was.called_with(
          'http://www.google-analytics.com/collect',
          'v=1&tid=plup&cid=plip&t=screenview&an=ploup&av=plep&cd=screen',
          nil,
          'urlencoded'
        )
      end
    )

    it(
      '> should post an event',
      function()
        stub(_G.http, 'post')

        analytics.init('plup', 'plip', 'ploup', 'plep')
        analytics.event('cat', 'act', 'lab')

        assert.stub(_G.http.post).was.called(1)
        assert.stub(_G.http.post).was.called_with(
          'http://www.google-analytics.com/collect',
          'v=1&tid=plup&cid=plip&t=event&an=ploup&av=plep&ec=cat&ea=act&el=lab',
          nil,
          'urlencoded'
        )
      end
    )
  end
)
