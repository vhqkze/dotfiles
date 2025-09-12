from typing import Literal, cast

from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: list[str]) -> str:
    return ''


def relative_resize_window(direction: Literal['left', 'right', 'top', 'bottom'], amount: int, target_window_id: int, boss: Boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None or boss.active_tab is None:
        return
    neighbors = boss.active_tab.current_layout.neighbors_for_window(window, boss.active_tab.windows)
    right_neighbors = neighbors.get('right')
    bottom_neighbors = neighbors.get('bottom')
    if direction == 'left':
        boss.active_tab.resize_window('narrower' if right_neighbors else 'wider', amount)
    elif direction == 'right':
        boss.active_tab.resize_window('wider' if right_neighbors else 'narrower', amount)
    elif direction == 'top':
        boss.active_tab.resize_window('shorter' if bottom_neighbors else 'taller', amount)
    elif direction == 'bottom':
        boss.active_tab.resize_window('taller' if bottom_neighbors else 'shorter', amount)
    return


@result_handler(no_ui=True)
def handle_result(args: list[str], result: str, target_window_id: int, boss: Boss) -> None:
    direction = cast(Literal['left', 'right', 'top', 'bottom'], args[1])
    key_mapping = args[2]
    amount = int(args[3])
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return
    cmd = window.child.foreground_cmdline[0]
    if cmd in ['tmux', 'nvim', 'ssh', '/usr/bin/ssh']:
        _ = window.send_key(key_mapping)
    else:
        relative_resize_window(direction, amount, target_window_id, boss)
