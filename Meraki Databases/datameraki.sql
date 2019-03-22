/*			Meraki data storage
 *Technological Institute of Costa Rica, Data Science Community.y 
 *Author: jdamdor.
 *Version: 0.0.1.
 */
-- Database -> datameraki.
create database datameraki;

-- Table that contains all information about devices.
create table devices (
	id_divice 	SERIAL 		NOt 	NULL,
	appMac  	Varchar(100) 	not 	null,
	apFloor 	INT 		NOT 	NULL,
	apTag 		VARCHAR(200) 	NOT 	NULL, -- It's possible that have to change this for a new table.
	constraint 	pk_devices 	Primary key(id_device)
);

-- Table that contains all observations about each devices.
CReate table observation(
	id_observation 	SERIAL 			not 	null,
	ipv4 		VARCHAR(15) 		Not 	null,
	lat 		double precision 	not 	null,
	lng 		double precision 	not 	null,
	unc 		DOUBLe precision 	not 	null,
	x 		Double precision 	not 	null,
	y 		double precision 	not 	null,
	seenTime 	TIMESTAMP 		not 	null,
	ssid 		Varchar(200) 		not 	null,
	os 		Varchar(200) 		not 	null,
	seenEpoch 	TIMESTAMP 		not 	null,
	rssi 		int 			not 	null,
	ipv6 		varchar(50) 		not 	null,
	manufacturer 	varchar(200) 		not 	null,
	id_client 	int not null,
	id_devices 	int no null,
	constraint 	pk_observations 	primary key(id_observation),
	constraint 	fk_observation_devices 	Foreign key(id_device) references devices(id_device),
	constraint 	fk_observation_client 	Foreign key(id_client) references clients(id_client)
);

-- Table that contents all information about applications accessed.
create table application (
	id_application 	SERIAL 		not 	null,
	application 	VARCHAR(200) 	NOT 	NULL,
	destination 	Varchar(200) 	not 	null,
	protocol 	Varchar(200) 	not 	null,
	port		int 		not 	null,
	recv 		int 		not 	null,
	sent		int 		not 	null,
	flows 		int 		not 	null,
	activeTime 	int 		not 	null,
	numClients 	int 		not 	null,
	constraint 	pk_application 	primary key(id_application)
);

-- Table that contents all information about clients.
create Table clients(
	id_client 		SERIAL 		NOT 	NULL,
	identifier 		varchar(8) 	not 	null,
	description 		Varchar(100)	not 	null,
	mdnsName 		varchar(100) 	not 	null,
	dhcpHostname 		varchar(100) 	not 	null,
	mac 			varchar(50) 	not 	null 	unique,
	ip 			varchar(20) 	not	null,
	vlan 			Varchar(20) 	not	null,
	first_seen 		iNT 		not 	null,
	last_seen 		int 		not	null,
	manufacturer 		varchar(100) 	not 	null,
	os 			varchar(100) 	not 	null,
	wirelessCapabilities 	varchar(200) 	not 	null,
	constraint 		pk_clients 	primary key(id_client)
);
-- Table that contents all information about clients usage.

create table client_usage (
	id_read 	SERIAL 			not 	null,
	id_client 	INT 			NOT 	NULL,
	send 		DOUBLE PRECISION 	not	null,
	rev 		DOUBLE PRECISION	not 	null,
	reading_data 	timestamp 		not 	null,
	constraint 	pk_client_usage 	primary key(id_read),
	constraint 	fk_client_usage 	FOREIGN kEy(id_client) references clients(id_client)
);

-- Function to add new clients.
CREATE or replace FUNCTION insert_client(
	_id varchar, 
	_des varchar, 
	_mdns varchar, 
	_dhcp varchar, 
	_mac varchar, 
	_ip varchar,
	_vlan varchar, 
	_firstSeen INT,
	_lastSeen INT,
	_manufac VArCHAR,
	_os varchar, 
	_wireless varchar)
RETURNS void
AS $$
BEGIN
	-- IF the client exist, only update the last seen time.
	if (select count(*) from clients where identifier = _id) > 0 THEN
		Update clients set last_seen = __lastSeen where identifier = _id;
	-- IF the client doesn't exist, add a new client.
	else
		Insert into clients(
				identifier,description, mdnsName, dhcpHostname, mac, ip, vlan,
				first_seen,last_seen, manufacturer, os, wirelessCapabilities)
			Values(
				_id, _des, _mdns, _dhcp, _mac, _ip, _vlan, _firstSeen, _lastSeen,
				_manufac, _os, _wireless);
	END IF;
END;
$$
LANGUAGE plpgsql;

-- Function that insert new application traffic register
create or replace function insert_app(
	_app VARCHAR,
	_des Varchar,
	_prot VARCHAR,
	_port int,
	_recv int,
	_sent int,
	_flows int,
	_activeT int,
	_numC INT)
returns void
as $$
begin 
	insert into application (
		application, destination, protocol, port, recv, sent, flows, activeTime, numClients)
		VALUES(_app, _des, _prot, _port, _recv, _sent, _flows, _activeT, _numC);
end;
$$
Language plpgsql;

-- Function that insert new usage readings.
create or replace function insert_usage(
	_mac VARCHAR,
	_sent DOUBLE PRECISION,
	_recv DOUBLE PRECISION,
	_date TIMESTAMP)
returns void
as $$
begin 
	IF ( select count(*) from clients where mac = _mac) > 0 THEN
		insert into client_usage( id_client, send, rev, reading_data) 
		VALUES((SELECT id_client from clients where mac = _mac), _sent, _recv, _date);
	end if;
end
$$
Language plpgsql;


/*
id_divice 	SERIAL 		NOt 	NULL,
	appMac  	Varchar(100) 	not 	null,
	apFloor 	INT 		NOT 	NULL,
	apTag 	
	*/
-- Function that insert a new device.
create or replace function insert_device(
	_appMac VARCHAR,
	_appFloor INT,
	_apTag INT)
returns void
as $$
begin 
	IF ( select count(*) from devices where appMac = _appMac) = 0 THEN
		insert into devices( appMac, appFloor, apTag) 
		VALUES(_appMac, _appFloor, _apTag);
	end if;
end
$$
Language plpgsql;

--Function that insert a new Observation.
create or replace function insert_observation(
	_lat double precision,
	_lng double precision,
	_unc double precision,
	_x double precision,
	_y double precision,
	_seenTime BIGINT,
	_ssid Varchar,
	_os Varchar,
	_seenEpoch BIGINT,
	_rssi INT,
	_ipv6 Varchar,
	_manufacturer Varchar,
	_mac VARCHAR,
	_macDevice VARCHAR
	)
returns void
as $$
begin 
	if (select count(*) from devices where appMac = _macDevice) > 0 THEN
		if (select count(*) from clients where mac = _mac) > 0 THEN
			Insert into observations(
				lng, unc, x, y, seenTime, ssid, os, seenEpoch, rssi, ipv6, manufacturer,id_client, id_devices)
			VALUES(_lng, _unc, _x, _y, _seenTime, _ssid, _os, _seenEpoch, _rssi, _ipv6,
			       _manufacturer, (select id_device from devices where appMac = _macDevice),
			       (select id_client from clients where mac = _mac));
		end if;
	end if;
end;
$$
Language plpgsql;