"""LangChain SQL agent that answers questions on the Olist database with Llama 3 (via Groq)."""
import os

from dotenv import load_dotenv
from langchain_community.agent_toolkits import create_sql_agent
from langchain_community.utilities import SQLDatabase
from langchain_groq import ChatGroq

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_PATH = os.path.join(ROOT_DIR, "olist.db")


def get_agent():
    load_dotenv(os.path.join(ROOT_DIR, ".env"))
    db = SQLDatabase.from_uri(f"sqlite:///{DB_PATH}")

    llm = ChatGroq(
        groq_api_key=os.getenv("GROQ_API_KEY"),
        model_name="llama-3.3-70b-versatile",
        temperature=0,
    )

    agent_executor = create_sql_agent(llm=llm, db=db, verbose=True)
    # Let the agent recover when the LLM output does not follow the expected format
    agent_executor.handle_parsing_errors = True
    return agent_executor


if __name__ == "__main__":
    print(get_agent().invoke("How many customers are there?")["output"])
