extends Node

## Default is actually 80/40 in rooms, but we use the halved version as
## it's the number we actually use in calculations
const DEFAULT_GRID_STEP_X : float = 40.0
const DEFAULT_GRID_STEP_Y : float = 20.0

const DEFAULT_SCALE : float = 1.0

const NULL_VECTOR : Vector2 = Vector2(-999, -999)

const ACTION_TIMEOUT = 0.25

const DEFAULT_GIKO_MOVESPEED = 85
const SLOW_GIKO_MOVESPEED = 30
const FAST_GIKO_MOVESPEED = 300



const GIKOANIM_BACK_STANDING = "back-standing"
const GIKOANIM_BACK_WALKING = "back-walking"
const GIKOANIM_FRONT_STANDING = "front-standing"
const GIKOANIM_FRONT_WALKING = "front-walking"
const GIKOANIM_FRONT_SITTING = "front-sitting"
const GIKOANIM_BACK_SITTING = "back-sitting"
const GIKOANIM_POP = "giko-pop"

const CAMERA_MAX_X = 540
const CAMERA_MIN_X = -240
const CAMERA_MAX_Y = 240
const CAMERA_MIN_Y = -CAMERA_MAX_Y

const TIME_TO_GHOST = 30.0
const GHOST_COLOR = Color(1, 1, 1, 0.5)
const NORMAL_COLOR = Color(1, 1, 1, 1)


enum LineType {
	Text,
	Choice
}

### CONDITION TYPES TO HELP BRANCH DIALOGUES, UNRELATED TO QUEST CONDITIONS
enum ConditionType {
	Flag,
	Item,
    NoItem,
    NoFlag
}

#const GIKO_MIN_SPEED = 5

enum Decisions {
	FINDSEAT,
	IDLE,
	CHANGEDIRECTION,
	TALK,
	MOVESOMEWHERE
}

enum Actions {
    MOVE,
    FACE,
    IDLE,
    TALK,
    FOLLOW,
    FLEE
}


enum Directions {
	DIR_LEFT,
	DIR_UP,
	DIR_RIGHT,
	DIR_DOWN
}

const DIRECTIONS_STRING = {
	Directions.DIR_LEFT : "Left",
	Directions.DIR_UP : "Up",
	Directions.DIR_RIGHT : "Right",
	Directions.DIR_DOWN : "Down"
}

const DIRECTION_VECTOR = {
	Directions.DIR_LEFT : Vector2(-1, 0),
	Directions.DIR_UP : Vector2(0, 1),
	Directions.DIR_RIGHT : Vector2(1, 0),
	Directions.DIR_DOWN : Vector2(0, -1)
}

enum Character {
	Baba_Shobon,
	Chotto_Toorimasu_Yo,
	Dark_Naito_Walking,
	Dokuo,
	FunkyNaito,
	Furoshiki,
	Furoshiki_Shii,
	Furoshiki_Shobon,
	George,
	Giko,
	Giko_Hat,
	Golden_Furoshiki,
	Hentai_Giko,
	Hikki,
	Himawari,
	Hotsuma_Giko,
	Hungry_Giko,
	Ika,
	Kaminarisama_Naito,
	Molgiko,
	Naito,
	Naito_Yurei,
	NaitoApple,
	Nida,
	Onigiri,
	Panda_Naito,
	Pumpkinhead,
	Rikishi_Naito,
	Sakura_Furoshiki_Shii,
	Salmon,
	Shar_Naito,
	Shii,
	Shii_Hat,
	Shii_Pianica,
	Shii_Uniform,
	Shiinigami,
	Shobon,
	Tabako_Dokuo,
	Takenoko,
	Tikan_Giko,
	Tinpopo,
	Tokita_Naito,
	Uzukumari,
	Wild_Panda_Naito,
	Youkanman,
	Zonu
}


