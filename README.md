This repository contains a blank postgreSQL schema for storing concurrently collected behavioral and neural data. Or just behavioral data. Or just neural data.

It was not initially intended for sharing, and as such it is a bit messy and hacked-together. That being said, I think it will provide a valuable starting place for a cleaner, more comprehensive database schema.

Tables.pdf is a handy visual rendering of the schema.
Views.pdf is a visual reference of some of the views defined in the schema.

/matlabinterface/ includes a variety of tools for accessing the database from matlab. There are probably lots of dependencies missing; this is meant only to be used as an example of the types of handler functions to query and upload data from and to the database.

to use the matlab functions, open a connection to the postgreSQL server with the matlab command:
conn = database()