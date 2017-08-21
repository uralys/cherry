local extension = require('cherry.core.extension-demo')

describe('[extension-demo]', function()
  it('> should provide an onReset function', function()
    extension:onReset()
  end)

  it('> should provide an onStop function', function()
    extension:onStop()
  end)

  it('> should provide an onStart function', function()
    extension:onStart()
  end)
end)
