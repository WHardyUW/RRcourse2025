import subprocess
import sys
def generate_quarto_report(number: int):
    filename = "season_"+str(number)+".pdf"
    command = [
        "quarto", "render",
        "Assignment.qmd",
        "--to", "pdf",
        "--output", filename,
        f"-P", f"season:{number}"
    ]
    subprocess.run(command, check=True)
    print(filename+" Generated ✅")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python main.py <season_number>")
        print("Usage: python main.py <season_number_from> <season_number_to>")
        sys.exit(1)
    if len(sys.argv) == 2 :
        generate_quarto_report(sys.argv[1])
        sys.exit(0)
    if len(sys.argv) == 3:
        for i in range(int(sys.argv[1]), int(sys.argv[2])+1):
            generate_quarto_report(i)
        sys.exit(0)
