# Olist AI Analyst

[![Python 3.9+](https://img.shields.io/badge/Python-3.9%2B-blue)](https://www.python.org/)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.28%2B-red)](https://streamlit.io)
[![LangChain](https://img.shields.io/badge/LangChain-0.1%2B-green)](https://www.langchain.com/)

An intelligent data analysis system that leverages **Large Language Models** (via Groq/Llama 3) to enable natural language querying of the Olist e-commerce dataset.

## 🎯 Project Overview

**Olist** is a Brazilian e-commerce platform. This project builds an **AI-powered analytics assistant** that transforms complex SQL queries into natural language conversations. Instead of writing SQL, users ask questions like:

> "What are the top 5 product categories by total revenue?" 
> "How many customers are in São Paulo?"

The LLM agent automatically translates these questions to SQL queries and returns formatted, visual results.

### Key Features

✅ **Natural Language Query Interface** - Ask questions in French or English  
✅ **Automatic SQL Generation** - LLM converts NL → SQL queries  
✅ **Real-time Data Analysis** - Query against ~1M+ e-commerce transactions  
✅ **Interactive Visualization** - Auto-generated charts and tables  
✅ **Production-ready** - Built with Streamlit for easy deployment  

---

## 📊 Dataset

The Olist dataset includes:

| Table | Records | Purpose |
|-------|---------|---------|
| **customers** | 99K | Customer demographics & location |
| **orders** | 99K | Order transactions |
| **order_items** | 112K | Individual items per order |
| **order_payments** | 103K | Payment methods & amounts |
| **order_reviews** | 98K | Customer reviews & ratings |
| **products** | 32K | Product catalog & categories |
| **sellers** | 3.6K | Seller information |
| **geolocation** | 1.1M | Brazilian ZIP code mapping |

**Source:** [Olist Brazilian E-Commerce Dataset](https://www.kaggle.com/olistbr/brazilian-ecommerce) (Kaggle)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│        User (Streamlit Interface)           │
│         "Natural Language Query"            │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│   Streamlit App (src/app.py)                │
│   • Query input handling                    │
│   • Response parsing & formatting           │
│   • Visualization generation                │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│   LLM Agent (src/agent.py)                  │
│   • LangChain SQL Agent                     │
│   • Groq/Llama-3 LLM backend                │
│   • SQL query generation & execution        │
└──────────────┬──────────────────────────────┘
               │
┌──────────────▼──────────────────────────────┐
│   SQLite Database (olist.db)                │
│   • Normalized tables                       │
│   • Indexed for fast queries                │
└─────────────────────────────────────────────┘
```

### Components

- **`src/data_loader.py`** - ETL pipeline: imports CSV files → SQLite
- **`src/agent.py`** - LLM agent for SQL generation & execution
- **`src/app.py`** - Streamlit frontend for interactive analysis

---

## 🚀 Quick Start

### Prerequisites

- Python 3.9+
- Groq API key ([sign up free](https://console.groq.com))

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/maxencegohin-dev/olist-ai-sql-analyst.git
   cd olist-ai-sql-analyst
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure API credentials**
   ```bash
   cp .env.example .env
   # Edit .env and add your Groq API key
   nano .env
   ```

5. **Initialize the database** (first time only)
   ```bash
   python src/data_loader.py
   ```
   This loads all CSV files into SQLite. Takes ~30 seconds.

6. **Launch the application**
   ```bash
   streamlit run src/app.py
   ```
   Opens at `http://localhost:8501`

---

## 📖 Usage Examples

Once the app is running, try these queries:

### Sales Analysis
- "Top 10 selling products by quantity"
- "Total revenue per month in 2017"
- "Which product categories have highest ROI?"

### Customer Insights
- "How many customers per state?"
- "Average order value by product category"
- "Customer retention by signup month"

### Operational Metrics
- "Payment method distribution"
- "Delivery time: planned vs actual"
- "Product category adoption trends"

The agent responds with:
1. **Formatted Markdown table** with results
2. **Auto-generated bar/line chart** (when applicable)
3. **Executive summary** in natural language

---

## 🔒 Security & Best Practices

### Secrets Management
- **Never commit `.env`** (included in `.gitignore`)
- Use `.env.example` as a template
- Rotate API keys regularly

### Data Privacy
- All data files excluded from version control
- Use SQLite locally (no cloud storage)
- For production: migrate to PostgreSQL with proper authentication

### API Rate Limiting
- Groq API has rate limits (varies by tier)
- Monitor usage in [Groq Console](https://console.groq.com)

---

## 📈 Performance Metrics

| Metric | Value |
|--------|-------|
| **Query Response Time** | 2-5 seconds (LLM inference + SQL execution) |
| **Database Size** | 106 MB (SQLite) |
| **Concurrent Users** | 1-5 (Streamlit default, upgrade for scale) |
| **Max Query Complexity** | SQL joins on 8 tables |

### Optimization Tips
- Enable caching: Streamlit's `@st.cache_resource` is enabled
- Index frequent columns in SQLite (already done)
- Use `.gitignore` to exclude large files from version control

---

## 🛠️ Development

### Project Structure
```
.
├── src/
│   ├── app.py              # Streamlit web interface
│   ├── agent.py            # LLM agent orchestration
│   └── data_loader.py      # ETL pipeline
├── data/
│   ├── raw/                # Original CSV files (git-ignored)
│   └── processed/          # Processed data artifacts
├── notebooks/              # Jupyter notebooks (optional)
├── requirements.txt        # Python dependencies
├── .env.example           # API key template
├── .gitignore            # Version control exclusions
└── README.md             # This file
```

### Adding New Data Sources

1. Add CSV to `data/raw/`
2. Update `src/data_loader.py` to handle new tables
3. Run `python src/data_loader.py` to rebuild database
4. Agent automatically detects new tables via SQLite introspection

### Customizing LLM Behavior

Edit the `suffix` parameter in `src/agent.py` to:
- Change output language (currently French)
- Modify formatting requirements
- Add domain-specific instructions

Example:
```python
suffix = """
Return results as HTML tables instead of Markdown.
Always include data quality metrics (null counts, distributions).
"""
```

---

## 📚 Technologies Used

| Layer | Technology | Version |
|-------|-----------|---------|
| **Frontend** | Streamlit | 1.28+ |
| **Backend** | LangChain | 0.1+ |
| **LLM** | Groq/Llama-3 | Latest |
| **Database** | SQLite | 3.x |
| **Data** | Pandas | 2.0+ |

---

## 🤝 Contributing

This is a personal/educational project. Feel free to fork and adapt!

### Future Enhancements
- [ ] Multi-language support (Portuguese, Spanish)
- [ ] Advanced analytics (trend detection, anomalies)
- [ ] Export to CSV/PDF reports
- [ ] Authentication & multi-user dashboard
- [ ] Data refresh automation (daily/weekly ETL)

---

## ⚠️ Limitations & Considerations

1. **LLM Hallucinations** - Agent may generate incorrect SQL (rare but possible)
2. **Query Complexity** - Very complex queries may timeout (>30s)
3. **Data Freshness** - SQLite is static; consider streaming updates for real-time
4. **Scalability** - Streamlit lacks horizontal scaling; use Streamlit Cloud for production

---

## 📄 License

This project uses the public Olist dataset (CC0 / Public Domain).

---

## 📧 Contact

Created by: **Maxence Gohin**  
GitHub: [@maxencegohin-dev](https://github.com/maxencegohin-dev)  
Email: maxencegohin@gmail.com

---

**Last Updated:** August 2026

> **Tip:** If this project was useful, please ⭐ star it on GitHub!
