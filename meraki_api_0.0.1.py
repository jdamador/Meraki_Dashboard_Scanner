#!/usr/bin/python3
# -*- coding: utf-8 -*-
'''
****************************************************
* Data Science TEC Community 2019
* Script that obtain informatiom from Meraki API
* Version: 0.0.3
* Created: 22-02-2019
****************************************************'''

# Import Meraki Library.
from meraki import meraki

# Import PostgreSQL Library.
import psycopg2

# Simple routine to run a query on a database
def insert(storageProcedure, values):
    # Data Base Configuration
    connection = psycopg2.connect("dbname='data_meraki' user='postgres' host='localhost' password='Dev98_2017' ")
    query = connection.cursor()
    # Set query structure
    statement = 'SELECT * FROM ' + storageProcedure +'(' + values + ');'
    # Run query
    query.execute(statement)
    connection.commit()
    return

# API Key to conecte with Meraki authentification services.
api_key = "511c40271fbead284e859697874724ff2060a337"

# Information about local divice MR33
org_id = 848678 
networkid = 'N_609674799555303190' 
serialnum = 'Q2PD-N83P-F9DM'

''' Get all clients and their network usage. '''
# Get Data.
clients = meraki.getclients(api_key,serialnum)
for i in clients:
    # Clean data.
    query = "'%s','%s','%s','%s',%s,%s" % (i['id'],i['description'],i['mac'],i['ip'],i['usage']['sent'],i['usage']['recv'])
    # Call function to insert data.
    insert('insert_data_clients',query)
    

''' Get all pages that have been accessed and their network usage. '''
# Get Data.
#data = meraki.getnetworktrafficstats(api_key, networkid)
#for i in data:
    # Clean data.
    #query =  "'%s','%s',%s,%s,%s,%s,%s" % (i['application'],i['destination'], i['recv'],i['sent'],i['flows'],i['activeTime'],i['numClients'])
    # Call function to insert data.
    #insert('insert_data_sites',query)