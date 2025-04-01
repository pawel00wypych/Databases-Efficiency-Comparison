import pandas as pd

def main():

    #prepare data before importing to database
    df = pd.read_csv("Google-Playstore.csv")

    df["INSTALLS"] = df["INSTALLS"].astype(str).str.replace(r"[+,]", "", regex=True)

    #df.to_csv("Google-Playstore_cleaned.csv", index=False)


if __name__ == "__main__":
    main()