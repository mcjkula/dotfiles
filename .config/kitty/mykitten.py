from typing import List
from kitty.boss import Boss
import subprocess

def main(args: List[str]) -> str:
    path = '/Volumes/Transcend/Developer/projects'
    find_command = ['find', f'{path}/*', '-maxdepth', '2', '-type', 'd']
    sed_command = ['sed', f's~{path}/~~']
    fzf_command = ['fzf-tmux', '-p', '--cycle', '--layout=reverse', '--prompt', 't> ']
    selected_dir = subprocess.run(find_command, stdout=subprocess.PIPE)
    selected_dir = subprocess.run(sed_command, stdin=selected_dir.stdout, stdout=subprocess.PIPE)
    selected_dir = subprocess.run(fzf_command, stdin=selected_dir.stdout, stdout=subprocess.PIPE)
    selected_dir = selected_dir.stdout.decode().strip()
    if selected_dir:
        tab_name = selected_dir.replace(f'{path}/', '')
        try:
            Boss().focus_tab(match='title:' + tab_name)
        except Exception:
            Boss().launch_tab(cwd=f'{path}/{selected_dir}', tab_title=tab_name)
    return ''

