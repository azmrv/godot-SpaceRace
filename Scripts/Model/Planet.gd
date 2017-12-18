# Planet info
extends Reference

# player
var owner

var colony = null

# which system this planet is in
var system

# Usually system.system_name + planet index, but can be changed
var planet_name

# size template
var size = "enormous"

# type template
var type = "cornucopia"

# initial max population
var base_population = 0

# both cell and building grids could just as well be dictionaries
# initial cell grid
var grid = []

# buildings grid
var buildings = []

# orbitals grid
var orbitals = []

# population
var population = {
	"work": 0, # working pop
	"idle": 0, # idle pop (alive - working)
	"alive": 0, # alive pop (grows when pop grows)
	"free": 0, # free slots (slots - alive)
	"slots": 0 # total slots (base + extra slots from buildings)
}

var total_population = 0 setget ,get_total_population

# current project
# FIXME: remove this
#var project = null

# TODO: methods should probably be in a PlanetController, to keep data separate from interaction
func get_total_population():
	return population.work + population.idle + population.free
	