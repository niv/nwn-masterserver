create table accounts (
	account varchar primary key,

	-- the password is stored as a non-salted md5 hash.
	-- This is a requirement of the protocol and cannot
	-- be changed without changing every client.
	password varchar
);

create table keys (
	key varchar primary key,
	expansion int
);
