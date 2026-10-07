# Olist AI SQL Analyst

Ask business questions about an e-commerce database in plain English or French, and get the answer
as text, a table and a chart, without writing SQL.

Built on the public [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
(~100k orders placed between 2016 and 2018, 9 tables: orders, items, payments, reviews, customers,
sellers, products, geolocation, category translations).

<!-- Add a screenshot or GIF of the app here, e.g. ![demo](docs/demo.gif) -->

## How it works

```
Question (Streamlit) ──► LangChain SQL agent ──► Llama 3.3 70B (Groq) writes SQL
                                │
                                ▼
                         SQLite (olist.db) ──► results ──► answer + Markdown table ──► bar chart
```

| File | Role |
|---|---|
| `src/data_loader.py` | Loads the Olist CSV files from `data/raw/` into a SQLite database |
| `src/agent.py` | LangChain SQL agent: reads the schema, writes and runs SQL, retries on errors |
| `src/app.py` | Streamlit interface: question input, answer, automatic bar chart from the result table |

## Example questions

- What are the top 5 product categories by revenue?
- How many customers are there per state?
- What is the distribution of payment methods?
- What is the average delivery time, planned vs actual?

## Run it locally

Requirements: Python 3.9+ and a free [Groq API key](https://console.groq.com).

```bash
git clone https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git
cd olist-ai-sql-analyst
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt

cp .env.example .env            # then paste your Groq API key in .env
# Download the dataset from Kaggle and unzip the CSV files into data/raw/
python src/data_loader.py       # builds olist.db
streamlit run src/app.py        # opens http://localhost:8501
```

## Limitations

- **The generated SQL is not always right.** The LLM can misread a column or a join, so answers
  should be checked against the SQL shown in the terminal (`verbose=True`).
- **The chart depends on the answer format.** It is drawn only when the model returns a Markdown
  table with a numeric column.
- **Static data.** The SQLite database is a snapshot of the 2016–2018 dataset.
- **Prototype.** Single user, local only, no authentication.

## Next steps

- Show the generated SQL in the interface, not only in the terminal
- Add a few-shot prompt with the table relationships to improve join accuracy
- Build a small evaluation set (questions with known answers) to measure accuracy

## Stack

Python · LangChain · Groq (Llama 3.3 70B) · SQLite · Pandas · Streamlit
