package source

import fnl "../../vendor/fast_noise_lite"


NoiseGen :: struct {
	state: fnl.FNL_State,
}


initNoise :: proc(seed: i32) -> NoiseGen {
	state := fnl.create_state(seed)
	return {state = state}
}


getNoise :: proc(noise: ^NoiseGen, x: f32, y: f32) -> f32 {
	return fnl.get_noise_2d(noise.state, x, y)
}
