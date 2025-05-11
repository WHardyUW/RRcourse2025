import subprocess


for season in range(1, 9):
    subprocess.run([
            "quarto", "render", "hw.qmd",
            "--output", f"GoT_season_{season}.html",
            "--execute", "-P", f"season:{season}",
            "--metadata", f"title=Game of Thrones – Season {season}",
            "--no-cache"
        ], cwd = 'C:/Users/kacpe/Desktop/rr/RRcourse2025/Assignments/05_05_2025')
    