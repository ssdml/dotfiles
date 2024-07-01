from pathlib import Path

IGNORED_DIRS = {'.git',}
IGNORED_FILES = {'.gitignore', 'mklinks.py'}

DOT_FILES_DIR = Path.home() / Path("Dotfiles")


def create_symlinks(source_dir: Path, target_dir: Path):
    """
    Creates symbolic links for every file in source_dir and its subdirectories.

    Args:
        source_dir: Path object representing the directory containing the files to link.
        target_dir: Path object representing the directory where the symbolic links will be created.
    """
    for item in source_dir.iterdir():
        if item.is_dir() and item.name not in IGNORED_DIRS:
            target_sub_dir = target_dir / item.relative_to(source_dir)
            target_sub_dir.mkdir(parents=True, exist_ok=True)    # Create target subdir if needed
            
            create_symlinks(item, target_sub_dir)    # Recursively call for subdirectories

        elif item.is_file() and item.name not in IGNORED_FILES:
            target_path = target_dir / item.relative_to(source_dir)
            try:
                target_path.symlink_to(item)
                print(f"Created symlink: {target_path} -> {item}")
            except OSError as e:
                pass
                # print(f"Error creating symlink for {item}: {e}")

if __name__ == "__main__":
    target_dir = Path.home()

    dirs = [item for item in DOT_FILES_DIR.iterdir() if item.is_dir() and not item.name.startswith('.')]

    for index, dir in enumerate(dirs, start=1):
        print(f'{index}. {dir.name}')

    print('0. all')

    input_index = int(input('Choose directory: '))

    if input_index == 0:
        for dir in dirs:
            create_symlinks(dir, target_dir)

    else:

        try:
            dir = dirs[input_index - 1]
        except IndexError:
            print('Wrong input')

        else:
            create_symlinks(dir, target_dir)