const CHARACTERS = {
	Character.Baba_Shobon : "baba_shobon",
	Character.Chotto_Toorimasu_Yo : "chotto_toorimasu_yo",
	Character.Dark_Naito_Walking : "dark_naito_walking",
	Character.Dokuo : "dokuo",
	Character.FunkyNaito : "funkynaito",
	Character.Furoshiki : "furoshiki",
	Character.Furoshiki_Shii : "furoshiki_shii",
	Character.Furoshiki_Shobon : "furoshiki_shobon",
	Character.George : "george",
	Character.Giko : "giko",
	Character.Giko_Hat : "giko_hat",
	Character.Golden_Furoshiki : "golden_furoshiki",
	Character.Hentai_Giko : "hentai_giko",
	Character.Hikki : "hikki",
	Character.Himawari : "himawari",
	Character.Hotsuma_Giko : "hotsuma_giko",
	Character.Hungry_Giko : "hungry_giko",
	Character.Ika : "ika",
	Character.Kaminarisama_Naito : "kaminarisama_naito",
	Character.Molgiko : "molgiko",
	Character.Naito : "naito",
	Character.Naito_Yurei : "naito_yurei",
	Character.NaitoApple : "naitoapple",
	Character.Nida : "nida",
	Character.Onigiri : "onigiri",
	Character.Panda_Naito : "panda_naito",
	Character.Pumpkinhead : "pumpkinhead",
	Character.Rikishi_Naito : "rikishi_naito",
	Character.Sakura_Furoshiki_Shii : "sakura_furoshiki_shii",
	Character.Salmon : "salmon",
	Character.Shar_Naito : "shar_naito",
	Character.Shii : "shii",
	Character.Shii_Hat : "shii_hat",
	Character.Shii_Pianica : "shii_pianica",
	Character.Shii_Uniform : "shii_uniform",
	Character.Shiinigami : "shiinigami",
	Character.Shobon : "shobon",
	Character.Tabako_Dokuo : "tabako_dokuo",
	Character.Takenoko : "takenoko",
	Character.Tikan_Giko : "tikan_giko",
	Character.Tinpopo : "tinpopo",
	Character.Tokita_Naito : "tokita_naito",
	Character.Uzukumari : "uzukumari",
	Character.Wild_Panda_Naito : "wild_panda_naito",
	Character.Youkanman : "youkanman",
	Character.Zonu : "zonu"
}


