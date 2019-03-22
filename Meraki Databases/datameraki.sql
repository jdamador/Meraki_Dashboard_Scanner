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
-- 'activeTime': 660, 'numClients': 3}
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
	switchport 		int 		not 	null,
	first_seen 		iNT 		not 	null,
	last_seen 		int 		not	null,
	manufacturer 		varchar(100) 	not 	null,
	os 			varchar(100) 	not 	null,
	wirelessCapabilities 	varchar(200) 	not 	null,
	constraint 		pk_clients 	primary key(id_client)
);
-- Table that contents all information about clients usage.
create table client_usage (
	id_read 	SERIAL 		not 	null,
	send 		int 		not	null,
	rev 		int		not 	null,
	reading_data 	timestamp 	not 	null,
	constraint 	pk_client_usage primary key(id_read)
);
CREATE or replace FUNCTION insert_client(_id varchar, _des varchar, _mdns varchar, _dhcp varchar, _mac varchar, _ip varchar,_vlan varchar, _switch varchar, 
_firstSeen INT,_lastSeen INT,_manufac VArCHAR, _os varchar, _wireless varchar)
RETURNS BOOLEAN
AS $$
BEGIN
	if (select count(*) from clients where identifier = _id) > 0
	then
		UPDATE clients set last_seen = _lastSeen WHERE identifier = _id;
	ELSE
		insert into clients(identifier, description, mdnsName, dhcpHostname, mac,ip,vlan, switchport, first_seen, last_seen, manufacturer, os, wirelessCapabilities)
		VALUES (_id, _des, _mdns, _dhcp, _mac, _ip, _vlan, _switch, _firstSeen, _lastSeen, _manufac, _os, _wireless);
	end if;	
	return true;
END
$$
LANGUAGE plpgsql;