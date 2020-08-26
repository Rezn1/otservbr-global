dofile('data/modules/scripts/prey_system/assets.lua')
CONST_PREY_SLOT_FIRST = 0
CONST_PREY_SLOT_SECOND = 1
CONST_PREY_SLOT_THIRD = 2

--CONST_MONSTER_TIER_BRONZE = 0
--CONST_MONSTER_TIER_SILVER = 1
--CONST_MONSTER_TIER_GOLD = 2
--CONST_MONSTER_TIER_PLATINUM = 3

CONST_MONSTER_TIER_TRIVIAL = 0
CONST_MONSTER_TIER_EASY = 1
CONST_MONSTER_TIER_MEDIUM = 2
CONST_MONSTER_TIER_HARD = 3

CONST_MONSTER_TIER_UNCOMMON = 4
CONST_MONSTER_TIER_RARE = 8
CONST_MONSTER_TIER_VERY_RARE = 16

CONST_BONUS_DAMAGE_BOOST = 0
CONST_BONUS_DAMAGE_REDUCTION = 1
CONST_BONUS_XP_BONUS = 2
CONST_BONUS_IMPROVED_LOOT = 3

Prey = {}

Prey.Config = {
	PreyTime = 7200, -- Milliseconds
	StoreSlotStorage = 63253,
	ListRerollPrice = 0, -- 150
	BonusRerollPrice = 1,
	SelectWithWildCardPrice = 5
}

Prey.S_Packets = {
	ShowDialog = 0xED,
	PreyRerollPrice = 0xE9,
	PreyData = 0xE8,
	PreyTimeLeft = 0xE7
}

Prey.StateTypes = {
	LOCKED = 0,
	INACTIVE = 1,
	ACTIVE = 2,
	SELECTION = 3,
	SELECTION_CHANGE_MONSTER = 4,
	SELECTION_WITH_WILDCARD = 6
}

Prey.UnlockTypes = {
	PREMIUM_OR_STORE = 0,
	STORE = 1,
	NONE = 2
}

Prey.Actions = {
	NEW_LIST = 0,
	NEW_BONUS = 1,
	SELECT = 2,
	LIST_ALL_MONSTERS = 3,
	SELECT_ALL_MONSTERS = 4,
	TICK_LOCK = 5
}

Prey.C_Packets = {
	RequestData = 0xED,
	PreyAction = 0xEB
}

Prey.Bonuses = {
	[CONST_BONUS_DAMAGE_BOOST] = {7, 9, 11, 13, 15, 17, 19, 21, 23, 25},
	[CONST_BONUS_DAMAGE_REDUCTION] = {12, 14, 16, 18, 20, 22, 24, 26, 28, 30},
	[CONST_BONUS_XP_BONUS] = {13, 16, 19, 22, 25, 28, 31, 34, 37, 40},
	[CONST_BONUS_IMPROVED_LOOT] = {13, 16, 19, 22, 25, 28, 31, 34, 37, 40}
}