const RANDOM_GIKOS = [
	{
		"name" : "maf",
		"character": Character.Zonu
	},
	{
		"name" : "Kaomoji",
		"character": Character.Salmon
	},
	{
		"name" : "Gaming",
		"character": Character.Dokuo
	},
	{
		"name" : "Kaiichi",
		"character": Character.Salmon
	},
	{
		"name" : "lin",
		"character": Character.Shii_Uniform
	},
	{
		"name" : "E P H E M E R A L",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "ChibiDenpachu",
		"character": Character.Furoshiki_Shobon
	},
	{
		"name" : "iccanobif",
		"character": Character.Chotto_Toorimasu_Yo
	},
	{
		"name" : "Bubz",
		"character": Character.Uzukumari
	},
	{
		"name" : "Bun",
		"character": Character.Naito
	},
	{
		"name" : "dinghy",
		"character": Character.Furoshiki
	},
	{
		"name" : "PINTO◆PINYEXSs8w",
		"character": Character.Himawari
	},
	{
		"name" : "pyon",
		"character": Character.Shii_Uniform
	},
	{
		"name" : ".orgman",
		"character": Character.Hikki
	},
	{
		"name" : "Nameless◆RUMIA.l2hM",
		"character": Character.Tinpopo
	},
	{
		"name" : "Nameless",
		"character": Character.Salmon
	},
	{
		"name" : "mouse",
		"character": Character.Shii
	},
	{
		"name" : "mugi",
		"character": Character.Furoshiki_Shobon
	},
	{
		"name" : "NiceBird",
		"character": Character.Salmon
	},
	{
		"name" : "puffy",
		"character": Character.Molgiko
	},
	{
		"name" : "little_mac",
		"character": Character.Baba_Shobon
	},
	{
		"name" : "JaLo",
		"character": Character.Giko
	},
	{
		"name" : "Indigo",
		"character": Character.Hotsuma_Giko
	},
	{
		"name" : "Archduke",
		"character": Character.Nida
	},
	{
		"name" : "Moon",
		"character": Character.Shii_Hat
	},
	{
		"name" : "CATARP!",
		"character": Character.Sakura_Furoshiki_Shii
	},
	{
		"name" : "MONA",
		"character": Character.Giko
	},
	{
		"name" : "bonbon",
		"character": Character.Furoshiki_Shobon
	},
	{
		"name" : "◆feor.cMejo",
		"character": Character.Golden_Furoshiki
	},
	{
		"name" : "Skyzzerz",
		"character": Character.Tinpopo
	},
	{
		"name" : "unknown",
		"character": Character.Hotsuma_Giko
	},
	{
		"name" : "Nerg-kun",
		"character": Character.Giko_Hat
	},
	{
		"name" : "Gunth",
		"character": Character.Giko_Hat
	},
	{
		"name" : "Red",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "♥",
		"character": Character.Shii
	},
	{
		"name" : "Zzazzachu",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "o_o",
		"character": Character.Salmon
	},
	{
		"name" : "ponzu",
		"character": Character.Shii
	},
	{
		"name" : "Frost",
		"character": Character.Giko
	},
	{
		"name" : "TOM_HANKS",
		"character": Character.Giko_Hat
	},
	{
		"name" : "Knoxy",
		"character": Character.Giko
	},
	{
		"name" : "polilla",
		"character": Character.Himawari
	},
	{
		"name" : "killsushi",
		"character": Character.NaitoApple
	},
	{
		"name" : "◆BLANK8x6Po",
		"character": Character.Furoshiki
	},
	{
		"name" : "tanami",
		"character": Character.FunkyNaito
	},
	{
		"name" : "that fkn cat",
		"character": Character.Giko
	},
	{
		"name" : "piano",
		"character": Character.Naito
	},
	{
		"name" : "capey",
		"character": Character.Giko
	},
	{
		"name" : "ssz",
		"character": Character.Naito
	},
	{
		"name" : "andypeach",
		"character": Character.Shii
	},
	{
		"name" : "Blank",
		"character": Character.Tikan_Giko
	},
	{
		"name" : "姜太K◆Hentai.kRI",
		"character": Character.Salmon
	},
	{
		"name" : "Wooly",
		"character": Character.Shobon
	},
	{
		"name" : "wen◆wenyeahVM2",
		"character": Character.Shii_Hat
	},
	{
		"name" : "uhh-kun",
		"character": Character.Shobon
	},
	{
		"name" : "lil badshit",
		"character": Character.Shobon
	},
	{
		"name" : "badpanda",
		"character": Character.Panda_Naito
	},
	{
		"name" : "rosuphone",
		"character": Character.Tabako_Dokuo
	},
	{
		"name" : "Rosuto",
		"character": Character.Furoshiki
	},
	{
		"name" : "roris",
		"character": Character.Uzukumari
	},
	{
		"name" : "Rifur",
		"character": Character.Hotsuma_Giko
	},
	{
		"name" : "Big-TF",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "Bipedal Octopus",
		"character": Character.Giko
	},
	{
		"name" : "Redmage",
		"character": Character.Shii_Hat
	},
	{
		"name" : "Grobda",
		"character": Character.Furoshiki
	},
	{
		"name" : "clair",
		"character": Character.Naito
	},
	{
		"name" : "ETF",
		"character": Character.Giko
	},
	{
		"name" : "manman",
		"character": Character.Naito
	},
	{
		"name" : "natachan",
		"character": Character.Shii_Hat
	},
	{
		"name" : "gizmogal",
		"character": Character.Shii
	},
	{
		"name" : "bawkbawkBAWK",
		"character": Character.Giko
	},
	{
		"name" : "Shewi",
		"character": Character.Furoshiki
	},
	{
		"name" : "wiiaboo",
		"character": Character.Giko_Hat
	},
	{
		"name" : "K",
		"character": Character.Giko
	},
	{
		"name" : "American Fatty",
		"character": Character.Giko_Hat
	},
	{
		"name" : "Santana",
		"character": Character.Hikki
	},
	{
		"name" : "cate",
		"character": Character.Tabako_Dokuo
	},
	{
		"name" : "rokoo",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "LSpark",
		"character": Character.Giko
	},
	{
		"name" : "Cocoron",
		"character": Character.Shii
	},
	{
		"name" : "balls",
		"character": Character.Naito
	},
	{
		"name" : "shotakid",
		"character": Character.Shobon
	},
	{
		"name" : "xeffu",
		"character": Character.Hotsuma_Giko
	},
	{
		"name" : "Kya!",
		"character": Character.Shii
	},
	{
		"name" : "zerostarchan",
		"character": Character.Sakura_Furoshiki_Shii
	},
	{
		"name" : "pineappleman",
		"character": Character.Naito
	},
	{
		"name" : "dqn",
		"character": Character.Giko
	},
	{
		"name" : "felixhoffman",
		"character": Character.Giko
	},
	{
		"name" : "fattytan",
		"character": Character.Hungry_Giko
	},
	{
		"name" : "pablo",
		"character": Character.Hentai_Giko
	},
	{
		"name" : "Caribear",
		"character": Character.Panda_Naito
	},
	{
		"name" : "Desuno",
		"character": Character.Giko
	},
	{
		"name" : "meltingwax",
		"character": Character.Shii_Uniform
	},
	{
		"name" : "E.T.",
		"character": Character.Hotsuma_Giko
	},
	{
		"name" : "dz",
		"character": Character.Naito
	},
	{
		"name" : "Dumpster Dave",
		"character": Character.Giko
	},
	{
		"name" : "roguyen",
		"character": Character.Shii
	},
	{
		"name" : "◆SON/uKUBu2",
		"character": Character.Shobon
	},
	{
		"name" : "LONGCAT",
		"character": Character.Giko
	},
	{
		"name" : "Rufio",
		"character": Character.Giko
	},
	{
		"name" : "otacon_",
		"character": Character.Naito
	},
	{
		"name" : "Breadspace",
		"character": Character.Giko
	},
	{
		"name" : "cF◆GLoXq//UpE",
		"character": Character.Giko
	},
	{
		"name" : "AKIBAjBrak",
		"character": Character.Giko
	},
	{
		"name" : "Sparky4",
		"character": Character.Giko
	},
	{
		"name" : "◆Hide/fvE.2",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "◆EBI/44onYM",
		"character": Character.Furoshiki
	},
	{
		"name" : "島民◆MVKPd8lXxA",
		"character": Character.Shii_Pianica
	},
	{
		"name": "鬼大◆raWgvxkpl2",
		"character": Character.Furoshiki_Shobon
	},
	{
		"name" : "E. Superstructure",
		"character": Character.Naito
	},
	{
		"name" : "Phy",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "Mr. B",
		"character": Character.Giko_Hat
	},
	{
		"name" : "THE DR IS A FAG",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "Das Igloo",
		"character": Character.Naito
	},
	{
		"name" : "Enigma",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "||||",
		"character": Character.Giko
	},
	{
		"name" : "aibo",
		"character": Character.Giko
	},
	{
		"name" : "oxba",
		"character": Character.Furoshiki
	},
	{
		"name" : "Rar",
		"character": Character.Giko
	},
	{
		"name" : "Van Giko",
		"character": Character.Shii_Pianica
	},
	{
		"name" : "Uru",
		"character": Character.Giko
	},
	{
		"name" : "NeoZero",
		"character": Character.Giko
	},
	{
		"name" : "grimmy",
		"character": Character.Shii
	},
	{
		"name" : "afro-tan",
		"character": Character.Dark_Naito_Walking
	},
	{
		"name" : "markavu",
		"character": Character.Dark_Naito_Walking
	},
	{
		"name" : "maffew",
		"character": Character.Giko
	},
	{
		"name" : "Y-W-S",
		"character": Character.Giko
	},
	{
		"name" : "vipper",
		"character": Character.Naito
	},
	{
		"name" : "muryokU",
		"character": Character.Salmon
	},
	{
		"name": "◆PPppppppSI",
		"character": Character.Dark_Naito_Walking
	},
	{
		"name" : "Macbeth",
		"character": Character.Hikki
	},
	{
		"name" : "Shaddox",
		"character": Character.Hentai_Giko
	},
	{
		"name" : "MEOW",
		"character": Character.Shii
	},
	{
		"name" : "HARBL DESU",
		"character": Character.Shii
	},
	{
		"name" : "42GeeFUN42",
		"character": Character.Giko
	},
	{
		"name" : "Sarahsuke",
		"character": Character.Shii
	},
	{
		"name": "◆N/oGYAHAHA",
		"character": Character.Giko
	},
	{
		"name": "Kouko",
		"character": Character.Shii_Uniform
	},
	{
		"name": "ケンコンコ数◆kEnKoNko1I",
		"character": Character.Salmon
	},
	{
		"name": "爽◆SK2v8l8drw",
		"character": Character.Onigiri
	},
	{
		"name": "くろ",
		"character": Character.Chotto_Toorimasu_Yo
	},
    {
        "name": "chos",
        "character": Character.Furoshiki_Shobon
    },
    {
        "name": "Butterscotch",
        "character": Character.Tinpopo
    },
    {
        "name": "漢",
        "character": Character.Golden_Furoshiki
    }
]


