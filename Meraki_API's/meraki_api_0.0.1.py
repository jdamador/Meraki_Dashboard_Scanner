#!/usr/bin/python3
# -*- coding: utf-8 -*-
'''
****************************************************
* Data Science TEC Community 2019
* Script that obtain informatiom from Meraki API
* Version: 0.0.4
* Created: 22-02-2019
****************************************************'''

# Import Meraki Library.
from meraki import meraki

# Import PostgreSQL Library.
import psycopg2

# System imports.
import datetime

# Simple routine to run a query on a database
def insert(storageProcedure, values):
    # Data Base Configuration
    connection = psycopg2.connect(
        "dbname='datameraki' user='panelesfv' host='ec2-18-144-27-14.us-west-1.compute.amazonaws.com' password='P@n3L3sF0v0' port='9876'")
    query = connection.cursor()

    # Set query structure
    statement = 'SELECT * FROM ' + storageProcedure + '(' + values + ');'
    print(statement)
    # Run query
    query.execute(statement)
    connection.commit()
    return


# API Key to conecte with Meraki authentification services.
API_KEY = "511c40271fbead284e859697874724ff2060a337"

# Information about local divice MR33
ORG_ID = 848678  # Organitation id.
NETWORK_ID = 'N_609674799555303190'  # Network id.
SERIAL_NUM = 'Q2PD-N83P-F9DM'  # Device serial num.

### GET clients information ###


def get_clients():
    clientsInfomation = meraki.getclients(API_KEY, SERIAL_NUM)
    for index in clientsInfomation:
        # GET Information about an specifit client.
        client = meraki.getclient(API_KEY, NETWORK_ID, index['id'])
        query = "'%s', '%s','%s', '%s', '%s', '%s','%s', %s, %s, '%s','%s', '%s'" % (
            index['id'],  # VARCHAR
            index['description'],  # VARCHAR
            index['mdnsName'],  # VARCHAR
            index['dhcpHostname'],  # VARCHAR
            index['mac'],   # VARCHAR
            index['ip'],  # VARCHAR
            index['vlan'],  # VARCHAR
            client['firstSeen'],  # INT
            client['lastSeen'],  # INT
            client['manufacturer'],  # VARCHAR
            client['os'],  # VARCHAR
            client['wirelessCapabilities'])  # VARCHAR

        insert('insert_client', query)

### GET applications traffic stats ###


def get_traffic():
    # application, destination, protocol, port, recv, sent, flows, activeTime, numClients
    appTraffic = meraki.getnetworktrafficstats(API_KEY, NETWORK_ID)
    for i in appTraffic:
        query = "'%s', '%s', '%s', %s, %s, %s, %s, %s, %s" % (
            i['application'],  # VARCHAR
            i['destination'],  # VARCHAR
            i['protocol'],  # VARCHAR
            i['port'],  # INT
            i['recv'],  # INT
            i['sent'],  # INT
            i['flows'],  # INT
            i['activeTime'],  # INT
            i['numClients'])  # INT
        insert('insert_app',query)

def get_clients_usage():
  clients = meraki.getclients(API_KEY, SERIAL_NUM)
  for index in clients:
    query = "'%s', %s, %s, '%s'" %(
      index['mac'],
      index['usage']['sent'], 
      index['usage']['recv'], 
      datetime.datetime.now().date())
    insert('insert_usage',query)