from pathlib import Path

IGNORED_DIRS = {'.git',}
IGNORED_FILES = {'.gitignore', 'mklinks.py'}

i = 0

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
                print(f"Error creating symlink for {item}: {e}")

if __name__ == "__main__":
    # Replace these with your actual paths
    source_dir = Path.home() / Path("Dotfiles")
    target_dir = Path.home()

    create_symlinks(source_dir, target_dir)
