class_name Card

extends RefCounted

var name: String

#This is going to have to be some complex data structure that lets me
#What the card is able to target
#How are we going to bake in roguelike instance changes to card behavior?
#It means that they are mutable or its just another input to a transform function?

var usage: String

#How do we define what it does to something?
#It has to be some function that just takes in the targets and then visits and does something to them...\

#This is going to be an interesting way to tackle since its going to be dynamic in allow for different kinds of inputs
#Or maybe its not that difficult, you can just allow for max number of characters that would ever be in battle and have it be split between allies and opponents
#I need to figure out the struct for this
func apply(battleState: BattleState):
	#This is applying the card to the game state
	battleState.enemies
	pass
