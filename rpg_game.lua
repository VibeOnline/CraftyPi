local player = {
    name = "Hero",
    hp = 100,
    maxHp = 100,
    attack = 10,
    xp = 0,
    level = 1
}

local monsters = {
    {name = "Slime", hp = 30, attack = 5, xp = 20},
    {name = "Goblin", hp = 50, attack = 8, xp = 40},
    {name = "Orc", hp = 80, attack = 12, xp = 70}
}

local function drawText(text)
    print(text)
end

local function battle()
    local monsterData = monsters[math.random(#monsters)]
    local monster = {
        name = monsterData.name,
        hp = monsterData.hp,
        attack = monsterData.attack,
        xp = monsterData.xp
    }

    drawText("\n--- A wild " .. monster.name .. " appeared! ---")

    while monster.hp > 0 and player.hp > 0 do
        drawText("\n" .. monster.name .. " HP: " .. monster.hp)
        drawText("Your HP: " .. player.hp)
        drawText("1. Attack")
        drawText("2. Run")
        
        local choice = io.read()
        if choice == "1" then
            local damage = math.random(player.attack - 2, player.attack + 2)
            monster.hp = monster.hp - damage
            drawText("You dealt " .. damage .. " damage!")

            if monster.hp > 0 then
                local mDamage = math.random(monster.attack - 2, monster.attack + 2)
                player.hp = player.hp - mDamage
                drawText(monster.name .. " dealt " .. mDamage .. " damage!")
            end
        elseif choice == "2" then
            if math.random() > 0.5 then
                drawText("You escaped!")
                return
            else
                drawText("Could not escape!")
                local mDamage = math.random(monster.attack - 2, monster.attack + 2)
                player.hp = player.hp - mDamage
                drawText(monster.name .. " attacked you while you tried to run for " .. mDamage .. " damage!")
            end
        end
    end

    if player.hp <= 0 then
        drawText("\nGame Over... You were defeated.")
        os.exit()
    elseif monster.hp <= 0 then
        drawText("\nVictory! You defeated the " .. monster.name .. "!")
        drawText("Gained " .. monster.xp .. " XP")
        player.xp = player.xp + monster.xp
        if player.xp >= player.level * 100 then
            player.level = player.level + 1
            player.maxHp = player.maxHp + 20
            player.hp = player.maxHp
            player.attack = player.attack + 5
            drawText("LEVEL UP! You are now level " .. player.level)
        end
    end
end

drawText("Welcome to the Minimalist RPG!")
io.write("Enter your name: ")
player.name = io.read()

while true do
    drawText("\n--- Main Menu ---")
    drawText("1. Explore")
    drawText("2. Rest (Heal)")
    drawText("3. Status")
    drawText("4. Quit")
    
    local choice = io.read()
    if choice == "1" then
        if math.random() > 0.3 then
            battle()
        else
            drawText("You wander around but find nothing.")
        end
    elseif choice == "2" then
        player.hp = player.maxHp
        drawText("You rested and recovered all HP!")
    elseif choice == "3" then
        drawText("\n--- " .. player.name .. "'s Stats ---")
        drawText("Level: " .. player.level)
        drawText("HP: " .. player.hp .. "/" .. player.maxHp)
        drawText("Attack: " .. player.attack)
        drawText("XP: " .. player.xp)
    elseif choice == "4" then
        drawText("Thanks for playing!")
        break
    end
end
