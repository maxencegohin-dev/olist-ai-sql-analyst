"""Streamlit interface: ask a question in plain language, get the answer as text, table and chart."""
import io

import pandas as pd
import streamlit as st

from agent import get_agent

TABLE_INSTRUCTION = " (Answer in the language of the question and present the figures in a Markdown table.)"


@st.cache_resource
def load_agent():
    return get_agent()


def markdown_table_to_df(text):
    """Extract the first Markdown table of the answer as a DataFrame, or None if there is none."""
    lines = [line.strip() for line in text.split("\n") if line.strip().startswith("|")]
    if len(lines) < 3:  # header + separator + at least one row
        return None
    df = pd.read_table(io.StringIO("\n".join(lines)), sep="|", skipinitialspace=True).dropna(axis=1, how="all")
    df.columns = df.columns.str.strip()
    df = df.iloc[1:].reset_index(drop=True)  # drop the |---| separator row
    for col in df.columns:
        df[col] = df[col].astype(str).str.strip()
        converted = pd.to_numeric(df[col], errors="coerce")
        if converted.notna().all():
            df[col] = converted
    return df


st.set_page_config(page_title="Olist AI Analyst", page_icon="📊")
st.title("📊 Olist Data Assistant")

agent_executor = load_agent()
question = st.text_input("What would you like to analyse?", placeholder="e.g. Top 5 product categories by revenue")

if st.button("Run analysis"):
    if not question:
        st.warning("Please enter a question.")
    else:
        with st.spinner("Querying the database..."):
            answer = agent_executor.invoke(question + TABLE_INSTRUCTION)["output"]

        st.markdown("### Answer")
        st.markdown(answer)

        try:
            df = markdown_table_to_df(answer)
        except Exception:
            df = None

        if df is not None and not df.empty:
            numeric_cols = df.select_dtypes(include="number").columns
            if len(numeric_cols) > 0:
                st.divider()
                st.markdown("### Chart")
                st.bar_chart(df, x=df.columns[0], y=numeric_cols[0])
