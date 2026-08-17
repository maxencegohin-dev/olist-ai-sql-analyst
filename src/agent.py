import os
from dotenv import load_dotenv
from langchain_groq import ChatGroq
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import create_sql_agent

def get_agent():
    load_dotenv()
    api_key = os.getenv("GROQ_API_KEY")
    db = SQLDatabase.from_uri("sqlite:///olist.db")
    
    llm = ChatGroq(
        groq_api_key=api_key, 
        model_name="llama-3.3-70b-versatile",
        temperature=0
    )

    suffix = """
INTERDICTION d'utiliser des listes à puces pour les chiffres. 
Tu dois OBLIGATOIREMENT créer un tableau Markdown avec des barres verticales '|' pour présenter les données.
Exemple :
| Catégorie | Ventes Totales |
| :--- | :--- |
| exemple | 1000 |

Enfin, termine TOUJOURS par 'Final Answer:' suivi de ta synthèse en français.
"""

    # 1. On crée l'agent sans options compliquées pour ne pas fâcher Groq
    agent_executor = create_sql_agent(
        llm=llm, 
        db=db, 
        verbose=True
    )

    # 2. PATCH MANUEL : On active la correction d'erreurs ici
    agent_executor.handle_parsing_errors = True

    return agent_executor

# This enable us to keep testing the file alone if we want to
if __name__ == "__main__":
    agent = get_agent()
    agent.invoke("how many customers are there")