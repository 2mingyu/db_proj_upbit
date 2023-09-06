/*
DROP DATABASE IF EXISTS  madangdb;
create database proj_upbit;
use proj_upbit;
*/

DROP USER IF EXISTS 201901581user;
create user 201901581user identified WITH mysql_native_password by '201901581pw';
grant all privileges on proj_upbit.* to 201901581user with grant option;
commit;

CREATE TABLE data_User (
	uid      VARCHAR(20),
	uname    VARCHAR(10) NOT NULL,
	PRIMARY KEY (uid)
);

CREATE TABLE  Market (
	mname		VARCHAR(10),
	price		DOUBLE NOT NULL,
	PRIMARY KEY (mname)
);

CREATE TABLE Orders (
	oid INTEGER,
    tradeDate DATETIME NOT NULL,
    tradeUser VARCHAR(20) NOT NULL,
    tradeCurrency VARCHAR(10) NOT NULL,
    tradePrice DOUBLE NOT NULL,
    tradeAmount DOUBLE NOT NULL,
    side VARCHAR(10) NOT NULL,
    PRIMARY KEY (oid),
    FOREIGN KEY (tradeUser) REFERENCES data_User(uid),
    FOREIGN KEY (tradeCurrency) REFERENCES Market(mname)
);

CREATE TABLE Currency (
	cname VARCHAR(10),
    cowner VARCHAR(20) NOT NULL,
    amount DOUBLE NOT NULL,
    PRIMARY KEY (cname),
    FOREIGN KEY (cname) REFERENCES Market(mname),
    FOREIGN KEY (cowner) REFERENCES data_User(uid)
);