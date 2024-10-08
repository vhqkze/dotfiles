-- sqlite3 yabai.db < create_table.sql
CREATE TABLE IF NOT EXISTS windows (
	id INTEGER primary key,
    pid INTEGER,
    app TEXT,
    title TEXT,
    scratchpad TEXT,
    frame_x INTEGER,
    frame_y INTEGER,
    frame_w INTEGER,
    frame_h INTEGER,
    role TEXT,
    subrole TEXT,
    root_window INTEGER,
    display INTEGER,
    space INTEGER,
    level INTEGER,
    sub_level INTEGER,
    layer TEXT,
    sub_layer TEXT,
    opacity REAL,
    split_type TEXT,
    split_child TEXT,
    stack_index INTEGER,
    can_move INTEGER,
    can_resize INTEGER,
    has_focus INTEGER,
    has_shadow INTEGER,
    has_parent_zoom INTEGER,
    has_fullscreen_zoom INTEGER,
    has_ax_reference INTEGER,
    is_native_fullscreen INTEGER,
    is_visible INTEGER,
    is_minimized INTEGER,
    is_hidden INTEGER,
    is_floating INTEGER,
    is_sticky INTEGER,
    is_grabbed INTEGER,
    update_time TEXT,
    focus_time TEXT,
    is_destroyed INTEGER
);
