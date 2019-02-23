/*****************************************************\
 * Data Science TEC Community 2019		     *
 * Script that contains the database queries	     *
 * Version: 0.0.1				     *
 * Created: 22-02-2019				     *
\*****************************************************/

--NOTICE> Table to save data about all accessed pages.
--DROP TABLE public.data_sites;
CREATE TABLE public.data_sites
(
  id_reading SERIAL NOT NULL,
  aplication character varying(100) NOT NULL,
  destination character varying(250) NOT NULL,
  recv bigint NOT NULL,
  sent bigint NOT NULL,
  flows bigint NOT NULL,
  active_time integer NOT NULL,
  numclients integer NOT NULL,
  CONSTRAINT pk_data_sites PRIMARY KEY (id_reading)
)

--NOTICE> Function to insert information into the table called data_sites.
--DROP FUNCTION insert_data_sites;
CREATE OR REPLACE FUNCTION  insert_data_sites(
VARCHAR, VARCHAR, BIGINT, bigint, bigint, int, INT) RETURNs void
as $$
begin
insert into data_sites(
aplication, destination, recv, sent, flows, active_time, numclients)
VALUES(
$1, $2, $3, $4, $5, $6, $7);
end;
$$ language plpgsql

--NOTICE> Table that contains clients information.
--DROP TABLE data_clients
CREATE table data_clients(
	idClient VARChar(10) NOT NUll,
	description VARCHAR(100) NOT NULL,
	mac VARCHAR(100) NOT NULL,
	ip VARCHAR(15) NOT NULL,
	sent double precision NOT NULL,
	recv double precision NOT NULL,
	constraint pk_data_clients PRIMARY KEY(idClient)	
);

--NOTICE> Function to insert information into the table called data_clients.
--DROP FUNCTION insert_data_sites;
CREATE OR REPLACE FUNCTION  insert_data_clients(
VArCHAR, VARCHAR, VARCHAR, VARCHAR, double precision, double precision) RETURNs void
as $$
begin
insert into data_clients(
idClient, description, mac, ip, sent, recv)
VALUES(
$1, $2, $3, $4, $5, $6);
end;
$$ language plpgsql

select * from data_clients