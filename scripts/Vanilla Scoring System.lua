if botPlay or practice then
  return
end

newScore = 0
noteMillisecond = 0
holdingSustain = false
holdnames = {"purple","blue","green","red"}
goodNoteHit = function(membersIndex, noteData, noteType, isSustainNote)
  noteMillisecond = (getPropertyFromGroup("playerStrums",noteData,"y") - getPropertyFromGroup("notes",membersIndex,"y"))/175
  local scoreMulti = 0

  if not isSustainNote then
    if (getPropertyFromGroup("playerStrums",noteData,"y") - getPropertyFromGroup("notes",membersIndex,"y")) <= 0 then
      scoreMulti = (1+noteMillisecond)
    else
      scoreMulti = (1-noteMillisecond)
    end
    scoreUpdate(math.floor(500 * scoreMulti))
  end

  if getPropertyFromGroup("notes",membersIndex,"animation.curAnim.name") == holdnames[noteData+1].."hold" then
    holdingSustain = true
  else
    holdingSustain = false
  end
end

onUpdateScore = function(miss)
  if miss then
    scoreUpdate(-10)
  end
end

onUpdatePost = function(elapsed)
  if holdingSustain then
    scoreUpdate(3)
  end

  if keyReleased("left") or keyReleased("down") or keyReleased("up") or keyReleased("right") then
    holdingSustain = false
  end
end

scoreUpdate = function(value)
  newScore = newScore + value
  setScore(newScore)
end