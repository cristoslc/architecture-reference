# import sqlite3

# ## Connectt to SQlite
# connection=sqlite3.connect("student.db")

# # Create a cursor object to insert record,create table

# cursor=connection.cursor()

# ## create the table
# table_info="""
# Create table STUDENT(NAME VARCHAR(25),CLASS VARCHAR(25),
# SECTION VARCHAR(25),MARKS INT);

# """
# cursor.execute(table_info)

# ## Insert Some more records

# cursor.execute('''Insert Into STUDENT values('Krish','Data Science','A',90)''')
# cursor.execute('''Insert Into STUDENT values('Sudhanshu','Data Science','B',100)''')
# cursor.execute('''Insert Into STUDENT values('Darius','Data Science','A',86)''')
# cursor.execute('''Insert Into STUDENT values('Vikash','DEVOPS','A',50)''')
# cursor.execute('''Insert Into STUDENT values('Dipesh','DEVOPS','A',35)''')

# ## Disspaly ALl the records

# print("The isnerted records are")
# data=cursor.execute('''Select * from STUDENT''')
# for row in data:
#     print(row)

# ## Commit your changes int he databse
# connection.commit()
# connection.close()



import sqlite3
import pandas as pd

# Read the CSV file (assuming the file is named 'data.csv')
data = pd.read_csv("data.csv")

# Connect to SQLite database (or create it if it doesn't exist)
connection = sqlite3.connect("data.db")
cursor = connection.cursor()

# Create the table structure based on the column names and data types
create_table_query = """
CREATE TABLE IF NOT EXISTS Products (
    ProductID TEXT,
    ProductName TEXT,
    Category TEXT,
    CategoryID INTEGER,
    OrderID TEXT,
    CustomerID TEXT,
    OrderStatus TEXT,
    ReturnEligible TEXT,
    ShippingDate TEXT,
    MerchantID TEXT,
    ClusterID INTEGER,
    ClusterLabel TEXT,
    Price REAL,
    StockQuantity INTEGER,
    Description TEXT,
    Rating REAL
);
"""
cursor.execute(create_table_query)

# Insert data from the CSV into the database
data.to_sql('Products', connection, if_exists='append', index=False)

# Commit the transaction and close the connection
connection.commit()
connection.close()

print("Data has been successfully inserted into data.db.")
