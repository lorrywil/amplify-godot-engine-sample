class_name GameGenres
extends Node

enum GenreType {
	OPEN_WORLD,
	BATTLE_ROYALE,
	FPS,
	RPG,
	MOBA,
	SPORTS,
	SURVIVAL,
	ARPG,
	PLATFORM,
	RACING
}

class GenreData:
	var name: String
	var description: String
	var actions: Dictionary
	var notable_games: Array
	var prompt: String
	var negative_prompt: String
	var icons: Array
	var ads: Array
	
	func _init(p_name: String, p_description: String, p_actions: Dictionary, p_games: Array, 
			   p_prompt: String, p_neg_prompt: String):
		name = p_name
		description = p_description
		actions = p_actions
		notable_games = p_games
		prompt = p_prompt
		negative_prompt = p_neg_prompt
		icons = [
			"res://icons/" + p_name.to_lower().replace(" ", "_") + "_1.png",
			"res://icons/" + p_name.to_lower().replace(" ", "_") + "_2.png",
			"res://icons/" + p_name.to_lower().replace(" ", "_") + "_3.png"
		]
		ads = [
			"res://ads/" + p_name.to_lower().replace(" ", "_") + "_1.png",
			"res://ads/" + p_name.to_lower().replace(" ", "_") + "_2.png",
			"res://ads/" + p_name.to_lower().replace(" ", "_") + "_3.png",
			"res://ads/" + p_name.to_lower().replace(" ", "_") + "_4.png",
			"res://ads/" + p_name.to_lower().replace(" ", "_") + "_5.png"
		]

var genres = {}
var selected_genre

const GLOBAL_ADDITIONS = """Include: Professional gaming logo design, high-end post-processing effects,
volumetric lighting, ambient occlusion, ray-traced reflections, and photo-realistic textures. 
Marketing-quality composition suitable for modern gaming promotional materials. 
Style of Unreal Engine 5 quality renders."""

const GLOBAL_NEGATIVE = """deformed anatomy, watermarks, signatures, text overlays, low-quality
compression artifacts, poor anti-aliasing, visible polygons, texture seams, inappropriate aspect ratio, 
overexposed lighting, unclear focal point, poor color grading, incorrect perspective, 
amateurish post-processing, lens flares, chromatic aberration, poor depth of field, 
jpeg artifacts, noise, grain, poor composition, blurry details, incorrect shadows"""

func _ready():
	_initialize_genres()

