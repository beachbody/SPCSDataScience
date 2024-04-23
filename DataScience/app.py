# Eventual App to Manage Snowflake ML Model Registry and Deployment
import streamlit as st

st.set_page_config(layout="wide")

import pandas as pd
import plotly.express as px
import datetime

from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import col
from snowflake.snowpark.window import Window
from connection import create_snowflake_session, get_connection_params

from streamlit.web.server.websocket_headers import _get_websocket_headers

user = _get_websocket_headers().get("Sf-Context-Current-User") or "Visitor"


@st.cache_resource
def connect_to_snowflake():
    return create_snowflake_session()


session = connect_to_snowflake()

st.sidebar.header(f"Hello, {user}")
st.sidebar.subheader("Connection Parameters")
st.sidebar.write(get_connection_params(session))