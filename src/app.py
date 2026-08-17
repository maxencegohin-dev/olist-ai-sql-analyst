import streamlit as st
import pandas as pd
import io
from agent import get_agent

# --- CONFIGURATION DE LA PAGE ---
st.set_page_config(page_title="Olist AI Analyst", page_icon="📊")
st.title("📊 Olist Data Assistant")

# --- CHARGEMENT DE L'AGENT (Optimisé avec Cache) ---
@st.cache_resource
def load_my_agent():
    return get_agent()

agent_executor = load_my_agent()

# --- INTERFACE ---
question = st.text_input("Quelle analyse souhaitez-vous effectuer ?", placeholder="Ex: Top 5 des catégories par CA...")

if st.button("Lancer l'analyse"):
    if question:
        with st.spinner("L'IA analyse la base de données..."):
            # 1. APPEL DE L'AGENT (Correction de la virgule traître)
            response = agent_executor.invoke(question + " (Réponds impérativement avec un tableau Markdown pour les chiffres)")

            # 2. EXTRACTION DU TEXTE (Gestion Dict vs Tuple pour éviter les erreurs rouges)
            if isinstance(response, dict):
                texte_final = response.get("output", str(response))
            elif isinstance(response, tuple):
                texte_final = response[0]
            else:
                texte_final = str(response)

            # 3. AFFICHAGE DE LA RÉPONSE TEXTUELLE
            st.markdown("### 🤖 Analyse de l'IA")
            st.write(texte_final)

            # 4. TENTATIVE DE GRAPHIQUE AUTOMATIQUE
            if "|" in texte_final:
                st.divider()
                st.markdown("### 📊 Visualisation des données")
                try:
                    # Extraction des lignes qui ressemblent à un tableau Markdown
                    lines = [l.strip() for l in texte_final.split('\n') if '|' in l]
                    if len(lines) > 2: # Il faut au moins entête + séparation + 1 donnée
                        table_text = '\n'.join(lines)
                        
                        # Conversion en DataFrame Pandas
                        df = pd.read_table(io.StringIO(table_text), sep="|", skipinitialspace=True).dropna(axis=1, how='all')
                        df.columns = df.columns.str.strip()
                        df = df.iloc[1:].reset_index(drop=True) # On enlève la ligne de séparation ---

                        # Affichage du tableau interactif
                        st.dataframe(df, use_container_width=True)

                        # Conversion automatique des colonnes en nombres si possible
                        for col in df.columns:
                            df[col] = pd.to_numeric(df[col], errors='ignore')

                        # On identifie les colonnes pour le graphique
                        cols_num = df.select_dtypes(include=['number']).columns
                        if not df.empty and len(cols_num) > 0:
                            st.bar_chart(data=df, x=df.columns[0], y=cols_num[0])
                except Exception as e:
                    st.info("Note : Les données n'ont pas pu être transformées en graphique, mais le texte est disponible ci-dessus.")
    else:
        st.warning("Veuillez entrer une question.")