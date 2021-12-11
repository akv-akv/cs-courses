import pandas as pd
orders = pd.read_excel('../initial_data/Sample - Superstore.xls',sheet_name='Orders', engine='xlrd', dtype=str)
orders.to_csv('../initial_data/orders.csv', index=False)
people = pd.read_excel('../initial_data/Sample - Superstore.xls',sheet_name='People', engine='xlrd', dtype=str)
people.to_csv('../initial_data/people.csv', index=False)
returns = pd.read_excel('../initial_data/Sample - Superstore.xls',sheet_name='Returns', engine='xlrd', dtype=str)
returns.to_csv('../initial_data/returns.csv', index=False)
