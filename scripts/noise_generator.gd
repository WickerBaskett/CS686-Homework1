extends MeshInstance2D

@export var frequency: float = 0.01
@export var noise_type: FastNoiseLite.NoiseType = FastNoiseLite.TYPE_VALUE
@export var seed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#### WILL NEED TO REPLACE FASTNOISELITE WITH MANUAL 
	#### NOISE FUNCTION FOR ANALYTICAL PARTIALS
	var noise: FastNoiseLite = FastNoiseLite.new();
	
	# Configuration Options
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.seed = randi() if (seed == 0) else seed
	noise.frequency = 0.01
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	noise.domain_warp_enabled = false
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