Prey.MonsterList = {
--	[CONST_MONSTER_TIER_BRONZE] = {
--		"Rotworm", "Carrion Worm", "Skeleton", "Ghoul", "Cyclops", "Cyclops Drone", "Cyclops Smith", "Dark Magician",
--		"Beholder", "Dragon", "Dragon Hatchling", "Dwarf", "Dwarf Guard", "Dwarf Geomancer", "Dwarf Soldier",
--		"Earth Elemental", "Fire Elemental", "Gargoyle", "Merlkin", "Minotaur", "Minotaur Guard", "Minotaur Mage",
--		"Minotaur Archer", "Nomad", "Amazon", "Hunter", "Orc", "Orc Berserker", "Orc Leader", "Orc Shaman",
--		"Orc Spearman", "Orc Warlord", "Panda", "Rotworm Queen", "Tarantula", "Scarab", "Skeleton Warrior", "Smuggler"
--	},
--	[CONST_MONSTER_TIER_SILVER] = {
--		"Pirate Buccaneer", "Pirate Ghost", "Pirate Marauder", "Pirate Skeleton", "Dragon Lord Hatchling",
--		"Frost Dragon Hatchling", "Behemoth", "Faun", "Dark Faun", "Dragon Lord", "Frost Dragon", "Hydra", "Hero",
--		"Bullwark", "Giant Spider", "Crystal Spider", "Deepling Brawler", "Deepling Elite", "Deepling Guard",
--		"Deepling Master Librarian", "Deepling Tyrant", "Deepling Warrior", "Wyrm", "Elder Wyrm", "Fleshslicer",
--		"Frost Giant", "Ghastly Dragon", "Ice Golem", "Infernalist", "Warlock", "Lich", "Lizard Chosen",
--		"Lizard Dragon Priest", "Lizard High Guard", "Lizard Legionnaire", "Lizard Zaogun", "Massive Energy Elemental",
--		"Massive Fire Elemental", "Massive Water Elemental", "Minotaur Amazon", "Execowtioner", "Minotaur Hunter",
--		"Mooh'Tah Warrior", "Mutated Bat", "Mutated Human", "Necromancer", "Nightmare", "Nightmare Scion", "Ogre Brute",
--		"Ogre Savage", "Ogre Shaman", "Orclops Doomhauler", "Orclops Ravager", "Quara Constrictor",
--		"Quara Constrictor Scout", "Quara Hydromancer", "Quara Mantassin", "Quara Pincher", "Quara Predator",
--		"Sea Serpent", "Shaper Matriarch", "Silencer", "Spitter", "Worker Golem", "Werewolf",
--		"Hellspawn", "Shadow Tentacle", "Vampire Bride", "Dragonling", "Shock Head", "Frazzlemaw",
--	},
--	[CONST_MONSTER_TIER_GOLD] = {
--		"Plaguesmith", "Demon", "Crystal Spider", "Defiler", "Destroyer", "Diamond Servant", "Draken Elite",
--		"Draken Spellweaver", "Draken Warmaster", "Draken Abomination", "Feversleep", "Terrorsleep", "Draptor",
--		"Grim Reaper", "Guzzlemaw", "Hellfire Fighter", "Hand of Cursed Fate", "Hellhound", "Juggernaut",
--		"Sparkion", "Dark Torturer", "Undead Dragon", "Retching Horror", "Choking Fear", "Choking Fear",
--		"Shiversleep", "Sight Of Surrender", "Demon Outcast", "Blightwalker", "Grimeleech", "Vexclaw", "Grimeleech",
--		"Dawnfire Asura", "Midnight Asura", "Frost Flower Asura", "True Dawnfire Asura", "True Frost Flower Asura",
--		"True Midnight Asura"
--	}
	[CONST_MONSTER_TIER_TRIVIAL] = {
		"Badger", "Bat", "Bug", "Cave Rat", "Chicken", "Fox", "Frost Troll", "Goblin", "Island Troll", "Penguin", "Poison Spider",
		"Rat", "Sandcrawler", "Skunk", "Snake", "Spider", "Troll", "Wasp", "Winter Wolf", "Wolf"
	},
	[CONST_MONSTER_TIER_EASY] = {
		"Abyssal Calamary", "Acolyte of Darkness", "Adventurer", "Amazon", "Assassin", "Azure Frog", "Bandit", "Barbarian Brutetamer", 
		"Barbarian Headsplitter", "Barbarian Skullhunter", "Bear", "Blood Crab", "Boar", "Bonelord", "Calamary", "Carrion Worm", 
		"Centipede", "Chakoya Toolshaper", "Chakoya Tribewarden", "Chakoya Windcaller", "Cobra", "Coral Frog", "Corym Charlatan", 
		"Crab", "Crazed Beggar", "Crimson Frog", "Crocodile", "Crypt Defiler", "Crypt Shambler", "Cyclops", "Damaged Crystal Golem", 
		"Damaged Worker Golem", "Dark Apprentice", "Dark Magician", "Dark Monk", "Deepling Worker", "Deepsea Blood Crab", 
		"Dire Penguin", "Dwarf", "Dwarf Guard", "Dwarf Soldier", "Dworc Fleshhunter", "Dworc Venomsniper", "Dworc Voodoomaster", 
		"Elephant", "Elf", "Elf Arcanist", "Elf Scout", "Emerald Damselfly", "Feverish Citizen", "Filth Toad", "Fire Devil", 
		"Firestarter", "Frost Giant", "Frost Giantess", "Furious Troll", "Gang Member", "Gargoyle", "Gazer", "Ghost", "Ghost Wolf", 
		"Ghoul", "Gladiator", "Gloom Wolf", "Gnarlhound", "Goblin Assassin", "Goblin Leader", "Goblin Scavenger", "Gozzler", 
		"Grave Robber", "Honour Guard", "Hunter", "Hyaena", "Insect Swarm", "Insectoid Scout", "Iron Servant", "Jellyfish", 
		"Killer Rabbit", "Kongra", "Ladybug", "Larva", "Leaf Golem", "Lion", "Little Corym Charlatan", "Lizard Sentinel", 
		"Lizard Templar", "Mad Scientist", "Mammoth", "Marsh Stalker", "Mercury Blob", "Merlkin", "Minotaur", "Minotaur Archer", 
		"Minotaur Guard", "Minotaur Mage", "Mole", "Monk", "Mummy", "Nomad", "Nomad Female", "Novice of the Cult", "Orc", "Orc Rider", 
		"Orc Shaman", "Orc Spearman", "Orc Warrior", "Orchid Frog", "Panda", "Pirate Ghost", "Pirate Marauder", "Pirate Skeleton", 
		"Poacher", "Polar Bear", "Quara Mantassin Scout", "Redeemed Soul", "Rorc", "Rotworm", "Salamander", "Scarab", "Scorpion", 
		"Sibang", "Skeleton", "Skeleton Warrior", "Slime", "Slug", "Smuggler", "Spit Nettle", "Squidgy Slime", "Stalker", 
		"Starving Wolf", "Stone Golem", "Swamp Troll", "Swampling", "Tarantula", "Tarnished Spirit", "Terramite", "Terror Bird", 
		"Thornback Tortoise", "Tiger", "Toad", "Tortoise", "Troll Champion", "Troll Guard", "Undead Mine Worker", "Undead Prospector", 
		"Valkyrie", "War Wolf", "Water Buffalo", "White Shade",
	},
	[CONST_MONSTER_TIER_MEDIUM] = {
		"Acid Blob", "Acolyte of the Cult", "Adept of the Cult", "Ancient Scarab", "Animated Snowman", "Arctic Faun", "Askarak Demon", 
		"Askarak Lord", "Askarak Prince", "Baleful Bunny", "Bane Bringer", "Bane of Light", "Banshee", "Barbarian Bloodwalker", 
		"Barkless Devotee", "Barkless Fanatic", "Behemoth", "Berserker Chicken", "Betrayed Wraith", "Blood Beast", "Blood Hand", 
		"Blood Priest", "Blue Djinn", "Bog Raider", "Bonebeast", "Boogy", "Braindeath", "Brimstone Bug", "Broken Shaper", "Carniphila", 
		"Clay Guardian", "Clomp", "Corym Skirmisher", "Corym Vanguard", "Crawler", "Crustacea Gigantica", "Crystal Spider", 
		"Crystal Wolf", "Crystalcrusher", "Cult Believer", "Cult Enforcer", "Cult Scholar", "Cyclops Drone", "Cyclops Smith", 
		"Dark Faun", "Death Blob", "Death Priest", "Deepling Brawler", "Deepling Elite", "Deepling Guard", "Deepling Master Librarian", 
		"Deepling Scout", "Deepling Spellsinger", "Deepling Warrior", "Demon Parrot", "Demon Skeleton", "Destroyer", "Devourer", 
		"Diabolic Imp", "Diamond Servant", "Diamond Servant Replica", "Doom Deer", "Dragon", "Dragon Hatchling", "Dragon Lord", 
		"Dragon Lord Hatchling", "Dragonling", "Draken Warmaster", "Draptor", "Drillworm", "Dryad", "Duskbringer", 
		"Dwarf Geomancer","Earth Elemental", "Efreet", "Elder Bonelord", "Elder Mummy", "Energy Elemental", "Enfeebled Silencer", 
		"Enlightened of the Cult", "Enraged Crystal Golem", "Enslaved Dwarf", "Eternal Guardian", "Evil Sheep", "Evil Sheep Lord", 
		"Execowtioner", "Faun", "Feversleep", "Fire Elemental", "Flying Book", "Forest Fury", "Frost Dragon", "Frost Dragon Hatchling", 
		"Frost Flower Asura", "Ghoulish Hyaena", "Giant Spider", "Glooth Anemone", "Glooth Bandit", "Glooth Blob", "Glooth Brigand", 
		"Glooth Golem", "Golden Servant", "Golden Servant Replica", "Goldhanded Cultist", "Grave Guard", "Gravedigger", "Green Djinn", 
		"Gryphon", "Haunted Treeling", "Hellspawn", "Herald of Gloom", "Hero", "Hibernal Moth", "High Voltage Elemental", "Hot Dog", 
		"Hydra", "Ice Dragon", "Ice Golem", "Ice Witch", "Infernal Frog", "Insectoid Worker", "Instable Breach Brood", 
		"Instable Sparkion", "Iron Servant Replica", "Killer Caiman", "Kollos", "Lacewing Moth", "Lancer Beetle", "Lich", 
		"Lizard Chosen", "Lizard Dragon Priest", "Lizard High Guard", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Snakecharmer", 
		"Lizard Zaogun", "Lost Basher", "Lost Exile", "Lost Husher", "Lost Soul", "Lost Thrower", "Lumbering Carnivor", "Manta Ray", 
		"Marid", "Massive Earth Elemental", "Massive Energy Elemental", "Massive Fire Elemental", "Massive Water Elemental", 
		"Metal Gargoyle", "Midnight Asura", "Midnight Panther", "Midnight Spawn", "Minotaur Cult Follower", "Minotaur Cult Prophet", 
		"Minotaur Cult Zealot", "Minotaur Hunter", "Minotaur Invader", "Misguided Bully", "Misguided Thief", "Mooh'Tah Warrior", 
		"Moohtant", "Mutated Bat", "Mutated Human", "Mutated Rat", "Mutated Tiger", "Necromancer", "Nightfiend", "Nightmare", 
		"Nightmare Scion", "Nightstalker", "Noble Lion", "Nymph", "Ogre Brute", "Ogre Savage", "Ogre Shaman", "Omnivora", 
		"Orc Berserker", "Orc Cult Fanatic", "Orc Cult Inquisitor", "Orc Cult Minion", "Orc Cult Priest", "Orc Cultist", "Orc Leader", 
		"Orc Marauder", "Orc Warlord", "Orclops Doomhauler", "Orclops Ravager", "Percht", "Pirate Buccaneer", "Pirate Corsair", 
		"Pirate Cutthroat", "Pixie", "Plaguesmith", "Pooka", "Priestess", "Putrid Mummy", "Quara Constrictor", 
		"Quara Constrictor Scout", "Quara Hydromancer", "Quara Hydromancer Scout", "Quara Mantassin", "Quara Pincher", 
		"Quara Pincher Scout", "Quara Predator", "Quara Predator Scout", "Raging Fire", "Ravenous Lava Lurker", "Renegade Knight", 
		"Renegade Quara Constrictor", "Renegade Quara Hydromancer", "Renegade Quara Mantassin", "Renegade Quara Pincher", 
		"Renegade Quara Predator", "Roaring Lion", "Rot Elemental", "Rustheap Golem", "Sacred Spider", "Sandstone Scorpion", "Schiach", 
		"Sea Serpent", "Serpent Spawn", "Shaburak Demon", "Shaburak Lord", "Shaburak Prince", "Shadow Hound", "Shadow Pupil", 
		"Shaper Matriarch", "Shark", "Silencer", "Souleater", "Spectre", "Spidris", "Spidris Elite", "Spitter", 
		"Stabilizing Dread Intruder", "Stabilizing Reality Reaver", "Stampor", "Stone Rhino", "Stonerefiner", "Swan Maiden", "Swarmer", 
		"Thornfire Wolf", "Tomb Servant", "Troll Legionnaire", "Twisted Pooka", "Twisted Shaper", "Undead Cavebear", "Undead Gladiator", 
		"Vampire", "Vampire Bride", "Vampire Pig", "Vampire Viscount", "Vicious Manbat", "Vicious Squire", "Vile Grandmaster", 
		"Wailing Widow", "Walker", "War Golem", "Warlock", "Waspoid", "Water Elemental", "Weakened Frazzlemaw", "Werebadger", 
		"Werebear", "Wereboar", "Werefox", "Werewolf", "Wiggler", "Wilting Leaf Golem", "Worker Golem", "Worm Priestess", "Wyrm", 
		"Wyvern", "Yeti", "Yielothax", "Young Sea Serpent", "Zombie"
	},
	[CONST_MONSTER_TIER_HARD] = {
		"Adult Goanna", "Animated Feather", "Arachnophobica", "Armadile", "Biting Book", "Black Sphinx Acolyte", "Blightwalker", 
		"Brain Squid", "Breach Brood", "Burning Book", "Burning Gladiator", "Burster Spectre", "Cave Devourer", "Chasm Spawn", 
		"Choking Fear", "Cliff Strider", "Cobra Assassin", "Cobra Scout", "Cobra Vizier", "Crazed Summer Rearguard", 
		"Crazed Summer Vanguard", "Crazed Winter Rearguard", "Crazed Winter Vanguard", "Crypt Warden", "Cursed Book", "Dark Torturer", 
		"Dawnfire Asura", "Deathling Scout", "Deathling Spellsinger", "Deepling Tyrant", "Deepworm", "Defiler", "Demon", 
		"Demon Outcast", "Diremaw", "Draken Abomination", "Draken Elite", "Draken Spellweaver", "Dread Intruder", "Elder Wyrm", 
		"Energetic Book", "Energuardian of Tales", "Falcon Knight", "Falcon Paladin", "Feral Sphinx", "Floating Savant", "Frazzlemaw", 
		"Fury", "Gazer Spectre", "Ghastly Dragon", "Grim Reaper", "Grimeleech", "Guardian of Tales", "Guzzlemaw", "Hand of Cursed Fate", 
		"Haunted Dragon", "Hellfire Fighter", "Hellflayer", "Hellhound", "Hideous Fungus", "Hive Overseer", "Humongous Fungus", 
		"Icecold Book", "Infected Weeper", "Infernalist", "Ink Blob", "Insane Siren", "Ironblight", "Juggernaut", "Knowledge Elemental", 
		"Lamassu", "Lava Golem", "Lava Lurker", "Lizard Noble", "Lost Berserker", "Magma Crawler", "Manticore", "Medusa", 
		"Menacing Carnivor", "Minotaur Amazon", "Ogre Rowdy", "Ogre Ruffian", "Ogre Sage", "Orewalker", "Phantasm", 
		"Priestess of the Wild Sun", "Rage Squid", "Reality Reaver", "Retching Horror", "Ripper Spectre", "Seacrest Serpent", 
		"Shock Head", "Sight of Surrender", "Skeleton Elite Warrior", "Son of Verminor", "Soul-Broken Harbinger", "Sparkion", "Sphinx", 
		"Spiky Carnivor", "Squid Warden", "Stone Devourer", "Terrorsleep", "Thanatursus", "True Dawnfire Asura", 
		"True Frost Flower Asura", "True Midnight Asura", "Tunnel Tyrant", "Undead Dragon", "Undead Elite Gladiator", "Vexclaw", 
		"Vulcongra", "Weeper", "Young Goanna"
	},
}

