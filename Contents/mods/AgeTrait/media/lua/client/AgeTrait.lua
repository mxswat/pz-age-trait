function MxIndexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return nil
end

local AGES = {
    30,
    40,
    50,
    60
}

local function Age_Init(age)
    local player = getSpecificPlayer(0)
    local levelBoost = MxIndexOf(AGES, age)
    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = PerkFactory.getPerk(Perks.fromIndex(i));
        local parent = perk:getParent()
        local isNotPassive = parent ~= Perks.None and parent ~= Perks.Passiv
        local info = player:getPerkInfo(perk)
        local level = info and info:getLevel() or 0
        if perk and isNotPassive and level >= 1 then
            local k = 1
            repeat
                player:LevelPerk(perk, false);
                k = k + 1
            until (k > levelBoost)
            player:getXp():setXPToLevel(perk, player:getPerkLevel(perk));
        end
    end
end


for i, age in ipairs(AGES) do
    -- Exclude code credits to Fenris_Wolf https://discord.com/channels/136501320340209664/232196827577974784/964694443460530196
    local exclude = {}
    for j=1+i, #AGES do
        table.insert(exclude, "Age"..AGES[j])
    end

    ProfessionFramework.addTrait('Age' .. age, {
        name = "Age " .. age,
        description = "UI_trait_Age" .. age .. "desc",
        icon = "trait_Age" .. age,
        cost = 1,
        xp = {
            [Perks.Fitness] = -(MxIndexOf(AGES, age)),
        },
        exclude = exclude,
        OnNewGame = function(player, square, profession)
            Age_Init(age)
        end,
        OnGameStart = function(trait)

        end
    })
end
