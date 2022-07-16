import glob

if __name__ == '__main__':
    print(glob.glob("**/ECE*", recursive=True))
