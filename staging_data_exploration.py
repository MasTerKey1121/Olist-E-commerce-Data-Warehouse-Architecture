import pandas as pd
from sqlalchemy import create_engine


#Create a database engine
engine = create_engine('postgresql://masterkey1121:mymomiskindofhomeless@localhost:5433/olist_warehouse')

#Function to load data from a specified table
def load_data(table_name):
    query = f"SELECT * FROM {table_name};"
    df = pd.read_sql(query, engine)
    return df

def explore_data(df, table_name):
    print(f"Exploring data from table: {table_name}")
    print("First 5 rows:")
    print(df.head(5))
    print("\nDataFrame Info:")
    print(df.info())
    print("\nMissing Values:")
    print(df.isnull().sum())
    print("\nStatistical Summary:")
    print(df.describe(include='all'))
    print("\n" + "="*50 + "\n")

#Load data from various tables
customers_df = load_data('staging_customers')
geolocation_df = load_data('staging_geolocations')
orders_df = load_data('staging_orders')
order_items_df = load_data('staging_order_items')
products_df = load_data('staging_products')
sellers_df = load_data('staging_sellers')



#Explore each DataFrame
explore_data(customers_df, 'staging_customers')
explore_data(geolocation_df, 'staging_geolocations')
explore_data(orders_df, 'staging_orders')
explore_data(order_items_df, 'staging_order_items')
explore_data(products_df, 'staging_products')
explore_data(sellers_df, 'staging_sellers')

'''
NOTE: EXPLORATORY DATA ANALYSIS (EDA) RESULTS
staging_customers:



'''
