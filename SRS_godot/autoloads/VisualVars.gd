extends Node
# All variables connected that governs the visuals

# Color palet
var ColorWhite = Color(1,1,1)
var ColorText = Color("FDFDFD")
var ColorTextAlt = Color("D7D6A6")
var ColorBackgroundAlt = Color("91A580")
var ColorBackground = Color("365C53")
var ColorDark = Color("121614")



func set_color_palette():

	VisualServer.set_default_clear_color(ColorBackground)

	var font = load("res://assets/FontsDF/Buttons.tres")
	font.outline_color = ColorDark

	font = load("res://assets/FontsDF/CommentsHeader.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/CommentsText.tres")
	font.outline_color = ColorDark

	font = load("res://assets/FontsDF/Header.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/Header2.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/SmallText.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/StudentButtons.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/TestTextSmall.tres")
	font.outline_color = ColorDark
	
	font = load("res://assets/FontsDF/VerySmallText.tres")
	font.outline_color = ColorDark
