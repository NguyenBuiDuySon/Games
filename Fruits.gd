extends Node2D



func _on_Hurtbox_body_entered(body):
	queue_free()
