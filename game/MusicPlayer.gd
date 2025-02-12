class_name MusicPlayer
extends Node

const PIRATES_VS_SHARKS_8_BIT_BUCCANEE = preload("res://art/musics/Pirates vs Sharks - 8-Bit Buccanee.mp3")
const PIRATES_VS_SHARKS_FIRE_BEACH_1 = preload("res://art/musics/Pirates vs Sharks - Fire Beach 1.mp3")
const PIRATES_VS_SHARKS_FIRE_BEACH_2 = preload("res://art/musics/Pirates vs Sharks - Fire Beach 2.mp3")
const PIRATES_VS_SHARKS_HIGH_SEAS_1 = preload("res://art/musics/Pirates vs Sharks - High Seas 1.mp3")
const PIRATES_VS_SHARKS_HIGH_SEAS_2 = preload("res://art/musics/Pirates vs Sharks - High Seas 2.mp3")
const PIRATES_VS_SHARKS_KINGS_OF_THE_WORLD_1 = preload("res://art/musics/Pirates vs Sharks - Kings of the World 1.mp3")
const PIRATES_VS_SHARKS_KINGS_OF_THE_WORLD_2 = preload("res://art/musics/Pirates vs Sharks - Kings of the World 2.mp3")
const PIRATES_VS_SHARKS_PIXEL_ADVENTURE_1 = preload("res://art/musics/Pirates vs Sharks - Pixel Adventure 1.mp3")
const PIRATES_VS_SHARKS_PIXEL_ADVENTURE_2 = preload("res://art/musics/Pirates vs Sharks - Pixel Adventure 2.mp3")
const PIRATES_VS_SHARKS_REEF_RUMBLE_1 = preload("res://art/musics/Pirates vs Sharks - Reef Rumble 1.mp3")
const PIRATES_VS_SHARKS_REEF_RUMBLE_2 = preload("res://art/musics/Pirates vs Sharks - Reef Rumble 2.mp3")

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_title():
	audio_stream_player.stream = PIRATES_VS_SHARKS_8_BIT_BUCCANEE
	audio_stream_player.play()	
	
func play_loop():
	audio_stream_player.stream = PIRATES_VS_SHARKS_REEF_RUMBLE_1
	audio_stream_player.play()
	
func play_commercial():
	audio_stream_player.stream = PIRATES_VS_SHARKS_REEF_RUMBLE_2
	audio_stream_player.play()
