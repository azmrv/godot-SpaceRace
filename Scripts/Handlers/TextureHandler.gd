# AutoLoad TextureHandler responsible for loading and caching textures requested by the rest of the game
# Keeps all paths to textures in one place
# Allows for switching out entire sets of textures
extends Node
# texture cache
var cache = {}

# lookup table for industry and research points
const indexed_lookup = [0,1,1,2,2,3,3,4,4,5,
	5,6,6,6,7,7,7,8,8,9,
	9,9,10,10,10,11,11,11,12,12,
	12,13,13,13,14,14,14,15,15,15,
	15,16,16,16,17,17,17,17,18,18,
	18,19,19,19,19]

# TODO: allow loading a "texturepack" (JSON with base paths)

func get_texture(path):
	if cache.has(path):
		return cache[path]
	elif File.new().file_exists(path):
		var texture = load(path)
		cache[path] = texture
		return texture
	else:
		print("TextureHandler: File not found: %s" % path)
		return null

func get_race_flag(player):
	var race = player.race
	var path = "res://Images/Races/FlagsBW/raceflag.shp_%02d.png" % [race.index + 1]
	return get_texture(path)
	pass
	
func get_race_icon(player):
	pass
	
func get_home_planet(player):
	pass
	
func get_star(system, small = false):
	var path = null
	var image_index = mapdefs.stars.find(system.star_type)
	if image_index != -1:
		if small:
			image_index = (image_index + 1) * 4
			path = "res://Images/Screens/Galaxy/Stars/cos_star.shp_%02d.png" % image_index
		else:
			path = "res://Images/Screens/Battle/Suns/%02d_%s.png" % [image_index+1, system.star_type]
		
		if path != null:
			return get_texture(path)
		else:
			print("TextureHandler: Star Texture not found")
			return null
	else:
		print("TextureHandler: Star Texture not found for %s" % [system.star_type])
		return null
	
func get_planet(planet, small = false):
	var type = planet.type
	var type_index = mapdefs.planet_types.find(type)
	var size = planet.size
	# offset by +1 because images start at 1
	var size_index = mapdefs.planet_sizes.find(size) + 1
	if type_index != -1 and size_index != -1:
		var path = null
		if small == true:
			var small_planet_index = (type_index * mapdefs.planet_sizes.size()) + size_index
			path = "res://Images/Screens/Battle/Planets/planets.shp_%02d.png" % [small_planet_index]
		else:
			path = "res://Images/Planets/planal%02d/planal%02d.shp_%d.png" % [type_index, type_index, size_index]
		if path != null:
			return get_texture(path)
	else:
		print("TextureHandler: Normal Planet Texture not found for %s, %s" % [type, size])
		return null
	pass
	
func get_surface_building(building):
	var building_index = BuildingDefinitions.building_types.find(building)
	if building_index != -1:
		var path = "res://Images/Screens/Planet/Buildings/Surface/%02d_%s.png" % [building_index + 1, building]
		return get_texture(path)
	pass
	
func get_research_icon(research):
	var resDef = ResearchDefinitions.research_defs[research]
	var path = "res://Images/Screens/Research/Research/restree.shp_%02d.png" % (resDef.index+1)
	return get_texture(path)
	pass
	
# research points display
func get_research(planet):
	return get_indexed_display("Research", planet.colony.adjusted_research)
	pass

func get_industry(planet):
	return get_indexed_display("Industry", planet.colony.adjusted_industry)
	pass

func get_prosperity(planet):
	return get_indexed_display("Prosperity", planet.colony.adjusted_prosperity)
	pass
	
func get_person(type, small = false):
	pass
	
func get_indexed_display(type, points):
	var index = -1
	if (type == "Research" or type == "Industry"):
		index = _lookup_index(points)
	elif (type == "Prosperity"):
		index = _flat_index(points)
	else:
		index = 0
		
	if index != -1:
		var path = "res://Images/Screens/Planet/%s/%02d.png" % [type, index]
		return get_texture(path)
	pass

func _lookup_index(points):
	var index = points
	if points < 0:
		index = 0
	elif points >= indexed_lookup.size():
		index = 20
	else:
		index = indexed_lookup[points]
	return index
	
func _flat_index(points):
	var index = points
	if points < 0:
		index = 0
	elif points > 20:
		index = 20
	return index