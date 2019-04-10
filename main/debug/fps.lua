local M = {}

M.fps = 0
M.sys_dt = 0
M.dt = 0

local LOG_SIZE = 150
local TICK_HEIGHT = 64
local TICK_WIDTH = 2
local GRAPH_BASE_DT = 1 / 60
local GRAPH_PX_DT = GRAPH_BASE_DT / 10
local GRAPH_MAX_DT = TICK_HEIGHT * GRAPH_PX_DT
local log_nodes = nil
local log_dt = nil

local last_time = -1
local frames = 0
local total_time = 0

function M.update(sys_dt)
	if last_time < 0 then
		last_time = socket.gettime()
		return
	end

	M.sys_dt = sys_dt

	local t = socket.gettime()
	M.dt = t - last_time
	if M.dt > 1 then
		M.dt = 1
	end

	frames = frames + 1

	total_time = total_time + M.dt
	if total_time > 1 then
		total_time = total_time - 1
		M.fps = frames
		frames = 0
	end

	for i = 1, LOG_SIZE - 1 do
		log_dt[i] = log_dt[i + 1]
	end
	log_dt[LOG_SIZE] = M.dt

	last_time = t
end

function M.init_graph(self)
	log_nodes = {}
	log_dt = {}

	local base_tick = gui.get_node("dt_tick")
	log_nodes[1] = base_tick
	log_dt[1] = 0

	for i = 2, LOG_SIZE do
		local new_tick = gui.clone(base_tick)
		local pos = gui.get_position(base_tick) + vmath.vector3(TICK_WIDTH * (i - 1), 0, 0)
		gui.set_position(new_tick, pos)

		log_nodes[i] = new_tick
		log_dt[i] = 0
	end

	M.update_graph(self)

	-- print(GRAPH_PX_DT * 1000 .. "ms, " .. GRAPH_MAX_DT * 1000 .. "ms")
end

function M.update_graph(self)
	local scale = vmath.vector3(1, 1, 1)
	
	for i = 1, LOG_SIZE do
		local v = log_dt[i]
		if v < GRAPH_PX_DT then
			v = GRAPH_PX_DT
		end
		if v > GRAPH_MAX_DT then
			v = GRAPH_MAX_DT
		end

		local h = math.floor(v / GRAPH_PX_DT)
		scale.y = h / TICK_HEIGHT

		gui.set_scale(log_nodes[i], scale)
	end
end

local is_html5_cache = nil
function M.is_html5()
	if is_html5_cache == nil then
		local info = sys.get_sys_info()
		if info.system_name == "HTML5" then
			is_html5_cache = true
		else
			is_html5_cache = false
		end
	end

	return is_html5_cache
end

local is_windows_cache = nil
function M.is_windows()
	if is_windows_cache == nil then
		local info = sys.get_sys_info()
		if info.system_name == "Windows" then
			is_windows_cache = true
		else
			is_windows_cache = false
		end
	end

	return is_windows_cache
end

return M
