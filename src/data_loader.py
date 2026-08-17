import pandas as pd
import sqlite3
import glob
import os

# 1. Création de la connexion
conn = sqlite3.connect('olist.db')

# 2. On boucle sur tous les fichiers CSV du dossier
path = './' #I create this variable so anybody with an other os just has to change it to find the file in an other folder 
csv_files = glob.glob(os.path.join(path, "*.csv"))  #looks at the folder and create a list of all the files ending by '.csv'

print(f"🚀 Début de l'importation de {len(csv_files)} fichiers...")

for f in csv_files:
    # We clean the name of the table which is currently conatining the path and the extension ".csv"
    
    table_name = os.path.basename(f).replace('olist_', '').replace('_dataset.csv', '')
    
    # Loading it in a panda data frame
    df = pd.read_csv(f)
    
    # Injection in SQLite
    df.to_sql(table_name, conn, if_exists='replace', index=False) # Send the data to the SQL database. If the table already exists, delete it and create a new one
    #index=False so we don't create a useless column with the index of panda
    print(f"✅ Table '{table_name}' créée ({len(df)} lignes)")

print("\n✨ Base de données 'olist.db' générée avec succès !")
conn.close()