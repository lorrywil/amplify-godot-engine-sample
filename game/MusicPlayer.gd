class_name MusicPlayer
extends Node

const PIRATES_VS_SHARKS_ADVENTURE_1 = preload("res://musics/Pirates vs Sharks Adventure 1.mp3")
const PIRATES_VS_SHARKS_ADVENTURE_2 = preload("res://musics/Pirates vs Sharks Adventure 2.mp3")
const PIRATES_VS_SHARKS_BEACH_1 = preload("res://musics/Pirates vs Sharks Beach 1.mp3")
const PIRATES_VS_SHARKS_BEACH_2 = preload("res://musics/Pirates vs Sharks Beach 2.mp3")
const PIRATES_VS_SHARKS_KINGS_OF_THE_WORLD_1 = preload("res://musics/Pirates vs Sharks Kings of the World 1.mp3")
const PIRATES_VS_SHARKS_KINGS_OF_THE_WORLD_2 = preload("res://musics/Pirates vs Sharks Kings of the World 2.mp3")

const PIRATES_VS_SHARKS_TITLE = preload("res://musics/Pirates vs Sharks Title.mp3")
const PIRATES_VS_SHARKS_LOOP = preload("res://musics/Pirates vs Sharks Loop.mp3")
const PIRATES_VS_SHARKS_COMMERCIAL = preload("res://musics/Pirates vs Sharks Commercial.mp3")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_title():
	audio_stream_player.stream = PIRATES_VS_SHARKS_TITLE
	audio_stream_player.play()	
	
func play_loop():
	audio_stream_player.stream = PIRATES_VS_SHARKS_LOOP
	audio_stream_player.play()
	
func play_commercial():
	audio_stream_player.stream = PIRATES_VS_SHARKS_COMMERCIAL
	audio_stream_player.play()
