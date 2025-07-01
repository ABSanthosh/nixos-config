#!/usr/bin/env python3

# Alternative for: https://gitingest.com/

import argparse
import argcomplete
import tiktoken 
from tqdm import tqdm
import subprocess
import fnmatch
from pathlib import Path

OUTPUT_FILE = "_context.txt"

def is_inside_git_repo() -> bool:
    return subprocess.run(
        ["git", "rev-parse", "--is-inside-work-tree"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    ).returncode == 0

def is_gitignored(path: Path) -> bool:
    result = subprocess.run(["git", "check-ignore", str(path)], stdout=subprocess.DEVNULL)
    return result.returncode == 0

def is_binary(path: Path) -> bool:
    try:
        with path.open("rb") as f:
            chunk = f.read(1024)
            return b'\0' in chunk
    except Exception:
        return True

def should_exclude(path: Path, exclude_patterns: list[str]) -> bool:
    rel_path = str(path.relative_to(Path.cwd()))
    for pattern in exclude_patterns:
        if fnmatch.fnmatch(rel_path, pattern):
            return True
    return False

def count_tokens(text: str, encoding) -> int:
    return len(encoding.encode(text))

def process_files(exclude_patterns: list[str], output_path: Path):
    output_path.write_text("")  # Clear output

    inside_git = is_inside_git_repo()
    total_files = 0
    total_lines = 0
    total_tokens = 0 
    binary_skipped = []

    encoding = tiktoken.get_encoding("o200k_base")

    all_files = list(Path.cwd().rglob("*"))
    for file in tqdm(all_files, desc="Processing files", unit="file"):
        if not file.is_file():
            continue

        rel_path = file.relative_to(Path.cwd())

        # Skip excluded patterns
        if should_exclude(file, exclude_patterns):
            continue

        # Skip .gitignored files
        if inside_git and is_gitignored(file):
            continue

        # Skip binary files
        if is_binary(file):
            binary_skipped.append(str(rel_path))
            continue

        try:
            content = file.read_text(errors="replace")
            token_count = count_tokens(content, encoding)
            with output_path.open("a") as out:
                out.write("\n")
                out.write("=" * 48 + "\n")
                out.write(f"FILE: {rel_path}\n")
                out.write("=" * 48 + "\n")
                out.write(content)
                out.write("\n")

            total_files += 1
            total_lines += content.count("\n")
            total_tokens += token_count

        except Exception as e:
            print(f"Error reading {file}: {e}")

    print(f"Done!")
    print(f"Total tokens: {total_tokens}")

    if binary_skipped:
        print(f"Skipped {len(binary_skipped)} binary files")

def main():
    parser = argparse.ArgumentParser(description="Scan and format text files into a single context file.")
    parser.add_argument("--exclude", type=str, help="Comma-separated glob patterns to exclude (e.g. '*.lock,.git/**')")
    
    argcomplete.autocomplete(parser)
    args = parser.parse_args()
    exclude_patterns = [OUTPUT_FILE, ".git/**", ".git"]
    if args.exclude:
        exclude_patterns += [pat.strip() for pat in args.exclude.split(",") if pat.strip()]

    process_files(exclude_patterns, Path(OUTPUT_FILE))

if __name__ == "__main__":
    main()
