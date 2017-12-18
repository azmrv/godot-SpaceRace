# Planet Data Generator / Factory
extends Reference

var Planet = preload("res://Scripts/Model/Planet.gd")
var PlanetTile = preload("res://Scripts/Model/PlanetTile.gd")
var BuildingTile = preload("res://Scripts/Model/BuildingTile.gd")

func generate_planet(size = null, type = null):
	#randomize()
	var planet = Planet.new()
	if size == null:
		randomize_planet_size(planet)
	else:
		planet.size = size
	if type == null:
		randomize_planet_type(planet)
	else:
		planet.type = type
		
	generate_planet_grid(planet)
	
	#initialize_building_grid(planet)
	#spawn_xeno_ruins(planet)
	
	# define population size
	var size_index = mapdefs.planet_sizes.find(planet.size)
	var slots = mapdefs.planet_slots[planet.type][size_index]
	var min_slots = slots[0]
	var max_slots = slots[1]
	var possible_slots = range(min_slots, max_slots+1)
	var actual_slots = Utils.rand_pick_from_array(possible_slots)
	planet.base_population = actual_slots
	return planet
	pass
	
func randomize_planet_size(planet):
	planet.size = Utils.rand_pick_from_array(mapdefs.planet_sizes)

func randomize_planet_type(planet):
	planet.type = Utils.rand_pick_from_array(mapdefs.planet_types)
	pass

func generate_planet_grid(planet):
	var template = mapdefs.planet_size[planet.size].map
	var weights = mapdefs.planet_type[planet.type].weights
	
	var planet_max_grid = mapdefs.planet_max_grid
	
	# weighted random to pick planet
	# tally tile weights for this type
	var total_weight = 0
	for w in weights:
		total_weight += weights[w]
		pass
		
	# shift template if size < default (default = 11, see mapdefs.planet_max_grid)
	# this keeps all templates centered so the tilemap can stay at the same position
	# the original game had hardcoded offsets that match this 1:1
	var shift_x = (planet_max_grid - template.size()) / 2
	var shift_y = shift_x
	
	# init empty grid
	for x in range(planet_max_grid):
		planet.grid.append([])
		planet.buildings.append([])
		for y in range(planet_max_grid):
			# init empty planet tile
			# TODO: this might be stupid in the long run, but interaction is blocked so eh..
			# TODO: maybe null them and set tile further below
			var planet_tile = PlanetTile.new()
			planet_tile.tilemap_x = x
			planet_tile.tilemap_y = y
			planet.grid[x].append(planet_tile)
			
			var building_tile = BuildingTile.new()
			building_tile.tilemap_x = x
			building_tile.tilemap_y = y
			planet.buildings[x].append(building_tile)
	
	# iterate over tiles
	for x in range(template.size()):
		for y in range(template[x].size()):
			if template[x][y] == 1:
				# weighted coloring according to planet type
				var pick = randi() % total_weight
				var tile = null
				for w in weights:
					pick -= weights[w]
					if pick < 0: # can't do <= because 0 chances exist, maybe have to offset total_weight by 1
						tile = w
						# TODO: generate proper planet tiles
						break
				if tile != null:
					# account for shift and set tile
					planet.grid[x+shift_x][y+shift_y].tiletype = tile
			pass
		pass
	pass