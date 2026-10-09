import subprocess
import datetime
import os
import sys

def run_backup():
    profile_dir = r"C:\Users\arifi\AppData\Local\hermes\profiles\pro-dev"
    if not os.path.isdir(profile_dir):
        print(f"ERROR: Profile directory does not exist: {profile_dir}", file=sys.stderr)
        sys.exit(1)

    os.chdir(profile_dir)

    # 1. Stage all changes adhering to .gitignore
    add_res = subprocess.run(["git", "add", "-A"], capture_output=True, text=True)
    if add_res.returncode != 0:
        print(f"ERROR: git add failed: {add_res.stderr}", file=sys.stderr)
        sys.exit(add_res.returncode)

    # 2. Check if there are staged changes
    diff_res = subprocess.run(["git", "diff", "--cached", "--quiet"])
    if diff_res.returncode == 0:
        print("pro-dev backup: No profile changes detected. Repository is up to date.")
        sys.exit(0)

    # 3. Commit with timestamp
    now_str = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    commit_msg = f"backup(pro-dev): automated weekend snapshot [{now_str}]"
    commit_res = subprocess.run(["git", "commit", "-m", commit_msg], capture_output=True, text=True)
    if commit_res.returncode != 0:
        print(f"ERROR: git commit failed: {commit_res.stderr}", file=sys.stderr)
        sys.exit(commit_res.returncode)

    # 4. Push to remote
    push_res = subprocess.run(["git", "push", "origin", "main"], capture_output=True, text=True)
    if push_res.returncode != 0:
        print(f"ERROR: git push failed: {push_res.stderr}", file=sys.stderr)
        sys.exit(push_res.returncode)

    print(f"SUCCESS: pro-dev profile backed up and pushed to GitHub at {now_str}.")

if __name__ == "__main__":
    run_backup()
