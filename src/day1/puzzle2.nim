type
  Elf = object
    number, calories: int

proc day1puzzle2*() =
  try:
    let elvesRaw = readFile("src/day1/input.txt")
      .strip()
      .split("\n\n")

    var top3Elves = [new(Elf), new(Elf), new(Elf)]
    var top3Calories = 0

    for currentElf, elfRaw in elvesRaw:
      var currentCalories: int
      for caloriesRaw in elfRaw.strip().splitLines():
        let calories = parseInt(caloriesRaw.strip())
        currentCalories += calories

      top3Calories = 0
      for i, topElf in top3Elves:
        if currentCalories > topElf.calories:
          top3Elves[i].calories = currentCalories
          top3Elves[i].number = currentElf+1
          top3Calories += top3Elves[i].calories
          break

        top3Calories += top3Elves[i].calories

    echo "Top 3 Elves carrying the most: ", top3Elves[0].number, ", ", top3Elves[
        1].number, ", ", top3Elves[2].number, " with ", top3Calories, " calories"
  except IOError:
    let
      e = getCurrentException()
      msg = getCurrentExceptionMsg()
    echo "Got exception ", repr(e), " with message ", msg