const POSSIBLE_MESSAGES = [
	"The dog is actually just a weird cat.",
	"ONIGIRI WASSHOI!!",
	"Sweet furoshiki!",
	"Let's play Mahjong!",
	"Get outta the way, jackass!",
	"I feel like pot pies get old a bit quickly.",
	"I love chocobos!",
	"Can we remain friends?",
	"You should play FFXIV with me.",
	"Pinto's wiki sure is something!",
	"The tripcode generator made my GPU overheat",
	"Onoes.",
	"Maf should fix it.",
	"I definitely don't want to be reincarnated as an oil sardine.",
	"Kanrinin street is a bug of cultural significance.",
	"Idling is the best.",
	"The train was made for watching anime.",
	"TIGER TIGER TIGER TIGER",
	"I want to take it easy.",
	"Twerking molecules are so hot!",
	"I'm afraid of the Boon Bicycle Gang.",
	"Amagami is a huge time sink.",
	"I want to learn how to play Backgammon.",
	"Some people here really drink too much.",
	"Prime Grade Accent.",
	"Hairy chests are polarizing.",
	"Are you really thinking about quitting your job?",
	"Time for my daily Japanese lesson.",
	"I hope animations are added soon.",
	"Everyone around me is Tokiko.",
	"This place is way too crowded.",
	"I have deep issues over my mother never loving me.",
	"Have you heard about this new game called Giko Idol?",
	"I want to play Gikobox...",
	"Don't forget, you're here forever.",
	"A cat is fine too.",
	"Let's watch some sumo!",
	"I'm going for a walk. See you later!",
	"Who made this room?",
	"If you're Taiwanese, why are you not in the Banquet Hall?",
	"I wish they never killed off Flash.",
	"I heard something about a secret chatroom called Gikobois.",
	"I think #rula is broken here...",
	"You gotta do the cooking by the book.",
	"Will you sign my petition to ban private streams?",
	"This rock looks like zonu. Incredible!",
	"Are you also a wizard?",
	"I wish I had a bathtub...",
	"I've spent way too much money on mahjong gacha.",
	"The mystery of the Epson Endeavor in hacker room remains.",
	"The two sun theory is not a conspiracy theory! It's true!",
	"Are you really using a square monitor?",
	"This new mech anime is GAR as fuck!",
	"What are you looking at?",
	"They're such nice people, aren't they?",
	"Nyoro~n :3c",
	"I'm gonna send you a package full of candy.",
	"Unboxing stream time!",
	"I'm having Jägerschnitzel for dinner.",
	"Honestly, the FFVII Remake isn't that bad.",
	"Gaming",
	"(´・ω・`)",
	"THE FORCED INDENTATION OF CODE",
	"Is the tofu in that supposed to be soft and slippery?",
	"The last time I was in Japan was for C96.",
	"hows it goin",
	"Hold shit for focused movement.",
	"I'M GONNA GO CALL THE WORLD POLICE"
]



const NOTIFICATIONS_PATH = "/root/Main/UI/Notifications"

const TITLESCREEN_SCENE_PATH = "res://UI/TitleScreen/TitleScreen.tscn"
const MENU_SCENE_PATH = "res://UI/Menu/Menu.tscn"
const AUDIOMENU_SCENE_PATH = "res://UI/Menu/AudioMenu/AudioMenu.tscn"
const DISPLAYMENU_SCENE_PATH = "res://UI/Menu/DisplayMenu/DisplayMenu.tscn"
const SAVEMENU_SCENE_PATH = "res://UI/Menu/SaveMenu/SaveMenu.tscn"
const LOADMENU_SCENE_PATH = "res://UI/Menu/LoadMenu/LoadMenu.tscn"