Prey.Rarities = {
	[CONST_MONSTER_TIER_UNCOMMON] = {
		"Husky", "Modified Gnarlhound", "Northern Pike (Creature)", "Pigeon", "Black Sheep", "Horse (Brown)", "Horse (Gray)", 
		"Calamary", "Damaged Crystal Golem", "Filth Toad", "Furious Troll", "Gloom Wolf", "Jellyfish", "Killer Rabbit", 
		"Little Corym Charlatan", "Nomad (Blue)", "Nomad (Female)", "Undead Mine Worker", "Undead Prospector", "Arctic Faun", 
		"Berserker Chicken", "Cult Scholar", "Deepling Brawler", "Deepling Elite", "Demon Parrot", "Doom Deer", "Dragonling", 
		"Elder Forest Fury", "Evil Sheep Lord", "Flying Book", "Goldhanded Cultist", "Goldhanded Cultist Bride", "Gryphon", 
		"Hibernal Moth", "Hot Dog", "Infernal Frog", "Lacewing Moth", "Massive Energy Elemental", "Noble Lion", "Orc Cult Fanatic", 
		"Orc Cult Priest", "Orc Cultist", "Stone Rhino", "Swan Maiden", "Vampire Pig", "Walker", "Armadile", "Cliff Strider", 
		"Cursed Book", "Guardian of Tales", "Infected Weeper", "Ironblight", "Knowledge Elemental", "Lava Golem", "Orewalker", 
		"Stone Devourer", "Weeper",
	},
	[CONST_MONSTER_TIER_RARE] = {
		"Horse (Taupe)", "White Deer", "Crypt Defiler", "Feverish Citizen", "Firestarter", "Ghost Wolf", "Grave Robber", "Honour Guard", 
		"Insectoid Scout", "Ladybug", "Squidgy Slime", "Starving Wolf", "Animated Snowman", "Askarak Lord", "Askarak Prince", 
		"Baleful Bunny", "Bellicose Orger", "Cow", "Death Priest", "Deepling Master Librarian", "Diamond Servant Replica", 
		"Elder Mummy", "Ghoulish Hyaena", "Golden Servant Replica", "Grave Guard", "Ice Dragon", "Kollos", "Loricate Orger", 
		"Manta Ray", "Minotaur Invader", "Orger", "Percht", "Renegade Quara Constrictor", "Renegade Quara Hydromancer", 
		"Renegade Quara Mantassin", "Renegade Quara Pincher", "Renegade Quara Predator", "Roast Pork", "Sacred Spider", 
		"Sandstone Scorpion", "Schiach", "Shaburak Lord", "Shaburak Prince", "Spidris", "Spidris Elite", "Tomb Servant", 
		"Deepling Tyrant", "Haunted Dragon", "Hive Overseer", "Seacrest Serpent", 
	},
	[CONST_MONSTER_TIER_VERY_RARE] = {
		"Berrypest", "Grynch Clan Goblin", "Undead Jester", "Wild Horse", "Acolyte of Darkness", "Cake Golem", "Dire Penguin", 
		"Doomsday Cultist", "Goblin Leader", "Iron Servant", "Troll Guard", "Water Buffalo", "Bane Bringer", "Bane of Light", 
		"Bride of Night", "Crustacea Gigantica", "Crystal Wolf", "Diamond Servant", "Draptor", "Dryad", "Duskbringer", "Elf Overseer", 
		"Golden Servant", "Herald of Gloom", "Midnight Panther", "Midnight Spawn", "Midnight Warrior", "Nightfiend", "Nightslayer", 
		"Raging Fire", "Shadow Hound", "Thornfire Wolf", "Undead Cavebear", "Vicious Manbat", "Yeti",
	},
}