func _initialize_genres():
	# Open World Action/Adventure
	genres[GenreType.OPEN_WORLD] = GenreData.new(
		"Open World",
		"Open World Action/Adventure",
		{
			"player_actions": ["Walking", "running", "climbing", "swimming", "fighting", "driving vehicles"],
			"interactions": ["Dialog choices", "item collection", "environment manipulation"],
			"control_pattern": ["Movement stick/keys", "action buttons", "camera control"],
			"common_actions": ["Opening chests", "missions", "upgrades", "fast travel"]
		},
		["Grand Theft Auto V", "Red Dead Redemption 2", "The Legend of Zelda: Breath of the Wild", 
		 "Assassin's Creed Valhalla", "Spider-Man 2", "Horizon Zero Dawn", "Cyberpunk 2077", 
		 "Ghost of Tsushima", "Elden Ring", "Watch Dogs series"],
		"Create a hyperrealistic promotional image for 'Pirates vs Sharks': A third-person perspective of a weathered pirate captain standing on the bow of a detailed wooden ship, sword drawn, facing a massive megalodon breaching the stormy Caribbean waters. Dramatic lighting, volumetric clouds, ray-traced water reflections, and detailed ship rigging in the style of modern AAA games like Assassin's Creed Black Flag. 8k, cinematic composition. " + GLOBAL_ADDITIONS,
		"cartoon, anime, cel-shading, low resolution, blurry, pixelated, amateur, mobile game graphics, flat lighting, simplified textures, poor composition, stick figures, children's illustration style, low-poly, unrealistic water effects, basic shadows, missing reflections, plastic-looking materials. " + GLOBAL_NEGATIVE
	)

	# Battle Royale
	genres[GenreType.BATTLE_ROYALE] = GenreData.new(
		"Battle Royale",
		"Battle Royale",
		{
			"player_actions": ["Looting", "shooting", "building", "hiding", "running"],
			"interactions": ["Enemy engagement", "team coordination", "inventory management"],
			"control_pattern": ["Precise aim control", "quick weapon switching"],
			"common_actions": ["Parachuting", "healing", "reviving teammates"]
		},
		["Fortnite", "PUBG: Battlegrounds", "Apex Legends", "Warzone 2.0", "Fall Guys",
		 "Vampire: The Masquerade - Blood Hunt", "Naraka: Bladepoint", "Realm Royale",
		 "Spellbreak", "Super People"],
		"Generate a hyperrealistic gaming promotional art for 'Pirates vs Sharks': An aerial view of multiple pirate ships engaged in combat across a shrinking safe zone marked by glowing blue barriers in tropical waters. Some ships are sinking, others fighting sharks, with players swimming between vessels. Dynamic action scene with modern HUD elements, inspired by PUBG's visual style. 8k, dramatic lighting. " + GLOBAL_ADDITIONS,
		"cartoon graphics, mobile game quality, simple shapes, flat colors, missing particle effects, basic water textures, poor draw distance, missing atmospheric effects, low-detail ships, simplistic UI, childish design, amateur composition, missing shadows, flat lighting, no ambient occlusion. " + GLOBAL_NEGATIVE
	)

	# First-Person Shooter (FPS)
	genres[GenreType.FPS] = GenreData.new(
		"FPS",
		"First-Person Shooter (FPS)",
		{
			"player_actions": ["Aiming", "shooting", "reloading", "crouching", "jumping"],
			"interactions": ["Team communication", "objective capturing"],
			"control_pattern": ["Mouse/stick aim", "WASD/stick movement"],
			"common_actions": ["Throwing grenades", "switching weapons"]
		},
		["Call of Duty series", "Counter-Strike 2 (CS2)", "Valorant", "Overwatch 2", "Doom Eternal",
		 "Rainbow Six Siege", "Battlefield series", "Destiny 2", "Halo Infinite", "Titanfall 2"],
		"Create a hyperrealistic FPS promotional image for 'Pirates vs Sharks': First-person view from a pirate's perspective, holding an ornate flintlock pistol in the right hand, cutlass in the left. Through the gun's iron sights, a great white shark is leaping toward the player. Detailed weapon textures, water droplets on screen, motion blur effects. Modern military game quality, 8k resolution. " + GLOBAL_ADDITIONS,
		"toy guns, cartoon sharks, unrealistic water, poor weapon detail, missing reflections, basic textures, mobile game quality, incomplete HUD, amateur perspective, incorrect proportions, flat lighting, missing particle effects, low resolution textures, simplistic materials. " + GLOBAL_NEGATIVE
	)

	# Role-Playing Games (RPG)
	genres[GenreType.RPG] = GenreData.new(
		"RPG",
		"Role-Playing Games (RPG)",
		{
			"player_actions": ["Character movement", "combat execution", "skill casting"],
			"interactions": ["NPC conversations", "quest management"],
			"control_pattern": ["Menu navigation", "combat commands"],
			"common_actions": ["Leveling up", "equipment management"]
		},
		["Final Fantasy series", "The Elder Scrolls V: Skyrim", "The Witcher 3: Wild Hunt", "Baldur's Gate 3",
		 "Dragon Age series", "Persona 5", "Mass Effect series", "Starfield", "Dragon Quest series", "Pillars of Eternity"],
		"Generate a hyperrealistic RPG promotional art for 'Pirates vs Sharks': A character selection screen showing three different pirate classes (Buccaneer, Navigator, and Cannoneer) in detailed period-accurate costumes, with stats and equipment displayed. Sharks lurking in the background waters. Style similar to modern RPGs like Baldur's Gate 3, with ray-traced lighting and high-end character models. " + GLOBAL_ADDITIONS,
		"simple character models, basic clothing textures, flat backgrounds, missing character details, amateur UI design, poor font choices, mobile game quality, static poses, unrealistic fabric, plastic-looking materials, missing atmospheric effects, poor lighting, inconsistent art style. " + GLOBAL_NEGATIVE
	)

	# Multiplayer Online Battle Arena (MOBA)
	genres[GenreType.MOBA] = GenreData.new(
		"MOBA",
		"Multiplayer Online Battle Arena (MOBA)",
		{
			"player_actions": ["Hero ability casting", "auto-attacking", "last-hitting"],
			"interactions": ["Lane management", "team coocoordination"],
			"control_pattern": ["Mouse clicking", "hotkeys for abilities"],
			"common_actions": ["Farming gold", "pushing lanes"]
		},
		["League of Legends", "Dota 2", "Heroes of the Storm", "Smite", "Mobile Legends: Bang Bang",
		 "Arena of Valor", "Pokemon Unite", "Heroes of Newerth", "Vainglory", "Infinity Warriors"],
		"Create a hyperrealistic MOBA promotional image for 'Pirates vs Sharks': Top-down isometric view of a naval arena with three distinct lanes separated by reefs. Hero pirates with unique abilities facing off against different species of sharks. Include mini-map, ability icons, and MOBA-style visual effects. Inspired by League of Legends' art style but with photorealistic graphics. " + GLOBAL_ADDITIONS,
		"basic overhead view, simple map design, crude UI elements, mobile game graphics, missing visual effects, poor water caustics, unrealistic shadows, flat textures, amateur icons, missing particle effects, simplified character models, poor perspective, basic lighting. " + GLOBAL_NEGATIVE
	)

	# Sports Games
	genres[GenreType.SPORTS] = GenreData.new(
		"Sports",
		"Sports Games",
		{
			"player_actions": ["Passing", "shooting", "tackling", "running plays"],
			"interactions": ["Team management", "player trading"],
			"control_pattern": ["Context-sensitive buttons", "analog movement"],
			"common_actions": ["Setting plays", "making substitutions"]
		},
		["FIFA series (now EA Sports FC)", "NBA 2K series", "Madden NFL series", "MLB The Show", "NHL series",
		 "WWE 2K series", "Tony Hawk's Pro Skater 1+2", "F1 series", "PGA Tour 2K", "eFootball"],
		"Generate a hyperrealistic sports-style promotional art for 'Pirates vs Sharks': Split screen showing a tournament-style ship racing competition, with detailed statistics, team logos, and performance metrics. Ships maneuvering through shark-infested waters like a maritime racing sport. ESPN-style presentation with modern sports game graphics quality. " + GLOBAL_ADDITIONS,
		"amateur scoreboard design, basic UI, poor statistical display, unrealistic water physics, simplified ship models, missing weather effects, cartoon style, mobile game quality, poor composition, unprofessional layout, missing reflections, basic lighting, flat textures. " + GLOBAL_NEGATIVE
	)

	# Survival/Crafting
	genres[GenreType.SURVIVAL] = GenreData.new(
		"Survival Crafting",
		"Survival/Crafting",
		{
			"player_actions": ["Gathering resources", "crafting", "building"],
			"interactions": ["Resource management", "tool creation"],
			"control_pattern": ["Inventory management", "building interface"],
			"common_actions": ["Mining", "farming", "cooking"]
		},
		["Minecraft", "Valheim", "Rust", "Terraria", "ARK: Survival Evolved",
		 "Don't Starve", "Subnautica", "The Forest", "Grounded", "7 Days to Die"],
		"Create a hyperrealistic survival game promotional image for 'Pirates vs Sharks': First-person view of a crafting interface showing ship building mechanics, with material requirements and blueprint overlays. Background shows a partially constructed ship with sharks circling. Include survival metrics (hunger, thirst, stamina). Similar to modern survival games like Rust but with naval theme. " + GLOBAL_ADDITIONS,
		"basic crafting interface, simplified blueprints, poor material textures, amateur UI design, mobile game quality, missing detail in construction, flat lighting, unrealistic water, basic particle effects, poor inventory design, missing depth, cartoon style. " + GLOBAL_NEGATIVE
	)

	# Action RPG (ARPG)
	genres[GenreType.ARPG] = GenreData.new(
		"ARPG",
		"Action RPG (ARPG)",
		{
			"player_actions": ["Constant clicking/button pressing", "skill activation"],
			"interactions": ["Loot collection", "gear optimization"],
			"control_pattern": ["Mouse-heavy clicking or button mapping"],
			"common_actions": ["Defeating mobs", "managing inventory"]
		},
		["Diablo series", "Path of Exile", "Grim Dawn", "Torchlight series", "Last Epoch",
		 "Lost Ark", "Wolcen: Lords of Mayhem", "Victor Vran", "Titan Quest", "Sacred series"],
		"Generate a hyperrealistic ARPG promotional art for 'Pirates vs Sharks': Close-up action shot of a heavily customized pirate character with visible gear stats and rarity indicators, fighting multiple sharks with special abilities and damage numbers popping up. Diablo-style inventory system visible but with naval warfare theme. Ray-traced water effects, 8k resolution. " + GLOBAL_ADDITIONS,
		"basic character models, poor equipment detail, simplified combat effects, amateur UI, mobile game quality, missing particle effects, unrealistic water physics, poor lighting, basic animations, missing damage effects, flat textures, cartoon style, simplified inventory. " + GLOBAL_NEGATIVE
	)

	# Platform Games
	genres[GenreType.PLATFORM] = GenreData.new(
		"Platform",
		"Platform Games",
		{
			"player_actions": ["Jumping", "running", "wall-jumping", "sliding"],
			"interactions": ["Obstacle navigation", "power-up collection"],
			"control_pattern": ["Precise directional control", "jump timing"],
			"common_actions": ["Collecting coins/items", "avoiding hazards"]
		},
		["Super Mario series", "Hollow Knight", "Celeste", "Ori series", "Rayman series",
		 "Crash Bandicoot series", "Sonic series", "Inside/Limbo", "Little Nightmares series", "A Hat in Time"],
		"Create a hyperrealistic platform game promotional image for 'Pirates vs Sharks': Side-view of a stylized but photorealistic pirate jumping between floating shipwrecks and platforms while avoiding shark-infested waters. Include collectible coins, power-ups, and platform game elements but with modern AAA graphics quality. Dynamic lighting and particle effects. " + GLOBAL_ADDITIONS,
		"2D graphics, basic platforming elements, cartoon style, simplified backgrounds, mobile game quality, missing particle effects, poor water physics, basic lighting, flat textures, amateur composition, missing depth, simplified obstacles, poor environmental detail. " + GLOBAL_NEGATIVE
	)

	# Racing Games
	genres[GenreType.RACING] = GenreData.new(
		"Racing",
		"Racing Games",
		{
			"player_actions": ["Accelerating", "braking", "steering", "using power-ups"],
			"interactions": ["Vehicle handling", "track memorization"],
			"control_pattern": ["Trigger controls", "analog steering"],
			"common_actions": ["Drifting", "slipstreaming", "vehicle customization"]
		},
		["Forza Horizon series", "Gran Turismo series", "Mario Kart series", "Need for Speed series", "Dirt series",
		 "Project CARS series", "Assetto Corsa", "The Crew series", "TrackMania", "F1 series"],
		"Generate a hyperrealistic racing game promotional art for 'Pirates vs Sharks': Third-person view of a heavily modified pirate ship in a racing position, with speed blur effects and racing line indicators. Sharks acting as dynamic obstacles. Include performance stats, speedometer, and mini-map. Forza-quality vehicle details but with historical sailing ships. " + GLOBAL_ADDITIONS,
		"basic ship models, poor water physics, simplified racing elements, amateur UI, mobile game quality, missing speed effects, unrealistic materials, flat lighting, basic particle effects, missing weather impacts, cartoon style, poor camera angles, simplified HUD. " + GLOBAL_NEGATIVE
	)

# Utility functions
func get_genre_data(genre_type: int) -> GenreData:
	return genres.get(genre_type)

func get_genre_names() -> Array:
	var names = []
	for genre in genres.values():
		names.append(genre.name)
	return names

func get_genre_actions(genre_type: int) -> Dictionary:
	var genre = get_genre_data(genre_type)
	return genre.actions if genre else {}

func get_genre_games(genre_type: int) -> Array:
	var genre = get_genre_data(genre_type)
	return genre.notable_games if genre else []

func get_prompt(genre_type: int) -> String:
	var genre = get_genre_data(genre_type)
	return genre.prompt if genre else ""

func get_negative_prompt(genre_type: int) -> String:
	var genre = get_genre_data(genre_type)
	return genre.negative_prompt if genre else ""
