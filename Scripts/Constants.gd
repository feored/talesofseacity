extends Node

## Default is actually 80/40 in rooms, this is fine
const DEFAULT_GRID_STEP_X : float = 40.0
const DEFAULT_GRID_STEP_Y : float = 20.0

const DEFAULT_SCALE : float = 1.0

const ACTION_TIMEOUT = 0.25

const GROUP_GIKOS = "gikos"
const POSITION_EPSILON = 2.5

const GIKO_MOVESPEED = 85
const GIKO_MOOD_LENGTH = 5
const GIKO_MESSAGE_LENGTH = 5

const MESSAGE_Z_INDEX = 9999

const GIKOANIM_BACK_STANDING = "back-standing"
const GIKOANIM_BACK_WALKING = "back-walking"
const GIKOANIM_FRONT_STANDING = "front-standing"
const GIKOANIM_FRONT_WALKING = "front-walking"
const GIKOANIM_FRONT_SITTING = "front-sitting"
const GIKOANIM_BACK_SITTING = "back-sitting"

const CAMERA_MAX_X = 3840
const CAMERA_MIN_X = -CAMERA_MAX_X
const CAMERA_MAX_Y = 2160
const CAMERA_MIN_Y = -CAMERA_MAX_Y

const TIME_TO_GHOST = 30.0
const GHOST_COLOR = Color(1, 1, 1, 0.5)
const NORMAL_COLOR = Color(1, 1, 1, 1)


const GIKO_MIN_SPEED = 5


enum PERSONALITIES {
    Explorer,
    Afk
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
	#Shiinigami,
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
	#Character.Shiinigami : "shiinigami",
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

const GIKO_NAMES = [
	"Anonymous",
	"Bipedal Octopus",
	"BigTF",
	"maf",
	"dinghy",
	"iccanobif",
	"ChibiDenpachu",
	"E P H E M E R A L",
	"lin",
	"Kaiichi",
	"Gaming",
	"Kaomoji",
	"◆feor.cMejo",
	"bonbon",
	"bonkerz",
	"MONA",
	"CATARP!",
	"Moon",
	"indigo",
	"Tokiko",
	"Arch",
	"oboron",
	"issue maker",
	"JaLo",
	"little_mac",
	"puffy",
	"NiceBird",
	"mugi",
	"mouse",
	"Nameless",
	"Nameless Rumia",
	".orgman",
	"PINTO",
	"pyon",
	"rifur",
	"roris",
	"rosuto",
	"rosuphone",
	"badpanda",
	"lil badshit",
	"uhh-kun",
	"wen◆wenyeahVM2",
	"Wooly",
	"姜太K◆Hentai.kRI",
	"Blank",
	"andypeach",
	"ssz",
	"capey",
	"piano",
	"that fkn cat",
	"tanami",
	"BLANK8x6Po",
	"killsushi",
	"polilla",
	"Knoxy",
	"TOM_HANKS",
	"Frost",
	"ponzu",
	"Red",
	"Skyzzerz",
	"Gunth",
	"o_o",
	"♥",
	"Nerg-kun",
	"unknown",
	"rokoo",
	"cate",
	"Santana",
	"American Fatty",
	"K",
	"wiiaboo",
	"Shewi",
	"Bawk",
	"gizmogal",
	"natachan",
	"manman",
	"etf",
	"clair",
	"Redmage",
	"grobda",
	"LSpark",
	"Cocoron",
	"balls",
	"shotakid",
	"xeffu",
	"kia",
	"zerostarchan",
	"pineappleman",
	"dqn",
	"felixhoffman",
	"fattytan",
	"pablo",
	"Dumpster Dave",
	"dz",
	"ET",
	"meltingwax",
	"Desuno"
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
    "(´・ω・`)"
]
