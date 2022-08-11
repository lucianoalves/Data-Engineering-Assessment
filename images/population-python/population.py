#!/usr/bin/env python

import csv
import json
import sqlalchemy

from sqlalchemy.sql import text

# connect to the database
engine = sqlalchemy.create_engine("mysql://temper_code_test:good_luck@database/temper_code_test")
connection = engine.connect()

metadata = sqlalchemy.schema.MetaData(engine)

# make an ORM object to refer to the table
People = sqlalchemy.schema.Table('people', metadata, autoload=True, autoload_with=engine)
Places = sqlalchemy.schema.Table('places', metadata, autoload=True, autoload_with=engine)

# read the CSV data file into the table
with open('/data/people.csv') as csv_file:
  reader = csv.reader(csv_file)
  next(reader)
  for row in reader:
    connection.execute(People.insert().values(given_name = row[0],
                                              family_name = row[1],
                                              date_of_birth = row[2],
                                              place_of_birth = row[3]))

with open('/data/places.csv') as csv_file:
  reader = csv.reader(csv_file)
  next(reader)
  for row in reader:
    connection.execute(Places.insert().values(city = row[0],
                                              county = row[1],
                                              country = row[2]))

# output the table to a JSON file
query = text("SELECT country, count(*) as count FROM people pe INNER JOIN places pl on pe.place_of_birth = pl.city GROUP BY country")
with open('/data/population_output.json', 'w') as json_file:
  rows = connection.execute(query).fetchall()
  rows = [{row["country"]: row["count"]} for row in rows]
  json.dump(rows, json_file, separators=(',', ':'))
