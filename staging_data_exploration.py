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
orders_payments_df = load_data('staging_order_payments')
orders_reviews_df = load_data('staging_order_reviews')
products_translations_df = load_data('staging_category_name_translation')




#Explore each DataFrame
explore_data(customers_df, 'staging_customers')
explore_data(geolocation_df, 'staging_geolocations')
explore_data(orders_df, 'staging_orders')
explore_data(order_items_df, 'staging_order_items')
explore_data(products_df, 'staging_products')
explore_data(sellers_df, 'staging_sellers')
explore_data(orders_payments_df, 'staging_order_payments')
explore_data(orders_reviews_df, 'staging_order_reviews')
explore_data(products_translations_df, 'staging_category_name_translation')



'''
NOTE: EXPLORATORY DATA ANALYSIS (EDA) RESULTS
staging_customers:
    - 99,441 records. 5 columns.
    - No missing values.
    - customer_id is unique identifier.
    - customer_unique_id will be primary key in the dimension table.

staging_geolocations:
    - 1,000,163 records. 5 columns.
    - No missing values.
    - customer_zip_code_prefix has duplicates.

staging_orders:
    - 99,441 records. 8 columns.
    - order_approved_at has 160 missing values.
    - order_delivered_carrier_date has 1783 missing values.
    - order_delivered_customer_date has 2965 missing values.
    - order_id is unique identifier.

staging_order_items:
    - 112,650 records. 7 columns.
    - No missing values.
    - order_item_id is unique identifier.

staging_order_payments:
    - 103,886 records. 5 columns.
    - No missing values.
    - payment_sequential is unique identifier.

staging_order_reviews:
    - 99,224 records. 7 columns.
    - review_comment_title has 87,656 missing values.
    - review_comment_message has 58,247 missing values.
    - review_id is unique identifier.

staging_products:
    - 32,951 records. 9 columns.
    - 610 missing values in product_name_length, product_description_length, product_photos_qty.
    - 2 missing values in product_weight_g and product_length_cm, product_height_cm, product_width_cm.
    - product_id is unique identifier.

staging_category_name_translation:
    - 71 records. 2 columns.
    - No missing values.
    - category_name_pt is unique identifier.

staging_sellers:
    - 3095 records. 4 columns.
    - No missing values.
    - seller_id is unique identifier.
'''
