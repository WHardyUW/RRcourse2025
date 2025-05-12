import subprocess

seasons = [
    "season_1", "season_2", "season_3",
    "season_4", "season_5", "season_6",
    "season_7", "season_8"
]

for season in seasons:
    output_name = f"game_of_thrones_{season.replace(' ', '_')}.pdf"
    print(f"Rendering {output_name}...")

    subprocess.run([
        "quarto", "render", "Assignment.qmd",
        "--to", "pdf",
        "--execute",
        "-P", f"season='{season}'",
        "--output", output_name
    ])