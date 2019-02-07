local toVersionNumber = require 'cherry.libs.version-number'

describe('[version number]', function()
  it('> 1.2.3', function()
    assert.are.equal(10203, toVersionNumber('1.2.3'))
  end)

  it('> 1.2.32', function()
    assert.are.equal(10232, toVersionNumber('1.2.32'))
  end)

  it('> 12.2.32', function()
    assert.are.equal(120232, toVersionNumber('12.2.32'))
  end)

  it('> 12.24.32', function()
    assert.are.equal(122432, toVersionNumber('12.24.32'))
  end)

  it('> 1.2', function()
    assert.are.equal(10200, toVersionNumber('1.2'))
  end)

  it('> 1', function()
    assert.are.equal(10000, toVersionNumber('1'))
  end)

  it('> 12 --> 0', function()
    assert.are.equal(0, toVersionNumber(12))
  end)

  it('> () --> 0', function()
    assert.are.equal(0, toVersionNumber())
  end)

  it('> nil', function()
    assert.are.equal(0, toVersionNumber(nil))
  end)

  it('> whatever.not.number', function()
    assert.are.equal(0, toVersionNumber('whatever.not.number'))
  end)
end)
