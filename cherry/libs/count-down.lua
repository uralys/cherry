local countDown
countDown = function(num, timeByStep, step)
  timer.performWithDelay(
    timeByStep,
    function()
      if (num > 0) then
        step(num - 1)
        countDown(num - 1, timeByStep, step)
      end
    end
  )
end

return countDown