-- Communication functions
function Player.sendResource(self, resourceType, value)
	local typeByte = 0
	if resourceType == "bank" then
		typeByte = 0x00
	elseif resourceType == "inventory" then
		typeByte = 0x01
	elseif resourceType == "prey" then
		typeByte = 0x0A
	end
	local msg = NetworkMessage()
	msg:addByte(0xEE)
	msg:addByte(typeByte)
	msg:addU64(value)
	msg:sendToPlayer(self)
end

function Player.sendErrorDialog(self, error)
	local msg = NetworkMessage()
	msg:addByte(Prey.S_Packets.ShowDialog)
	msg:addByte(0x15)
	msg:addString(error)
	msg:sendToPlayer(self)
end

-- Core functions
function Player.setRandomBonusValue(self, slot, bonus, typeChange)
	local type = self:getPreyBonusType(slot)
	local bonusValue = math.random(1, 10)
	local starUP = math.random(1, 3)
	local value = Prey.Bonuses[type][bonusValue]
	local bonusGrade = self:getPreyBonusGrade(slot)
	
	if bonus then
		if typeChange then
			self:setPreyBonusGrade(slot, bonusValue)
			self:setPreyBonusValue(slot, value)
		else
			local upgradeStar = bonusGrade + starUP
			if upgradeStar >= 10 then
				upgradeStar = 10
			end
			local newBonus = Prey.Bonuses[type][upgradeStar]
			self:setPreyBonusGrade(slot, upgradeStar)
			self:setPreyBonusValue(slot, newBonus)
		end
	end
