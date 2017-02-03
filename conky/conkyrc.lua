-----------------------------------------------------------------------------
--                               conkyrc_seamod
-- Date    : 01-02-2017
-- Author  : Retuben D'Netto, forked from https://github.com/maxiwell/conky-seamod
-- Conky   : >= 1.10 
-- License : Distributed under the terms of GNU GPL version 2 or later
-----------------------------------------------------------------------------

conky.config = {

	background = true,
	update_interval = 0.5,

	cpu_avg_samples = 2,
	net_avg_samples = 2,
    diskio_avg_samples = 2,
	temperature_unit = 'celsius',
    top_cpu_separate = true,

	double_buffer = true,
	no_buffers = true,
	text_buffer_size = 2048,

	gap_x = 0,
	gap_y = 0,
	minimum_width = 350,
	maximum_width = 350,
    minimum_height = 1200,
	own_window = true,
	own_window_type = 'override',
	own_window_transparent = true,
	own_window_argb_visual = true,

	own_window_type = 'override',
	own_window_class = 'conky-semi',
	own_window_hints = 'undecorated,sticky,skip_taskbar,skip_pager,below',
	border_inner_margin = 0,
	border_outer_margin = 0,
	alignment = 'top_right',

	draw_shades = false,
	draw_outline = false,
	draw_borders = false,
	draw_graph_borders = true,  -- useful for debugging

	override_utf8_locale = true,
	use_xft = true,
	font = 'caviar dreams:size=11',
	xftalpha = 0.5,
	uppercase = false,

-- Defining colors
	default_color = '#FFFFFF',
-- Shades of Gray
	color1 = '#DDDDDD',
	color2 = '#AAAAAA',
	color3 = '#888888',
-- Orange
	color4 = '#EF5A29',
-- Green
	color5 = '#77B753',
-- Loading lua script for drawning rings
	lua_load = '~/.config/i3/conky/seamod_rings.lua',
	lua_draw_hook_pre = 'main',

};

--${offset 15}${font Ubuntu:size=11:style=normal}${color1}${pre_exec lsb_release -d | cut -f 2} - $sysname $kernel
conky.text = [[
${font Ubuntu:size=11:style=bold}${color4}SYSTEM ${hr 2}
${offset 15}${font Ubuntu:size=11:style=normal}${color1}$sysname $kernel
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Battery:  ${color3}${battery_bar 5,150 BAT1} ${color3}${battery_percent BAT1}%
${offset 15}${font Ubuntu:size=11:style=normal}${color1}Uptime: ${color3}$uptime

# Showing CPU Graph
${voffset -20}
${offset 125}${cpugraph cpu0 80,220 #000000 #000000 -0.5}

${voffset -65}
${offset 85}${font Ubuntu:size=11:style=bold}${color5}CPU

# Showing TOP 5 CPU-consumers
${offset 105}${font Ubuntu:size=11:style=normal}${color4}${top name 1}${alignr}${top cpu 1}%
${offset 105}${font Ubuntu:size=11:style=normal}${color1}${top name 2}${alignr}${top cpu 2}%
${offset 105}${font Ubuntu:size=11:style=normal}${color2}${top name 3}${alignr}${top cpu 3}%
${offset 105}${font Ubuntu:size=11:style=normal}${color3}${top name 4}${alignr}${top cpu 4}%
${offset 105}${font Ubuntu:size=11:style=normal}${color3}${top name 5}${alignr}${top cpu 5}%

# Showing Memory Graph
${voffset -20}
${offset 125}${memgraph 80,220 #000000 #000000 -0.5}

${voffset -70}
${offset 80}${font Ubuntu:size=11:style=bold}${color5}MEM

#Showing memory part with TOP 3
${offset 105}${font Ubuntu:size=11:style=normal}${color4}${top_mem name 1}${alignr}${top_mem mem_res 1}
${offset 105}${font Ubuntu:size=11:style=normal}${color1}${top_mem name 2}${alignr}${top_mem mem_res 2}
${offset 105}${font Ubuntu:size=11:style=normal}${color2}${top_mem name 3}${alignr}${top_mem mem_res 3}

# Showing disk partitions
${voffset 40}
${offset 90}${font Ubuntu:size=11:style=bold}${color5}I/O

${voffset -120}${color3}
${offset 120}${diskiograph 80,220 666666 666666}

${voffset -30}
${offset 20}${color1}${font Ubuntu:size=10:style=bold}R: ${alignr 250}${font Ubuntu:size=10:style=normal}${color2}${diskio_read}
${offset 20}${color1}${font Ubuntu:size=10:style=bold}W: ${alignr 250}${font Ubuntu:size=10:style=normal}${color2}${diskio_write}

#Showing IO part with TOP 3
${voffset -50}
${offset 105}${font Ubuntu:size=11:style=normal}${color4}${top_io name 1}${alignr}${top_io io_read 1}/ ${top_io io_write 1}
${offset 105}${font Ubuntu:size=11:style=normal}${color1}${top_io name 2}${alignr}${top_io io_read 2}/ ${top_io io_write 2}
${offset 105}${font Ubuntu:size=11:style=normal}${color2}${top_io name 3}${alignr}${top_io io_read 3}/ ${top_io io_write 3}

# Network data
${voffset 60}
${offset 80}${font Ubuntu:size=11:style=bold}${color5}NET

${voffset -130}
${offset 120}${color1}${font ubuntu:size=10:style=bold}Up: ${alignr}${font Ubuntu:size=10:style=normal}$color2${upspeed wlp1s0} / ${totalup wlp1s0}
${offset 120}${upspeedgraph wlp1s0 40,220 4B1B0C FF5C2B 1280KiB -l}
${offset 120}${color1}${font Ubuntu:size=10:style=bold}Down: ${alignr}${font Ubuntu:size=10:style=normal}$color2${downspeed wlp1s0} / ${totaldown wlp1s0}
${offset 120}${downspeedgraph wlp1s0 40,220 324D23 77B753 1280KiB -l}

# Temperature
# TODO: we shouldn't need to fork for this
${voffset 30}
${offset 60}${font Ubuntu:size=11:style=bold}${color5}TEMP
${voffset -80}
${offset 125}${color3}${execgraph "$HOME/.config/i3/conky/temp.sh" 80,220}

]];