end

function Player.getMonsterTier(self)
	local level = self:getLevel()
	local trivial = 10
	local easy = math.min(100,4*level)
	local medium = math.min(200,math.max(0,4*(level-35)-2*math.max(0,level-60)))
	local hard = math.min(300,math.max(0,4*(level-85)))
	local r = math.random(trivial+easy+medium+hard)
	if r <= trivial then
		return CONST_MONSTER_TIER_TRIVIAL
	elseif r <= trivial+easy then
		return CONST_MONSTER_TIER_EASY
	elseif r <= trivial+easy+medium then
		return CONST_MONSTER_TIER_MEDIUM
	else 
		return CONST_MONSTER_TIER_HARD
	end
end

function Player.createMonsterList(self)
	-- Do not allow repeated monsters
	local repeatedList = {}
	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		if (self:getPreyCurrentMonster(slot) ~= '') then
			repeatedList[#repeatedList + 1] = self:getPreyCurrentMonster(slot)
		end
		if (self:getPreyMonsterList(slot) ~= '') then
			local currentList = self:getPreyMonsterList(slot):split(";")
			for i = 1, #currentList do
				repeatedList[#repeatedList + 1] = currentList[i]
			end
		end
	end
	-- Generating monsterList
	local monsters = {}
	while (#monsters ~= 9) do
		local monsterList = self:getMonsterTier()
		local randomMonster = Prey.MonsterList[monsterList][math.random(#Prey.MonsterList[monsterList])]
		-- Rare monsters have chance lowered
		local rareCheck = true
		for i, rare in pairs(Prey.Rarities) do
			if table.contains(rare, randomMonster) then
				rareCheck = math.random(i) == 1
			end
		end
		-- Verify that monster actually exists
		if MonsterType(randomMonster) and not table.contains(monsters, randomMonster) and not table.contains(repeatedList, randomMonster) and rareCheck then
			monsters[#monsters + 1] = randomMonster
		end
	end
	return table.concat(monsters, ";")
end

function Player.resetPreySlot(self, slot, from)
	self:setPreyMonsterList(slot, self:createMonsterList())
	self:setPreyState(slot, from)
	return self:sendPreyData(slot)
end

function Player.getMinutesUntilFreeReroll(self, slot)
	local currentTime = os.time()
	if (self:getPreyNextUse(slot) <= currentTime) then
		return 0
	end
	return math.floor((self:getPreyNextUse(slot) - currentTime) / 60)
end

function Player.getRerollPrice(self)
	return (self:getLevel() * Prey.Config.ListRerollPrice)
end

function getNameByRace(race)
    local monsterTable = Bestiary.Monsters[race]
	return monsterTable.name
end

function Player.getMonsterList(self)
	local repeatedList = {}
    local sortList = {}
	local monsterList = {}

	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		if (self:getPreyCurrentMonster(slot) ~= '') then
			repeatedList[#repeatedList + 1] = self:getPreyCurrentMonster(slot)
		end
		if (self:getPreyMonsterList(slot) ~= '') then
			local currentList = self:getPreyMonsterList(slot):split(";")
			for i = 1, #currentList do
				repeatedList[#repeatedList + 1] = currentList[i]
			end
		end
	end
	
	-- Insert the monstersId
	for i = 1, #preyRaceIds do
		table.insert(sortList, preyRaceIds[i])
	end

    -- Do not allow repeated monsters
	for k, v in pairs(sortList) do
		if not table.contains(repeatedList, getNameByRace(tonumber(v))) then
			table.insert(monsterList, v)
		end
	end
	
	return monsterList
end

function Player.setAutomaticBonus(self, slot)
	local monster = self:getPreyCurrentMonster(slot)

	-- Automatic Bonus Reroll
	if self:getPreyTick(slot) == 1 and self:getPreyBonusRerolls() >= 1 then
		self:setPreyBonusType(slot, self:getDiffBonus(slot))
		self:setRandomBonusValue(slot, true, true)
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 1)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey bonus was automatically rolled.", monster:lower()))
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
	
	-- Lock Prey
	elseif self:getPreyTick(slot) == 2 and self:getPreyBonusRerolls() >= 5 then
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 5)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey time was automatically renewed.", monster:lower()))
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
	else
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey has expired because you don't have enough prey wildcards.", monster:lower()))
		self:setPreyCurrentMonster(slot, "")
		self:setPreyTick(slot, 0)
	end	
end	

function onRecvbyte(player, msg, byte)
	if (byte == Prey.C_Packets.RequestData) then
		player:sendPreyData(CONST_PREY_SLOT_FIRST)
		player:sendPreyData(CONST_PREY_SLOT_SECOND)
		player:sendPreyData(CONST_PREY_SLOT_THIRD)
	elseif (byte == Prey.C_Packets.PreyAction) then
		player:preyAction(msg)
	end
end

function Player.preyAction(self, msg)

	local slot = msg:getByte()
	local action = msg:getByte()

	if not slot then
		return self:sendErrorDialog("Sorry, there was an issue, please relog-in.")
	end

	-- Verify whether the slot is unlocked
	if (self:getPreyUnlocked(slot) ~= 2) then
		return self:sendErrorDialog("Sorry, you don't have this slot unlocked yet.")
	end

	-- Listreroll
	if (action == Prey.Actions.NEW_LIST) then

		-- Verifying state
		if (self:getPreyState(slot) ~= Prey.StateTypes.ACTIVE and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION
		and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION_CHANGE_MONSTER)
		and self:getPreyState(slot) ~= Prey.StateTypes.INACTIVE then
			return self:sendErrorDialog("This slot is not active.")
		end

		-- If free reroll is available
		if (self:getMinutesUntilFreeReroll(slot) == 0) then
			self:setPreyNextUse(slot, os.time() + 20 * 60 * 60)
		elseif (not self:removeMoneyNpc(self:getRerollPrice())) then
			return self:sendErrorDialog("You do not have enough money to perform this action.")
		end

		self:setPreyCurrentMonster(slot, "")
		self:setPreyMonsterList(slot, self:createMonsterList())
		self:setPreyState(slot, Prey.StateTypes.SELECTION_CHANGE_MONSTER)

	-- Listreroll with wildcards
	elseif (action == Prey.Actions.LIST_ALL_MONSTERS) then

		-- Removing bonus rerolls
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 5)

		self:setPreyCurrentMonster(slot, "")
		self:setPreyMonsterList(slot, "")
		self:setPreyState(slot, Prey.StateTypes.SELECTION_WITH_WILDCARD)

	-- Select monster from the list
	elseif (action == Prey.Actions.SELECT_ALL_MONSTERS) then
		local race = msg:getU16()
		local race = getNameByRace(race)
	
		-- Converts RaceID to String
		self:setPreyCurrentMonster(slot, race)

		self:setPreyState(slot, Prey.StateTypes.ACTIVE)
		self:setPreyMonsterList(slot, "")
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)

	-- Bonus reroll
	elseif (action == Prey.Actions.NEW_BONUS) then

		-- Verifying state
		if (self:getPreyState(slot) ~= Prey.StateTypes.ACTIVE) then
			return self:sendErrorDialog("This is slot is not even active.")
		end

		if (self:getPreyBonusRerolls() < 1) then
			return self:sendErrorDialog("You don't have any bonus rerolls.")
		end

		-- Removing bonus rerolls
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 1)

		-- Calculating new bonus
		local oldType = self:getPreyBonusType(slot)
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		self:setRandomBonusValue(slot, true, false)
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)

	-- Select monster from list
	elseif (action == Prey.Actions.SELECT) then

		local selectedMonster = msg:getByte()
		local monsterList = self:getPreyMonsterList(slot):split(";")

		-- Verify if the monster exists.
		local monster = MonsterType(monsterList[selectedMonster + 1])
		if not monster then
			return self:sendPreyData(slot)
		end

		-- Verifying slot state
		if (self:getPreyState(slot) ~= Prey.StateTypes.SELECTION
		and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION_CHANGE_MONSTER) then
			return self:sendErrorDialog("This slot can't select monsters.")
		end

		-- Proceeding to prey monster selection
		self:selectPreyMonster(slot, monsterList[selectedMonster + 1])

	-- Automatic Reroll/Lock
	elseif (action == Prey.Actions.TICK_LOCK) then
	
		local button = msg:getByte()
		if button == 1 then
			self:setPreyTick(slot, 1)
		elseif button == 2 then
			self:setPreyTick(slot, 2)
		else
			self:setPreyTick(slot, 0)
		end
	end

	-- Perfom slot update
	return self:sendPreyData(slot)
end

function Player.selectPreyMonster(self, slot, monster)

	-- Verify if the monster exists.
	local monster = MonsterType(monster)
	if not monster then
		return self:sendPreyData(slot)
	end

	local msg = NetworkMessage()

	-- Only first/expired selection list gets new prey bonus
	if (self:getPreyState(slot) == Prey.StateTypes.SELECTION) then
		-- Generating random prey type
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		-- Generating random bonus stats
		self:setRandomBonusValue(slot, true, true)
	elseif (self:getPreyBonusGrade(slot) == 0) then
		-- Generating random prey type
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		-- Generating random bonus stats
		self:setRandomBonusValue(slot, true, true)
	end

	-- Setting current monster
	self:setPreyCurrentMonster(slot, monster:getName())
	-- Setting preySlot state
	self:setPreyState(slot, Prey.StateTypes.ACTIVE)
	-- Cleaning up monsterList
	self:setPreyMonsterList(slot, "")
	-- Time left
	self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
end

function Player.sendPreyData(self, slot)
	-- Unlock First Slot
	if self:getPreyState(CONST_PREY_SLOT_FIRST) == 0 then
		self:setPreyUnlocked(CONST_PREY_SLOT_FIRST, 2)
		self:setPreyState(CONST_PREY_SLOT_FIRST, 1)
	end

	-- Unlock/lock second slot (premium status)
	if self:isPremium() then
		if self:getPreyState(CONST_PREY_SLOT_SECOND) == 0 then
			self:setPreyUnlocked(CONST_PREY_SLOT_SECOND, 2)
			self:setPreyState(CONST_PREY_SLOT_SECOND, 1)
		end
	else
		self:setPreyUnlocked(CONST_PREY_SLOT_SECOND, 0)
		self:setPreyState(CONST_PREY_SLOT_SECOND, 0)
	end

	-- Unlock store slot
	if self:getPreyState(CONST_PREY_SLOT_THIRD) == 0 then
		if self:getStorageValue(Prey.Config.StoreSlotStorage) == 1	then
			self:setPreyUnlocked(CONST_PREY_SLOT_THIRD, 2)
			self:setPreyState(CONST_PREY_SLOT_THIRD, 1)
		else
			self:setPreyUnlocked(CONST_PREY_SLOT_THIRD, 1)
			self:setPreyState(CONST_PREY_SLOT_THIRD, 0)
		end
	end

	local slotState = self:getPreyState(slot)
	local tickState = self:getPreyTick(slot)

	local msg = NetworkMessage()
	msg:addByte(Prey.S_Packets.PreyData) -- packet header

	if slotState == Prey.StateTypes.SELECTION_CHANGE_MONSTER then
		msg:addByte(slot) -- slot number
		msg:addByte(slotState)
		msg:addByte(self:getPreyBonusType(slot))
		msg:addU16(self:getPreyBonusValue(slot))
		msg:addByte(self:getPreyBonusGrade(slot))

		local monsterList = self:getPreyMonsterList(slot):split(";")
		msg:addByte(#monsterList)
		for i = 1, #monsterList do
			local monster = MonsterType(monsterList[i])
			if monster then
				msg:addString(monster:getName())
				msg:addU16(monster:getOutfit().lookType or 21)
				msg:addByte(monster:getOutfit().lookHead or 0x00)
				msg:addByte(monster:getOutfit().lookBody or 0x00)
				msg:addByte(monster:getOutfit().lookLegs or 0x00)
				msg:addByte(monster:getOutfit().lookFeet or 0x00)
				msg:addByte(monster:getOutfit().lookAddons or 0x00)
			else
				return self:resetPreySlot(slot, Prey.StateTypes.SELECTION_CHANGE_MONSTER)
			end
		end

	elseif slotState == Prey.StateTypes.SELECTION then
		msg:addByte(slot)
		msg:addByte(slotState)

		local preyMonsterList = self:getPreyMonsterList(slot)
		if preyMonsterList == '' then
			self:setPreyMonsterList(slot, self:createMonsterList())
			return self:sendPreyData(slot)
		end

		local monsterList = preyMonsterList:split(";")
		msg:addByte(#monsterList)
		for i = 1, #monsterList do
			local monster = MonsterType(monsterList[i])
			if monster then
				msg:addString(monster:getName())
				msg:addU16(monster:getOutfit().lookType or 21)
				msg:addByte(monster:getOutfit().lookHead or 0x00)
				msg:addByte(monster:getOutfit().lookBody or 0x00)
				msg:addByte(monster:getOutfit().lookLegs or 0x00)
				msg:addByte(monster:getOutfit().lookFeet or 0x00)
				msg:addByte(monster:getOutfit().lookAddons or 0x00)
			else
				return self:resetPreySlot(slot, Prey.StateTypes.SELECTION)
			end
		end

	elseif slotState == Prey.StateTypes.ACTIVE then
		msg:addByte(slot)
		msg:addByte(slotState)
		local monster = MonsterType(self:getPreyCurrentMonster(slot))
		if monster then
			msg:addString(monster:getName())
			msg:addU16(monster:getOutfit().lookType or 21)
			msg:addByte(monster:getOutfit().lookHead or 0x00)
			msg:addByte(monster:getOutfit().lookBody or 0x00)
			msg:addByte(monster:getOutfit().lookLegs or 0x00)
			msg:addByte(monster:getOutfit().lookFeet or 0x00)
			msg:addByte(monster:getOutfit().lookAddons or 0x00)
			msg:addByte(self:getPreyBonusType(slot))
			msg:addU16(self:getPreyBonusValue(slot))
			msg:addByte(self:getPreyBonusGrade(slot))
			msg:addU16(self:getPreyTimeLeft(slot))
		else
			return self:resetPreySlot(slot, Prey.StateTypes.SELECTION)
		end

	elseif slotState == Prey.StateTypes.INACTIVE then
		msg:addByte(slot) -- slot number
		msg:addByte(slotState) -- slot state

	elseif slotState == Prey.StateTypes.LOCKED then
		msg:addByte(slot)
		msg:addByte(slotState)
		msg:addByte(self:getPreyUnlocked(slot))

	elseif slotState == Prey.StateTypes.SELECTION_WITH_WILDCARD then
		local raceList = self:getMonsterList()

		msg:addByte(slot) -- slot number
		msg:addByte(slotState) -- slot state
		
		-- Check if has any bonus
		if self:getPreyBonusType(slot) < 1 then
			self:setRandomBonusValue(slot, true, true)
		end
		
		msg:addByte(self:getPreyBonusType(slot)) -- bonus type
		msg:addU16(self:getPreyBonusValue(slot)) -- bonus value
		msg:addByte(self:getPreyBonusGrade(slot)) -- bonus grade
		msg:addU16(#raceList) -- monsters count
		
		for i = 1, #raceList do
			msg:addU16(raceList[i]) -- raceID
		end
	end

	-- Next free reroll
	msg:addU16(self:getMinutesUntilFreeReroll(slot))

	-- Automatic Reroll/Lock Prey
	msg:addByte(tickState)

	-- send prey message
	msg:sendToPlayer(self)

	-- close emb window
	self:closeImbuementWindow()

	-- Send resources
	self:sendResource("prey", self:getPreyBonusRerolls())
	self:sendResource("bank", self:getBankBalance())
	self:sendResource("inventory", self:getMoney())

	-- Send reroll price
	self:sendPreyRerollPrice()

end

function Player:sendPreyRerollPrice()
	local msg = NetworkMessage()
	
	msg:addByte(Prey.S_Packets.PreyRerollPrice)
	msg:addU32(self:getRerollPrice())
	msg:addByte(Prey.Config.BonusRerollPrice) -- wildcards
	msg:addByte(Prey.Config.SelectWithWildCardPrice) -- select directly

	-- Feature unavailable
	msg:addU32(0)
	msg:addU32(0)
	msg:addByte(0)
	msg:addByte(0)

	msg:sendToPlayer(self)
end
